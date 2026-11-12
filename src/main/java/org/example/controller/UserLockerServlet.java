package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.LockerDAO;
import org.example.daos.LockerDAOImpl;
import org.example.models.Account;
import org.example.models.Locker;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/tudungco")
public class UserLockerServlet extends HttpServlet {

    private LockerDAO lockerDAO;

    @Override
    public void init() throws ServletException {
        lockerDAO = new LockerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Account currentUser = (Account) req.getSession().getAttribute("account");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        // Get personal locker if any
        Locker myLocker = lockerDAO.getByMemberId(currentUser.getId());
        req.setAttribute("myLocker", myLocker);

        // Get all lockers list to view status
        List<Locker> lockerList = lockerDAO.getAll();
        req.setAttribute("lockerList", lockerList);

        req.getRequestDispatcher("/user/tudungco.jsp").forward(req, resp);
    }
}
