package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.*;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/employee/trangchunhanvien")
public class EmployeeServlet extends HttpServlet {

    private TableBidaDAO tableBidaDAO;
    private TableTypeDAO tableTypeDAO;
    private BillDAO billDAO;
    private BillDetailsDAO billDetailsDAO;
    private ServiceDAO serviceDAO;
    private ShiftDAO shiftDAO;
    private MemberDAO memberDAO;
    private BookingDAO bookingDAO;
    private AccountDAO accountDAO;

    /** Số giờ tới cần kiểm tra lịch đặt trước khi nhân viên mở bàn (24 giờ). */
    public static final int UPCOMING_BOOKING_WARNING_HOURS = 24;

    @Override
    public void init() throws ServletException {
        tableBidaDAO = new TableBidaDAOImpl();
        tableTypeDAO = new TableTypeDAOImpl();
        billDAO = new BillDAOImpl();
        billDetailsDAO = new BilldetailsDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        shiftDAO = new ShiftDAOImpl();
        memberDAO = new MemberDAOImpl();
        bookingDAO = new BookingDAOImpl();
        accountDAO = new AccountDAOImpl();
    }

    /** Mô tả ngắn gọn các lịch đặt bàn để hiển thị cho nhân viên. */
    private List<Map<String, Object>> describeBookings(List<Booking> bookings) {
        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Booking b : bookings) {
            Map<String, Object> row = new HashMap<>();
            row.put("bookingId", b.getId());
            row.put("playTime", b.getPlayTime() != null ? b.getPlayTime().format(dtf) : "");
            row.put("endTime", b.getPlayTime() != null ? b.getPlayTime().plusHours(b.getDuration()).format(dtf) : "");
            row.put("duration", b.getDuration());
            row.put("status", b.getStatus());
            row.put("paymentType", b.getPaymentType());

            Account customer = accountDAO.getAccountById(b.getAccountId());
            row.put("customerName", customer != null ? customer.getName() : "Không rõ");
            row.put("customerPhone", customer != null ? customer.getPhone() : "");

            TableBida table = tableBidaDAO.getById(b.getTable_id());
            row.put("tableId", b.getTable_id());
            row.put("tableName", table != null ? table.getName() : "Bàn #" + b.getTable_id());
            rows.add(row);
        }
        return rows;
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

        String action = req.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "invoice":
                showInvoice(req, resp);
                break;
            case "payosCallback":
                handlePayosCallback(req, resp);
                break;
            case "shiftSummary":
                showShiftSummary(req, resp);
                break;
            case "lookupMember":
                lookupMember(req, resp);
                break;
            case "view":
            default:
                viewDashboard(req, resp, currentAccount);
                break;
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

