<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Tài Khoản Hệ Thống</title>
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
                <style>
                    * {
                        box-sizing: border-box;
                        margin: 0;
                        padding: 0;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    body {
                        background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.95)),
                            url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
                        background-size: cover;
                        min-height: 100vh;
                        padding: 110px 20px 40px;
                    }

                    /* Navbar */
                    .navbar {
                        background: #f4f6f8;
                        padding: 0 32px;
                        height: 68px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        z-index: 100;
                    }

                    .navbar-brand {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        text-decoration: none;
                    }

                    .navbar-brand .logo-icon {
                        width: 40px;
                        height: 40px;
                        background: #0c764a;
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 20px;
                    }

                    .navbar-brand .brand-text {
                        font-size: 20px;
                        font-weight: 800;
                        letter-spacing: 1px;
                        color: #0c764a;
                    }

                    .navbar-user {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                    }

                    .navbar-user .user-info {
                        text-align: right;
                    }

                    .navbar-user .user-name {
                        font-size: 14px;
                        font-weight: 700;
                        color: #333;
                    }

                    .navbar-user .user-role {
                        font-size: 11px;
                        color: #0c764a;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        font-weight: 700;
                    }

                    .navbar-user .avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        background: #0c764a;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 16px;
                        color: white;
                    }

                    .btn-logout {
                        background: #fdf2f2;
                        color: #e74c3c;
                        border: 1px solid #fadbd8;
                        padding: 8px 16px;
                        border-radius: 8px;
                        font-size: 13px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        transition: 0.2s;
                    }

                    .btn-logout:hover {
                        background: #fadbd8;
                    }

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        background: rgba(255, 255, 255, 0.95);
                        padding: 30px;
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                    }

                    .header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 25px;
                        padding-bottom: 15px;
                        border-bottom: 2px solid #e2e8f0;
                    }

                    .header h2 {
                        color: #0c764a;
                        font-size: 24px;
                        font-weight: bold;
                    }

                    .btn-add {
                        background-color: #0c764a;
                        color: white;
                        padding: 10px 20px;
                        text-decoration: none;
                        border-radius: 6px;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        transition: background-color 0.2s;
                    }

                    .btn-add:hover {
                        background-color: #085233;
                    }

                    /* Responsive Wrapper cho Table */
                    .table-responsive {
                        overflow-x: auto;
                        width: 100%;
                        border-radius: 8px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        background-color: white;
                        min-width: 600px;
                        /* Đảm bảo bảng không co cụm quá nhỏ */
                    }

                    th,
                    td {
                        padding: 15px;
                        text-align: left;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    th {
                        background-color: #f8fafc;
                        font-weight: 600;
                        color: #334155;
                        text-transform: uppercase;
                        font-size: 13px;
                    }

                    tbody tr:hover {
                        background-color: #f1f5f9;
                    }

                    .role-badge {
                        padding: 4px 10px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: bold;
                        color: white;
                        background: #64748b;
                    }

                    .actions {
                        display: flex;
                        gap: 10px;
                    }

                    .btn {
                        padding: 6px 12px;
                        border-radius: 4px;
                        text-decoration: none;
                        font-size: 13px;
                        font-weight: 500;
                        transition: opacity 0.2s;
                        display: flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .btn:hover {
                        opacity: 0.8;
                    }

                    .btn-edit {
                        background-color: #e0f2fe;
                        color: #0369a1;
                        border: 1px solid #bae6fd;
                    }

                    .btn-delete {
                        background-color: #fee2e2;
                        color: #b91c1c;
                        border: 1px solid #fecaca;
                    }

                    /* Lớp hiển thị khi không có data */
                    .no-data {
                        text-align: center;
                        padding: 30px;
                        color: #64748b;
                        font-style: italic;
                    }

                    /* Search form styles */
                    .search-container {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        background: #f8fafc;
                        border: 1px solid #cbd5e1;
                        border-radius: 8px;
                        padding: 4px 12px;
                        transition: all 0.3s ease;
                        max-width: 400px;
                        width: 100%;
                    }

                    .search-container:focus-within {
                        border-color: #0c764a;
                        box-shadow: 0 0 0 3px rgba(12, 118, 74, 0.15);
                        background: white;
                    }

                    .search-input {
                        border: none;
                        outline: none;
                        background: transparent;
                        width: 100%;
                        font-size: 14px;
                        color: #1e293b;
                        padding: 6px 0;
                    }

                    .search-input::placeholder {
                        color: #94a3b8;
                    }

                    .clear-btn {
                        background: none;
                        border: none;
                        color: #94a3b8;
                        cursor: pointer;
                        font-size: 14px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: color 0.2s;
                        text-decoration: none;
                    }

                    .clear-btn:hover {
                        color: #ef4444;
                    }

                    /* MODAL CONFIRM DELETE */
                    .modal-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.6);
                        backdrop-filter: blur(6px);
                        z-index: 1000;
                        align-items: center;
                        justify-content: center;
                        animation: fadeIn 0.25s ease;
                    }
                    .modal-overlay.active {
                        display: flex;
                    }
                    @keyframes fadeIn {
                        from { opacity: 0; }
                        to { opacity: 1; }
                    }
                    .modal {
                        background: rgba(255, 255, 255, 0.98);
                        border: 1px solid #cbd5e1;
                        border-radius: 16px;
                        width: 100%;
                        max-width: 420px;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
                        animation: modalSlideUp 0.35s ease;
                        overflow: hidden;
                    }
                    @keyframes modalSlideUp {
                        from { opacity: 0; transform: translateY(30px) scale(0.97); }
                        to { opacity: 1; transform: translateY(0) scale(1); }
                    }
                    .confirm-modal .modal {
                        text-align: center;
                    }
                    .confirm-icon {
                        width: 64px;
                        height: 64px;
                        margin: 0 auto 20px;
                        border-radius: 50%;
                        background: #fee2e2;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 28px;
                        color: #ef4444;
                    }
                    .confirm-title {
                        font-size: 20px;
                        font-weight: 700;
                        color: #1e293b;
                        margin-bottom: 8px;
                    }
                    .confirm-text {
                        font-size: 14px;
                        color: #64748b;
                        margin-bottom: 24px;
                        line-height: 1.5;
                    }
                    .confirm-actions {
                        display: flex;
                        gap: 12px;
                        justify-content: center;
                    }
                    .btn-secondary {
                        background: #f1f5f9;
                        color: #64748b;
                        border: 1px solid #cbd5e1;
                    }
                    .btn-secondary:hover {
                        background: #e2e8f0;
                    }
                    .btn-danger {
                        background: #ef4444;
                        color: white;
                        border: none;
                    }
                    .btn-danger:hover {
                        background: #dc2626;
                    }
                </style>
            </head>

            <body>
                <%@ include file="sidebar.jsp" %>
                    <nav class="navbar" style="padding-left: 32px;">
                        <div class="navbar-left">
                            <h1 style="font-size: 18px; color: #0c764a; font-weight: 700; margin: 0;">Quản lý tài khoản
                            </h1>
                        </div>
                        <div class="navbar-user">
                            <div class="user-info">
                                <div class="user-name">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account.name}">
                                            <!-- Sử dụng c:out chống XSS -->
                                            <c:out value="${sessionScope.account.name}" />
                                        </c:when>
                                        <c:otherwise>Nguyễn Nguyễn</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="user-role">ADMINISTRATOR</div>
                            </div>
                            <div class="avatar">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account.name}">
                                        <!-- Sử dụng fn function an toàn thay cho Java method trực tiếp -->
                                        <c:out
                                            value="${fn:toUpperCase(fn:substring(sessionScope.account.name, 0, 1))}" />
                                    </c:when>
                                    <c:otherwise>N</c:otherwise>
                                </c:choose>
                            </div>
                            <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="btn-logout">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </nav>

                    <div class="container">
                        <div class="header">
                            <h2>Danh Sách Tài Khoản</h2>

                            <form action="${pageContext.request.contextPath}/admin/quanliAccount" method="get"
                                class="search-container">
                                <i class="fas fa-search" style="color: #94a3b8; font-size: 14px;"></i>
                                <input type="text" name="search" class="search-input"
                                    placeholder="Tìm kiếm tài khoản..." value="<c:out value='${searchKeyword}'/>">
                                <c:if test="${not empty searchKeyword}">
                                    <a href="${pageContext.request.contextPath}/admin/quanliAccount" class="clear-btn"
                                        title="Xóa tìm kiếm">
                                        <i class="fas fa-times-circle"></i>
                                    </a>
                                </c:if>
                                <button type="submit" style="display: none;"></button>
                            </form>

                            <a href="${pageContext.request.contextPath}/admin/quanliAccount?action=new" class="btn-add">
                                <i class="fas fa-user-plus"></i> Tạo Tài Khoản Mới
                            </a>
                        </div>

                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Họ & Tên</th>
                                        <th>Email</th>
                                        <th>SĐT</th>
                                        <th>Quyền Hạn</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty accountList}">
                                            <c:forEach var="acc" items="${accountList}">
                                                <tr>
                                                    <td style="font-weight:bold; color: #0c764a;">@
                                                        <c:out value="${acc.username}" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${acc.name}" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${acc.email}" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${acc.phone}" />
                                                    </td>
                                                    <td>
                                                        <span class="role-badge"
                                                            style="background-color: ${acc.role == 'Quản lý' ? '#e11d48' : (acc.role == 'Nhân viên' ? '#0284c7' : '#0c764a')};">
                                                            <c:out value="${acc.role}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="actions">
                                                            <a href="${pageContext.request.contextPath}/admin/quanliAccount?action=edit&id=${acc.id}"
                                                                class="btn btn-edit">
                                                                <i class="fas fa-edit"></i> Phân quyền/Sửa
                                                            </a>
                                                            <a href="javascript:void(0)"
                                                                class="btn btn-delete"
                                                                onclick="confirmDelete(${acc.id}, '<c:out value="${acc.username}" />')">
                                                                <i class="fas fa-trash"></i> Xóa
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="no-data">
                                                    <c:choose>
                                                        <c:when test="${not empty searchKeyword}">
                                                            Không tìm thấy tài khoản nào phù hợp với từ khóa "<strong>
                                                                <c:out value="${searchKeyword}" />
                                                            </strong>".
                                                        </c:when>
                                                        <c:otherwise>
                                                            Không có tài khoản nào trong hệ thống.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                <!-- DELETE CONFIRM MODAL -->
                <div class="modal-overlay confirm-modal" id="deleteModal">
                    <div class="modal">
                        <div class="modal-body" style="padding: 40px 28px;">
                            <div class="confirm-icon"><i class="fas fa-trash-alt"></i></div>
                            <div class="confirm-title">Xác nhận xóa?</div>
                            <div class="confirm-text">
                                Bạn có chắc muốn xóa vĩnh viễn tài khoản @<strong id="deleteAccountUsername"></strong>?<br>
                                Tài khoản này sẽ bị xóa khỏi hệ thống.
                            </div>
                            <div class="confirm-actions">
                                <button class="btn btn-secondary" onclick="closeDeleteModal()">
                                    <i class="fas fa-times"></i> Hủy
                                </button>
                                <a href="#" id="deleteLink" class="btn btn-danger" style="text-decoration:none">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    function confirmDelete(id, username) {
                        document.getElementById('deleteAccountUsername').textContent = username;
                        document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/admin/quanliAccount?action=delete&id=' + id;
                        document.getElementById('deleteModal').classList.add('active');
                    }
                    function closeDeleteModal() {
                        document.getElementById('deleteModal').classList.remove('active');
                    }
                    document.getElementById('deleteModal').addEventListener('click', function (e) {
                        if (e.target === this) closeDeleteModal();
                    });
                </script>
            </body>

            </html>