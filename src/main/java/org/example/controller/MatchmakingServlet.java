package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.MatchmakingDAO;
import org.example.daos.MatchmakingDAOImpl;
import org.example.daos.MatchmakingProfileDAO;
import org.example.daos.MatchmakingProfileDAOImpl;
import org.example.models.Account;
import org.example.models.Matchmaking;
import org.example.models.MatchmakingProfile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/user/ghepkeo")
public class MatchmakingServlet extends HttpServlet {

    private MatchmakingProfileDAO matchmakingProfileDAO;
    private MatchmakingDAO matchmakingDAO;
    private org.example.daos.AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        matchmakingProfileDAO = new MatchmakingProfileDAOImpl();
        matchmakingDAO = new MatchmakingDAOImpl();
        accountDAO = new org.example.daos.AccountDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = requireLogin(req, resp);
        if (currentUser == null) return;

        List<MatchmakingProfile> playerList = matchmakingProfileDAO.getAll();
        MatchmakingProfile myProfile = matchmakingProfileDAO.getByAccountId(currentUser.getId());

        // Nạp thêm thông tin tài khoản (phong cách chơi, điểm tích lũy, SĐT) của từng người chơi
        // để hiển thị đầy đủ ngay trong danh sách.
        java.util.Map<Integer, Account> playerAccountMap = new java.util.HashMap<>();
        for (MatchmakingProfile p : playerList) {
            if (!playerAccountMap.containsKey(p.getAccountId())) {
                Account acc = accountDAO.getAccountById(p.getAccountId());
                if (acc != null) {
                    playerAccountMap.put(p.getAccountId(), acc);
                }
            }
        }
        req.setAttribute("playerAccountMap", playerAccountMap);
        req.setAttribute("playerCount", playerList.size());

        List<Matchmaking> openMatches = matchmakingDAO.getAllWaiting();
        List<Matchmaking> myHostedMatches = matchmakingDAO.getByAccountId(currentUser.getId());
        List<Matchmaking> myJoinedMatches = matchmakingDAO.getByPartnerId(currentUser.getId());

        HttpSession session = req.getSession();
        if (session.getAttribute("gotoMyMatches") != null) {
            req.setAttribute("gotoMyMatches", true);
            session.removeAttribute("gotoMyMatches");
        }

        req.setAttribute("playerList", playerList);
        req.setAttribute("myProfile", myProfile);
        req.setAttribute("openMatches", openMatches);
        req.setAttribute("myHostedMatches", myHostedMatches);
        req.setAttribute("myJoinedMatches", myJoinedMatches);

