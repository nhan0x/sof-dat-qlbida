package org.example.controller;

import org.example.daos.TableBidaDAO;
import org.example.daos.TableBidaDAOImpl;
import org.example.daos.TableTypeDAO;
import org.example.daos.TableTypeDAOImpl;
import org.example.models.TableBida;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/themTableBida")
public class ThemTableBidaServlet extends HttpServlet {
    private TableBidaDAO tableBidaDAO;
    private TableTypeDAO tableTypeDAO;

    @Override
    public void init() throws ServletException {
        tableBidaDAO = new TableBidaDAOImpl();
        tableTypeDAO = new TableTypeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("tableTypeList", tableTypeDAO.getAll());
        RequestDispatcher dispatcher = req.getRequestDispatcher("/admin/themTableBida.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String status = req.getParameter("status");
        int tableTypeId = Integer.parseInt(req.getParameter("tableTypeId"));

        if (name != null && !name.trim().isEmpty()) {
            String cleanName = name.trim();
            boolean duplicate = tableBidaDAO.getAll().stream().anyMatch(t -> t.getName().equalsIgnoreCase(cleanName));
            if (duplicate) {
                req.getSession().setAttribute("error", "Lỗi: Tên bàn '" + cleanName + "' đã tồn tại! Vui lòng nhập tên khác.");
                resp.sendRedirect(req.getContextPath() + "/admin/quanliTableBida");
                return;
            }
            TableBida newTable = new TableBida(0, cleanName, status, tableTypeId);
            boolean ok = tableBidaDAO.create(newTable);
            if (ok) {
                req.getSession().setAttribute("message", "Thêm bàn bida thành công!");
            } else {
                req.getSession().setAttribute("error", "Không thể thêm bàn bida.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliTableBida");
    }
}
