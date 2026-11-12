package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.BookingDAO;
import org.example.daos.BookingDAOImpl;
import org.example.daos.TableBidaDAO;
import org.example.daos.TableBidaDAOImpl;
import org.example.models.Account;
import org.example.models.Booking;
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
 * Xem lịch đặt bàn của ngày hôm nay (mặc định) cho nhân viên và admin.
 */
@WebServlet({"/employee/lichdatbanhomnay", "/admin/lichdatbanhomnay"})
public class TodayBookingServlet extends HttpServlet {

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

        LocalDate today = LocalDate.now();
        LocalDate selectedDate = today;
        String dateStr = req.getParameter("date");
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateStr.trim());
            } catch (Exception e) {
                selectedDate = today;
            }
        }

        List<Booking> bookings = bookingDAO.getBookingsByPlayDate(selectedDate);

        DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
        DateTimeFormatter dateTimeFmt = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        LocalDateTime now = LocalDateTime.now();

        List<Map<String, Object>> rows = new ArrayList<>();
        int upcomingCount = 0;
        int playingCount = 0;
        int doneCount = 0;

        for (Booking b : bookings) {
            Map<String, Object> row = new HashMap<>();
            LocalDateTime start = b.getPlayTime();
            LocalDateTime end = start != null ? start.plusHours(b.getDuration()) : null;

            row.put("id", b.getId());
            row.put("startTime", start != null ? start.format(timeFmt) : "");
            row.put("endTime", end != null ? end.format(timeFmt) : "");
            row.put("duration", b.getDuration());
            row.put("status", b.getStatus());
            row.put("paymentType", b.getPaymentType());
            row.put("bookingTime", b.getBookingTime() != null ? b.getBookingTime().format(dateTimeFmt) : "");

            TableBida table = tableBidaDAO.getById(b.getTable_id());
            row.put("tableName", table != null ? table.getName() : "Bàn #" + b.getTable_id());

            Account customer = accountDAO.getAccountById(b.getAccountId());
            row.put("customerName", customer != null ? customer.getName() : "Không rõ");
            row.put("customerPhone", customer != null ? customer.getPhone() : "");

            // Trạng thái theo thời gian thực trong ngày
            String timeState;
            if (start == null || end == null) {
                timeState = "unknown";
            } else if (now.isBefore(start)) {
                timeState = "upcoming";
                upcomingCount++;
            } else if (now.isBefore(end)) {
                timeState = "playing";
                playingCount++;
            } else {
                timeState = "done";
                doneCount++;
            }
            row.put("timeState", timeState);
            rows.add(row);
        }

        req.setAttribute("bookingRows", rows);
        req.setAttribute("totalCount", rows.size());
        req.setAttribute("upcomingCount", upcomingCount);
        req.setAttribute("playingCount", playingCount);
        req.setAttribute("doneCount", doneCount);
        req.setAttribute("selectedDate", selectedDate.toString());
        req.setAttribute("selectedDateLabel", selectedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        req.setAttribute("isToday", selectedDate.equals(today));
        req.setAttribute("isAdminView", req.getServletPath().startsWith("/admin"));

        req.getRequestDispatcher("/employee/lichdatbanhomnay.jsp").forward(req, resp);
    }
}
