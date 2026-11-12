package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.ServiceDAO;
import org.example.daos.ServiceDAOImpl;
import org.example.models.Service;

import java.io.IOException;
import java.util.List;

// Cùng một servlet phục vụ cả Admin và Nhân viên (AuthFilter sẽ phân quyền theo path)
@WebServlet({"/admin/quanlidichvu", "/employee/quanlidichvu"})
public class ServiceServlet extends HttpServlet {

    private ServiceDAO serviceDAO;
    private org.example.daos.CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAOImpl();
        categoryDAO = new org.example.daos.CategoryDAOImpl();
    }

    private String basePath(HttpServletRequest req) {
        return req.getServletPath(); // "/admin/quanlidichvu" hoặc "/employee/quanlidichvu"
    }

    private String jspPath(HttpServletRequest req) {
        return basePath(req) + ".jsp";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        boolean isEmployee = basePath(req).startsWith("/employee");

        switch (action) {
            case "edit":
                if (isEmployee) {
                    req.getSession().setAttribute("error", "Chỉ Admin mới có quyền sửa dịch vụ.");
                    resp.sendRedirect(req.getContextPath() + basePath(req));
                    return;
                }
                showEditForm(req, resp);
                break;
            case "delete":
                if (isEmployee) {
                    req.getSession().setAttribute("error", "Chỉ Admin mới có quyền xóa dịch vụ.");
                    resp.sendRedirect(req.getContextPath() + basePath(req));
                    return;
                }
                deleteService(req, resp);
                break;
            case "list":
            default:
                listServices(req, resp);
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

        boolean isEmployee = basePath(req).startsWith("/employee");

        switch (action) {
            case "create":
                if (isEmployee) {
                    req.getSession().setAttribute("error", "Chỉ Admin mới có quyền thêm dịch vụ.");
                    resp.sendRedirect(req.getContextPath() + basePath(req));
                    return;
                }
                createService(req, resp);
                break;
            case "update":
                if (isEmployee) {
                    req.getSession().setAttribute("error", "Chỉ Admin mới có quyền sửa dịch vụ.");
                    resp.sendRedirect(req.getContextPath() + basePath(req));
                    return;
                }
                updateService(req, resp);
                break;
            default:
                listServices(req, resp);
                break;
        }
    }

    // --- Hiển thị danh sách tất cả dịch vụ ---
    private void listServices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Service> serviceList = serviceDAO.getAll();
        req.setAttribute("serviceList", serviceList);
        req.setAttribute("categoryList", categoryDAO.getAll());

        String tableIdStr = req.getParameter("tableId");
        if (tableIdStr != null && !tableIdStr.trim().isEmpty()) {
            try {
                int tableId = Integer.parseInt(tableIdStr.trim());
                org.example.daos.TableBidaDAO tableDAO = new org.example.daos.TableBidaDAOImpl();
                org.example.models.TableBida table = tableDAO.getById(tableId);
                req.setAttribute("selectedTable", table);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        req.getRequestDispatcher(jspPath(req)).forward(req, resp);
    }

    // --- Hiển thị form sửa với dữ liệu dịch vụ ---
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Service service = serviceDAO.getById(id);
            if (service != null) {
                req.setAttribute("editService", service);
            } else {
                req.setAttribute("error", "Không tìm thấy dịch vụ với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        List<Service> serviceList = serviceDAO.getAll();
        req.setAttribute("serviceList", serviceList);
        req.setAttribute("categoryList", categoryDAO.getAll());
        req.getRequestDispatcher(jspPath(req)).forward(req, resp);
    }
    // --- Tạo mới dịch vụ ---
    private void createService(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price"));
            String category = req.getParameter("category");

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên dịch vụ không được để trống.");
            } else if (price <= 0) {
                req.getSession().setAttribute("error", "Giá dịch vụ phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                String cleanName = name.trim();
                boolean duplicate = serviceDAO.getAll().stream().anyMatch(s -> s.getName().equalsIgnoreCase(cleanName));
                if (duplicate) {
                    req.getSession().setAttribute("error", "Lỗi: Tên dịch vụ '" + cleanName + "' đã tồn tại! Vui lòng nhập tên khác.");
                } else {
                    Service newService = new Service(0, cleanName, price, category != null ? category.trim() : "Khác");
                    boolean result = serviceDAO.create(newService);
                    if (result) {
                        req.getSession().setAttribute("message", "Thêm dịch vụ thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể thêm dịch vụ.");
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Giá dịch vụ không hợp lệ. Vui lòng nhập số.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + basePath(req));
    }

    // --- Cập nhật dịch vụ ---
    private void updateService(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price"));
            String category = req.getParameter("category");

            if (name == null || name.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên dịch vụ không được để trống.");
            } else if (price <= 0) {
                req.getSession().setAttribute("error", "Giá dịch vụ phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                Service service = new Service(id, name.trim(), price, category != null ? category.trim() : "Khác");
                boolean result = serviceDAO.update(service);
                if (result) {
                    req.getSession().setAttribute("message", "Cập nhật dịch vụ thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật dịch vụ.");
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + basePath(req));
    }
    // --- Xóa dịch vụ ---
    private void deleteService(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean result = serviceDAO.delete(id);
            if (result) {
                req.getSession().setAttribute("message", "Xóa dịch vụ thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể xóa dịch vụ. Dịch vụ có thể đang được sử dụng trong hóa đơn.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + basePath(req));
    }
}
