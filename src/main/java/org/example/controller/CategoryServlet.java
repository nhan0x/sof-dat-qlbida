package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CategoryDAO;
import org.example.daos.CategoryDAOImpl;
import org.example.models.Category;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanlidanhmuc")
public class CategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAOImpl();
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
                deleteCategory(req, resp);
                break;
            case "list":
            default:
                listCategories(req, resp);
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
                createCategory(req, resp);
                break;
            case "update":
                updateCategory(req, resp);
                break;
            default:
                listCategories(req, resp);
                break;
        }
    }

    private void listCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categoryList = categoryDAO.getAll();
        req.setAttribute("categoryList", categoryList);
        req.getRequestDispatcher("/admin/quanlidanhmuc.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = categoryDAO.getById(id);
            if (category != null) {
                req.setAttribute("editCategory", category);
            } else {
                req.setAttribute("error", "Không tìm thấy danh mục với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        List<Category> categoryList = categoryDAO.getAll();
        req.setAttribute("categoryList", categoryList);
        req.getRequestDispatcher("/admin/quanlidanhmuc.jsp").forward(req, resp);
    }

    private void createCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên danh mục không được để trống.");
            } else {
                name = name.trim();
                Category existing = categoryDAO.getByName(name);
                if (existing != null) {
                    req.getSession().setAttribute("error", "Danh mục '" + name + "' đã tồn tại.");
                } else {
                    Category newCat = new Category(0, name);
                    boolean result = categoryDAO.create(newCat);
                    if (result) {
                        req.getSession().setAttribute("message", "Thêm danh mục thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể thêm danh mục.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlidanhmuc");
    }

    private void updateCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên danh mục không được để trống.");
            } else {
                name = name.trim();
                Category old = categoryDAO.getById(id);
                if (old == null) {
                    req.getSession().setAttribute("error", "Không tìm thấy danh mục.");
                } else {
                    Category existing = categoryDAO.getByName(name);
                    if (existing != null && existing.getId() != id) {
                        req.getSession().setAttribute("error", "Tên danh mục '" + name + "' đã được sử dụng.");
                    } else {
                        Category cat = new Category(id, name);
                        boolean result = categoryDAO.update(cat);
                        if (result) {
                            req.getSession().setAttribute("message", "Cập nhật danh mục thành công!");
                        } else {
                            req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật danh mục.");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlidanhmuc");
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Category cat = categoryDAO.getById(id);
            if (cat != null) {
                if ("Khác".equalsIgnoreCase(cat.getName())) {
                    req.getSession().setAttribute("error", "Không thể xóa danh mục mặc định 'Khác'.");
                } else {
                    boolean result = categoryDAO.delete(id);
                    if (result) {
                        req.getSession().setAttribute("message", "Xóa danh mục thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể xóa danh mục.");
                    }
                }
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy danh mục để xóa.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlidanhmuc");
    }
}
