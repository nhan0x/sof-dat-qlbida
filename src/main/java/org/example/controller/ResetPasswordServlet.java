package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = (String) req.getSession().getAttribute("email");
        String flow = (String) req.getSession().getAttribute("flow");

        if (email == null || !"forgot_password".equals(flow)) {
            resp.sendRedirect(req.getContextPath() + "/quenMatKhau");
            return;
        }
        req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = (String) req.getSession().getAttribute("email");
        String password = req.getParameter("password");
        String confirm_password = req.getParameter("confirm_password");

        if (password == null || password.trim().length() < 6 || password.contains(" ")) {
            req.setAttribute("loi", "Mật khẩu phải từ 6 ký tự trở lên và không được chứa khoảng trắng");
            req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm_password)) {
            req.setAttribute("loi", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
            return;
        }

        AccountDAO dao = new AccountDAOImpl();
        String passwordHashed = BCrypt.hashpw(password, BCrypt.gensalt(12));

        if (dao.resetPassword(email, passwordHashed)) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/dangnhap?message=success");
        } else {
            req.setAttribute("loi", "Lỗi khi cập nhật mật khẩu. Vui lòng thử lại!");
            req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
        }
    }
}
