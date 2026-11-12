package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Bill;
import org.example.models.TableBida;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/doanhthu")
public class RevenueServlet extends HttpServlet {

    private BillDAO billDAO;
    private TableBidaDAO tableBidaDAO;
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        billDAO = new BillDAOImpl();
        tableBidaDAO = new TableBidaDAOImpl();
        accountDAO = new AccountDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        LocalDate today = LocalDate.now();
        String mode = req.getParameter("mode");
        if (mode == null || (!mode.equals("day") && !mode.equals("month") && !mode.equals("year"))) {
            mode = "day";
        }

        String dateStr = req.getParameter("date");
        int month;
        int year;
        LocalDate selectedDay;

        try {
            selectedDay = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : today;
        } catch (Exception e) {
            selectedDay = today;
        }
        try {
            month = req.getParameter("month") != null ? Integer.parseInt(req.getParameter("month")) : today.getMonthValue();
            if (month < 1 || month > 12) month = today.getMonthValue();
        } catch (Exception e) {
            month = today.getMonthValue();
        }
        try {
            year = req.getParameter("year") != null ? Integer.parseInt(req.getParameter("year")) : today.getYear();
            if (year < 2000 || year > 2100) year = today.getYear();
        } catch (Exception e) {
            year = today.getYear();
        }

        LocalDateTime start;
        LocalDateTime end;
        String rangeLabel;

        if (mode.equals("month")) {
            YearMonth ym = YearMonth.of(year, month);
            start = ym.atDay(1).atStartOfDay();
            end = ym.plusMonths(1).atDay(1).atStartOfDay();
            rangeLabel = "Tháng " + month + "/" + year;
        } else if (mode.equals("year")) {
            start = LocalDate.of(year, 1, 1).atStartOfDay();
            end = LocalDate.of(year + 1, 1, 1).atStartOfDay();
            rangeLabel = "Năm " + year;
        } else {
            start = selectedDay.atStartOfDay();
            end = selectedDay.plusDays(1).atStartOfDay();
            rangeLabel = "Ngày " + selectedDay.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }

        List<Bill> bills = billDAO.getPaidBillsByShift(start, end.minusNanos(1));

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        List<Map<String, Object>> billRows = new ArrayList<>();
        double totalRevenue = 0;

        for (Bill b : bills) {
            Map<String, Object> row = new HashMap<>();
            row.put("billId", b.getBill_id());
            row.put("total", b.getTotal());
            row.put("timeStart", b.getTime_start() != null ? b.getTime_start().format(dtf) : "");
            row.put("timeEnd", b.getTime_end() != null ? b.getTime_end().format(dtf) : "");

            TableBida table = tableBidaDAO.getById(b.getTable_id());
            row.put("tableName", table != null ? table.getName() : "Không rõ");

            if (b.getAccount_id() != null) {
                Account staff = accountDAO.getAccountById(b.getAccount_id());
                row.put("staffName", staff != null ? staff.getName() : "Không rõ");
            } else {
                row.put("staffName", "Không rõ");
            }

            billRows.add(row);
            totalRevenue += b.getTotal();
        }

        // Newest bills first
        billRows.sort((a, c) -> ((Integer) c.get("billId")).compareTo((Integer) a.get("billId")));

        int totalBillCount = billRows.size();
        double avgPerBill = totalBillCount > 0 ? totalRevenue / totalBillCount : 0;

        req.setAttribute("bills", billRows);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalBillCount", totalBillCount);
        req.setAttribute("avgPerBill", avgPerBill);
        req.setAttribute("rangeLabel", rangeLabel);
        req.setAttribute("mode", mode);
        req.setAttribute("selectedDate", selectedDay.toString());
        req.setAttribute("selectedMonth", month);
        req.setAttribute("selectedYear", year);

        req.getRequestDispatcher("/admin/doanhthu.jsp").forward(req, resp);
    }
}
