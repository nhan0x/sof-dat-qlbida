package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.*;
import org.example.utils.DBUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

/**
 * QROrderServlet handles two endpoints:
 *  GET  /order?table=<tableId>  → show the order page (public, no login required)
 *  POST /order                  → submit the order (creates a StaffCall row)
 *  GET  /admin/quanliqr         → show admin QR management page
 */
@WebServlet(urlPatterns = {"/order", "/admin/quanliqr"})
public class QROrderServlet extends HttpServlet {

    private TableBidaDAO tableBidaDAO;
    private ServiceDAO serviceDAO;
    private BillDAO billDAO;
    private BillDetailsDAO billDetailsDAO;

    @Override
    public void init() throws ServletException {
        tableBidaDAO = new TableBidaDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        billDAO = new BillDAOImpl();
        billDetailsDAO = new BilldetailsDAOImpl();
    }

    // ─────────────────────────────────────────────────────────
    //  GET handlers
    // ─────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String uri = req.getRequestURI();

        if (uri.contains("/admin/quanliqr")) {
            // Admin: view all tables with their QR codes
            List<TableBida> tableList = tableBidaDAO.getAll();
            req.setAttribute("tableList", tableList);
            req.getRequestDispatcher("/admin/quanliqr.jsp").forward(req, resp);
            return;
        }

        // Public order page: /order?table=<id>
        String tableIdStr = req.getParameter("table");
        if (tableIdStr == null || tableIdStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin bàn.");
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdStr);
            TableBida table = tableBidaDAO.getById(tableId);
            if (table == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Bàn không tồn tại.");
                return;
            }
            req.setAttribute("table", table);
            req.setAttribute("serviceList", serviceDAO.getAll());
            req.getRequestDispatcher("/order.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bàn không hợp lệ.");
        }
    }

    // ─────────────────────────────────────────────────────────
    //  POST handler: submit order
    // ─────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String tableIdStr = req.getParameter("tableId");
        String note       = req.getParameter("note");
        String callType   = req.getParameter("callType"); // "call", "order", or "pay"

        if (tableIdStr == null || tableIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order?error=missingTable");
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdStr);
            String[] serviceIds = req.getParameterValues("serviceIds");

            // Build descriptive note
            StringBuilder fullNote = new StringBuilder();

            if ("pay".equals(callType)) {
                fullNote.append("[YÊU CẦU THANH TOÁN] ");
            } else if ("order".equals(callType)) {
                fullNote.append("[ORDER ĐỒ] ");
                if (serviceIds != null && serviceIds.length > 0) {
                    fullNote.append("Dịch vụ: ");
                    for (int i = 0; i < serviceIds.length; i++) {
                        try {
                            int svcId = Integer.parseInt(serviceIds[i]);
                            org.example.models.Service svc = serviceDAO.getById(svcId);
                            if (svc != null) {
                                fullNote.append(svc.getName());
                                if (i < serviceIds.length - 1) fullNote.append(", ");
                            }
                        } catch (NumberFormatException ignored) { }
                    }
                    fullNote.append(". ");
                }
            } else {
                // "call" (default)
                fullNote.append("[GỌI NHÂN VIÊN] ");
            }

            if (note != null && !note.trim().isEmpty()) {
                fullNote.append(note.trim());
            }

            // Check if there is already an active Pending call for this table to prevent duplicate/repeating alerts
            String checkSql = "SELECT id, note FROM StaffCall WHERE table_id = ? AND status = 'Pending' ORDER BY call_time DESC";
            try (java.sql.Connection con = org.example.utils.DBUtil.getConnection();
                 java.sql.PreparedStatement checkPst = con.prepareStatement(checkSql)) {
                checkPst.setInt(1, tableId);
                try (java.sql.ResultSet rs = checkPst.executeQuery()) {
                    if (rs.next()) {
                        int existingId = rs.getInt("id");
                        String existingNote = rs.getNString("note");
                        String newNote = fullNote.toString();
                        if (existingNote != null && !existingNote.isEmpty() && !existingNote.contains(newNote)) {
                            newNote = existingNote + " | " + newNote;
                        }
                        String updateSql = "UPDATE StaffCall SET call_time = CURRENT_TIMESTAMP, note = ? WHERE id = ?";
                        try (java.sql.PreparedStatement updatePst = con.prepareStatement(updateSql)) {
                            updatePst.setNString(1, newNote);
                            updatePst.setInt(2, existingId);
                            updatePst.executeUpdate();
                        }
                    } else {
                        // Insert new StaffCall row if no pending call exists
                        String insertSql = "INSERT INTO StaffCall (table_id, status, note) VALUES (?, 'Pending', ?)";
                        try (java.sql.PreparedStatement insertPst = con.prepareStatement(insertSql)) {
                            insertPst.setInt(1, tableId);
                            insertPst.setNString(2, fullNote.toString());
                            insertPst.executeUpdate();
                        }
                    }
                }
            }

            // Direct insertion of food order items into active bill details
            if ("order".equals(callType) && serviceIds != null && serviceIds.length > 0) {
                Bill activeBill = billDAO.getUnpaidBillByTableId(tableId);
                if (activeBill != null) {
                    for (String serviceIdStr : serviceIds) {
                        try {
                            int svcId = Integer.parseInt(serviceIdStr);
                            Service svc = serviceDAO.getById(svcId);
                            if (svc != null) {
                                BillDetails existing = billDetailsDAO.getDetailByBillAndService(activeBill.getBill_id(), svcId);
                                if (existing != null) {
                                    existing.setQuantity(existing.getQuantity() + 1);
                                    billDetailsDAO.updateDetail(existing);
                                } else {
                                    BillDetails detail = new BillDetails();
                                    detail.setBillId(activeBill.getBill_id());
                                    detail.setService_id(svcId);
                                    detail.setQuantity(1);
                                    detail.setPrice(svc.getPrice());
                                    billDetailsDAO.addDetail(detail);
                                }
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/order?table=" + tableId + "&success=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/order?table=" + tableIdStr + "&error=system");
        }
    }
}