        req.getRequestDispatcher("/user/ghepkeo.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = requireLogin(req, resp);
        if (currentUser == null) return;

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "register":
                registerProfile(req, resp, currentUser);
                break;
            case "createMatch":
                createMatch(req, resp, currentUser);
                break;
            case "joinMatch":
                joinMatch(req, resp, currentUser);
                break;
            case "cancelMatch":
                cancelMatch(req, resp, currentUser);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/ghepkeo");
                break;
        }
    }

    private Account requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Account currentUser = (Account) session.getAttribute("account");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return currentUser;
    }

    // --- Đăng ký / cập nhật hồ sơ Ghép Kèo (Họ tên, Tuổi, Hạng, Số Zalo) ---
    private void registerProfile(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        try {
            String fullName = req.getParameter("fullName");
            String ageStr = req.getParameter("age");
            String rank = req.getParameter("rank");
            String zaloPhone = req.getParameter("zaloPhone");

            if (fullName == null || fullName.trim().isEmpty()
                    || ageStr == null || ageStr.trim().isEmpty()
                    || rank == null || rank.trim().isEmpty()
                    || zaloPhone == null || zaloPhone.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng nhập đầy đủ Họ tên, Tuổi, Hạng và Số Zalo.");
            } else {
                int age;
                try {
                    age = Integer.parseInt(ageStr.trim());
                } catch (NumberFormatException e) {
                    age = -1;
                }
                if (age <= 0 || age > 120) {
                    req.getSession().setAttribute("error", "Tuổi không hợp lệ.");
                } else {
                    MatchmakingProfile profile = new MatchmakingProfile();
                    profile.setAccountId(currentUser.getId());
                    profile.setFullName(fullName.trim());
                    profile.setAge(age);
                    profile.setRank(rank.trim());
                    profile.setZaloPhone(zaloPhone.trim());

                    boolean success = matchmakingProfileDAO.upsert(profile);
                    if (success) {
                        // Đồng bộ cấp độ sang tài khoản để thống nhất với trang Thông Tin Cá Nhân
                        Account acc = accountDAO.getAccountById(currentUser.getId());
                        if (acc != null) {
                            acc.setMemberRank(rank.trim());
                            accountDAO.updatePersonalInfo(acc);
                            req.getSession().setAttribute("account", acc);
                        }
                        req.getSession().setAttribute("message", "Đăng ký ghép kèo thành công! Hồ sơ của bạn đã xuất hiện trong danh sách người chơi.");
                    } else {
                        req.getSession().setAttribute("error", "Không thể lưu hồ sơ ghép kèo. Vui lòng thử lại.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/user/ghepkeo");
    }

    // --- Lập kèo mới (Loại bàn, Thể thức, Yêu cầu đối thủ, Ngày giờ chơi, Ghi chú) ---
    private void createMatch(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        try {
            String tableType = req.getParameter("tableType");
            String format = req.getParameter("format");
            String rankRequirement = req.getParameter("rankRequirement");
            String playTimeStr = req.getParameter("playTime");
            String note = req.getParameter("note");

            if (tableType == null || tableType.trim().isEmpty()
                    || format == null || format.trim().isEmpty()
                    || rankRequirement == null || rankRequirement.trim().isEmpty()
                    || playTimeStr == null || playTimeStr.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng nhập đầy đủ thông tin kèo.");
            } else {
                LocalDateTime playTime = LocalDateTime.parse(playTimeStr);
                if (playTime.isBefore(LocalDateTime.now().minusMinutes(10))) {
                    req.getSession().setAttribute("error", "Thời gian chơi không thể ở quá khứ.");
                } else {
                    Matchmaking match = new Matchmaking();
                    match.setAccountId(currentUser.getId());
                    match.setTableType(tableType.trim());
                    match.setFormat(format.trim());
                    match.setRankRequirement(rankRequirement.trim());
                    match.setPlayTime(playTime);
                    match.setNote(note != null ? note.trim() : "");

                    boolean success = matchmakingDAO.create(match);
                    if (success) {
                        req.getSession().setAttribute("message", "Lập kèo thành công! Kèo của bạn đang chờ ghép với khách hàng khác.");
                        req.getSession().setAttribute("gotoMyMatches", "1");
                    } else {
                        req.getSession().setAttribute("error", "Không thể lập kèo. Vui lòng thử lại.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Dữ liệu nhập vào không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/user/ghepkeo");
    }

    // --- Tham gia kèo đang chờ ---
    private void joinMatch(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        try {
            int matchId = Integer.parseInt(req.getParameter("matchId"));
            Matchmaking match = matchmakingDAO.getById(matchId);

            if (match == null) {
                req.getSession().setAttribute("error", "Kèo không tồn tại.");
            } else if (match.getAccountId() == currentUser.getId()) {
                req.getSession().setAttribute("error", "Bạn không thể tham gia kèo do chính mình lập.");
            } else if (!"Waiting".equalsIgnoreCase(match.getStatus())) {
                req.getSession().setAttribute("error", "Kèo này đã có người tham gia hoặc đã bị hủy.");
            } else {
                boolean success = matchmakingDAO.joinMatch(matchId, currentUser.getId());
                if (success) {
                    req.getSession().setAttribute("message", "Tham gia kèo thành công! Hãy liên hệ với chủ kèo để chuẩn bị chơi.");
                } else {
                    req.getSession().setAttribute("error", "Không thể tham gia kèo. Vui lòng thử lại.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi tham gia kèo: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/user/ghepkeo");
    }

    // --- Hủy kèo do chính mình lập ---
    private void cancelMatch(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        try {
            int matchId = Integer.parseInt(req.getParameter("matchId"));
            Matchmaking match = matchmakingDAO.getById(matchId);

            if (match == null) {
                req.getSession().setAttribute("error", "Kèo không tồn tại.");
            } else if (match.getAccountId() != currentUser.getId()) {
                req.getSession().setAttribute("error", "Bạn chỉ có thể hủy kèo do chính mình lập.");
            } else if (!"Waiting".equalsIgnoreCase(match.getStatus())) {
                req.getSession().setAttribute("error", "Chỉ có thể hủy các kèo đang ở trạng thái chờ.");
            } else {
                boolean success = matchmakingDAO.cancelMatch(matchId);
                if (success) {
                    req.getSession().setAttribute("message", "Đã hủy kèo thành công.");
                } else {
                    req.getSession().setAttribute("error", "Không thể hủy kèo. Vui lòng thử lại.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hủy kèo: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/user/ghepkeo");
    }
}
