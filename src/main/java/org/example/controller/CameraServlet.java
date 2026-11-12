package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.TableBidaDAO;
import org.example.daos.TableBidaDAOImpl;
import org.example.models.TableBida;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/camera")
public class CameraServlet extends HttpServlet {

    private TableBidaDAO tableBidaDAO;

    @Override
    public void init() throws ServletException {
        tableBidaDAO = new TableBidaDAOImpl();
    }

    private static final char Q = '"';

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewCamera(req, resp);
                break;
            case "list":
            default:
                listCameras(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String action = req.getParameter("action");
        if ("save".equals(action)) {
            saveCameraConfig(req, resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{" + Q + "success" + Q + ":false," + Q + "error" + Q + ":" + Q + "bad_request" + Q + "}");
        }
    }

    // --- Lưu nhanh cấu hình camera (gọi bằng AJAX từ trang xem camera) ---
    private void saveCameraConfig(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            TableBida table = tableBidaDAO.getById(id);
            if (table == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{" + Q + "success" + Q + ":false," + Q + "error" + Q + ":" + Q + "not_found" + Q + "}");
                return;
            }
            table.setCameraIp(trimToNull(req.getParameter("cameraIp")));
            table.setCameraPort(trimToNull(req.getParameter("cameraPort")));
            table.setCameraUsername(trimToNull(req.getParameter("cameraUsername")));
            table.setCameraPassword(trimToNull(req.getParameter("cameraPassword")));
            boolean result = tableBidaDAO.update(table);
            if (result) {
                resp.getWriter().write("{" + Q + "success" + Q + ":true}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{" + Q + "success" + Q + ":false," + Q + "error" + Q + ":" + Q + "db_error" + Q + "}");
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{" + Q + "success" + Q + ":false," + Q + "error" + Q + ":" + Q + "invalid_id" + Q + "}");
        }
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    // --- Hiển thị danh sách camera của tất cả các bàn ---
    private void listCameras(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<TableBida> tableList = tableBidaDAO.getAll();
        req.setAttribute("tableList", tableList);
        req.getRequestDispatcher("/admin/quanliCamera.jsp").forward(req, resp);
    }

    // --- Hiển thị camera của một bàn cụ thể ---
    private void viewCamera(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            TableBida table = tableBidaDAO.getById(id);
            if (table != null) {
                req.setAttribute("camTable", table);
            } else {
                req.setAttribute("error", "Không tìm thấy bàn với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        req.getRequestDispatcher("/admin/xemCamera.jsp").forward(req, resp);
    }
}
