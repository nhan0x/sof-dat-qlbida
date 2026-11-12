<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Đặt Bàn - H.N.D.D Management</title>
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
        .item-time { font-family: monospace; font-size: 13px; }

        /* STATUS BADGE */
        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600;
        }
        .status-pending { background: var(--warning-bg); color: var(--warning); border: 1px solid rgba(245,158,11,0.25); }
        .status-approved { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.25); }
        .status-cancelled { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.25); }
        .status-waiting-payment { background: rgba(59,130,246,0.1); color: #3b82f6; border: 1px solid rgba(59,130,246,0.25); }

        /* ACTION BUTTONS */
        .action-btns { display: flex; gap: 8px; }
        .btn-action {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 14px; border: none; border-radius: var(--radius-sm);
            font-size: 12px; font-weight: 600; cursor: pointer; transition: all 0.3s;
            text-decoration: none;
        }
        .btn-approve { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.2); }
        .btn-approve:hover { background: var(--success); color: white; transform: translateY(-2px); }
        .btn-cancel { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.2); }
        .btn-cancel:hover { background: var(--danger); color: white; transform: translateY(-2px); }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 48px; color: var(--text-muted); margin-bottom: 16px; }
        .empty-state h4 { font-size: 18px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: var(--text-muted); }

        /* ALERT MESSAGES */
        .bida-alert {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 18px; border-radius: var(--radius-md);
            margin-bottom: 20px; font-size: 14px; font-weight: 500;
        }
        .alert-success {
            background: var(--success-bg); color: var(--success);
            border: 1px solid rgba(16,185,129,0.25);
        }
        .alert-danger {
            background: var(--danger-bg); color: var(--danger);
            border: 1px solid rgba(239,68,68,0.25);
        }
        .alert-close {
            margin-left: auto; background: none; border: none;
            cursor: pointer; color: inherit; opacity: 0.7; font-size: 14px;
        }
        .alert-close:hover { opacity: 1; }

        @media (max-width: 768px) {
            .main-content { padding: 16px; }
            .page-header { flex-direction: column; gap: 16px; align-items: flex-start; }
            .data-table { display: block; overflow-x: auto; }
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

    <!-- NAVBAR -->
    <nav class="navbar" style="padding-left: 32px;">
        <div class="navbar-left">
            <h1 style="font-size: 18px; color: #0c764a; font-weight: 700; margin: 0;">Quản lý & Duyệt Đặt Bàn</h1>
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
                <h1 class="page-title">Duyệt Đặt Bàn</h1>
                <p class="page-subtitle">Xem, xác nhận hoặc hủy các yêu cầu đặt bàn từ khách hàng</p>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="bida-alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${sessionScope.message}</span>
                <button class="alert-close" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="bida-alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${sessionScope.error}</span>
                <button class="alert-close" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Table Card -->
        <div class="table-card">
            <div class="table-card-header">
                <h3><i class="fas fa-calendar-check" style="color: var(--accent-primary)"></i> Danh Sách Yêu Cầu Đặt Bàn</h3>
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm đơn đặt bàn..." onkeyup="filterTable()">
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty bookings}">
                    <table class="data-table" id="tableMain">
                        <thead>
                            <tr>
                                <th>Mã Đơn</th>
                                <th>Khách Hàng</th>
                                <th>Số Điện Thoại</th>
                                <th>Bàn</th>
                                <th>Ngày Đặt Đơn</th>
                                <th>Thời Gian Chơi</th>
                                <th>Thời Lượng</th>
                                <th>Thanh Toán</th>
                                <th>Trạng Thái</th>
                                <th style="text-align:center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${bookings}">
                                <c:set var="isPayOS" value="${item.paymentType == 'Trả trước'}"/>
                                <c:set var="isPending" value="${item.status == 'Chờ Xác Nhận' || item.status == 'Pending'}"/>
                                <c:set var="isApproved" value="${item.status == 'Đã Xác Nhận' || item.status == 'Approved'}"/>

                                <tr>
                                    <td class="item-id">#BK${item.id}</td>
                                    <td class="item-name">
                                        <div style="font-weight:700;">${item.customerName}</div>
                                        <div style="font-size:11px;color:#6b7280;"><i class="fas fa-phone"></i> ${item.customerPhone}</div>
                                    </td>
                                    <td>${item.customerPhone}</td>
                                    <td class="font-medium text-emerald-800">
                                        <span style="display:inline-block;padding:2px 8px;background:#ecfdf5;color:#047857;border-radius:6px;font-weight:700;">
                                            🎱 ${item.tableName}
                                        </span>
                                    </td>
                                    <td class="item-time text-gray-500">${item.bookingTime}</td>
                                    <td class="item-time font-bold text-amber-900">${item.playTime}</td>
                                    <td>${item.duration} giờ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${isPayOS}">
                                                <span style="display:inline-block;padding:3px 8px;background:#d1fae5;color:#065f46;border-radius:6px;font-weight:800;font-size:11px;">
                                                    💳 PayOS Online
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="display:inline-block;padding:3px 8px;background:#f3f4f6;color:#374151;border-radius:6px;font-weight:600;font-size:11px;">
                                                    💵 Trả Sau Tại Quán
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${isPending}">
                                                <c:choose>
                                                    <c:when test="${isPayOS}">
                                                        <span class="status-badge" style="background:#059669;color:#ffffff;font-weight:800;padding:4px 10px;border-radius:20px;box-shadow:0 2px 5px rgba(5,150,105,0.3);">
                                                            <i class="fas fa-check-circle"></i> Đã Thanh Toán • Chờ Duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending">
                                                            <i class="fas fa-clock"></i> Chờ duyệt (Trả sau)
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${isApproved}">
                                                <span class="status-badge status-approved">
                                                    <i class="fas fa-check-circle"></i> Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-cancelled">
                                                    <i class="fas fa-times-circle"></i> Đã hủy
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-btns" style="justify-content:center">
                                            <c:if test="${isPending}">
                                                <form action="${pageContext.request.contextPath}/admin/duyetdatban" method="POST" style="display:inline">
                                                    <input type="hidden" name="bookingId" value="${item.id}">
                                                    <input type="hidden" name="action" value="approve">
                                                    <button type="submit" class="btn-action btn-approve" onclick="return confirm('Xác nhận duyệt đơn đặt bàn này?')">
                                                        <i class="fas fa-check"></i> Duyệt
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/duyetdatban" method="POST" style="display:inline">
                                                    <input type="hidden" name="bookingId" value="${item.id}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn-action btn-cancel" onclick="return confirm('Bạn có chắc muốn hủy đơn đặt bàn này?')">
                                                        <i class="fas fa-times"></i> Hủy
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h4>Không có đơn đặt bàn nào</h4>
                        <p>Hiện tại không có yêu cầu đặt bàn nào từ phía người dùng.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function filterTable() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('#tableMain tbody tr').forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
            });
        }
        
        // Auto-dismiss alerts
        setTimeout(() => {
            document.querySelectorAll('.bida-alert').forEach(a => {
                a.style.transition = 'opacity 0.4s';
                a.style.opacity = '0';
                setTimeout(() => a.remove(), 400);
            });
        }, 4000);
    </script>

