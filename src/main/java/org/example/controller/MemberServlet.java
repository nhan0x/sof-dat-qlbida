package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.MemberDAO;
import org.example.daos.MemberDAOImpl;
import org.example.models.Member;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quanlithanhvien")
public class MemberServlet extends HttpServlet {

    private MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAOImpl();
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
                deleteMember(req, resp);
                break;
            case "list":
            default:
                listMembers(req, resp);
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
                createMember(req, resp);
                break;
            case "update":
                updateMember(req, resp);
                break;
            default:
                listMembers(req, resp);
                break;
        }
    }

    private void listMembers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        List<Member> memberList;
        if (search != null && !search.trim().isEmpty()) {
            memberList = memberDAO.search(search.trim());
            req.setAttribute("searchKeyword", search.trim());
        } else {
            memberList = memberDAO.getAll();
        }
        req.setAttribute("memberList", memberList);
        req.getRequestDispatcher("/admin/quanlithanhvien.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Member member = memberDAO.getById(id);
            if (member != null) {
                req.setAttribute("editMember", member);
            } else {
                req.setAttribute("error", "Không tìm thấy thành viên với ID: " + id);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ.");
        }
        List<Member> memberList = memberDAO.getAll();
        req.setAttribute("memberList", memberList);
        req.getRequestDispatcher("/admin/quanlithanhvien.jsp").forward(req, resp);
    }

    private void createMember(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            
            int points = 0;
            double discountRate = 0.0;
            
            try {
                if (req.getParameter("points") != null) {
                    points = Integer.parseInt(req.getParameter("points"));
                }
                if (req.getParameter("discountRate") != null) {
                    discountRate = Double.parseDouble(req.getParameter("discountRate"));
                }
            } catch (Exception ex) {}

            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên và SĐT không được để trống.");
            } else {
                name = name.trim();
                phone = phone.trim();
                email = email != null ? email.trim() : "";
                
                if (username == null || username.trim().isEmpty()) {
                    username = phone; // Default username is phone number
                } else {
                    username = username.trim();
                }

                Member existing = memberDAO.getByPhone(phone);
                if (existing != null) {
                    req.getSession().setAttribute("error", "Thành viên có SĐT '" + phone + "' đã tồn tại.");
                } else {
                    Member newMember = new Member(0, username, name, phone, email, points, discountRate);
                    boolean result = memberDAO.create(newMember, password);
                    if (result) {
                        req.getSession().setAttribute("message", "Thêm thành viên thành công!");
                    } else {
                        req.getSession().setAttribute("error", "Lỗi: Không thể thêm thành viên. Tên đăng nhập hoặc SĐT có thể đã trùng lặp trong hệ thống.");
                    }
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlithanhvien");
    }

    private void updateMember(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            int points = Integer.parseInt(req.getParameter("points"));
            double discountRate = Double.parseDouble(req.getParameter("discountRate"));

            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Tên và SĐT không được để trống.");
            } else {
                name = name.trim();
                phone = phone.trim();
                email = email != null ? email.trim() : "";

                Member old = memberDAO.getById(id);
                if (old == null) {
                    req.getSession().setAttribute("error", "Không tìm thấy thành viên.");
                } else {
                    Member existing = memberDAO.getByPhone(phone);
                    if (existing != null && existing.getId() != id) {
                        req.getSession().setAttribute("error", "SĐT '" + phone + "' đã được sử dụng bởi thành viên khác.");
                    } else {
                        Member member = new Member(id, old.getUsername(), name, phone, email, points, discountRate);
                        boolean result = memberDAO.update(member);
                        if (result) {
                            req.getSession().setAttribute("message", "Cập nhật thành viên thành công!");
                        } else {
                            req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật thành viên.");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu điểm hoặc giảm giá không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlithanhvien");
    }

    private void deleteMember(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Member member = memberDAO.getById(id);
            if (member != null) {
                boolean result = memberDAO.delete(id);
                if (result) {
                    req.getSession().setAttribute("message", "Xóa thành viên thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi: Không thể xóa thành viên.");
                }
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy thành viên để xóa.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quanlithanhvien");
    }
}
