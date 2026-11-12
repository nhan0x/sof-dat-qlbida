package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.utils.EmailUtil;
import org.jetbrains.annotations.NotNull;
import org.mindrot.jbcrypt.BCrypt;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.Random;

@WebServlet("/dangky")
public class DangKyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = req.getParameter("role");
        if (role != null) {
            req.setAttribute("role", role);
        }
        req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = (String) req.getParameter("name");
        String email = (String) req.getParameter("email");
        String password = (String) req.getParameter("password");
        String confirm_password = (String) req.getParameter("confirm_password");
        String phone = (String) req.getParameter("phone");
        String username = (String) req.getParameter("username");

        if (username == null || username.trim().isEmpty() || username.contains(" ")) {
            req.setAttribute("loi", "Tài khoản không được để trống hoặc chứa khoảng trắng");
            req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.trim().length() < 6 || password.contains(" ")) {
            req.setAttribute("loi", "Mật khẩu phải từ 6 ký tự trở lên và không được chứa khoảng trắng");
            req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm_password)) {
            req.setAttribute("loi", "Mật khẩu không khớp");
            req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
            return;
        }
        AccountDAO dao = new AccountDAOImpl();
        if (dao.daTonTaiEmail(email)) {
            req.setAttribute("loi", "Email đã được sử dụng");
            req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
            return;
        }
        if (dao.daTonTaiUserName(username)) {
            req.setAttribute("loi", "Username đã được sử dụng");
            req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
            return;
        }

        String otp = String.format("%06d",
                new java.security.SecureRandom().nextInt(999999));
        try {
            EmailUtil.sendEmail(email, "[OTP từ HNDD Application]", "OTP của bạn là: " + otp);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }

        String mahoaMK = BCrypt.hashpw(password, BCrypt.gensalt(12));

        String role = req.getParameter("role");
        if (role == null || role.trim().isEmpty()) {
            role = "Khách hàng";
        }

        req.getSession().setAttribute("username", username);
        req.getSession().setAttribute("password", mahoaMK);
        req.getSession().setAttribute("name", name);
        req.getSession().setAttribute("email", email);
        req.getSession().setAttribute("phone", phone);
        req.getSession().setAttribute("role", role);
        req.getSession().setAttribute("otp", otp);
        resp.sendRedirect(req.getContextPath() + "/xacNhanOTP");

    }
}
