package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.utils.EmailUtil;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.Random;

@WebServlet("/quenMatKhau")
public class QuenMatKhauServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/quenMatKhau.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");

        AccountDAO dao = new AccountDAOImpl();
        if (!dao.daTonTaiEmail(email)) {
            req.setAttribute("loi", "Email này không tồn tại trong hệ thống!");
            req.getRequestDispatcher("/quenMatKhau.jsp").forward(req, resp);
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(999999));
        try {
            EmailUtil.sendEmail(email, "[OTP Reset Password - HNDD]",
                    "Mã OTP để khôi phục mật khẩu của bạn là: " + otp);
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("loi", "Không thể gửi email. Vui lòng thử lại sau!");
            req.getRequestDispatcher("/quenMatKhau.jsp").forward(req, resp);
            return;
        }

        req.getSession().setAttribute("email", email);
        req.getSession().setAttribute("otp", otp);
        req.getSession().setAttribute("flow", "forgot_password");
        resp.sendRedirect(req.getContextPath() + "/xacNhanOTP");
    }
}
