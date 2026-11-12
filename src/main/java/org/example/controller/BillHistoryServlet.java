package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Bill;
import org.example.models.BillDetails;
import org.example.models.Service;
import org.example.models.TableBida;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Lịch sử / quản lí hóa đơn.
 *
 * <ul>
 *   <li>{@code /employee/lichsuhoadon} — nhân viên xem lịch sử hóa đơn do chính mình thao tác.</li>
 *   <li>{@code /admin/quanlihoadon} — admin xem và lọc toàn bộ hóa đơn của cửa hàng
 *       (theo khoảng ngày, nhân viên thực hiện, bàn, trạng thái).</li>
 * </ul>
 */
@WebServlet({"/employee/lichsuhoadon", "/admin/quanlihoadon"})
public class BillHistoryServlet extends HttpServlet {

    private BillDAO billDAO;
    private BillDetailsDAO billDetailsDAO;
    private ServiceDAO serviceDAO;
    private TableBidaDAO tableBidaDAO;
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        billDAO = new BillDAOImpl();
        billDetailsDAO = new BilldetailsDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        tableBidaDAO = new TableBidaDAOImpl();
        accountDAO = new AccountDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentAccount = (Account) req.getSession().getAttribute("account");
        if (currentAccount == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        boolean adminView = req.getServletPath().startsWith("/admin");
        if (adminView && !"admin".equalsIgnoreCase(currentAccount.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        // Xem / Xóa một hóa đơn
        String action = req.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            deleteBill(req, resp, currentAccount, adminView);
            return;
        }

        String billIdStr = req.getParameter("billId");
        if (billIdStr != null && !billIdStr.trim().isEmpty()) {
            showBillDetail(req, resp, currentAccount, adminView, billIdStr.trim());
            return;
        }

        // --- Bộ lọc ---
        LocalDate today = LocalDate.now();
        LocalDate fromDate = parseDate(req.getParameter("fromDate"), adminView ? today.withDayOfMonth(1) : today.minusDays(7));
        LocalDate toDate = parseDate(req.getParameter("toDate"), today);
        if (toDate.isBefore(fromDate)) {
            toDate = fromDate;
        }

        Integer filterAccountId;
        if (adminView) {
            // null means "tất cả nhân viên" — không lọc theo account
            filterAccountId = parseInteger(req.getParameter("staffId"));
        } else {
            filterAccountId = currentAccount.getId();
        }
        Integer filterTableId = parseInteger(req.getParameter("tableId"));
        String filterStatus = req.getParameter("status");
        if (filterStatus != null && filterStatus.trim().isEmpty()) filterStatus = null;

        LocalDateTime from = fromDate.atStartOfDay();
        LocalDateTime to = toDate.plusDays(1).atStartOfDay();

        List<Bill> bills = billDAO.searchBills(from, to, filterAccountId, filterTableId, filterStatus);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
        List<Map<String, Object>> rows = new ArrayList<>();
        double totalPaid = 0;
        int paidCount = 0;
        int unpaidCount = 0;

        for (Bill b : bills) {
            Map<String, Object> row = new HashMap<>();
            row.put("billId", b.getBill_id());
            row.put("total", b.getTotal());
            row.put("status", b.getStatus());
            row.put("timeStart", b.getTime_start() != null ? b.getTime_start().format(dtf) : "");
            row.put("timeEnd", b.getTime_end() != null ? b.getTime_end().format(dtf) : "");

            TableBida table = tableBidaDAO.getById(b.getTable_id());
            row.put("tableName", table != null ? table.getName() : "Bàn #" + b.getTable_id());

            // "Người bấm" hóa đơn: nhân viên/thu ngân đã mở & thanh toán bàn
            Account staff = b.getAccount_id() != null ? accountDAO.getAccountById(b.getAccount_id()) : null;
            row.put("staffName", staff != null ? staff.getName() : "Không rõ");
            row.put("staffRole", staff != null ? staff.getRole() : "");

            if ("Paid".equalsIgnoreCase(b.getStatus())) {
                totalPaid += b.getTotal();
                paidCount++;
            } else {
                unpaidCount++;
            }
            rows.add(row);
        }

        req.setAttribute("billRows", rows);
        req.setAttribute("totalPaid", totalPaid);
        req.setAttribute("paidCount", paidCount);
        req.setAttribute("unpaidCount", unpaidCount);
        req.setAttribute("totalCount", rows.size());
        req.setAttribute("avgPerBill", paidCount > 0 ? totalPaid / paidCount : 0);

        req.setAttribute("fromDate", fromDate.toString());
        req.setAttribute("toDate", toDate.toString());
        req.setAttribute("filterStatus", filterStatus == null ? "" : filterStatus);
        // Để nguyên kiểu Integer (null khi không lọc) cho EL so sánh với id của bàn/nhân viên
        req.setAttribute("filterTableId", filterTableId);
        req.setAttribute("filterStaffId", filterAccountId);
        req.setAttribute("tables", tableBidaDAO.getAll());
        req.setAttribute("isAdminView", adminView);

        if (adminView) {
            // Danh sách nhân viên/admin để lọc theo "người bấm"
            List<Account> staffList = new ArrayList<>();
            for (Account a : accountDAO.getAllAccounts()) {
                String role = a.getRole() != null ? a.getRole() : "";
                if ("admin".equalsIgnoreCase(role) || "Nhân viên".equalsIgnoreCase(role) || "employee".equalsIgnoreCase(role)) {
                    staffList.add(a);
                }
            }
            req.setAttribute("staffList", staffList);
            req.getRequestDispatcher("/admin/quanlihoadon.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/employee/lichsuhoadon.jsp").forward(req, resp);
        }
    }

    private void showBillDetail(HttpServletRequest req, HttpServletResponse resp, Account currentAccount,
                                boolean adminView, String billIdStr) throws ServletException, IOException {
        Integer billId = parseInteger(billIdStr);
        Bill bill = billId != null ? billDAO.getBillById(billId) : null;

        if (bill == null) {
            req.getSession().setAttribute("error", "Không tìm thấy hóa đơn.");
            resp.sendRedirect(req.getContextPath() + (adminView ? "/admin/quanlihoadon" : "/employee/lichsuhoadon"));
            return;
        }
        // Nhân viên chỉ được xem hóa đơn của chính mình
        if (!adminView && (bill.getAccount_id() == null || bill.getAccount_id().intValue() != currentAccount.getId())) {
            req.getSession().setAttribute("error", "Bạn chỉ có thể xem hóa đơn do chính mình thực hiện.");
            resp.sendRedirect(req.getContextPath() + "/employee/lichsuhoadon");
            return;
        }

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
        Map<String, Object> detail = new HashMap<>();
        detail.put("billId", bill.getBill_id());
        detail.put("total", bill.getTotal());
        detail.put("status", bill.getStatus());
        detail.put("timeStart", bill.getTime_start() != null ? bill.getTime_start().format(dtf) : "");
        detail.put("timeEnd", bill.getTime_end() != null ? bill.getTime_end().format(dtf) : "");

        TableBida table = tableBidaDAO.getById(bill.getTable_id());
        detail.put("tableName", table != null ? table.getName() : "Bàn #" + bill.getTable_id());

        Account staff = bill.getAccount_id() != null ? accountDAO.getAccountById(bill.getAccount_id()) : null;
        detail.put("staffName", staff != null ? staff.getName() : "Không rõ");
        detail.put("staffRole", staff != null ? staff.getRole() : "");

        List<Map<String, Object>> serviceRows = new ArrayList<>();
        double serviceTotal = 0;
        for (BillDetails d : billDetailsDAO.getDetailsByBillId(bill.getBill_id())) {
            Service s = serviceDAO.getById(d.getService_id());
            Map<String, Object> sm = new HashMap<>();
            sm.put("name", s != null ? s.getName() : "Không rõ");
            sm.put("quantity", d.getQuantity());
            sm.put("price", d.getPrice());
            double lineTotal = d.getQuantity() * d.getPrice();
            sm.put("total", lineTotal);
            serviceTotal += lineTotal;
            serviceRows.add(sm);
        }
        detail.put("services", serviceRows);
        detail.put("serviceTotal", serviceTotal);

        req.setAttribute("billDetail", detail);
        req.setAttribute("isAdminView", adminView);
        req.getRequestDispatcher("/employee/chitiethoadon.jsp").forward(req, resp);
    }

    private LocalDate parseDate(String value, LocalDate fallback) {
        if (value == null || value.trim().isEmpty()) return fallback;
        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void deleteBill(HttpServletRequest req, HttpServletResponse resp, Account currentAccount, boolean adminView) throws IOException {
        Integer billId = parseInteger(req.getParameter("billId"));
        if (billId == null) {
            req.getSession().setAttribute("error", "Mã hóa đơn không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + (adminView ? "/admin/quanlihoadon" : "/employee/lichsuhoadon"));
            return;
        }

        Bill bill = billDAO.getBillById(billId);
        if (bill == null) {
            req.getSession().setAttribute("error", "Không tìm thấy hóa đơn cần xóa.");
            resp.sendRedirect(req.getContextPath() + (adminView ? "/admin/quanlihoadon" : "/employee/lichsuhoadon"));
            return;
        }

        TableBida table = tableBidaDAO.getById(bill.getTable_id());
        String tableName = table != null ? table.getName() : "Bàn #" + bill.getTable_id();
        double total = bill.getTotal();
        String staffName = currentAccount.getName();

        boolean success = billDAO.deleteBill(billId);
        if (success) {
            req.getSession().setAttribute("message", "Đã xóa hóa đơn #" + billId + " thành công!");

            // Notify Admin
            org.example.utils.NotificationQueue.getInstance().pushDeletedBill(
                    new org.example.utils.NotificationQueue.DeletedBillNotification(
                            billId, tableName, staffName, total, "Xóa bởi " + staffName
                    )
            );
        } else {
            req.getSession().setAttribute("error", "Lỗi: Không thể xóa hóa đơn #" + billId);
        }

        resp.sendRedirect(req.getContextPath() + (adminView ? "/admin/quanlihoadon" : "/employee/lichsuhoadon"));
    }
}
