package org.example.controller;

import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.BookingDAO;
import org.example.daos.BookingDAOImpl;
import org.example.daos.BookingDetailDAO;
import org.example.daos.BookingDetailDAOImpl;
import org.example.daos.ServiceDAO;
import org.example.daos.ServiceDAOImpl;
import org.example.daos.TableBidaDAO;
import org.example.daos.TableBidaDAOImpl;
import org.example.models.Account;
import org.example.models.Booking;
import org.example.models.BookingDetail;
import org.example.models.Service;
import org.example.models.TableBida;
import org.example.utils.NotificationQueue;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = { "/datban", "/lichsudatban", "/datban/payos-callback" })
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private TableBidaDAO tableDAO;
    private ServiceDAO serviceDAO;
    private BookingDetailDAO bookingDetailDAO;
    private org.example.daos.TableTypeDAO tableTypeDAO;
    private org.example.daos.BillDAO billDAO;
    private org.example.utils.TableAvailability availability;
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAOImpl();
        tableDAO = new TableBidaDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        bookingDetailDAO = new BookingDetailDAOImpl();
        tableTypeDAO = new org.example.daos.TableTypeDAOImpl();
        billDAO = new org.example.daos.BillDAOImpl();
        availability = new org.example.utils.TableAvailability(bookingDAO, tableDAO, billDAO);
        accountDAO = new AccountDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String path = req.getServletPath();

        // Xử lý callback PayOS sau khi thanh toán đặt bàn trả trước
        if (path.equals("/datban/payos-callback")) {
            handlePayosCallback(req, resp);
            return;
        }

        if (path.equals("/lichsudatban")) {
            List<Booking> list = bookingDAO.getBookingsByAccountId(acc.getId());
            // Loại bỏ các đơn "Chờ Thanh Toán" chưa hoàn tất để người dùng không nhìn thấy đơn dở dang
            if (list != null) {
                list.removeIf(b -> "Chờ Thanh Toán".equalsIgnoreCase(b.getStatus()));
            }
            req.setAttribute("bookingHistory", list);

            // Nạp tên bàn cho từng booking (tableId -> tableName)
            Map<Integer, String> tableNameMap = new HashMap<>();
            for (Booking bk : list) {
                if (!tableNameMap.containsKey(bk.getTable_id())) {
                    TableBida tb = tableDAO.getById(bk.getTable_id());
                    tableNameMap.put(bk.getTable_id(), tb != null ? tb.getName() : "Bàn #" + bk.getTable_id());
                }
            }
            req.setAttribute("tableNameMap", tableNameMap);

            // Nạp danh sách dịch vụ đã đặt trước cho từng booking để hiển thị
            Map<Integer, List<Map<String, Object>>> bookingServicesMap = new HashMap<>();
            for (Booking bk : list) {
                List<BookingDetail> details = bookingDetailDAO.getByBookingId(bk.getId());
                List<Map<String, Object>> serviceInfos = new ArrayList<>();
                for (BookingDetail d : details) {
                    Service s = serviceDAO.getById(d.getServiceId());
                    if (s != null) {
                        Map<String, Object> info = new HashMap<>();
                        info.put("name", s.getName());
                        info.put("price", s.getPrice());
                        info.put("quantity", d.getQuantity());
                        serviceInfos.add(info);
                    }
                }
                bookingServicesMap.put(bk.getId(), serviceInfos);
            }
            req.setAttribute("bookingServicesMap", bookingServicesMap);

            RequestDispatcher dispatcher = req.getRequestDispatcher("/user/lichsudatban.jsp");
            dispatcher.forward(req, resp);
        } else if (path.equals("/datban")) {
            // Lấy toàn bộ bàn kèm giá tiền. Bàn đang chơi vẫn được hiển thị vì khách
            // có thể đặt sau khi bàn trống theo quy tắc trong TableAvailability.
            List<TableBida> allTables = tableDAO.getAll();
            List<TableBida> displayTables = new ArrayList<>();
            java.util.Map<Integer, String> freeFromMap = new HashMap<>();
            java.time.format.DateTimeFormatter dtf =
                    java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
            for (TableBida t : allTables) {
                java.time.LocalDateTime freeFrom = availability.getWalkInFreeFrom(t.getId());
                if (freeFrom != null) {
                    freeFromMap.put(t.getId(), freeFrom.format(dtf));
                }
                if (t.getPricePerHour() == 0 && t.getTableTypeId() > 0) {
                    org.example.models.TableType type = tableTypeDAO.getById(t.getTableTypeId());
                    if (type != null) t.setPricePerHour(type.getPricePerHour());
                }
                displayTables.add(t);
            }

            // Kiểm tra nếu người dùng đã nhập bộ lọc thời gian
            String filterDate = req.getParameter("bookingDate");
            String filterTime = req.getParameter("bookingTime");
            String filterDurationStr = req.getParameter("duration");

            if (filterDate != null && !filterDate.isEmpty()
                    && filterTime != null && !filterTime.isEmpty()
                    && filterDurationStr != null && !filterDurationStr.isEmpty()) {
                try {
                    int dur = Integer.parseInt(filterDurationStr);
                    String playTimeStr = filterDate + "T" + filterTime + ":00";
                    java.time.LocalDateTime playTime = java.time.LocalDateTime.parse(
                            playTimeStr, java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);

                    // Đánh dấu từng bàn: "booked" = không đặt được trong slot, "available" = trống
                    java.util.Map<Integer, String> slotStatusMap = new java.util.HashMap<>();
                    java.util.Map<Integer, String> slotReasonMap = new java.util.HashMap<>();
                    for (TableBida t : displayTables) {
                        String reason = availability.getUnavailableReason(t.getId(), playTime, dur);
                        slotStatusMap.put(t.getId(), reason == null ? "available" : "booked");
                        if (reason != null) slotReasonMap.put(t.getId(), reason);
                    }
                    req.setAttribute("slotStatusMap", slotStatusMap);
                    req.setAttribute("slotReasonMap", slotReasonMap);
                    req.setAttribute("filterDate", filterDate);
                    req.setAttribute("filterTime", filterTime);
                    req.setAttribute("filterDuration", filterDurationStr);
                    req.setAttribute("filterPlayTime", playTimeStr);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            req.setAttribute("tables", displayTables);
            req.setAttribute("freeFromMap", freeFromMap);
            RequestDispatcher dispatcher = req.getRequestDispatcher("/user/datban.jsp");
            dispatcher.forward(req, resp);
        }


    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String action = req.getParameter("action");
        if ("calculate".equals(action)) {
            try {
                int tableId = Integer.parseInt(req.getParameter("tableId"));
                String bookingDate = req.getParameter("bookingDate");
                String bookingTime = req.getParameter("bookingTime");
                int duration = Integer.parseInt(req.getParameter("duration"));

                // Combine date and time (e.g. 2026-06-24T18:30:00)
                String playTimeStr = bookingDate + "T" + bookingTime + ":00";
                LocalDateTime playTime = LocalDateTime.parse(playTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

                // Kiểm tra thời gian đặt không được ở quá khứ
                if (playTime.isBefore(LocalDateTime.now())) {
                    req.getSession().setAttribute("booking_error", "Thời gian đặt bàn không hợp lệ. Vui lòng chọn thời gian trong tương lai.");
                    resp.sendRedirect(req.getContextPath() + "/datban?bookingDate=" + bookingDate
                            + "&bookingTime=" + java.net.URLEncoder.encode(bookingTime, "UTF-8")
                            + "&duration=" + duration);
                    return;
                }

                // Kiểm tra bàn có trống theo quy tắc đặt bàn không
                String reason = availability.getUnavailableReason(tableId, playTime, duration);
                if (reason != null) {
                    req.getSession().setAttribute("booking_error", reason);
                    resp.sendRedirect(req.getContextPath() + "/datban?bookingDate=" + bookingDate
                            + "&bookingTime=" + java.net.URLEncoder.encode(bookingTime, "UTF-8")
                            + "&duration=" + duration);
                    return;
                }

                TableBida table = tableDAO.getById(tableId);
                double hourlyRate = 50000.0;
                if (table != null) {
                    org.example.models.TableType type = tableTypeDAO.getById(table.getTableTypeId());
                    if (type != null) {
                        hourlyRate = type.getPricePerHour();
                    }
                }
                double totalPrice = hourlyRate * duration;
                String playTimeFormatted = playTime.format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

                req.setAttribute("table", table);
                req.setAttribute("playTime", playTimeStr);
                req.setAttribute("playTimeFormatted", playTimeFormatted);
                req.setAttribute("duration", duration);
                req.setAttribute("hourlyRate", hourlyRate);
                req.setAttribute("totalPrice", totalPrice);

                req.getRequestDispatcher("/user/xacnhanbooking.jsp").forward(req, resp);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                req.getSession().setAttribute("booking_error", "Có lỗi xảy ra khi tính hóa đơn đặt bàn.");
                resp.sendRedirect(req.getContextPath() + "/datban");
            }
        } else if ("confirm".equals(action)) {
            try {
                int tableId = Integer.parseInt(req.getParameter("tableId"));
                String playTimeStr = req.getParameter("playTime");
                if (playTimeStr != null && playTimeStr.length() == 16) {
                    playTimeStr += ":00";
                }
                LocalDateTime playTime = LocalDateTime.parse(playTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                int duration = Integer.parseInt(req.getParameter("duration"));
                String paymentType = req.getParameter("paymentType");

                // Kiểm tra lại lần cuối (phòng race condition: 2 người đặt cùng lúc,
                // hoặc bàn vừa được mở cho khách vãng lai)
                String reason = availability.getUnavailableReason(tableId, playTime, duration);
                if (reason != null) {
                    req.getSession().setAttribute("booking_error", "Rất tiếc! " + reason);
                    resp.sendRedirect(req.getContextPath() + "/datban");
                    return;
                }

                if ("Trả trước".equals(paymentType)) {
                    // --- Luồng thanh toán online PayOS ---
                    // 1. Tạo booking trạng thái "Chờ Thanh Toán" và lấy ID
                    Booking b = new Booking(0, acc.getId(), tableId, LocalDateTime.now(), playTime, "Chờ Thanh Toán", duration, paymentType);
                    int newBookingId = bookingDAO.createAndGetId(b);

                    if (newBookingId <= 0) {
                        req.getSession().setAttribute("booking_error", "Lỗi tạo đơn đặt bàn. Vui lòng thử lại.");
                        resp.sendRedirect(req.getContextPath() + "/datban");
                        return;
                    }

                    // 2. Tính số tiền cần thanh toán
                    TableBida table = tableDAO.getById(tableId);
                    double hourlyRate = 50000.0;
                    if (table != null) {
                        org.example.models.TableType type = tableTypeDAO.getById(table.getTableTypeId());
                        if (type != null) hourlyRate = type.getPricePerHour();
                    }
                    int totalAmount = (int) Math.round(hourlyRate * duration);

                    // 3. Xây dựng URL return/cancel
                    String scheme = req.getScheme();
                    String serverName = req.getServerName();
                    int serverPort = req.getServerPort();
                    String contextPath = req.getContextPath();
                    String baseUrl = scheme + "://" + serverName +
                                     (serverPort == 80 || serverPort == 443 ? "" : ":" + serverPort) + contextPath;

                    String returnUrl = baseUrl + "/datban/payos-callback?status=success&bookingId=" + newBookingId;
                    String cancelUrl = baseUrl + "/datban/payos-callback?status=cancel&bookingId=" + newBookingId;

                    // 4. Tạo link thanh toán PayOS
                    long orderCode = System.currentTimeMillis();
                    String checkoutUrl = org.example.utils.PayOSPayment.createPaymentLink(
                        orderCode,
                        totalAmount,
                        "DatBan " + newBookingId,
                        returnUrl,
                        cancelUrl
                    );
                    
                    resp.sendRedirect(checkoutUrl);
                    return;

                } else {
                    // --- Luồng trả sau thông thường ---
                    Booking b = new Booking(0, acc.getId(), tableId, LocalDateTime.now(), playTime, "Chờ Xác Nhận", duration, paymentType);
                    bookingDAO.create(b);
                    // Thông báo cho nhân viên/admin
                    TableBida tblForNotif = tableDAO.getById(tableId);
                    pushNotification(acc, tblForNotif, playTime, duration, 0, "Trả sau");
                }

            } catch (Exception e) {
                e.printStackTrace();
                req.getSession().setAttribute("booking_error", "Có lỗi xảy ra khi đặt bàn. Vui lòng thử lại.");
                resp.sendRedirect(req.getContextPath() + "/datban");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/lichsudatban");
        } else if ("cancel".equals(action)) {
            try {
                int bookingId = Integer.parseInt(req.getParameter("bookingId"));
                bookingDAO.updateStatus(bookingId, "Đã Hủy");
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/lichsudatban");
        } else if ("repay".equals(action)) {
            // Thanh toán lại cho booking "Chờ Thanh Toán"
            try {
                int bookingId = Integer.parseInt(req.getParameter("bookingId"));
                Booking bk = bookingDAO.getById(bookingId);

                // Kiểm tra bảo mật: chỉ cho phép chủ sở hữu đơn thực hiện
                if (bk == null || bk.getAccountId() != acc.getId()) {
                    req.getSession().setAttribute("booking_error", "Không tìm thấy đơn đặt bàn.");
                    resp.sendRedirect(req.getContextPath() + "/lichsudatban");
                    return;
                }
                if (!"Chờ Thanh Toán".equals(bk.getStatus())) {
                    req.getSession().setAttribute("booking_error", "Đơn này không ở trạng thái chờ thanh toán.");
                    resp.sendRedirect(req.getContextPath() + "/lichsudatban");
                    return;
                }

                // Tính lại số tiền
                TableBida table = tableDAO.getById(bk.getTable_id());
                double hourlyRate = 50000.0;
                if (table != null) {
                    org.example.models.TableType type = tableTypeDAO.getById(table.getTableTypeId());
                    if (type != null) hourlyRate = type.getPricePerHour();
                }
                int totalAmount = (int) Math.round(hourlyRate * bk.getDuration());

                // Xây dựng URL
                String scheme = req.getScheme();
                String serverName = req.getServerName();
                int serverPort = req.getServerPort();
                String contextPath = req.getContextPath();
                String baseUrl = scheme + "://" + serverName +
                                 (serverPort == 80 || serverPort == 443 ? "" : ":" + serverPort) + contextPath;

                String returnUrl = baseUrl + "/datban/payos-callback?status=success&bookingId=" + bookingId;
                String cancelUrl = baseUrl + "/datban/payos-callback?status=cancel&bookingId=" + bookingId;

                // Tạo link thanh toán mới
                long orderCode = System.currentTimeMillis();
                String checkoutUrl = org.example.utils.PayOSPayment.createPaymentLink(
                    orderCode, totalAmount, "DatBan " + bookingId, returnUrl, cancelUrl
                );
                
                resp.sendRedirect(checkoutUrl);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                req.getSession().setAttribute("booking_error", "Lỗi khi tạo link thanh toán. Vui lòng thử lại.");
                resp.sendRedirect(req.getContextPath() + "/lichsudatban");
            }
        }
    }

    // -------------------------------------------------------
    /**
     * Push a booking notification into the in-memory queue so that
     * all connected staff/admin SSE clients receive it immediately.
     */
    private void pushNotification(Account acc, TableBida table, LocalDateTime playTime, int duration, int bookingId, String paymentType) {
        try {
            String customerName = acc.getName() != null ? acc.getName() : acc.getEmail();
            String tableName    = table != null ? table.getName() : "Bàn không xác định";
            String playTimeStr  = playTime.format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
            NotificationQueue.getInstance().push(
                new NotificationQueue.Notification(customerName, tableName, playTimeStr, duration, bookingId, paymentType)
            );
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    // -------------------------------------------------------

    /**
     * Xử lý callback sau khi người dùng thanh toán qua PayOS.
     * PayOS redirect về: /datban/payos-callback?status=success&bookingId=X
     * hoặc:               /datban/payos-callback?status=cancel&bookingId=X&cancel=true
     */
    private void handlePayosCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String statusParam = req.getParameter("status");
            String cancelParam = req.getParameter("cancel");
            String codeParam = req.getParameter("code");
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));

            boolean isSuccess = "00".equals(codeParam) || "PAID".equalsIgnoreCase(statusParam) || "false".equalsIgnoreCase(cancelParam) || "success".equalsIgnoreCase(statusParam);
            boolean cancelled = "cancel".equalsIgnoreCase(statusParam) || "true".equalsIgnoreCase(cancelParam) || "CANCELLED".equalsIgnoreCase(statusParam);

            if (isSuccess && !cancelled) {
                Booking bk = bookingDAO.getById(bookingId);
                if (bk != null) {
                    // Check if table is still available for the requested time
                    boolean isBookedByOthers = bookingDAO.isTableBooked(bk.getTable_id(), bk.getPlayTime(), bk.getDuration(), bk.getId());
                    if (isBookedByOthers) {
                        bookingDAO.updateStatus(bookingId, "Đã Hủy");
                        req.getSession().setAttribute("booking_error",
                            "Rất tiếc! Trong lúc bạn thanh toán, bàn này đã được người khác đặt trước. Đơn đặt bàn đã bị hủy.");
                    } else {
                        // Khách đã thanh toán online thành công → chuyển sang "Chờ Xác Nhận" để nhân viên duyệt
                        bookingDAO.updateStatus(bookingId, "Chờ Xác Nhận");
                        req.getSession().setAttribute("booking_success",
                            "Thanh toán trực tuyến thành công! Đơn đặt bàn đã được gửi và đang chờ nhân viên duyệt.");

                        // Đẩy thông báo real-time cho nhân viên/admin ngay khi khách thanh toán xong
                        Account bookingAcc = accountDAO.getAccountById(bk.getAccountId());
                        TableBida tblForNotif = tableDAO.getById(bk.getTable_id());
                        pushNotification(bookingAcc != null ? bookingAcc : new Account(), tblForNotif, bk.getPlayTime(), bk.getDuration(), bk.getId(), "Trả trước");
                    }
                }
            } else {
                // Người dùng hủy hoặc không hoàn tất thanh toán → hủy booking ngay
                bookingDAO.updateStatus(bookingId, "Đã Hủy");
                req.getSession().setAttribute("booking_error",
                    "Thanh toán đã bị hủy / chưa hoàn tất. Đơn đặt bàn của bạn đã bị hủy.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("booking_error", "Lỗi xử lý kết quả thanh toán.");
        }
        resp.sendRedirect(req.getContextPath() + "/lichsudatban");
    }
}
