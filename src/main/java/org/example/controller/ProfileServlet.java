package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.MatchmakingProfileDAO;
import org.example.daos.MatchmakingProfileDAOImpl;
import org.example.models.Account;
import org.example.models.MatchmakingProfile;

import java.io.IOException;

/**
 * Trang "Thông Tin Cá Nhân" của người chơi: xem và chỉnh sửa họ tên, SĐT, email,
 * cấp độ (hạng), phong cách chơi, tuổi và số Zalo hiển thị trong danh sách ghép kèo.
 */
@WebServlet("/user/thongtincanhan")
public class ProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;
    private MatchmakingProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAOImpl();
        profileDAO = new MatchmakingProfileDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = requireLogin(req, resp);
        if (currentUser == null) return;

        // Nạp lại từ DB để chắc chắn hiển thị dữ liệu mới nhất (điểm, cấp độ...)
        Account fresh = accountDAO.getAccountById(currentUser.getId());
        if (fresh != null) {
            req.getSession().setAttribute("account", fresh);
            currentUser = fresh;
        }

        req.setAttribute("profileAccount", currentUser);
        req.setAttribute("myProfile", profileDAO.getByAccountId(currentUser.getId()));
        req.getRequestDispatcher("/user/thongtincanhan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = requireLogin(req, resp);
        if (currentUser == null) return;

        String name = trim(req.getParameter("name"));
        String phone = trim(req.getParameter("phone"));
        String email = trim(req.getParameter("email"));
        String memberRank = trim(req.getParameter("memberRank"));
        String playingStyle = trim(req.getParameter("playingStyle"));
        String ageStr = trim(req.getParameter("age"));
        String zaloPhone = trim(req.getParameter("zaloPhone"));

        if (name.isEmpty() || phone.isEmpty() || email.isEmpty() || memberRank.isEmpty()) {
            req.getSession().setAttribute("error", "Vui lòng nhập đầy đủ Họ tên, Số điện thoại, Email và Cấp độ.");
            resp.sendRedirect(req.getContextPath() + "/user/thongtincanhan");
            return;
        }

        int age = 0;
        if (!ageStr.isEmpty()) {
            try {
                age = Integer.parseInt(ageStr);
            } catch (NumberFormatException e) {
                age = -1;
            }
            if (age <= 0 || age > 120) {
                req.getSession().setAttribute("error", "Tuổi không hợp lệ.");
                resp.sendRedirect(req.getContextPath() + "/user/thongtincanhan");
                return;
            }
        }

        // Email đã thuộc về tài khoản khác?
        Account owner = accountDAO.getAccountByEmail(email);
        if (owner != null && owner.getId() != currentUser.getId()) {
            req.getSession().setAttribute("error", "Email này đã được sử dụng bởi tài khoản khác.");
            resp.sendRedirect(req.getContextPath() + "/user/thongtincanhan");
            return;
        }

        Account updated = accountDAO.getAccountById(currentUser.getId());
        if (updated == null) updated = currentUser;
        updated.setName(name);
        updated.setPhone(phone);
        updated.setEmail(email);
        updated.setMemberRank(memberRank);
        updated.setPlayingStyle(playingStyle);

        if (!accountDAO.updatePersonalInfo(updated)) {
            req.getSession().setAttribute("error", "Không thể lưu thông tin cá nhân. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/user/thongtincanhan");
            return;
        }

        // Đồng bộ sang hồ sơ ghép kèo để danh sách người chơi hiển thị đúng cấp độ
        MatchmakingProfile existing = profileDAO.getByAccountId(currentUser.getId());
        if (existing != null || age > 0 || !zaloPhone.isEmpty()) {
            MatchmakingProfile profile = existing != null ? existing : new MatchmakingProfile();
            profile.setAccountId(currentUser.getId());
            profile.setFullName(name);
            if (age > 0) profile.setAge(age);
            profile.setRank(memberRank);
            profile.setZaloPhone(!zaloPhone.isEmpty() ? zaloPhone : phone);
            profileDAO.upsert(profile);
        }

        req.getSession().setAttribute("account", accountDAO.getAccountById(currentUser.getId()));
        req.getSession().setAttribute("message", "Cập nhật thông tin cá nhân thành công!");
        resp.sendRedirect(req.getContextPath() + "/user/thongtincanhan");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
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
}
