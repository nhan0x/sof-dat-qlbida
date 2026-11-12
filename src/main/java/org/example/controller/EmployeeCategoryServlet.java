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

@WebServlet("/employee/quanlidanhmuc")
public class EmployeeCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        req.getSession().setAttribute("error", "Chỉ Admin mới có quyền quản lý danh mục.");
        resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        req.getSession().setAttribute("error", "Chỉ Admin mới có quyền quản lý danh mục.");
        resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu");
    }

    private void createCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("catError", "Tên danh mục không được để trống.");
            } else {
                name = name.trim();
                Category existing = categoryDAO.getByName(name);
                if (existing != null) {
                    req.getSession().setAttribute("catError", "Danh mục '" + name + "' đã tồn tại.");
                } else {
                    Category newCat = new Category(0, name);
                    boolean result = categoryDAO.create(newCat);
                    if (result) {
                        req.getSession().setAttribute("catMessage", "Thêm danh mục '" + name + "' thành công!");
                    } else {
                        req.getSession().setAttribute("catError", "Lỗi: Không thể thêm danh mục.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("catError", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu?openCatModal=1");
    }

    private void updateCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("catError", "Tên danh mục không được để trống.");
            } else {
                name = name.trim();
                Category old = categoryDAO.getById(id);
                if (old == null) {
                    req.getSession().setAttribute("catError", "Không tìm thấy danh mục.");
                } else {
                    Category existing = categoryDAO.getAnyByName(name);
                    if (existing != null && existing.getId() != id) {
                        req.getSession().setAttribute("catError", "Tên danh mục '" + name + "' đã được sử dụng.");
                    } else {
                        Category cat = new Category(id, name);
                        boolean result = categoryDAO.update(cat);
                        if (result) {
                            req.getSession().setAttribute("catMessage", "Cập nhật danh mục thành công!");
                        } else {
                            req.getSession().setAttribute("catError", "Lỗi: Không thể cập nhật danh mục.");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("catError", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("catError", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu?openCatModal=1");
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Category cat = categoryDAO.getById(id);
            if (cat != null) {
                if ("Khác".equalsIgnoreCase(cat.getName())) {
                    req.getSession().setAttribute("catError", "Không thể xóa danh mục mặc định 'Khác'.");
                } else {
                    boolean result = categoryDAO.delete(id);
                    if (result) {
                        req.getSession().setAttribute("catMessage", "Xóa danh mục '" + cat.getName() + "' thành công!");
                    } else {
                        req.getSession().setAttribute("catError", "Lỗi: Không thể xóa danh mục.");
                    }
                }
            } else {
                req.getSession().setAttribute("catError", "Không tìm thấy danh mục để xóa.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("catError", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("catError", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/employee/quanlidichvu?openCatModal=1");
    }
}
