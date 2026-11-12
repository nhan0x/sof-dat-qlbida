package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CueDAO;
import org.example.daos.CueDAOImpl;
import org.example.models.Cue;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanlico")
public class CueServlet extends HttpServlet {

    private CueDAO cueDAO;

    @Override
    public void init() throws ServletException {
        cueDAO = new CueDAOImpl();
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
                deleteCue(req, resp);
                break;
            case "list":
            default:
                listCues(req, resp);
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
                createCue(req, resp);
                break;
            case "update":
                updateCue(req, resp);
                break;
            default:
                listCues(req, resp);
                break;
        }
    }

    // --- Hiển thị danh sách tất cả Cue ---
    private void listCues(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Cue> cueList = cueDAO.getAll();
        req.setAttribute("cueList", cueList);
        req.getRequestDispatcher("/admin/quanlico.jsp").forward(req, resp);
    }

    // --- Hiển thị form sửa với dữ liệu Cue ---
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Cue cue = cueDAO.getById(id);
            if (cue != null) {
                req.setAttribute("editCue", cue);
            } else {
                req.setAttribute("error", "Không tìm thấy cơ với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        // Vẫn load danh sách để hiển thị bảng
        List<Cue> cueList = cueDAO.getAll();
        req.setAttribute("cueList", cueList);
        req.getRequestDispatcher("/admin/quanlico.jsp").forward(req, resp);
    }

    // --- Tạo mới Cue ---
    private void createCue(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String name = req.getParameter("name");
            String brand = req.getParameter("brand");
            float pricePerHour = Float.parseFloat(req.getParameter("pricePerHour"));
            String status = req.getParameter("status");
            String description = req.getParameter("description");

            if (pricePerHour <= 0) {
                req.getSession().setAttribute("error", "Giá thuê phải là số dương, không được để số âm hoặc bằng 0.");
            } else if (name != null && cueDAO.getAll().stream().anyMatch(c -> c.getName().equalsIgnoreCase(name.trim()))) {
                req.getSession().setAttribute("error", "Lỗi: Tên cơ '" + name.trim() + "' đã tồn tại! Vui lòng nhập tên khác.");
            } else {
                boolean result = cueDAO.create(name != null ? name.trim() : "", brand, pricePerHour, status, description);
                if (result) {
                    req.getSession().setAttribute("message", "Thêm cơ thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể thêm cơ.");
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Giá thuê không hợp lệ. Vui lòng nhập số.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlico");
    }

    // --- Cập nhật Cue ---
    private void updateCue(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String brand = req.getParameter("brand");
            float pricePerHour = Float.parseFloat(req.getParameter("pricePerHour"));
            String status = req.getParameter("status");
            String description = req.getParameter("description");

            if (pricePerHour <= 0) {
                req.getSession().setAttribute("error", "Giá thuê phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                boolean result = cueDAO.update(id, name, brand, pricePerHour, status, description);
                if (result) {
                    req.getSession().setAttribute("message", "Cập nhật cơ thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật cơ.");
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlico");
    }

    // --- Xóa Cue ---
    private void deleteCue(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean result = cueDAO.delete(id);
            if (result) {
                req.getSession().setAttribute("message", "Xóa cơ thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể xóa cơ.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlico");
    }
}
