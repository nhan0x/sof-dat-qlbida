package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.models.Account;

import java.io.IOException;


@WebServlet("/dangnhap")
public class DangNhapServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // Xử lý đăng xuất
        if ("logout".equals(action)) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String step = req.getParameter("step");
        if ("email".equals(step)) {
            Account tempAcc = (Account) req.getSession().getAttribute("tempAccount");
            if (tempAcc == null) {
                resp.sendRedirect(req.getContextPath() + "/dangnhap");
                return;
            }
            req.getRequestDispatcher("/dangnhapEmail.jsp").forward(req, resp);
            return;
        }

        // Nếu đã đăng nhập rồi thì không cần vào trang login nữa
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc != null) {
            if ("admin".equalsIgnoreCase(acc.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/quanli.jsp");
            } else if ("Nhân viên".equalsIgnoreCase(acc.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/trangchunguoidung");
            }
            return;
        }

        String message = req.getParameter("message");
        if (message != null) {
            if ("success".equals(message)) {
                req.setAttribute("thongbao", "Đặt lại mật khẩu thành công!");
            } else if ("registerSuccess".equals(message)) {
                req.setAttribute("thongbao", "Đăng ký tài khoản thành công!");
            }
        }

        req.getRequestDispatcher("/dangnhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("sendEmailOTP".equals(action)) {
            // Xử lý gửi OTP qua Email
            Account tempAcc = (Account) req.getSession().getAttribute("tempAccount");
            if (tempAcc == null) {
                resp.sendRedirect(req.getContextPath() + "/dangnhap");
                return;
            }

            String email = req.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("loi", "Vui lòng nhập email.");
                req.getRequestDispatcher("/dangnhapEmail.jsp").forward(req, resp);
                return;
            }

            if (!email.trim().equalsIgnoreCase(tempAcc.getEmail())) {
                req.setAttribute("loi", "Email không khớp với tài khoản này!");
                req.getRequestDispatcher("/dangnhapEmail.jsp").forward(req, resp);
                return;
            }

            // Gửi OTP
            java.util.Random rand = new java.util.Random();
            String otp = String.format("%06d", rand.nextInt(999999));
            try {
                org.example.utils.EmailUtil.sendEmail(email.trim(), "[OTP Đăng Nhập - HNDD]",
                        "Mã OTP để đăng nhập của bạn là: " + otp);
            } catch (javax.mail.MessagingException e) {
                e.printStackTrace();
                req.setAttribute("loi", "Không thể gửi email. Vui lòng thử lại sau!");
                req.getRequestDispatcher("/dangnhapEmail.jsp").forward(req, resp);
                return;
            }

            req.getSession().setAttribute("otp", otp);
            req.getSession().setAttribute("flow", "login_otp");
            resp.sendRedirect(req.getContextPath() + "/xacNhanOTP");
            return;
        }

        // Mặc định: xử lý Đăng nhập thông thường (username/password)
        AccountDAO dao = new AccountDAOImpl();

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // 1. Kiểm tra trống trước
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("loi", "Vui lòng nhập đầy đủ tài khoản và mật khẩu");
            req.getRequestDispatcher("/dangnhap.jsp").forward(req, resp);
            return;
        }

        // 2. Thử đăng nhập thẳng — nếu đúng cả hai thì trả về Account
        Account acc = dao.dangNhap(username, password);
        if (acc == null) {
            // Phân biệt sai tk hay sai mk
            if (!dao.daTonTaiUserName(username)) {
                req.setAttribute("loi", "Tài khoản không tồn tại");
            } else {
                req.setAttribute("loi", "Mật khẩu không đúng");
            }
            req.getRequestDispatcher("/dangnhap.jsp").forward(req, resp);
            return;
        }

        // 3. Đúng mật khẩu
        req.getSession().setAttribute("account", acc);
        if ("admin".equalsIgnoreCase(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/quanli.jsp");
        } else if ("Nhân viên".equalsIgnoreCase(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
        } else {
            resp.sendRedirect(req.getContextPath() + "/user/trangchunguoidung");
        }
    }
}