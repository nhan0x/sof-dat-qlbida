package org.example.controller;

import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.models.Account;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanliAccount")
public class AccountServlet extends HttpServlet {
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteAccount(req, resp);
                break;
            case "list":
            default:
                listAccounts(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "insert":
                insertAccount(req, resp);
                break;
            case "update":
                updateAccount(req, resp);
                break;
            default:
                listAccounts(req, resp);
                break;
        }
    }

    private void listAccounts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("search");
        List<Account> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = accountDAO.searchAccounts(keyword.trim());
            req.setAttribute("searchKeyword", keyword.trim());
        } else {
            list = accountDAO.getAllAccounts();
        }

        // Filter out admin accounts
        if (list != null) {
            list.removeIf(acc -> "admin".equalsIgnoreCase(acc.getRole()));
        }

        req.setAttribute("accountList", list);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/admin/quanliAccount.jsp");
        dispatcher.forward(req, resp);
    }

    private void showNewForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("/admin/themAccount.jsp");
        dispatcher.forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Account existing = accountDAO.getAccountById(id);
            req.setAttribute("accountParams", existing);
        } catch (NumberFormatException e) {
            req.setAttribute("loi", "ID tài khoản không hợp lệ");
        }
        RequestDispatcher dispatcher = req.getRequestDispatcher("/admin/themAccount.jsp");
        dispatcher.forward(req, resp);
    }

    private void insertAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String passwordRaw = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || username.contains(" ")) {
            req.setAttribute("loi", "Username không được để trống hoặc chứa khoảng trắng");
            try {
                req.getRequestDispatcher("/admin/themAccount.jsp").forward(req, resp);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        if (passwordRaw == null || passwordRaw.trim().length() < 6 || passwordRaw.contains(" ")) {
            req.setAttribute("loi", "Password phải từ 6 ký tự trở lên và không được chứa khoảng trắng");
            try {
                req.getRequestDispatcher("/admin/themAccount.jsp").forward(req, resp);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        String role = req.getParameter("role");
        if (role == null || (!"Khách hàng".equalsIgnoreCase(role) && !"Nhân viên".equalsIgnoreCase(role))) {
            req.setAttribute("loi", "Chỉ được phân quyền Nhân viên hoặc Khách hàng, không được phân quyền Admin");
            try {
                req.getRequestDispatcher("/admin/themAccount.jsp").forward(req, resp);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        // Hash the password exactly as the DangKyServlet does, though
        // BCrypt.hashpw(password, BCrypt.gensalt(12)) is standard
        String passwordHashed = BCrypt.hashpw(passwordRaw, BCrypt.gensalt(12));
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        Account newAcc = new Account(0, username, passwordHashed, role, name, phone, email);
        accountDAO.createAccount(newAcc);
        resp.sendRedirect(req.getContextPath() + "/admin/quanliAccount");
    }

    private void updateAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        // Role không thể thay đổi qua form sửa tài khoản - giữ nguyên role hiện tại
        Account existing = accountDAO.getAccountById(id);
        String role = existing != null ? existing.getRole() : req.getParameter("role");

        Account acc = new Account(id, "", "", role, name, phone, email);
        accountDAO.updateAccount(acc);
        resp.sendRedirect(req.getContextPath() + "/admin/quanliAccount");
    }

    private void deleteAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            accountDAO.deleteAccount(id);
        } catch (NumberFormatException e) {
            // ID không hợp lệ, bỏ qua
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliAccount");
    }
}
