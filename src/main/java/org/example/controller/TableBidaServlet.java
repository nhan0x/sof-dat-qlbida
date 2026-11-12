package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.TableBidaDAO;
import org.example.daos.TableBidaDAOImpl;
import org.example.daos.TableTypeDAO;
import org.example.daos.TableTypeDAOImpl;
import org.example.models.TableBida;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanliTableBida")
public class TableBidaServlet extends HttpServlet {

    private TableBidaDAO tableBidaDAO;
    private TableTypeDAO tableTypeDAO;

    @Override
    public void init() throws ServletException {
        tableBidaDAO = new TableBidaDAOImpl();
        tableTypeDAO = new TableTypeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteTable(req, resp);
                break;
            case "list":
            default:
                listTables(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createTable(req, resp);
                break;
            case "update":
                updateTable(req, resp);
                break;
            default:
                listTables(req, resp);
                break;
        }
    }

    // --- Hiển thị danh sách tất cả bàn ---
    private void listTables(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<TableBida> tableList = tableBidaDAO.getAll();
        req.setAttribute("tableList", tableList);
        req.setAttribute("tableTypeList", tableTypeDAO.getAll());
        req.getRequestDispatcher("/admin/quanliTableBida.jsp").forward(req, resp);
    }

    // --- Hiển thị form sửa với dữ liệu bàn ---
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            TableBida table = tableBidaDAO.getById(id);
            if (table != null) {
                req.setAttribute("editTable", table);
            } else {
                req.setAttribute("error", "Không tìm thấy bàn với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        // Vẫn load danh sách để hiển thị bảng
        List<TableBida> tableList = tableBidaDAO.getAll();
        req.setAttribute("tableList", tableList);
        req.setAttribute("tableTypeList", tableTypeDAO.getAll());
        req.getRequestDispatcher("/admin/quanliTableBida.jsp").forward(req, resp);
    }

    // --- Tạo mới bàn ---
    private void createTable(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");
            String status = req.getParameter("status");
            String tableTypeIdStr = req.getParameter("tableTypeId");

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên bàn không được để trống.");
            } else if (tableTypeIdStr == null || tableTypeIdStr.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng chọn loại bàn.");
            } else {
                TableBida newTable = new TableBida(0, name.trim(), status, Integer.parseInt(tableTypeIdStr));
                newTable.setCameraIp(trimToNull(req.getParameter("cameraIp")));
                newTable.setCameraPort(trimToNull(req.getParameter("cameraPort")));
                newTable.setCameraUsername(trimToNull(req.getParameter("cameraUsername")));
                newTable.setCameraPassword(trimToNull(req.getParameter("cameraPassword")));
                boolean result = tableBidaDAO.create(newTable);
                if (result) {
                    req.getSession().setAttribute("message", "Thêm bàn thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể thêm bàn.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliTableBida");
    }

    // --- Cập nhật bàn ---
    private void updateTable(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String status = req.getParameter("status");
            int tableTypeId = Integer.parseInt(req.getParameter("tableTypeId"));

            TableBida table = new TableBida(id, name, status, tableTypeId);
            table.setCameraIp(trimToNull(req.getParameter("cameraIp")));
            table.setCameraPort(trimToNull(req.getParameter("cameraPort")));
            table.setCameraUsername(trimToNull(req.getParameter("cameraUsername")));
            table.setCameraPassword(trimToNull(req.getParameter("cameraPassword")));
            boolean result = tableBidaDAO.update(table);
            if (result) {
                req.getSession().setAttribute("message", "Cập nhật bàn thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật bàn.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliTableBida");
    }

    // --- Chuyển chuỗi rỗng thành null ---
    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    // --- Xóa bàn ---
    private void deleteTable(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean result = tableBidaDAO.delete(id);
            if (result) {
                req.getSession().setAttribute("message", "Xóa bàn thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể xóa bàn.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliTableBida");
    }
}
