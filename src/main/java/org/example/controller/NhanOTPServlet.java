package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;

import java.io.IOException;

@WebServlet("/xacNhanOTP")
public class NhanOTPServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/nhanOTP.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = (String) req.getSession().getAttribute("username");
        String name = (String) req.getSession().getAttribute("name");
        String phone = (String) req.getSession().getAttribute("phone");
        String email = (String) req.getSession().getAttribute("email");
        String password = (String) req.getSession().getAttribute("password");
        String role = (String) req.getSession().getAttribute("role");
        String otpChinhXac = (String) req.getSession().getAttribute("otp");

        String otp1 = req.getParameter("otp1");
        String otp2 = req.getParameter("otp2");
        String otp3 = req.getParameter("otp3");
        String otp4 = req.getParameter("otp4");
        String otp5 = req.getParameter("otp5");
        String otp6 = req.getParameter("otp6");

        String otpNguoiDung = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;

        if (otpChinhXac != null && otpChinhXac.equals(otpNguoiDung)) {
            String flow = (String) req.getSession().getAttribute("flow");
            if ("forgot_password".equals(flow)) {
                resp.sendRedirect(req.getContextPath() + "/resetPassword");
            } else if ("login_otp".equals(flow)) {
                org.example.models.Account tempAcc = (org.example.models.Account) req.getSession().getAttribute("tempAccount");
                req.getSession().removeAttribute("tempAccount");
                req.getSession().removeAttribute("otp");
                req.getSession().removeAttribute("flow");

                if (tempAcc != null) {
                    req.getSession().setAttribute("account", tempAcc);
                    if ("admin".equalsIgnoreCase(tempAcc.getRole())) {
                        resp.sendRedirect(req.getContextPath() + "/admin/quanli.jsp");
                    } else if ("Nhân viên".equalsIgnoreCase(tempAcc.getRole())) {
                        resp.sendRedirect(req.getContextPath() + "/employee/trangchunhanvien");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/user/trangchunguoidung");
                    }
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dangnhap");
                }
            } else {
                AccountDAO dao = new AccountDAOImpl();
                dao.dangKy(username, password, name, phone, email, role);
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/dangnhap?message=registerSuccess");
            }
        } else {
            req.setAttribute("loi", "OTP không khớp!");
            req.getRequestDispatcher("/nhanOTP.jsp").forward(req, resp);
        }
    }
}
