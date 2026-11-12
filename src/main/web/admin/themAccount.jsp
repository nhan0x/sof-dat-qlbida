<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:if test="${accountParams != null}">Cập Nhật Tài Khoản</c:if>
                <c:if test="${accountParams == null}">Tạo Tài Khoản Hệ Thống</c:if>
            </title>
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
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    min-height: 100vh;
                    padding: 100px 20px 40px;
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

                .form-container {
                    background: rgba(255, 255, 255, 0.95);
                    padding: 40px;
                    border-radius: 12px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                    width: 100%;
                    max-width: 550px;
                    border-top: 5px solid #0c764a;
                }

                .form-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .form-header h2 {
                    color: #0c764a;
                    font-size: 24px;
                    font-weight: bold;
                    margin-top: 10px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    color: #333;
                    font-weight: 600;
                    font-size: 14px;
                }

                .form-control {
                    width: 100%;
                    padding: 12px 15px;
                    border: 1px solid #cbd5e1;
                    border-radius: 8px;
                    font-size: 14px;
                    transition: border-color 0.2s, box-shadow 0.2s;
                }

                select.form-control {
                    appearance: none;
                    background-color: white;
                }

                .form-control:focus {
                    outline: none;
                    border-color: #0c764a;
                    box-shadow: 0 0 0 3px rgba(12, 118, 74, 0.1);
                }

                .form-control[disabled] {
                    background: #f1f5f9;
                    color: #94a3b8;
                    cursor: not-allowed;
                }

                .flex-row {
                    display: flex;
                    gap: 15px;
                }

                .flex-row .form-group {
                    flex: 1;
                }

                .btn-submit {
                    width: 100%;
                    background: #0c764a;
                    color: white;
                    border: none;
                    padding: 12px;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: background-color 0.2s;
                    margin-top: 10px;
                }

                .btn-submit:hover {
                    background: #085233;
                }

                .btn-back {
                    display: block;
                    text-align: center;
                    margin-top: 15px;
                    color: #64748b;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 500;
                }

                .alert-info {
                    background: #eef2ff;
                    color: #4338ca;
                    padding: 12px;
                    border-radius: 8px;
                    font-size: 13px;
                    margin-bottom: 20px;
                }
            </style>
        </head>

        <body>
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/admin/quanli.jsp" class="navbar-brand">
                    <div class="logo-icon">🎱</div>
                    <span class="brand-text">H.N.D.D</span>
                </a>
                <div class="navbar-user">
                    <div class="user-info">
                        <div class="user-name">
                            <c:choose>
                                <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}
                                </c:when>
                                <c:otherwise>Nguyễn Nguyễn</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-role">ADMINISTRATOR</div>
                    </div>
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.account.name}">
                                ${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                            <c:otherwise>N</c:otherwise>
                        </c:choose>
                    </div>
                    <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </nav>

            <div class="form-container">
                <div class="form-header">
                    <h2>
                        <c:if test="${accountParams != null}">Chỉnh Sửa Quyền & Thông Tin</c:if>
                        <c:if test="${accountParams == null}">Tạo Tài Khoản Mới</c:if>
                    </h2>
                </div>

                <c:if test="${not empty loi}">
                    <div class="error-alert"
                        style="background: #fee2e2; color: #b91c1c; padding: 12px; border-radius: 8px; font-size: 13px; margin-bottom: 20px; border: 1px solid #fca5a5;">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:out value="${loi}" />
                    </div>
                </c:if>

                <c:if test="${accountParams != null}">
                    <div class="alert-info">Chỉ có thể thay đổi thông tin liên lạc. Username, Password và Phân quyền
                        không thể sửa bởi Admin.</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/quanliAccount" method="post">
                    <c:choose>
                        <c:when test="${accountParams != null}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${accountParams.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="insert">
                        </c:otherwise>
                    </c:choose>

                    <div class="flex-row">
                        <div class="form-group">
                            <label>Username:</label>
                            <input type="text" name="username" class="form-control"
                                value="${accountParams != null ? accountParams.username : ''}" ${accountParams !=null
                                ? 'disabled' : 'required' } pattern="^\S+$"
                                title="Username không được chứa khoảng trắng hoặc để trống">
                        </div>

                        <c:if test="${accountParams == null}">
                            <div class="form-group">
                                <label>Password:</label>
                                <input type="password" name="password" class="form-control" required minlength="6"
                                    pattern="^\S{6,}$"
                                    title="Password phải từ 6 ký tự trở lên và không được chứa khoảng trắng">
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>Quyền hạn trong hệ thống (Role):</label>
                        <select name="role" class="form-control" ${accountParams != null ? 'disabled' : ''}>
                            <option value="Khách hàng" ${accountParams !=null && accountParams.role=='Khách hàng'
                                ? 'selected' : '' }>Khách hàng (Xem/Đặt bàn)</option>
                            <option value="Nhân viên" ${accountParams !=null && accountParams.role=='Nhân viên'
                                ? 'selected' : '' }>Nhân viên</option>
                        </select>
                        <c:if test="${accountParams != null}">
                            <input type="hidden" name="role" value="${accountParams.role}">
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>Họ & Tên Chủ Tài Khoản:</label>
                        <input type="text" name="name" class="form-control"
                            value="${accountParams != null ? accountParams.name : ''}" required>
                    </div>

                    <div class="flex-row">
                        <div class="form-group">
                            <label>Số Điện Thoại:</label>
                            <input type="tel" name="phone" class="form-control"
                                value="${accountParams != null ? accountParams.phone : ''}" required>
                        </div>

                        <div class="form-group">
                            <label>Email liên lạc:</label>
                            <input type="email" name="email" class="form-control"
                                value="${accountParams != null ? accountParams.email : ''}" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <c:if test="${accountParams != null}"><i class="fas fa-save"></i> Cập Nhật Sự Thay Đổi</c:if>
                        <c:if test="${accountParams == null}"><i class="fas fa-plus"></i> Khởi Tạo Tài Khoản Này</c:if>
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/admin/quanliAccount" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </body>

        </html>