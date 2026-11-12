package org.example.controller;

import org.example.daos.CueDAO;
import org.example.daos.CueDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Nếu bạn đang dùng javax thay vì jakarta, hãy đổi import jakarta.* thành javax.*
@WebServlet("/admin/themCo")
public class ThemCoServlet extends HttpServlet {

    private CueDAO cueDAO;

    @Override
    public void init() throws ServletException {
        // Khởi tạo DAO
        cueDAO = new CueDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng người dùng đến trang form khi họ truy cập bằng phương thức GET
        request.getRequestDispatcher("/admin/themco.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cấu hình encoding để hỗ trợ tiếng Việt có dấu
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String priceStr = request.getParameter("pricePerHour");
            String status = request.getParameter("status");
            String description = request.getParameter("description");

            // Chuyển đổi dữ liệu (parsing)
            float pricePerHour = 0;
            if (priceStr != null && !priceStr.isEmpty()) {
                pricePerHour = Float.parseFloat(priceStr);
            }

            if (pricePerHour <= 0) {
                request.setAttribute("error", "Giá thuê phải là số dương, không được để số âm hoặc bằng 0.");
            } else {
                // Gọi DAO để lưu vào database
                boolean isCreated = cueDAO.create(name, brand, pricePerHour, status, description);

                if (isCreated) {
                    // POST-Redirect-GET: tránh double submit khi F5
                    response.sendRedirect(request.getContextPath() + "/admin/quanlico");
                    return;
                } else {
                    request.setAttribute("error", "Lỗi: Không thể thêm cơ vào cơ sở dữ liệu.");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Lỗi: Giá thuê không hợp lệ. Vui lòng nhập số.");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        // Chỉ forward lại form khi có lỗi
        request.getRequestDispatcher("/admin/themco.jsp").forward(request, response);
    }
}