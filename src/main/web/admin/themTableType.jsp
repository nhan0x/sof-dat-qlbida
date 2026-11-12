<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:if test="${tableTypeParams != null}">Sửa Loại Bàn</c:if>
                <c:if test="${tableTypeParams == null}">Thêm Loại Bàn</c:if>
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
                    background: linear-gradient(135deg, #0e5e36, #06311a);
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    min-height: 100vh;
                    padding: 100px 20px 40px;
                }

                /* Navbar Styles from existing theme */
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
                    max-width: 500px;
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

                .form-control:focus {
                    outline: none;
                    border-color: #0c764a;
                    box-shadow: 0 0 0 3px rgba(12, 118, 74, 0.1);
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

                .btn-back:hover {
                    color: #0c764a;
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
                <div class="form-header">
                    <h2>
                        <c:if test="${tableTypeParams != null}">Cập Nhật Loại Bàn</c:if>
                        <c:if test="${tableTypeParams == null}">Thêm Loại Bàn Mới</c:if>
                    </h2>
                </div>

                <form action="${pageContext.request.contextPath}/admin/quanliloaiban" method="post">
                    <c:choose>
                        <c:when test="${tableTypeParams != null}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${tableTypeParams.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="insert">
                        </c:otherwise>
                    </c:choose>

                    <div class="form-group">
                        <label for="name">Tên Loại Bàn (VD: Pool, Carom 3 Băng):</label>
                        <input type="text" id="name" name="name" class="form-control"
                            value="${tableTypeParams != null ? tableTypeParams.name : ''}" required>
                    </div>

                    <div class="form-group">
                        <label for="pricePerHour">Đơn giá / Giờ (VNĐ):</label>
                        <input type="number" step="1000" min="1000" id="pricePerHour" name="pricePerHour" class="form-control"
                            value="${tableTypeParams != null ? tableTypeParams.pricePerHour : ''}" required>
                    </div>

                    <button type="submit" class="btn-submit">
                        <c:if test="${tableTypeParams != null}"><i class="fas fa-save"></i> Lưu Thay Đổi</c:if>
                        <c:if test="${tableTypeParams == null}"><i class="fas fa-plus"></i> Thêm Loại Bàn</c:if>
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/admin/quanliloaiban" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </body>

        </html>