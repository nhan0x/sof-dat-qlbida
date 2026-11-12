<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Dịch Vụ - H.N.D.D Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-card: rgba(255, 255, 255, 0.95);
            --bg-input: #f7f9fa;
            --border-color: #e2e8f0;
            --border-focus: #0c764a;
            --text-primary: #1e293b;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --accent-primary: #0c764a;
            --accent-gradient: linear-gradient(135deg, #0c764a 0%, #0a603c 100%);
            --success: #10b981;
            --success-bg: rgba(16, 185, 129, 0.15);
            --danger: #ef4444;
            --danger-bg: rgba(239, 68, 68, 0.15);
            --warning: #f59e0b;
            --warning-bg: rgba(245, 158, 11, 0.15);
            --info: #3b82f6;
            --info-bg: rgba(59, 130, 246, 0.15);
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 14px rgba(0,0,0,0.15);
            --shadow-lg: 0 15px 30px rgba(0,0,0,0.2);
            --radius-sm: 8px; --radius-md: 12px; --radius-lg: 16px; --radius-xl: 20px;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.95)),
                url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-primary); min-height: 100vh; line-height: 1.6;
        }

        /* NAVBAR */
        .navbar {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(20px);
            border-bottom: 2px solid #fff; padding: 0 32px; height: 68px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-user { display: flex; align-items: center; gap: 16px; }
        .navbar-user .user-info { text-align: right; }
        .navbar-user .user-name { font-size: 14px; font-weight: 600; color: var(--text-primary); }
        .navbar-user .user-role { font-size: 11px; color: var(--accent-primary); text-transform: uppercase; letter-spacing: 1px; font-weight: 600; }
        .navbar-user .avatar {
            width: 40px; height: 40px; border-radius: 50%; background: var(--accent-gradient);
            display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 16px; color: white;
        }
        .btn-logout {
            background: rgba(239,68,68,0.15); color: var(--danger); border: 1px solid rgba(239,68,68,0.3);
            padding: 8px 16px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all 0.3s; text-decoration: none;
        }
        .btn-logout:hover { background: var(--danger); color: white; transform: translateY(-1px); }

        /* MAIN */
        .main-content { max-width: 1400px; margin: 0 auto; padding: 32px; }

        /* PAGE HEADER */
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
        .page-header .page-title { font-size: 28px; font-weight: 800; color: white; }
        .page-header .page-subtitle { font-size: 14px; color: rgba(255,255,255,0.7); margin-top: 4px; }
        .btn-add-new {
            display: inline-flex; align-items: center; gap: 8px; background: var(--accent-gradient);
            color: white; border: none; padding: 12px 24px; border-radius: var(--radius-md);
            font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(12,118,74,0.4); text-decoration: none;
        }
        .btn-add-new:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(12,118,74,0.5); }

        /* STATS */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; transition: all 0.3s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-icon { width: 48px; height: 48px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 20px; margin-bottom: 16px; }
        .stat-value { font-size: 28px; font-weight: 800; color: var(--text-primary); }
        .stat-label { font-size: 13px; color: var(--text-secondary); margin-top: 4px; font-weight: 500; }
        .stat-icon.blue { background: var(--info-bg); color: var(--info); }
        .stat-icon.green { background: var(--success-bg); color: var(--success); }

        /* ALERT */
        .alert { padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; animation: slideDown 0.4s ease; }
        .alert-success { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.3); }
        .alert-danger  { background: var(--danger-bg);  color: var(--danger);  border: 1px solid rgba(239,68,68,0.3); }
        .close-alert { margin-left: auto; background: none; border: none; color: inherit; font-size: 18px; cursor: pointer; opacity: 0.7; }
        .close-alert:hover { opacity: 1; }
        @keyframes slideDown { from { opacity:0; transform: translateY(-10px); } to { opacity:1; transform: translateY(0); } }

        /* TABLE CARD */
        .table-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); overflow: hidden; box-shadow: var(--shadow-sm); }
        .table-card-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid var(--border-color); }
        .table-card-header h3 { font-size: 16px; font-weight: 700; display: flex; align-items: center; gap: 8px; }

        .search-box { position: relative; }
        .search-box input { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 10px 14px 10px 38px; color: var(--text-primary); font-size: 13px; font-family: inherit; width: 260px; transition: all 0.3s; }
        .search-box input:focus { outline: none; border-color: var(--border-focus); box-shadow: 0 0 0 3px rgba(12,118,74,0.15); }
        .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px; }

        /* DATA TABLE */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 14px 20px; text-align: left; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: #fff; background: #0c764a; white-space: nowrap; }
        .data-table tbody tr { border-bottom: 1px solid rgba(51,65,85,0.1); transition: all 0.2s; }
        .data-table tbody tr:hover { background: rgba(12,118,74,0.04); }
        .data-table tbody tr:last-child { border-bottom: none; }
        .data-table tbody td { padding: 16px 20px; font-size: 14px; color: var(--text-primary); vertical-align: middle; }
        .item-id { font-weight: 700; color: var(--accent-primary); font-size: 13px; }
        .item-name { font-weight: 600; }
        .item-price { font-weight: 700; color: var(--success); }

        .action-btns { display: flex; gap: 8px; }
        .btn-action { width: 36px; height: 36px; border: none; border-radius: var(--radius-sm); display: inline-flex; align-items: center; justify-content: center; font-size: 14px; cursor: pointer; transition: all 0.3s; text-decoration: none; }
        .btn-edit  { background: var(--info-bg); color: var(--info); border: 1px solid rgba(59,130,246,0.2); }
        .btn-edit:hover  { background: var(--info); color: white; transform: translateY(-2px); }
        .btn-delete { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.2); }
        .btn-delete:hover { background: var(--danger); color: white; transform: translateY(-2px); }

        /* MODAL */
        .modal-overlay { display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(6px); z-index: 1000; align-items: center; justify-content: center; animation: fadeIn 0.25s ease; }
        .modal-overlay.active { display: flex; }
        @keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
        .modal { background: rgba(255,255,255,0.98); border: 1px solid var(--border-color); border-radius: var(--radius-xl); width: 100%; max-width: 520px; max-height: 90vh; overflow-y: auto; box-shadow: var(--shadow-lg); animation: modalSlideUp 0.35s ease; }
        @keyframes modalSlideUp { from { opacity:0; transform: translateY(30px) scale(0.97); } to { opacity:1; transform: translateY(0) scale(1); } }
        .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 24px 28px 16px; border-bottom: 1px solid var(--border-color); }
        .modal-header h3 { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .modal-header h3 i { color: var(--accent-primary); }
        .modal-close { width: 36px; height: 36px; border: 1px solid var(--border-color); border-radius: var(--radius-sm); background: transparent; color: var(--text-secondary); font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s; }
        .modal-close:hover { background: var(--danger-bg); color: var(--danger); border-color: rgba(239,68,68,0.3); }
        .modal-body { padding: 24px 28px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control { width: 100%; padding: 12px 16px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: var(--radius-sm); color: var(--text-primary); font-size: 14px; font-family: inherit; transition: all 0.3s; }
        .form-control:focus { outline: none; border-color: var(--border-focus); box-shadow: 0 0 0 3px rgba(12,118,74,0.15); }
        .modal-footer { display: flex; gap: 12px; justify-content: flex-end; padding: 16px 28px 24px; border-top: 1px solid var(--border-color); }
        .btn { padding: 11px 24px; border-radius: var(--radius-sm); font-size: 14px; font-weight: 600; font-family: inherit; cursor: pointer; transition: all 0.3s; border: none; display: inline-flex; align-items: center; gap: 8px; }
        .btn-primary { background: var(--accent-gradient); color: white; box-shadow: 0 4px 12px rgba(12,118,74,0.25); }
        .btn-primary:hover { transform: translateY(-1px); }
        .btn-secondary { background: var(--bg-input); color: var(--text-secondary); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: var(--border-color); }
        .btn-danger { background: var(--danger); color: white; }
        .btn-danger:hover { background: #dc2626; transform: translateY(-1px); }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 48px; color: var(--text-muted); margin-bottom: 16px; }
        .empty-state h4 { font-size: 18px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: var(--text-muted); }

        /* DELETE CONFIRM */
        .confirm-modal .modal { max-width: 420px; text-align: center; }
        .confirm-icon { width: 64px; height: 64px; margin: 0 auto 20px; border-radius: 50%; background: var(--danger-bg); display: flex; align-items: center; justify-content: center; font-size: 28px; color: var(--danger); }
        .confirm-title { font-size: 20px; font-weight: 700; margin-bottom: 8px; }
        .confirm-text { font-size: 14px; color: var(--text-secondary); margin-bottom: 24px; }
        .confirm-actions { display: flex; gap: 12px; justify-content: center; }

        .category-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.05);
            padding: 6px;
            border-radius: var(--radius-md);
            overflow-x: auto;
            border: 1px solid rgba(255,255,255,0.1);
        }
        .category-tab {
            padding: 8px 16px;
            border-radius: var(--radius-sm);
            background: transparent;
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s;
            white-space: nowrap;
        }
        .category-tab:hover {
            background: rgba(12, 118, 74, 0.2);
            color: var(--accent-primary);
        }
        .category-tab.active {
            background: var(--accent-gradient);
            color: white;
            box-shadow: 0 4px 10px rgba(12, 118, 74, 0.3);
        }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 700;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .badge-category {
            background: rgba(12, 118, 74, 0.15);
            color: var(--accent-primary);
            border: 1px solid rgba(12, 118, 74, 0.3);
        }
        @media (max-width: 768px) {
            .main-content { padding: 16px; }
            .page-header { flex-direction: column; gap: 16px; align-items: flex-start; }
            .stats-grid { grid-template-columns: repeat(2,1fr); }
            .data-table { display: block; overflow-x: auto; }
            .modal { margin: 16px; max-width: calc(100% - 32px); }
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

    <!-- NAVBAR -->
    <nav class="navbar" style="padding-left: 32px;">
        <div class="navbar-left">
            <h1 style="font-size: 18px; color: #0c764a; font-weight: 700; margin: 0;">Quản lý dịch vụ</h1>
        </div>
        <div class="navbar-user">
            <div class="user-info">
                <div class="user-name">${sessionScope.account.name}</div>
                <div class="user-role">Administrator</div>
            </div>
            <div class="avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">
                        ${sessionScope.account.name.substring(0,1).toUpperCase()}
                    </c:when>
                    <c:otherwise>A</c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </nav>

    <!-- MAIN -->
    <div class="main-content">

        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">Quản Lý Dịch Vụ</h1>
                <p class="page-subtitle">Xem, thêm, sửa và xóa các dịch vụ (đồ uống, món ăn...) của quán</p>
            </div>
            <button class="btn-add-new" onclick="openCreateModal()">
                <i class="fas fa-plus"></i> Thêm Dịch Vụ Mới
            </button>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-concierge-bell"></i></div>
                <div class="stat-value" id="statTotal">0</div>
                <div class="stat-label">Tổng số dịch vụ</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-money-bill-wave"></i></div>
                <div class="stat-value" id="statAvgPrice">0</div>
                <div class="stat-label">Giá TB (VNĐ)</div>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${sessionScope.message}</span>
                <button class="close-alert" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${sessionScope.error}</span>
                <button class="close-alert" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>
        <!-- Category Tabs -->
        <div class="category-tabs">
            <button class="category-tab active" data-category="Tất cả" onclick="filterByCategory('Tất cả')">🎱 Tất cả</button>
            <c:forEach var="cat" items="${categoryList}">
                <button class="category-tab" data-category="${cat.name}" onclick="filterByCategory('${cat.name}')">
                    <c:choose>
                        <c:when test="${cat.name == 'Nước uống'}">🥤</c:when>
                        <c:when test="${cat.name == 'Đồ uống có cồn'}">🍺</c:when>
                        <c:when test="${cat.name == 'Đồ ăn'}">🍔</c:when>
                        <c:when test="${cat.name == 'Thuốc lá'}">🚬</c:when>
                        <c:when test="${cat.name == 'Khác'}">📦</c:when>
                        <c:otherwise>🏷️</c:otherwise>
                    </c:choose>
                    ${cat.name}
                </button>
            </c:forEach>
        </div>

        <!-- Table Card -->
        <div class="table-card">
            <div class="table-card-header">
                <h3><i class="fas fa-concierge-bell" style="color: var(--accent-primary)"></i> Danh Sách Dịch Vụ</h3>
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm dịch vụ..." onkeyup="filterTable()">
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty serviceList}">
                    <table class="data-table" id="tableMain">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>ID</th>
                                <th>Tên Dịch Vụ</th>
                                <th>Danh Mục</th>
                                <th>Giá (VNĐ)</th>
                                <th style="text-align:center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${serviceList}" varStatus="status">
                                <tr data-category="${item.category != null ? item.category : 'Khác'}">
                                    <td class="row-stt" style="font-weight: 600; color: var(--text-muted);">${status.index + 1}</td>
                                    <td class="item-id">#${item.id}</td>
                                    <td class="item-name">${item.name}</td>
                                    <td>
                                        <span class="badge badge-category">${item.category != null ? item.category : 'Khác'}</span>
                                    </td>
                                    <td class="item-price">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/>đ
                                    </td>
                                    <td>
                                        <div class="action-btns" style="justify-content:center">
                                            <a href="javascript:void(0)" class="btn-action btn-edit" title="Sửa"
                                               onclick="openEditModal(${item.id}, '${item.name}', ${item.price}, '${item.category != null ? item.category : 'Khác'}')">
                                                <i class="fas fa-pen"></i>
                                            </a>
                                            <a href="javascript:void(0)" class="btn-action btn-delete" title="Xóa"
                                               onclick="openDeleteModal(${item.id}, '${item.name}')">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h4>Chưa có dữ liệu</h4>
                        <p>Nhấn "Thêm Dịch Vụ Mới" để bắt đầu quản lý dịch vụ.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- CREATE / EDIT MODAL -->
    <div class="modal-overlay" id="serviceModal">
        <div class="modal">
            <div class="modal-header">
                <h3 id="modalTitle"><i class="fas fa-plus-circle"></i> <span>Thêm Dịch Vụ Mới</span></h3>
                <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
            </div>
            <form id="serviceForm" method="POST" action="${pageContext.request.contextPath}/admin/quanlidichvu">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="formId" value="">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="formName"><i class="fas fa-tag"></i> Tên Dịch Vụ</label>
                        <input type="text" class="form-control" id="formName" name="name"
                               placeholder="Ví dụ: Nước suối, Cà phê, Mì gói..." required>
                    </div>
                    <div class="form-group">
                        <label for="formPrice"><i class="fas fa-money-bill-wave"></i> Giá (VNĐ)</label>
                        <input type="number" step="1000" min="1000" class="form-control" id="formPrice" name="price"
                               placeholder="Nhập giá dịch vụ..." required>
                    </div>
                    <div class="form-group">
                        <label for="formCategory"><i class="fas fa-list"></i> Danh Mục</label>
                        <select class="form-control" id="formCategory" name="category" required>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.name}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check"></i> <span id="btnSubmitText">Thêm Dịch Vụ</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- DELETE CONFIRM MODAL -->
    <div class="modal-overlay confirm-modal" id="deleteModal">
        <div class="modal">
            <div class="modal-body" style="padding: 40px 28px;">
                <div class="confirm-icon"><i class="fas fa-trash-alt"></i></div>
                <div class="confirm-title">Xác nhận xóa?</div>
                <div class="confirm-text">
                    Bạn có chắc muốn xóa dịch vụ "<strong id="deleteServiceName"></strong>"?<br>
                    Hành động này không thể hoàn tác.
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
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('#tableMain tbody tr');
            animateCount('statTotal', rows.length);

            let totalPrice = 0;
            rows.forEach(row => {
                const priceText = row.cells[2] ? row.cells[2].textContent.replace(/[^0-9]/g, '') : '0';
                totalPrice += parseInt(priceText) || 0;
            });
            const avg = rows.length > 0 ? Math.round(totalPrice / rows.length) : 0;
            animateCount('statAvgPrice', avg);

            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(a => {
                    a.style.transition = 'opacity 0.4s';
                    a.style.opacity = '0';
                    setTimeout(() => a.remove(), 400);
                });
            }, 4000);

            <c:if test="${not empty editService}">
                openEditModal(${editService.id}, '${editService.name}', ${editService.price}, '${editService.category != null ? editService.category : 'Khác'}');
            </c:if>
            filterByCategory('Tất cả');
        });

        let currentCategory = 'Tất cả';

        function filterByCategory(category) {
            currentCategory = category;
            document.querySelectorAll('.category-tab').forEach(tab => {
                if (tab.getAttribute('data-category') === category) {
                    tab.classList.add('active');
                } else {
                    tab.classList.remove('active');
                }
            });
            filterTable();
        }

        function animateCount(id, target) {
            const el = document.getElementById(id);
            if (!el) return;
            let current = 0;
            if (target === 0) { el.textContent = '0'; return; }
            const step = Math.max(Math.ceil(target / 20), 1);
            const timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                el.textContent = current.toLocaleString('vi-VN');
            }, 40);
        }

        function filterTable() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            let stt = 1;
            document.querySelectorAll('#tableMain tbody tr').forEach(row => {
                const nameText = row.querySelector('.item-name') ? row.querySelector('.item-name').textContent.toLowerCase() : '';
                const rowCategory = row.getAttribute('data-category') || 'Khác';
                
                const matchesQuery = nameText.includes(query);
                const matchesCategory = (currentCategory === 'Tất cả' || rowCategory === currentCategory);
                
                if (matchesQuery && matchesCategory) {
                    row.style.display = '';
                    const sttCell = row.querySelector('.row-stt');
                    if (sttCell) sttCell.textContent = stt++;
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function openCreateModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> <span>Thêm Dịch Vụ Mới</span>';
            document.getElementById('formAction').value = 'create';
            document.getElementById('formId').value = '';
            document.getElementById('formName').value = '';
            document.getElementById('formPrice').value = '';
            document.getElementById('formCategory').value = 'Nước uống';
            document.getElementById('btnSubmitText').textContent = 'Thêm Dịch Vụ';
            document.getElementById('serviceModal').classList.add('active');
        }

        function openEditModal(id, name, price, category) {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> <span>Chỉnh Sửa Dịch Vụ</span>';
            document.getElementById('formAction').value = 'update';
            document.getElementById('formId').value = id;
            document.getElementById('formName').value = name;
            document.getElementById('formPrice').value = price;
            document.getElementById('formCategory').value = category || 'Khác';
            document.getElementById('btnSubmitText').textContent = 'Cập Nhật';
            document.getElementById('serviceModal').classList.add('active');
        }

        function closeModal() { document.getElementById('serviceModal').classList.remove('active'); }

        function openDeleteModal(id, name) {
            document.getElementById('deleteServiceName').textContent = name;
            document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/admin/quanlidichvu?action=delete&id=' + id;
            document.getElementById('deleteModal').classList.add('active');
        }
        function closeDeleteModal() { document.getElementById('deleteModal').classList.remove('active'); }

        document.getElementById('serviceModal').addEventListener('click', function(e) { if (e.target === this) closeModal(); });
        document.getElementById('deleteModal').addEventListener('click', function(e) { if (e.target === this) closeDeleteModal(); });
        document.addEventListener('keydown', function(e) { if (e.key === 'Escape') { closeModal(); closeDeleteModal(); } });
    </script>

</body>
</html>