        String action = req.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "openShift":
                openShift(req, resp, currentAccount);
                break;
            case "closeShift":
                closeShift(req, resp, currentAccount);
                break;
            case "openTable":
                openTable(req, resp);
                break;
            case "addService":
                addService(req, resp);
                break;
            case "removeService":
                removeService(req, resp);
                break;
            case "checkout":
                checkoutTable(req, resp, currentAccount);
                break;
            case "dismissStaffCall":
                dismissStaffCall(req, resp);
                break;
            case "mergeTable":
                mergeTable(req, resp);
                break;
            case "registerMember":
                registerMember(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                break;
        }
    }

    private void viewDashboard(HttpServletRequest req, HttpServletResponse resp, Account currentAccount) throws ServletException, IOException {
        // 1. Check Shift status
        Shift activeShift = shiftDAO.getActiveShiftByAccountId(currentAccount.getId());
        if (activeShift == null) {
            req.setAttribute("noActiveShift", true);
        } else {
            req.setAttribute("activeShift", activeShift);
            if (activeShift.getTimeStart() != null) {
                java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss dd/MM");
                req.setAttribute("activeShiftTimeStartStr", dtf.format(activeShift.getTimeStart()));
            }
        }

        // 2. Load all tables
        List<TableBida> tables = tableBidaDAO.getAll();
        req.setAttribute("memberList", memberDAO.getAll());

        // 3. Construct a combined list of table details with active bills
        List<Map<String, Object>> tablesWithBills = new ArrayList<>();
        for (TableBida table : tables) {
            Map<String, Object> tableMap = new HashMap<>();
            tableMap.put("id", table.getId());
            tableMap.put("name", table.getName());
            String rawStatus = table.getStatus();
            String status = rawStatus != null ? rawStatus.trim() : "";
            tableMap.put("status", status);
            tableMap.put("tableTypeId", table.getTableTypeId());
            tableMap.put("tableTypeName", table.getTableTypeName());
            tableMap.put("pricePerHour", table.getPricePerHour());
            
            // Lịch đặt trước của bàn này trong 3 giờ tới (hiển thị để nhân viên biết trước khi mở bàn)
            LocalDateTime nowForBooking = LocalDateTime.now();
            List<Map<String, Object>> upcoming = describeBookings(bookingDAO.getUpcomingBookings(
                    table.getId(), nowForBooking, nowForBooking.plusHours(UPCOMING_BOOKING_WARNING_HOURS)));
            tableMap.put("upcomingBookings", upcoming);

            boolean isInUse = "Đang sử dụng".equalsIgnoreCase(status) || "In Use".equalsIgnoreCase(status);
            if (isInUse) {
                Bill bill = billDAO.getUnpaidBillByTableId(table.getId());
                if (bill != null) {
                    tableMap.put("bill", bill);
                    tableMap.put("startTime", bill.getTime_start());
                    if (bill.getTime_start() != null) {
                        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
                        tableMap.put("startTimeStr", dtf.format(bill.getTime_start()));
                        long startEpoch = bill.getTime_start().atZone(java.time.ZoneId.systemDefault()).toInstant().toEpochMilli();
                        tableMap.put("startTimeMillis", startEpoch);
                    } else {
                        tableMap.put("startTimeStr", "");
                        tableMap.put("startTimeMillis", null);
                    }
                    
                    // Load details
                    List<BillDetails> details = billDetailsDAO.getDetailsByBillId(bill.getBill_id());
                    List<Map<String, Object>> sDetails = new ArrayList<>();
                    for (BillDetails d : details) {
                        Service s = serviceDAO.getById(d.getService_id());
                        Map<String, Object> sm = new HashMap<>();
                        sm.put("detailId", d.getId());
                        sm.put("serviceName", s != null ? s.getName() : "Không rõ");
                        sm.put("quantity", d.getQuantity());
                        sm.put("price", d.getPrice());
                        sm.put("total", d.getQuantity() * d.getPrice());
                        sDetails.add(sm);
                    }
                    tableMap.put("services", sDetails);
                    
                    // Calculate elapsed play time
                    LocalDateTime start = bill.getTime_start();
                    LocalDateTime now = LocalDateTime.now();
                    long min = Duration.between(start, now).toMinutes();
                    if (min < 1) min = 0;
                    tableMap.put("elapsedMinutes", min);
                    
                    // Calculate pricePerHour
                    double pPerHour = table.getPricePerHour();
                    double playFee = (min / 60.0) * pPerHour;
                    tableMap.put("playTimeFee", playFee);
                    tableMap.put("hourlyRate", pPerHour);
                }
            }
            tablesWithBills.add(tableMap);
        }

        req.setAttribute("tablesWithBills", tablesWithBills);

        // 4. Load all available services for ordering (in case needed elsewhere)
        List<Service> services = serviceDAO.getAll();
        req.setAttribute("services", services);

        // 5. Load pending StaffCall requests (from QR orders)
        List<java.util.Map<String, Object>> staffCalls = new java.util.ArrayList<>();
        String scSql = "SELECT sc.id, sc.table_id, sc.call_time, sc.status, sc.note, " +
                       "tb.name AS table_name " +
                       "FROM StaffCall sc " +
                       "JOIN TableBida tb ON sc.table_id = tb.id " +
                       "WHERE sc.status = 'Pending' " +
                       "ORDER BY sc.call_time ASC";
        try (java.sql.Connection con = org.example.utils.DBUtil.getConnection();
             java.sql.PreparedStatement pst = con.prepareStatement(scSql);
             java.sql.ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> sc = new java.util.HashMap<>();
                sc.put("id", rs.getInt("id"));
                sc.put("tableId", rs.getInt("table_id"));
                sc.put("tableName", rs.getNString("table_name"));
                sc.put("note", rs.getNString("note"));
                sc.put("status", rs.getString("status"));
                java.sql.Timestamp callTime = rs.getTimestamp("call_time");
                if (callTime != null) {
                    LocalDateTime ldt = callTime.toLocalDateTime();
                    sc.put("callTime", java.time.format.DateTimeFormatter.ofPattern("HH:mm - dd/MM").format(ldt));
                }
                staffCalls.add(sc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("staffCalls", staffCalls);
        req.setAttribute("staffCallCount", staffCalls.size());

        // 6. Shift statistics for current shift (if active)
        if (activeShift != null) {
            List<Bill> shiftBills = billDAO.getPaidBillsByShift(activeShift.getTimeStart(), LocalDateTime.now());
            double shiftRevenue = 0;
            int shiftBillCount = 0;
            for (Bill b : shiftBills) {
                if (b.getAccount_id() != null && b.getAccount_id() == currentAccount.getId()) {
                    shiftRevenue += b.getTotal();
                    shiftBillCount++;
                }
            }
            long tablesInUse = tablesWithBills.stream()
                .filter(t -> {
                    String s = (String) t.get("status");
                    return s != null && ("đang sử dụng".equalsIgnoreCase(s.trim()) || "in use".equalsIgnoreCase(s.trim()));
                }).count();
            req.setAttribute("shiftRevenue", shiftRevenue);
            req.setAttribute("shiftBillCount", shiftBillCount);
            req.setAttribute("shiftTablesInUse", (int) tablesInUse);
        }

        req.getRequestDispatcher("/employee/trangchunhanvien.jsp").forward(req, resp);
    }

    private void dismissStaffCall(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int callId = Integer.parseInt(req.getParameter("callId"));
            String sql = "UPDATE StaffCall SET status = 'Done' WHERE id = ?";
            try (java.sql.Connection con = org.example.utils.DBUtil.getConnection();
                 java.sql.PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, callId);
                pst.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private double getHourlyRate(int tableId) {
        double rate = 50000.0; // Fallback default hourly price (50k VND)
        try {
            TableBida table = tableBidaDAO.getById(tableId);
            if (table != null) {
                int tableTypeId = table.getTableTypeId();

                TableType type = null;
                if (tableTypeId > 0) {
                    type = tableTypeDAO.getById(tableTypeId);
                }

                if (type == null) {
                    // Fallback to first available TableType
                    List<TableType> allTypes = tableTypeDAO.getAll();
                    if (!allTypes.isEmpty()) {
                        type = allTypes.get(0);
                    }
                }

                if (type != null) {
                    double p = type.getPricePerHour();
                    if (p != 0) {
                        rate = Math.abs(p);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rate;
    }

    private void openShift(HttpServletRequest req, HttpServletResponse resp, Account account) throws IOException {
        try {
            double initialBalance = Double.parseDouble(req.getParameter("initialBalance"));
            Shift shift = new Shift();
            shift.setAccountId(account.getId());
            shift.setTimeStart(LocalDateTime.now());
            shift.setInitialBalance(initialBalance);
            shift.setTotalRevenue(0);
            shift.setStatus("Open");

            boolean success = shiftDAO.openShift(shift);
            if (success) {
                req.getSession().setAttribute("message", "Mở ca làm việc thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể mở ca.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Dữ liệu mở ca không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void closeShift(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws ServletException, IOException {
        Shift activeShift = shiftDAO.getActiveShiftByAccountId(account.getId());
        if (activeShift == null) {
            req.getSession().setAttribute("error", "Lỗi: Không có ca làm việc nào đang mở.");
            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
            return;
        }

        // Bắt buộc nhập số tiền thực tế trong két khi đóng ca
        String closingBalanceStr = req.getParameter("closingBalance");
        double closingBalance;
        try {
            if (closingBalanceStr == null || closingBalanceStr.trim().isEmpty()) {
                throw new NumberFormatException("empty");
            }
            closingBalance = Double.parseDouble(closingBalanceStr.trim().replace(",", ""));
            if (closingBalance < 0) throw new NumberFormatException("negative");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Vui lòng nhập số tiền cuối ca hợp lệ trước khi đóng ca.");
            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
            return;
        }

        // Đọc số tiền đầu ca (xác nhận hoặc điều chỉnh lại nếu kiểm đếm thực tế đầu ca thay đổi)
        String initialBalanceStr = req.getParameter("initialBalance");
        double initialBalance = activeShift.getInitialBalance();
        if (initialBalanceStr != null && !initialBalanceStr.trim().isEmpty()) {
            try {
                double parsed = Double.parseDouble(initialBalanceStr.trim().replace(",", ""));
                if (parsed >= 0) {
                    initialBalance = parsed;
                }
            } catch (Exception ex) {
                // Giữ mặc định initialBalance của activeShift
            }
        }

        // Đọc ghi chú giải trình dư/thiếu & bàn giao ca
        String note = req.getParameter("note");
        if (note != null) {
            note = note.trim();
        }

        // Calculate total revenue from all bills closed during this shift by this employee
        List<Bill> bills = billDAO.getPaidBillsByShift(activeShift.getTimeStart(), LocalDateTime.now());
        double totalRevenue = 0;
        for (Bill b : bills) {
            if (b.getAccount_id() != null && b.getAccount_id() == account.getId()) {
                totalRevenue += b.getTotal();
            }
        }

        boolean success = shiftDAO.closeShift(activeShift.getId(), initialBalance, totalRevenue, closingBalance, note);
        if (!success) {
            req.getSession().setAttribute("error", "Lỗi: Không thể đóng ca làm việc.");
            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
            return;
        }

        // Hiển thị phiếu tổng kết ca rồi đăng xuất nhân viên khỏi hệ thống
        Shift closedShift = shiftDAO.getShiftById(activeShift.getId());
        prepareShiftSummary(req, closedShift != null ? closedShift : activeShift);
        req.setAttribute("loggedOut", true);
        req.getSession().invalidate();
        req.getRequestDispatcher("/employee/tongketca.jsp").forward(req, resp);
    }

    private void openTable(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int tableId = Integer.parseInt(req.getParameter("tableId"));
            TableBida table = tableBidaDAO.getById(tableId);
            if (table != null) {
                String rawStatus = table.getStatus() != null ? table.getStatus().trim() : "";
                if ("Trống".equalsIgnoreCase(rawStatus) || "Available".equalsIgnoreCase(rawStatus)) {

                    // Cảnh báo nếu bàn đã có khách đặt trước trong 3 giờ tới
                    boolean force = "1".equals(req.getParameter("force"));
                    if (!force) {
                        LocalDateTime now = LocalDateTime.now();
                        List<Booking> upcoming = bookingDAO.getUpcomingBookings(
                                tableId, now, now.plusHours(UPCOMING_BOOKING_WARNING_HOURS));
                        if (!upcoming.isEmpty()) {
                            req.getSession().setAttribute("openTableWarningTableId", tableId);
                            req.getSession().setAttribute("openTableWarningTableName", table.getName());
                            req.getSession().setAttribute("openTableWarnings", describeBookings(upcoming));
                            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                            return;
                        }
                    }

                    Bill bill = new Bill();
                    bill.setTable_id(tableId);
                    Account acc = (Account) req.getSession().getAttribute("account");
                    if (acc != null) {
                        bill.setAccount_id(acc.getId());
                    }
                    bill.setTime_start(LocalDateTime.now());
                    bill.setTotal(0);
                    bill.setStatus("Unpaid");

                    boolean billCreated = billDAO.createBill(bill);
                    if (billCreated) {
                        table.setStatus("Đang sử dụng");
                        boolean tableUpdated = tableBidaDAO.update(table);
                        if (tableUpdated) {
                            req.getSession().setAttribute("message", "Mở bàn " + table.getName() + " thành công!");
                        } else {
                            req.getSession().setAttribute("error", "Lỗi cập nhật trạng thái bàn thành đang sử dụng.");
                        }
                    } else {
                        req.getSession().setAttribute("error", "Lỗi khởi tạo hóa đơn khi mở bàn.");
                    }
                } else {
                    req.getSession().setAttribute("error", "Bàn đã được mở hoặc không hợp lệ. Trạng thái: '" + rawStatus + "'");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi mở bàn: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void addService(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int tableId = 0;
        try {
            tableId = Integer.parseInt(req.getParameter("tableId"));
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            Bill bill = billDAO.getUnpaidBillByTableId(tableId);
            if (bill != null) {
                Service service = serviceDAO.getById(serviceId);
                if (service != null) {
                    BillDetails existing = billDetailsDAO.getDetailByBillAndService(bill.getBill_id(), serviceId);
                    if (existing != null) {
                        existing.setQuantity(existing.getQuantity() + quantity);
                        billDetailsDAO.updateDetail(existing);
                    } else {
                        BillDetails detail = new BillDetails();
                        detail.setBillId(bill.getBill_id());
                        detail.setService_id(serviceId);
                        detail.setQuantity(quantity);
                        detail.setPrice(service.getPrice());
                        billDetailsDAO.addDetail(detail);
                    }
                    req.getSession().setAttribute("message", "Thêm dịch vụ thành công!");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi thêm dịch vụ: " + e.getMessage());
        }
        
        String referer = req.getHeader("referer");
        if (referer != null && referer.contains("quanlidichvu")) {
            resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu?tableId=" + tableId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
        }
    }

    private void removeService(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int detailId = Integer.parseInt(req.getParameter("detailId"));
            billDetailsDAO.deleteDetail(detailId);
            req.getSession().setAttribute("message", "Xóa dịch vụ thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi xóa dịch vụ: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void checkoutTable(HttpServletRequest req, HttpServletResponse resp, Account currentAccount) throws IOException {
        try {
            int tableId = Integer.parseInt(req.getParameter("tableId"));
            String paymentMethod = req.getParameter("paymentMethod");
            String memberIdStr = req.getParameter("memberId");
            TableBida table = tableBidaDAO.getById(tableId);
            Bill bill = billDAO.getUnpaidBillByTableId(tableId);

            if (table != null && bill != null) {
                LocalDateTime end = LocalDateTime.now();
                long minutes = Duration.between(bill.getTime_start(), end).toMinutes();
                if (minutes < 1) minutes = 0;
                double hours = minutes / 60.0;

                double pPerHour = table.getPricePerHour();
                double playFee = hours * pPerHour;

                // Sum service charges
                List<BillDetails> details = billDetailsDAO.getDetailsByBillId(bill.getBill_id());
                double serviceTotal = 0;
                for (BillDetails d : details) {
                    serviceTotal += d.getQuantity() * d.getPrice();
                }

                double subtotal = playFee + serviceTotal;
                Integer memberId = null;
                if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                    try {
                        memberId = Integer.parseInt(memberIdStr.trim());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
                
                double discountRate = 0.0;
                if (memberId != null) {
                    try {
                        Member member = memberDAO.getById(memberId);
                        if (member != null) {
                            int pts = member.getPoints();
                            double maxAllowedRate = 0.0;
                            if (pts >= 2000) {
                                maxAllowedRate = 20.0;
                            } else if (pts >= 1000) {
                                maxAllowedRate = 15.0;
                            } else if (pts >= 500) {
                                maxAllowedRate = 10.0;
                            } else if (pts >= 300) {
                                maxAllowedRate = 5.0;
                            }

                            String discountRateStr = req.getParameter("discountRate");
                            double requestedRate = 0.0;
                            if (discountRateStr != null && !discountRateStr.trim().isEmpty()) {
                                try {
                                    requestedRate = Double.parseDouble(discountRateStr.trim());
                                } catch (Exception ex) {
                                    requestedRate = 0.0;
                                }
                            } else {
                                requestedRate = member.getDiscountRate();
                            }

                            discountRate = Math.min(requestedRate, maxAllowedRate);
                            if (discountRate < 0) discountRate = 0.0;
                        } else {
                            memberId = null;
                            discountRate = 0.0;
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        discountRate = 0.0;
                    }
                } else {
                    discountRate = 0.0;
                }
                
                double discountAmount = (subtotal * discountRate) / 100.0;
                double total = subtotal - discountAmount;

                if ("transfer".equalsIgnoreCase(paymentMethod)) {
                    // PayOS flow
                    bill.setTime_end(end);
                    bill.setTotal(total);
                    bill.setAccount_id(currentAccount.getId());
                    bill.setMemberId(memberId);
                    billDAO.updateBill(bill);

                    String scheme = req.getScheme();
                    String serverName = req.getServerName();
                    int serverPort = req.getServerPort();
                    String contextPath = req.getContextPath();

                    String baseUrl = scheme + "://" + serverName + (serverPort == 80 || serverPort == 443 ? "" : ":" + serverPort) + contextPath;
                    String returnUrl = baseUrl + "/employee/trangchunhanvien?action=payosCallback&billId=" + bill.getBill_id() + "&tableId=" + tableId;
                    String cancelUrl = baseUrl + "/employee/trangchunhanvien?action=payosCallback&billId=" + bill.getBill_id() + "&tableId=" + tableId;

                    long orderCode = System.currentTimeMillis();
                    String checkoutUrl = org.example.utils.PayOSPayment.createPaymentLink(
                        orderCode,
                        (int) Math.round(total),
                        "Thanh toan " + table.getName(),
                        returnUrl,
                        cancelUrl
                    );
                    
                    resp.sendRedirect(checkoutUrl);
                    return;
                } else {
                    // Traditional cash flow
                    bill.setTime_end(end);
                    bill.setTotal(total);
                    bill.setStatus("Paid");
                    bill.setAccount_id(currentAccount.getId()); // Record cashier who processed checkout
                    bill.setMemberId(memberId);
                    billDAO.updateBill(bill);

                    // Award points
                    if (memberId != null) {
                        int pointsEarned = (int) (total / 1000);
                        memberDAO.addPoints(memberId, pointsEarned);
                    }

                    // Update table
                    table.setStatus("Trống");
                    tableBidaDAO.update(table);

                    resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien?action=invoice&billId=" + bill.getBill_id());
                    return;
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi thanh toán: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void handlePayosCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String cancelParam = req.getParameter("cancel");
            String codeParam = req.getParameter("code");
            String statusParam = req.getParameter("status");
            int billId = Integer.parseInt(req.getParameter("billId"));
            int tableId = Integer.parseInt(req.getParameter("tableId"));

            boolean isSuccess = "00".equals(codeParam) || "PAID".equalsIgnoreCase(statusParam) || "false".equalsIgnoreCase(cancelParam) || "success".equalsIgnoreCase(statusParam);
            boolean isCancelled = "true".equalsIgnoreCase(cancelParam) || "CANCELLED".equalsIgnoreCase(statusParam) || "cancel".equalsIgnoreCase(statusParam);

            if (isSuccess && !isCancelled) {
                Bill bill = billDAO.getBillById(billId);
                TableBida table = tableBidaDAO.getById(tableId);
                if (bill != null && table != null) {
                    bill.setStatus("Paid");
                    billDAO.updateBill(bill);

                    // Award points if member is set
                    if (bill.getMemberId() != null) {
                        int pointsEarned = (int) (bill.getTotal() / 1000);
                        memberDAO.addPoints(bill.getMemberId(), pointsEarned);
                    }

                    table.setStatus("Trống");
                    tableBidaDAO.update(table);

                    req.getSession().setAttribute("message", "Thanh toán qua PayOS thành công!");
                    resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien?action=invoice&billId=" + billId);
                    return;
                }
            } else {
                req.getSession().setAttribute("error", "Thanh toán qua PayOS đã bị hủy hoặc thất bại.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi xử lý phản hồi PayOS: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void showInvoice(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int billId = Integer.parseInt(req.getParameter("billId"));
            Bill bill = billDAO.getBillById(billId);
            if (bill != null) {
                TableBida table = tableBidaDAO.getById(bill.getTable_id());
                req.setAttribute("bill", bill);
                req.setAttribute("table", table);

                 // Time math
                LocalDateTime start = bill.getTime_start();
                LocalDateTime end = bill.getTime_end();
                long minutes = Duration.between(start, end).toMinutes();
                if (minutes < 1) minutes = 0;
                req.setAttribute("playMinutes", minutes);

                java.time.format.DateTimeFormatter hFormatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yy");
                req.setAttribute("billStartTimeStr", start != null ? hFormatter.format(start) : "");
                req.setAttribute("billEndTimeStr", end != null ? hFormatter.format(end) : "");

                double rate = table != null ? table.getPricePerHour() : 50000.0;
                req.setAttribute("hourlyRate", rate);
                double playFee = (minutes / 60.0) * rate;
                req.setAttribute("playFee", playFee);

                // Service Details
                List<BillDetails> details = billDetailsDAO.getDetailsByBillId(billId);
                List<Map<String, Object>> sDetails = new ArrayList<>();
                double serviceTotal = 0;
                for (BillDetails d : details) {
                    Service s = serviceDAO.getById(d.getService_id());
                    Map<String, Object> map = new HashMap<>();
                    map.put("serviceName", s != null ? s.getName() : "Không rõ");
                    map.put("quantity", d.getQuantity());
                    map.put("price", d.getPrice());
                    map.put("total", d.getQuantity() * d.getPrice());
                    sDetails.add(map);
                    serviceTotal += d.getQuantity() * d.getPrice();
                }
                req.setAttribute("services", sDetails);
                req.setAttribute("serviceTotal", serviceTotal);

                // Cashier name
                String cashierName = "Nhân viên";
                if (bill.getAccount_id() != null) {
                    Account cash = new AccountDAOImpl().getAccountById(bill.getAccount_id());
                    if (cash != null) {
                        cashierName = cash.getName();
                    }
                }
                req.setAttribute("cashierName", cashierName);

                // Member details
                if (bill.getMemberId() != null) {
                    Member member = memberDAO.getById(bill.getMemberId());
                    req.setAttribute("member", member);
                }

                req.getRequestDispatcher("/employee/hoadon.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    private void showShiftSummary(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int shiftId = Integer.parseInt(req.getParameter("shiftId"));
            Shift shift = shiftDAO.getShiftById(shiftId);
            if (shift != null) {
                prepareShiftSummary(req, shift);
                req.getRequestDispatcher("/employee/tongketca.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    /** Nạp toàn bộ dữ liệu phiếu tổng kết ca vào request để hiển thị tongketca.jsp. */
    private void prepareShiftSummary(HttpServletRequest req, Shift shift) {
        req.setAttribute("shift", shift);
        Account employee = new AccountDAOImpl().getAccountById(shift.getAccountId());
        req.setAttribute("employee", employee);

        // Load all bills closed by this cashier in this shift
        LocalDateTime end = shift.getTimeEnd() != null ? shift.getTimeEnd() : LocalDateTime.now();
        List<Bill> bills = billDAO.getPaidBillsByShift(shift.getTimeStart(), end);
        List<Map<String, Object>> shiftBillsList = new ArrayList<>();
        java.time.format.DateTimeFormatter billTimeEndFormatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss");
        double computedRevenue = 0;
        for (Bill b : bills) {
            if (b.getAccount_id() != null && b.getAccount_id() == shift.getAccountId()) {
                Map<String, Object> bm = new HashMap<>();
                bm.put("bill_id", b.getBill_id());
                bm.put("table_id", b.getTable_id());
                bm.put("total", b.getTotal());
                bm.put("timeEndStr", b.getTime_end() != null ? billTimeEndFormatter.format(b.getTime_end()) : "");
                shiftBillsList.add(bm);
                computedRevenue += b.getTotal();
            }
        }
        double grandTotal = shift.getInitialBalance() + computedRevenue;
        req.setAttribute("shiftBills", shiftBillsList);
        req.setAttribute("computedRevenue", computedRevenue);
        req.setAttribute("grandTotalAmount", grandTotal);
        // Chênh lệch giữa tiền thực tế nhân viên nhập khi đóng ca và số tiền kỳ vọng
        req.setAttribute("cashDifference", shift.getClosingBalance() - grandTotal);

        java.time.format.DateTimeFormatter sFormatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
        req.setAttribute("shiftTimeStartStr", shift.getTimeStart() != null ? sFormatter.format(shift.getTimeStart()) : "");
        req.setAttribute("shiftTimeEndStr", shift.getTimeEnd() != null ? sFormatter.format(shift.getTimeEnd()) : "");
    }

    private void mergeTable(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int targetTableId = Integer.parseInt(req.getParameter("targetTableId"));
            int sourceTableId = Integer.parseInt(req.getParameter("sourceTableId"));

            if (targetTableId == sourceTableId) {
                req.getSession().setAttribute("error", "Không thể gộp bàn vào chính nó.");
                resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                return;
            }

            TableBida targetTable = tableBidaDAO.getById(targetTableId);
            TableBida sourceTable = tableBidaDAO.getById(sourceTableId);
            Bill targetBill = billDAO.getUnpaidBillByTableId(targetTableId);
            Bill sourceBill = billDAO.getUnpaidBillByTableId(sourceTableId);

            if (targetTable == null || sourceTable == null || sourceBill == null) {
                req.getSession().setAttribute("error", "Thông tin bàn hoặc hóa đơn không hợp lệ.");
                resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                return;
            }

            if (targetBill == null) {
                // Target table is empty: simple move, not a merge (no bill to merge into).
                sourceBill.setTable_id(targetTableId);
                boolean moved = billDAO.updateBill(sourceBill);
                if (moved) {
                    sourceTable.setStatus("Trống");
                    tableBidaDAO.update(sourceTable);

                    targetTable.setStatus("Đang sử dụng");
                    tableBidaDAO.update(targetTable);

                    req.getSession().setAttribute("message", "Chuyển bàn thành công từ " + sourceTable.getName() + " sang " + targetTable.getName() + "!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể chuyển hóa đơn sang bàn mới.");
                }
                resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                return;
            }

            LocalDateTime now = LocalDateTime.now();
            
            // 1. Calculate play time fee of the source table
            LocalDateTime sourceStart = sourceBill.getTime_start();
            long minutes = Duration.between(sourceStart, now).toMinutes();
            if (minutes < 0) minutes = 0;
            double rate = sourceTable.getPricePerHour();
            double playFee = (minutes / 60.0) * rate;
            double roundedPlayFee = Math.round(playFee);

            // 2. Find or create the Service named "Tiền giờ [Source Table Name]"
            String serviceName = "Tiền giờ " + sourceTable.getName();
            Service timeService = null;
            List<Service> allServices = serviceDAO.getAll();
            for (Service s : allServices) {
                if (serviceName.equalsIgnoreCase(s.getName())) {
                    timeService = s;
                    break;
                }
            }
            if (timeService == null) {
                timeService = new Service();
                timeService.setName(serviceName);
                timeService.setPrice(0.0);
                timeService.setCategory("Khác");
                serviceDAO.create(timeService);
                // reload services
                for (Service s : serviceDAO.getAll()) {
                    if (serviceName.equalsIgnoreCase(s.getName())) {
                        timeService = s;
                        break;
                    }
                }
            }

            if (timeService != null) {
                // Add play fee to target bill
                BillDetails playFeeDetail = new BillDetails();
                playFeeDetail.setBillId(targetBill.getBill_id());
                playFeeDetail.setService_id(timeService.getId());
                playFeeDetail.setQuantity(1);
                playFeeDetail.setPrice(roundedPlayFee);
                billDetailsDAO.addDetail(playFeeDetail);
            }

            // 3. Move all services from source bill to target bill
            List<BillDetails> sourceDetails = billDetailsDAO.getDetailsByBillId(sourceBill.getBill_id());
            for (BillDetails sd : sourceDetails) {
                // Check if target already has this service
                BillDetails existing = billDetailsDAO.getDetailByBillAndService(targetBill.getBill_id(), sd.getService_id());
                if (existing != null) {
                    existing.setQuantity(existing.getQuantity() + sd.getQuantity());
                    billDetailsDAO.updateDetail(existing);
                    billDetailsDAO.deleteDetail(sd.getId());
                } else {
                    sd.setBillId(targetBill.getBill_id());
                    billDetailsDAO.updateDetail(sd);
                }
            }

            // 4. Mark source bill as merged/paid with 0 total
            sourceBill.setStatus("Paid");
            sourceBill.setTotal(0.0);
            sourceBill.setTime_end(now);
            billDAO.updateBill(sourceBill);

            // 5. Update source table status to available
            sourceTable.setStatus("Trống");
            tableBidaDAO.update(sourceTable);

            req.getSession().setAttribute("message", "Gộp hóa đơn " + sourceTable.getName() + " vào " + targetTable.getName() + " thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi gộp bàn: " + e.getMessage());
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
    }

    // Looks up a member by phone number for the checkout payment modal (AJAX, JSON response).
    private void lookupMember(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String phone = req.getParameter("phone");
        StringBuilder json = new StringBuilder();
        try {
            Member member = (phone != null && !phone.trim().isEmpty()) ? memberDAO.getByPhone(phone.trim()) : null;
            if (member != null) {
                json.append("{\"found\":true,")
                    .append("\"id\":").append(member.getId()).append(",")
                    .append("\"name\":\"").append(jsonEscape(member.getName())).append("\",")
                    .append("\"phone\":\"").append(jsonEscape(member.getPhone())).append("\",")
                    .append("\"points\":").append(member.getPoints()).append(",")
                    .append("\"discountRate\":").append(member.getDiscountRate())
                    .append("}");
            } else {
                json.append("{\"found\":false}");
            }
        } catch (Exception e) {
            json = new StringBuilder("{\"found\":false}");
        }
        resp.getWriter().write(json.toString());
    }

    // Quick membership registration for first-time customers during checkout (AJAX, JSON response).
    private void registerMember(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        StringBuilder json = new StringBuilder();
        try {
            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                json.append("{\"success\":false,\"error\":\"Vui lòng nhập đầy đủ tên và số điện thoại.\"}");
            } else if (memberDAO.getByPhone(phone.trim()) != null) {
                json.append("{\"success\":false,\"error\":\"Số điện thoại này đã được đăng ký thành viên.\"}");
            } else {
                Member newMember = new Member();
                newMember.setUsername(phone.trim());
                newMember.setName(name.trim());
                newMember.setPhone(phone.trim());
                newMember.setEmail("");
                newMember.setPoints(0);
                newMember.setDiscountRate(0);
                boolean success = memberDAO.create(newMember, null);
                if (success) {
                    Member created = memberDAO.getByPhone(phone.trim());
                    if (created != null) {
                        json.append("{\"success\":true,")
                            .append("\"id\":").append(created.getId()).append(",")
                            .append("\"name\":\"").append(jsonEscape(created.getName())).append("\",")
                            .append("\"phone\":\"").append(jsonEscape(created.getPhone())).append("\",")
                            .append("\"points\":").append(created.getPoints()).append(",")
                            .append("\"discountRate\":").append(created.getDiscountRate())
                            .append("}");
                    } else {
                        json.append("{\"success\":true}");
                    }
                } else {
                    json.append("{\"success\":false,\"error\":\"Không thể đăng ký thành viên. Vui lòng thử lại.\"}");
                }
            }
        } catch (Exception e) {
            json = new StringBuilder("{\"success\":false,\"error\":\"Lỗi hệ thống: ").append(jsonEscape(e.getMessage())).append("\"}");
        }
        resp.getWriter().write(json.toString());
    }

    private String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}
