package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.models.Account;

import java.io.IOException;
import java.sql.*;
import java.time.format.DateTimeFormatter;

@WebServlet("/employee/api/staffcalls")
public class StaffCallApiServlet extends HttpServlet {

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("HH:mm - dd/MM");
    private static final char Q = '"';

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        Account currentUser = (Account) req.getSession().getAttribute("account");
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{" + Q + "error" + Q + ":" + Q + "unauthorized" + Q + "}");
            return;
        }
        StringBuilder json = new StringBuilder();
        json.append("{" + Q + "calls" + Q + ":[");
        String sql = "SELECT sc.id, sc.table_id, sc.call_time, sc.note, tb.name AS table_name FROM StaffCall sc JOIN TableBida tb ON sc.table_id = tb.id WHERE sc.status = 'Pending' ORDER BY sc.call_time ASC";
        try (Connection con = org.example.utils.DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            int count = 0;
            while (rs.next()) {
                if (count > 0) json.append(",");
                int id = rs.getInt("id"); int tableId = rs.getInt("table_id");
                String tableName = rs.getNString("table_name");
                String note = rs.getNString("note"); if (note == null) note = "";
                Timestamp ts = rs.getTimestamp("call_time");
                String ct = ts != null ? DTF.format(ts.toLocalDateTime()) : "";
                String callType = note.contains("THANH TO") ? "pay" : note.contains("ORDER") ? "order" : "call";
                json.append("{").append(Q).append("id").append(Q).append(":").append(id)
                    .append(",").append(Q).append("tableId").append(Q).append(":").append(tableId)
                    .append(",").append(Q).append("tableName").append(Q).append(":").append(Q).append(escapeJson(tableName)).append(Q)
                    .append(",").append(Q).append("note").append(Q).append(":").append(Q).append(escapeJson(note)).append(Q)
                    .append(",").append(Q).append("callTime").append(Q).append(":").append(Q).append(ct).append(Q)
                    .append(",").append(Q).append("callType").append(Q).append(":").append(Q).append(callType).append(Q).append("}");
                count++;
            }
            json.append("],").append(Q).append("count").append(Q).append(":").append(count).append("}");
        } catch (Exception e) {
            e.printStackTrace(); resp.setStatus(500);
            json = new StringBuilder("{" + Q + "error" + Q + ":" + Q + "db_error" + Q + "," + Q + "calls" + Q + ":[]," + Q + "count" + Q + ":0}");
        }
        resp.getWriter().print(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        Account currentUser = (Account) req.getSession().getAttribute("account");
        if (currentUser == null) { resp.setStatus(401); resp.getWriter().write("{" + Q + "error" + Q + ":" + Q + "unauthorized" + Q + "}"); return; }
        String action = req.getParameter("action"); String idStr = req.getParameter("id");
        if ("dismiss".equals(action) && idStr != null) {
            try {
                int callId = Integer.parseInt(idStr);
                String sql = "UPDATE StaffCall SET status = 'Done' WHERE id = ?";
                try (Connection con = org.example.utils.DBUtil.getConnection();
                     PreparedStatement pst = con.prepareStatement(sql)) { pst.setInt(1, callId); pst.executeUpdate(); }
                resp.getWriter().write("{" + Q + "success" + Q + ":true}");
            } catch (Exception e) { e.printStackTrace(); resp.setStatus(500); resp.getWriter().write("{" + Q + "error" + Q + ":" + Q + "db_error" + Q + "}"); }
        } else { resp.setStatus(400); resp.getWriter().write("{" + Q + "error" + Q + ":" + Q + "bad_request" + Q + "}"); }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace(String.valueOf(Q), "\\" + Q).replace("\n","\\n").replace("\r","\\r").replace("\t","\\t");
    }
}