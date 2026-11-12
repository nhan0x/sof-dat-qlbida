package org.example.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.models.Account;
import org.example.utils.NotificationQueue;
import org.example.utils.NotificationQueue.Notification;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * SSE (Server-Sent Events) endpoint for booking notifications.
 *
 * Client connects via:
 *   const source = new EventSource('/contextPath/notify/stream?since=0');
 *
 * The servlet polls the NotificationQueue every 2 seconds, sends any new
 * events, then keeps the connection alive for up to 25 seconds before closing
 * (the browser's EventSource will reconnect automatically).
 *
 * Access is restricted to logged-in users with role 'admin' or 'Nhân viên'.
 */
@WebServlet("/notify/stream")
public class NotificationSSEServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // --- Auth check ---
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        String role = acc.getRole() == null ? "" : acc.getRole();
        if (!"admin".equalsIgnoreCase(role) && !"Nhân viên".equalsIgnoreCase(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // --- SSE headers ---
        resp.setContentType("text/event-stream;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Connection", "keep-alive");
        resp.setHeader("X-Accel-Buffering", "no"); // disable nginx buffering if present

        // Read last-seen timestamp from client (default 0 → first load, send nothing)
        long since;
        try {
            String sinceParam = req.getParameter("since");
            since = (sinceParam != null && !sinceParam.isEmpty()) ? Long.parseLong(sinceParam) : 0L;
        } catch (NumberFormatException e) {
            since = 0L;
        }

        // On very first connect with since=0, use current server time so we don't
        // replay old notifications that are already in the queue.
        if (since == 0L) {
            since = System.currentTimeMillis();
        }

        NotificationQueue nq = NotificationQueue.getInstance();
        PrintWriter out = resp.getWriter();

        // Keep connection alive for ~25 seconds, polling every 2 seconds
        long deadline = System.currentTimeMillis() + 25_000;

        try {
            while (System.currentTimeMillis() < deadline) {
                List<Notification> fresh = nq.getNewerThan(since);
                for (Notification n : fresh) {
                    out.print("event: booking\n");
                    out.print("data: " + toJson(n) + "\n\n");
                    since = Math.max(since, n.timestamp);
                }

                List<NotificationQueue.DeletedBillNotification> freshDeleted = nq.getNewerDeletedBills(since);
                for (NotificationQueue.DeletedBillNotification dn : freshDeleted) {
                    out.print("event: bill_deleted\n");
                    out.print("data: " + toDeletedJson(dn) + "\n\n");
                    since = Math.max(since, dn.timestamp);
                }

                if (!fresh.isEmpty() || !freshDeleted.isEmpty()) {
                    out.flush();
                    if (out.checkError()) break; // client disconnected
                }

                // Send a keep-alive comment every loop iteration
                out.print(": keep-alive\n\n");
                out.flush();
                if (out.checkError()) break;

                Thread.sleep(2000);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            // client disconnected or other error – just close
        }
    }

    /** Build a minimal JSON string from a Notification */
    private String toJson(Notification n) {
        return "{"
            + "\"bookingId\":" + n.bookingId + ","
            + "\"timestamp\":" + n.timestamp + ","
            + "\"customerName\":\"" + escape(n.customerName) + "\","
            + "\"tableName\":\"" + escape(n.tableName) + "\","
            + "\"playTime\":\"" + escape(n.playTime) + "\","
            + "\"duration\":" + n.duration + ","
            + "\"paymentType\":\"" + escape(n.paymentType) + "\""
            + "}";
    }

    private String toDeletedJson(NotificationQueue.DeletedBillNotification dn) {
        return "{"
            + "\"billId\":" + dn.billId + ","
            + "\"timestamp\":" + dn.timestamp + ","
            + "\"tableName\":\"" + escape(dn.tableName) + "\","
            + "\"staffName\":\"" + escape(dn.staffName) + "\","
            + "\"total\":" + dn.total + ","
            + "\"reason\":\"" + escape(dn.reason) + "\""
            + "}";
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