</body>

<!-- =====================================================
     BOOKING NOTIFICATION SYSTEM — SSE Toast (Admin)
     ===================================================== -->
<style>
    #notif-container {
        position: fixed; bottom: 24px; right: 24px;
        display: flex; flex-direction: column-reverse; gap: 12px;
        z-index: 9999; pointer-events: none;
        max-width: 360px;
    }
    .notif-toast {
        pointer-events: all;
        background: #fff;
        border: 1.5px solid #0c764a;
        border-radius: 16px;
        padding: 16px 18px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.18);
        display: flex; gap: 12px; align-items: flex-start;
        animation: toastSlideIn 0.4s cubic-bezier(0.34,1.56,0.64,1) both;
        font-family: 'Inter', sans-serif;
        position: relative; overflow: hidden;
    }
    .notif-toast.hiding { animation: toastSlideOut 0.35s ease-in both; }
    @keyframes toastSlideIn {
        from { opacity:0; transform:translateX(110%) scale(0.9); }
        to   { opacity:1; transform:translateX(0) scale(1); }
    }
    @keyframes toastSlideOut {
        from { opacity:1; transform:translateX(0); }
        to   { opacity:0; transform:translateX(110%); }
    }
    .notif-progress {
        position:absolute; bottom:0; left:0; height:3px;
        background:linear-gradient(90deg,#0c764a,#15a572);
        border-radius:0 0 16px 16px;
        animation:progressShrink 8s linear forwards;
    }
    @keyframes progressShrink { from{width:100%;} to{width:0%;} }
    .notif-bell {
        width:42px; height:42px; border-radius:12px; flex-shrink:0;
        background:rgba(12,118,74,0.08);
        border:1px solid rgba(12,118,74,0.25);
        display:flex; align-items:center; justify-content:center; font-size:20px;
        animation:bellPulse 1.2s ease-in-out 2;
    }
    @keyframes bellPulse {
        0%,100%{transform:rotate(0);}
        15%{transform:rotate(12deg);}
        30%{transform:rotate(-12deg);}
        45%{transform:rotate(8deg);}
        60%{transform:rotate(-8deg);}
    }
    .notif-body { flex:1; min-width:0; }
    .notif-header { font-size:11px; font-weight:700; letter-spacing:0.08em; text-transform:uppercase; color:#0c764a; margin-bottom:4px; }
    .notif-name { font-size:14px; font-weight:700; color:#1e293b; }
    .notif-detail { font-size:12px; color:#475569; margin-top:2px; line-height:1.5; }
    .notif-detail strong { color:#0c764a; }
    .notif-actions { display:flex; gap:7px; margin-top:10px; }
    .notif-btn-view {
        font-size:11.5px; font-weight:600; padding:5px 12px; border-radius:8px;
        background:linear-gradient(135deg,#0c764a,#0a603c); color:#fff;
        border:none; cursor:pointer; text-decoration:none; display:inline-flex; align-items:center; gap:5px;
        transition:filter 0.15s;
    }
    .notif-btn-view:hover { filter:brightness(1.15); }
    .notif-btn-close {
        font-size:11.5px; font-weight:600; padding:5px 10px; border-radius:8px;
        background:rgba(100,116,139,0.12); color:#64748b;
        border:1px solid rgba(100,116,139,0.2); cursor:pointer;
        transition:background 0.15s;
    }
    .notif-btn-close:hover { background:rgba(100,116,139,0.25); }
</style>

<div id="notif-container"></div>

<script>
(function() {
    const ctx = '${pageContext.request.contextPath}';
    let lastSince = 0;
    let pendingCount = 0;
    const container = document.getElementById('notif-container');
    const origTitle = document.title;

    function showToast(data) {
        const toast = document.createElement('div');
        toast.className = 'notif-toast';
        toast.innerHTML =
            '<div class="notif-bell">\uD83D\uDD14</div>' +
            '<div class="notif-body">' +
                '<div class="notif-header">\uD83D\uDCC5 \u0110\u1EB7t B\u00E0n M\u1EDBi</div>' +
                '<div class="notif-name">' + escHtml(data.customerName) + '</div>' +
                '<div class="notif-detail">' +
                    '<strong>' + escHtml(data.tableName) + '</strong> &bull; ' +
                    escHtml(data.playTime) + ' &bull; ' +
                    '<strong>' + data.duration + 'h</strong>' +
                '</div>' +
                '<div class="notif-actions">' +
                    '<a href="' + ctx + '/admin/duyetdatban" class="notif-btn-view">' +
                        '<i class="fas fa-calendar-check"></i> Xem Duy\u1EC7t' +
                    '</a>' +
                    '<button class="notif-btn-close" onclick="dismissToast(this.closest(\'.notif-toast\'))">' +
                        'B\u1ECF qua' +
                    '</button>' +
                '</div>' +
            '</div>' +
            '<div class="notif-progress"></div>';
        container.appendChild(toast);
        setTimeout(() => dismissToast(toast), 8000);
        pendingCount++;
        document.title = '(' + pendingCount + ') ' + origTitle;
    }

    function dismissToast(toast) {
        if (!toast || toast.classList.contains('hiding')) return;
        toast.classList.add('hiding');
        toast.addEventListener('animationend', () => toast.remove(), { once: true });
    }

    function escHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function connectSSE() {
        if (!window.EventSource) return;
        const es = new EventSource(ctx + '/notify/stream?since=' + lastSince);
        es.addEventListener('booking', function(e) {
            try {
                const data = JSON.parse(e.data);
                lastSince = Math.max(lastSince, data.timestamp || 0);
                showToast(data);
            } catch(err) {}
        });
        es.onerror = function() {
            es.close();
            setTimeout(connectSSE, 3000);
        };
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', connectSSE);
    } else {
        connectSSE();
    }
})();
</script>
</html>
