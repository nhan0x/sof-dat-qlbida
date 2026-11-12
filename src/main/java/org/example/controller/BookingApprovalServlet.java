package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Booking;
import org.example.models.TableBida;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/employee/duyetdatban", "/admin/duyetdatban"})
public class BookingApprovalServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private TableBidaDAO tableBidaDAO;
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAOImpl();
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

        String role = currentAccount.getRole() != null ? currentAccount.getRole().toLowerCase() : "";
        if (!"admin".equals(role) && !"nhân viên".equals(role) && !"employee".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        List<Booking> bookings = bookingDAO.getAll();
        List<Map<String, Object>> bookingDetails = new ArrayList<>();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

        for (Booking b : bookings) {
            if ("Chờ Thanh Toán".equalsIgnoreCase(b.getStatus())) {
                continue; // Khách chưa thanh toán xong / đã hủy -> không hiển thị trong hàng chờ duyệt
            }
            Map<String, Object> map = new HashMap<>();
            map.put("id", b.getId());
            map.put("bookingTime", b.getBookingTime() != null ? b.getBookingTime().format(dtf) : "");
            map.put("playTime", b.getPlayTime() != null ? b.getPlayTime().format(dtf) : "");
            map.put("duration", b.getDuration());
            map.put("paymentType", b.getPaymentType());
            map.put("status", b.getStatus());

            // Get customer name
            Account customer = accountDAO.getAccountById(b.getAccountId());
            map.put("customerName", customer != null ? customer.getName() : "Không rõ");
            map.put("customerPhone", customer != null ? customer.getPhone() : "Không rõ");

            // Get table name
            TableBida table = tableBidaDAO.getById(b.getTable_id());
            map.put("tableName", table != null ? table.getName() : "Không rõ");

            bookingDetails.add(map);
        }

        req.setAttribute("bookings", bookingDetails);

        String servletPath = req.getServletPath();
        if (servletPath.contains("/admin")) {
            req.getRequestDispatcher("/admin/duyetdatban.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/employee/duyetdatban.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentAccount = (Account) req.getSession().getAttribute("account");
        if (currentAccount == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String role = currentAccount.getRole() != null ? currentAccount.getRole().toLowerCase() : "";
        if (!"admin".equals(role) && !"nhân viên".equals(role) && !"employee".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            String action = req.getParameter("action");

            if ("approve".equals(action)) {
                Booking bNew = bookingDAO.getById(bookingId);
                if (bNew != null) {
                    java.time.LocalDateTime bNewStart = bNew.getPlayTime();
                    java.time.LocalDateTime bNewEnd = bNewStart.plusHours(bNew.getDuration());
                    java.time.LocalDateTime now = java.time.LocalDateTime.now();

                    // 1. Check if it overlaps with current occupancy
                    boolean overlapsWithNow = !bNewStart.isAfter(now) && bNewEnd.isAfter(now);
                    if (overlapsWithNow) {
                        TableBida table = tableBidaDAO.getById(bNew.getTable_id());
                        if (table != null && !"Trống".equalsIgnoreCase(table.getStatus()) && !"Available".equalsIgnoreCase(table.getStatus())) {
                            req.getSession().setAttribute("error", "Không thể duyệt! Bàn này hiện đang được sử dụng (Trạng thái: " + table.getStatus() + ").");
                            resp.sendRedirect(req.getRequestURI());
                            return;
                        }
                    }

                    // 2. Check overlap with other approved bookings
                    List<Booking> allBookings = bookingDAO.getAll();
                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM");
                    for (Booking bExisting : allBookings) {
                        if (bExisting.getId() != bNew.getId() && 
                            bExisting.getTable_id() == bNew.getTable_id() && 
                            "Đã Xác Nhận".equalsIgnoreCase(bExisting.getStatus())) {
                            
                            java.time.LocalDateTime existStart = bExisting.getPlayTime();
                            java.time.LocalDateTime existEnd = existStart.plusHours(bExisting.getDuration());

                            // Check overlap condition: Start1 < End2 AND End1 > Start2
                            if (bNewStart.isBefore(existEnd) && bNewEnd.isAfter(existStart)) {
                                req.getSession().setAttribute("error", "Không thể duyệt! Bàn này đã có lịch đặt khác được xác nhận trong khoảng: " + existStart.format(dtf) + " - " + existEnd.format(dtf) + ".");
                                resp.sendRedirect(req.getRequestURI());
                                return;
                            }
                        }
                    }

                    bookingDAO.updateStatus(bookingId, "Đã Xác Nhận");
                    req.getSession().setAttribute("message", "Xác nhận đặt bàn thành công!");
                } else {
                    req.getSession().setAttribute("error", "Không tìm thấy đơn đặt bàn.");
                }
            } else if ("cancel".equals(action)) {
                bookingDAO.updateStatus(bookingId, "Đã Hủy");
                req.getSession().setAttribute("message", "Đã hủy đơn đặt bàn thành công!");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getRequestURI());
    }
}
