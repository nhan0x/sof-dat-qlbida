package org.example.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.models.Account;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/user/*", "/employee/*"}, dispatcherTypes = {DispatcherType.REQUEST})
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Ngăn trình duyệt lưu cache trang admin/user/employee
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        Account acc = (Account) req.getSession().getAttribute("account");
        String url = req.getRequestURI();

        if (acc == null) {
            // Chưa đăng nhập → redirect về trang đăng nhập
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        // Kiểm tra quyền admin
        if (url.contains("/admin") && !"admin".equalsIgnoreCase(acc.getRole())) {
            String targetPath = "/user/trangchunguoidung";
            if ("Nhân viên".equalsIgnoreCase(acc.getRole())) {
                targetPath = "/employee/trangchunhanvien";
            }
            resp.sendRedirect(req.getContextPath() + targetPath);
            return;
        }

        // Kiểm tra quyền nhân viên
        if (url.contains("/employee") && !"Nhân viên".equalsIgnoreCase(acc.getRole()) && !"admin".equalsIgnoreCase(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/user/trangchunguoidung");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
