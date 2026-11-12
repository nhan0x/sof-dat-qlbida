package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.LockerDAO;
import org.example.daos.LockerDAOImpl;
import org.example.daos.MemberDAO;
import org.example.daos.MemberDAOImpl;
import org.example.models.Account;
import org.example.models.Locker;
import org.example.models.Member;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/quanlilocker")
public class LockerServlet extends HttpServlet {

    private LockerDAO lockerDAO;
    private MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        lockerDAO = new LockerDAOImpl();
        memberDAO = new MemberDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = (Account) req.getSession().getAttribute("account");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                deleteLocker(req, resp);
                break;
            case "release":
                releaseLocker(req, resp);
                break;
            case "lockerPayosCallback":
                handleLockerPayosCallback(req, resp);
                break;
            case "lockerReceipt":
                showLockerReceipt(req, resp);
                break;
            case "list":
            default:
                listLockers(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = (Account) req.getSession().getAttribute("account");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createLocker(req, resp);
                break;
            case "update":
                updateLocker(req, resp);
                break;
            case "rent":
                rentLocker(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
                break;
        }
    }

    private void listLockers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        List<Locker> lockerList;
        if (search != null && !search.trim().isEmpty()) {
            lockerList = lockerDAO.search(search.trim());
            req.setAttribute("searchKeyword", search.trim());
        } else {
            lockerList = lockerDAO.getAll();
        }
        
        List<Member> memberList = memberDAO.getAll();
        req.setAttribute("lockerList", lockerList);
        req.setAttribute("memberList", memberList);
        
