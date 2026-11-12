package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.TableTypeDAO;
import org.example.daos.TableTypeDAOImpl;
import org.example.models.TableType;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanliloaiban")
public class TableTypeServlet extends HttpServlet {

    private TableTypeDAO tableTypeDAO;

    @Override
    public void init() throws ServletException {
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
                deleteTableType(req, resp);
                break;
            case "list":
            default:
                listTableTypes(req, resp);
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
                createTableType(req, resp);
                break;
            case "update":
                updateTableType(req, resp);
                break;
            default:
                listTableTypes(req, resp);
                break;
        }
    }

    // --- Hiển thị danh sách tất cả loại bàn ---
    private void listTableTypes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<TableType> tableTypeList = tableTypeDAO.getAll();
        req.setAttribute("tableTypeList", tableTypeList);
        req.getRequestDispatcher("/admin/quanliTableType.jsp").forward(req, resp);
    }

    // --- Hiển thị form sửa với dữ liệu loại bàn ---
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            TableType tableType = tableTypeDAO.getById(id);
            if (tableType != null) {
                req.setAttribute("editTableType", tableType);
            } else {
                req.setAttribute("error", "Không tìm thấy loại bàn với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        // Vẫn load danh sách để hiển thị bảng
        List<TableType> tableTypeList = tableTypeDAO.getAll();
        req.setAttribute("tableTypeList", tableTypeList);
        req.getRequestDispatcher("/admin/quanliTableType.jsp").forward(req, resp);
    }

    // --- Tạo mới loại bàn ---
    private void createTableType(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");
            double pricePerHour = Double.parseDouble(req.getParameter("pricePerHour"));

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên loại bàn không được để trống.");
            } else if (pricePerHour <= 0) {
                req.getSession().setAttribute("error", "Giá thuê phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                String cleanName = name.trim();
                boolean duplicate = tableTypeDAO.getAll().stream().anyMatch(t -> t.getName().equalsIgnoreCase(cleanName));
                if (duplicate) {
                    req.getSession().setAttribute("error", "Lỗi: Tên loại bàn '" + cleanName + "' đã tồn tại! Vui lòng nhập tên khác.");
                } else {
                    TableType newType = new TableType(0, cleanName, pricePerHour);
                    boolean result = tableTypeDAO.create(newType);
                    if (result) {
                        req.getSession().setAttribute("message", "Thêm loại bàn thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể thêm loại bàn.");
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Giá thuê không hợp lệ. Vui lòng nhập số.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliloaiban");
    }

    // --- Cập nhật loại bàn ---
    private void updateTableType(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            double pricePerHour = Double.parseDouble(req.getParameter("pricePerHour"));

            if (pricePerHour <= 0) {
                req.getSession().setAttribute("error", "Giá thuê phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                TableType type = new TableType(id, name, pricePerHour);
                boolean result = tableTypeDAO.update(type);
                if (result) {
                    req.getSession().setAttribute("message", "Cập nhật loại bàn thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật loại bàn.");
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliloaiban");
    }

    // --- Xóa loại bàn ---
    private void deleteTableType(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean result = tableTypeDAO.delete(id);
            if (result) {
                req.getSession().setAttribute("message", "Xóa loại bàn thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể xóa loại bàn.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanliloaiban");
    }
}
