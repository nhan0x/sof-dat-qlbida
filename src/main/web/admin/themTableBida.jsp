<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:if test="${table != null}">Sửa Bàn Bida</c:if>
                <c:if test="${table == null}">Thêm Bàn Bida Mới</c:if>
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
                    /* Hình nền màu xanh bida */
                    background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.95)),
                                url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
                    background-size: cover;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                    padding: 100px 20px 40px;
                }

                /* Navbar Styles */
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
                    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
                    width: 100%;
                    max-width: 450px;
                    border: 2px solid #fff;
                }

                .header-logo {
                    text-align: center;
                    margin-bottom: 20px;
                }

                .header-logo img {
                    max-width: 150px;
                    margin-bottom: 10px;
                }

                h2 {
                    text-align: center;
                    margin-bottom: 30px;
                    color: #333;
                    font-size: 22px;
                    font-weight: 700;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    color: #555;
                    font-size: 14px;
                    font-weight: 600;
                }

                .input-group {
                    position: relative;
                }

                .input-group input {
                    width: 100%;
                    padding: 12px 15px;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    font-size: 15px;
                    transition: all 0.3s ease;
                    background-color: #f7f9fa;
                }

                .input-group input:focus {
                    outline: none;
                    border-color: #0c764a;
                    box-shadow: 0 0 0 3px rgba(12, 118, 74, 0.2);
                    background-color: #fff;
                }

                .btn-submit {
                    width: 100%;
                    padding: 14px;
                    background: #0c764a;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: bold;
                    cursor: pointer;
                    margin-top: 10px;
                    transition: background 0.3s;
                    text-transform: uppercase;
                }

                .btn-submit:hover {
                    background: #0a603c;
                }

                .back-link {
                    display: block;
                    text-align: center;
                    margin-top: 20px;
                    text-decoration: none;
                    color: #0c764a;
                    font-weight: 600;
                    font-size: 14px;
                }

                .back-link:hover {
                    text-decoration: underline;
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
                <div class="header-logo">
                    <!-- Thêm ảnh logo bida nếu có -->
                    <h2>BIDA PRO <br><span style="font-size: 14px; font-weight: normal; color: #666;">MANAGEMENT</span>
                    </h2>
                </div>

                <h2>
                    <c:if test="${table != null}">Cập Nhật Bàn Bida</c:if>
                    <c:if test="${table == null}">Thêm Bàn Bida Mới</c:if>
                </h2>

                <c:if test="${table != null}">
                    <form action="${pageContext.request.contextPath}/admin/suaTableBida" method="post">
                </c:if>
                <c:if test="${table == null}">
                    <form action="${pageContext.request.contextPath}/admin/themTableBida" method="post">
                </c:if>

                <c:if test="${table != null}">
                    <input type="hidden" name="id" value="${table.id}" />
                </c:if>

                <div class="form-group">
                    <label for="name">Tên bàn (Tên hiển thị)</label>
                    <div class="input-group">
                        <input type="text" id="name" name="name" value="<c:out value=" ${table.name}" />"
                        placeholder="Nhập tên bàn..." required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="tableTypeId">Loại bàn</label>
                    <div class="input-group">
                        <select id="tableTypeId" name="tableTypeId" required>
                            <option value="" disabled selected>-- Chọn loại bàn --</option>
                            <c:forEach var="tt" items="${tableTypeList}">
                                <option value="${tt.id}" ${tt.id == table.tableTypeId ? 'selected' : ''}>${tt.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="status">Tình trạng</label>
                    <div class="input-group">
                        <input type="text" id="status" name="status" value="<c:out value=" ${table.status}" />"
                        placeholder="Mới, Đang sử dụng..." required>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    <c:if test="${table != null}">Lưu thay đổi</c:if>
                    <c:if test="${table == null}">Thêm Mới</c:if>
                </button>
                </form>

                <a href="${pageContext.request.contextPath}/admin/quanliTableBida" class="back-link">← Quay lại danh
                    sách quản lý</a>
            </div>
        </body>

        </html>