        req.getRequestDispatcher("/admin/quanlilocker.jsp").forward(req, resp);
    }

    private void createLocker(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String lockerNumber = req.getParameter("lockerNumber");
            double price = Double.parseDouble(req.getParameter("price"));
            String note = req.getParameter("note");

            if (lockerNumber == null || lockerNumber.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Số tủ không được để trống.");
            } else {
                Locker locker = new Locker();
                locker.setLockerNumber(lockerNumber.trim());
                locker.setPrice(price);
                locker.setNote(note != null ? note.trim() : "");

                boolean success = lockerDAO.create(locker);
                if (success) {
                    req.getSession().setAttribute("message", "Thêm tủ đựng cơ mới thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể thêm tủ. Số tủ có thể đã tồn tại.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Dữ liệu nhập vào không hợp lệ: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }

    private void updateLocker(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String lockerNumber = req.getParameter("lockerNumber");
            double price = Double.parseDouble(req.getParameter("price"));
            String note = req.getParameter("note");

            if (lockerNumber == null || lockerNumber.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Số tủ không được để trống.");
            } else {
                Locker locker = lockerDAO.getById(id);
                if (locker == null) {
                    req.getSession().setAttribute("error", "Không tìm thấy tủ.");
                } else {
                    locker.setLockerNumber(lockerNumber.trim());
                    locker.setPrice(price);
                    locker.setNote(note != null ? note.trim() : "");

                    boolean success = lockerDAO.update(locker);
                    if (success) {
                        req.getSession().setAttribute("message", "Cập nhật thông tin tủ thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật tủ.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Dữ liệu nhập vào không hợp lệ: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }

    private void deleteLocker(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Locker locker = lockerDAO.getById(id);
            if (locker != null) {
                if ("Occupied".equalsIgnoreCase(locker.getStatus())) {
                    req.getSession().setAttribute("error", "Không thể xóa tủ đang có thành viên thuê. Vui lòng giải phóng tủ trước.");
                } else {
                    boolean success = lockerDAO.delete(id);
                    if (success) {
                        req.getSession().setAttribute("message", "Xóa tủ đựng cơ thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể xóa tủ.");
                    }
                }
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy tủ để xóa.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }

    private void rentLocker(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int lockerId = Integer.parseInt(req.getParameter("lockerId"));
            String customerType = req.getParameter("customerType"); // "member" or "guest"
            String memberIdStr = req.getParameter("memberId");
            String customerName = req.getParameter("customerName");
            String startDateStr = req.getParameter("startDate");
            String endDateStr = req.getParameter("endDate");
            double price = Double.parseDouble(req.getParameter("price"));
            String note = req.getParameter("note");
            String paymentMethod = req.getParameter("paymentMethod"); // "TM" or "CK"

            Integer memberId = null;
            if (!"guest".equals(customerType) && memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                memberId = Integer.parseInt(memberIdStr.trim());
            }
            if ("guest".equals(customerType)) {
                customerName = customerName != null ? customerName.trim() : "";
            } else {
                customerName = null;
            }

            // Build note with payment prefix
            String prefix = "CK".equals(paymentMethod) ? "[CK]" : "[TM]";
            String fullNote = prefix + (note != null ? note.trim() : "");

            if (memberId == null && (customerName == null || customerName.isEmpty())) {
                req.getSession().setAttribute("error", "Vui lòng chọn thành viên hoặc nhập tên khách hàng.");
            } else if (startDateStr == null || startDateStr.trim().isEmpty() || endDateStr == null || endDateStr.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng chọn thời gian bắt đầu và kết thúc thuê.");
            } else {
                // HTML datetime-local format: yyyy-MM-dd'T'HH:mm
                DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                LocalDateTime start = LocalDateTime.parse(startDateStr, formatter);
                LocalDateTime end = LocalDateTime.parse(endDateStr, formatter);

                if (end.isBefore(start)) {
                    req.getSession().setAttribute("error", "Thời gian kết thúc không thể trước thời gian bắt đầu.");
                } else {
                    Locker locker = lockerDAO.getById(lockerId);
                    if (locker == null) {
                        req.getSession().setAttribute("error", "Tủ đựng cơ không tồn tại.");
                    } else if (!"Available".equalsIgnoreCase(locker.getStatus())) {
                        req.getSession().setAttribute("error", "Tủ này đang được thuê hoặc chờ thanh toán bởi khách khác.");
                    } else if (memberId != null && lockerDAO.getByMemberId(memberId) != null) {
                        Locker existing = lockerDAO.getByMemberId(memberId);
                        req.getSession().setAttribute("error", "Thành viên này đang thuê tủ " + existing.getLockerNumber() + ". Mỗi thành viên chỉ được thuê một tủ.");
                    } else if ("CK".equals(paymentMethod)) {
                        // Bank transfer: reserve the locker as "awaiting payment" and redirect to PayOS
                        boolean reserved = lockerDAO.assignMember(lockerId, memberId, customerName, start, end, price, fullNote, "Chờ Thanh Toán");
                        if (!reserved) {
                            req.getSession().setAttribute("error", "Lỗi: Không thể giữ tủ để thanh toán.");
                        } else {
                            try {
                                String baseUrl = buildBaseUrl(req);
                                String callbackUrl = baseUrl + "/admin/quanlilocker?action=lockerPayosCallback&lockerId=" + lockerId;
                                long orderCode = System.currentTimeMillis();
                                String checkoutUrl = org.example.utils.PayOSPayment.createPaymentLink(
                                        orderCode,
                                        (int) Math.round(price),
                                        "Thue tu " + locker.getLockerNumber(),
                                        callbackUrl,
                                        callbackUrl
                                );
                                
                                resp.sendRedirect(checkoutUrl);
                                return;
                            } catch (Exception payosEx) {
                                lockerDAO.releaseLocker(lockerId);
                                req.getSession().setAttribute("error", "Lỗi tạo liên kết thanh toán PayOS: " + payosEx.getMessage());
                            }
                        }
                    } else {
                        // Cash: assign immediately and print a receipt
                        boolean success = lockerDAO.assignMember(lockerId, memberId, customerName, start, end, price, fullNote, "Occupied");
                        if (success) {
                            resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker?action=lockerReceipt&lockerId=" + lockerId);
                            return;
                        } else {
                            req.getSession().setAttribute("error", "Lỗi: Không thể gán tủ.");
                        }
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi gán tủ: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }

    private void handleLockerPayosCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String cancelParam = req.getParameter("cancel");
            String codeParam = req.getParameter("code");
            String statusParam = req.getParameter("status");
            int lockerId = Integer.parseInt(req.getParameter("lockerId"));

            boolean isSuccess = "00".equals(codeParam) || "PAID".equalsIgnoreCase(statusParam) || "false".equalsIgnoreCase(cancelParam) || "success".equalsIgnoreCase(statusParam);
            boolean isCancelled = "true".equalsIgnoreCase(cancelParam) || "CANCELLED".equalsIgnoreCase(statusParam) || "cancel".equalsIgnoreCase(statusParam);

            if (isSuccess && !isCancelled) {
                boolean confirmed = lockerDAO.confirmRental(lockerId);
                if (confirmed) {
                    req.getSession().setAttribute("message", "Thanh toán thuê tủ qua PayOS thành công!");
                    resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker?action=lockerReceipt&lockerId=" + lockerId);
                    return;
                } else {
                    req.getSession().setAttribute("error", "Lỗi xác nhận thuê tủ sau khi thanh toán.");
                }
            } else {
                // Payment cancelled or failed: release the locker back to Available
                lockerDAO.releaseLocker(lockerId);
                req.getSession().setAttribute("error", "Thanh toán qua PayOS đã bị hủy hoặc thất bại.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi xử lý phản hồi PayOS: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }

    private void showLockerReceipt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int lockerId = Integer.parseInt(req.getParameter("lockerId"));
            Locker locker = lockerDAO.getById(lockerId);
            if (locker == null) {
                req.getSession().setAttribute("error", "Không tìm thấy thông tin tủ để in hóa đơn.");
                resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
                return;
            }
            req.setAttribute("locker", locker);
            req.getRequestDispatcher("/admin/hoadonlocker.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hiển thị hóa đơn: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
        }
    }

    private String buildBaseUrl(HttpServletRequest req) {
        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();
        return scheme + "://" + serverName + (serverPort == 80 || serverPort == 443 ? "" : ":" + serverPort) + contextPath;
    }

    private void releaseLocker(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int lockerId = Integer.parseInt(req.getParameter("lockerId"));
            Locker locker = lockerDAO.getById(lockerId);
            if (locker != null) {
                boolean success = lockerDAO.releaseLocker(lockerId);
                if (success) {
                    req.getSession().setAttribute("message", "Đã giải phóng tủ " + locker.getLockerNumber() + " thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể giải phóng tủ.");
                }
            } else {
                req.getSession().setAttribute("error", "Tủ đựng cơ không tồn tại.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlilocker");
    }
}
