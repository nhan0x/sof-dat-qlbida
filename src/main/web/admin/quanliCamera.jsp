<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Camera - H.N.D.D Management</title>
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
            --info: #3b82f6;
            --info-bg: rgba(59, 130, 246, 0.15);
            --purple: #8b5cf6;
            --purple-bg: rgba(139, 92, 246, 0.15);
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

        /* STATS */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; transition: all 0.3s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-icon { width: 48px; height: 48px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 20px; margin-bottom: 16px; }
        .stat-value { font-size: 28px; font-weight: 800; color: var(--text-primary); }
        .stat-label { font-size: 13px; color: var(--text-secondary); margin-top: 4px; font-weight: 500; }
        .stat-icon.purple { background: var(--purple-bg); color: var(--purple); }
        .stat-icon.green { background: var(--success-bg); color: var(--success); }
        .stat-icon.red { background: var(--danger-bg); color: var(--danger); }

        /* ALERT */
        .alert { padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; }
        .alert-danger { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.3); }
        .close-alert { margin-left: auto; background: none; border: none; color: inherit; font-size: 18px; cursor: pointer; opacity: 0.7; }
        .close-alert:hover { opacity: 1; }

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
        .mono { font-family: 'Courier New', monospace; font-size: 13px; }

        .status-badge { display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-badge.configured { background: var(--success-bg); color: var(--success); }
        .status-badge.not-configured { background: rgba(100,116,139,0.15); color: #64748b; }
        .status-badge .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        .action-btns { display: flex; gap: 8px; justify-content: center; }
        .btn-action { width: 36px; height: 36px; border: none; border-radius: var(--radius-sm); display: inline-flex; align-items: center; justify-content: center; font-size: 14px; cursor: pointer; transition: all 0.3s; text-decoration: none; }
        .btn-view { background: var(--purple-bg); color: var(--purple); border: 1px solid rgba(139,92,246,0.25); }
        .btn-view:hover { background: var(--purple); color: white; transform: translateY(-2px); }
        .btn-view.disabled { opacity: 0.4; cursor: not-allowed; pointer-events: none; }
        .btn-edit { background: var(--info-bg); color: var(--info); border: 1px solid rgba(59,130,246,0.2); text-decoration: none; }
        .btn-edit:hover { background: var(--info); color: white; transform: translateY(-2px); }

        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 48px; color: var(--text-muted); margin-bottom: 16px; }
        .empty-state h4 { font-size: 18px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: var(--text-muted); }

        @media (max-width: 768px) {
            .main-content { padding: 16px; }
            .page-header { flex-direction: column; gap: 16px; align-items: flex-start; }
            .stats-grid { grid-template-columns: 1fr; }
            .data-table { display: block; overflow-x: auto; }
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

    <!-- NAVBAR -->
    <nav class="navbar" style="padding-left: 32px;">
        <div class="navbar-left">
            <h1 style="font-size: 18px; color: #0c764a; font-weight: 700; margin: 0;">Quản lý Camera</h1>
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

        <div class="page-header">
            <div>
                <h1 class="page-title">Quản Lý Camera</h1>
                <p class="page-subtitle">Danh sách camera giám sát gắn theo từng bàn bida</p>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-video"></i></div>
                <div class="stat-value" id="statTotal">0</div>
                <div class="stat-label">Tổng số bàn</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                <div class="stat-value" id="statConfigured">0</div>
                <div class="stat-label">Camera đã cấu hình</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon red"><i class="fas fa-exclamation-circle"></i></div>
                <div class="stat-value" id="statNotConfigured">0</div>
                <div class="stat-label">Chưa cấu hình camera</div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
                <button class="close-alert" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
            </div>
        </c:if>

        <div class="table-card">
            <div class="table-card-header">
                <h3><i class="fas fa-video" style="color: var(--accent-primary)"></i> Danh Sách Camera Theo Bàn</h3>
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm bàn..." onkeyup="filterTable()">
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty tableList}">
                    <table class="data-table" id="tableMain">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Bàn</th>
                                <th>Loại Bàn</th>
                                <th>Địa Chỉ IP</th>
                                <th>Port</th>
                                <th>Trạng Thái</th>
                                <th style="text-align:center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tableList}" varStatus="status">
                                <tr data-configured="${t.cameraConfigured}">
                                    <td class="item-id">${status.index + 1}</td>
                                    <td class="item-name">${t.name}</td>
                                    <td>${t.tableTypeName}</td>
                                    <td class="mono">
                                        <c:choose>
                                            <c:when test="${t.cameraConfigured}">${t.cameraIp}</c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">--</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="mono">
                                        <c:choose>
                                            <c:when test="${t.cameraConfigured}">${t.cameraPort}</c:when>
                                            <c:otherwise><span style="color:var(--text-muted)">--</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.cameraConfigured}">
                                                <span class="status-badge configured"><span class="dot"></span>Đã cấu hình</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge not-configured"><span class="dot"></span>Chưa cấu hình</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="${pageContext.request.contextPath}/admin/camera?action=view&id=${t.id}"
                                               class="btn-action btn-view" title="Xem Camera">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/quanliTableBida?action=edit&id=${t.id}"
                                               class="btn-action btn-edit" title="Cấu hình Camera">
                                                <i class="fas fa-cog"></i>
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
                        <h4>Chưa có bàn nào</h4>
                        <p>Vào "Quản Lý Bàn Bida" để thêm bàn và cấu hình camera.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('#tableMain tbody tr');
            let total = rows.length, configured = 0;
            rows.forEach(row => {
                if (row.getAttribute('data-configured') === 'true') configured++;
            });
            animateCount('statTotal', total);
            animateCount('statConfigured', configured);
            animateCount('statNotConfigured', total - configured);
        });

        function animateCount(id, target) {
            const el = document.getElementById(id);
            if (!el) return;
            let current = 0;
            if (target === 0) { el.textContent = '0'; return; }
            const step = Math.max(Math.ceil(target / 20), 1);
            const timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                el.textContent = current.toString();
            }, 40);
        }

        function filterTable() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            let stt = 1;
            document.querySelectorAll('#tableMain tbody tr').forEach(row => {
                const matches = row.textContent.toLowerCase().includes(query);
                if (matches) {
                    row.style.display = '';
                    const idCell = row.querySelector('.item-id');
                    if (idCell) idCell.textContent = stt++;
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>

</body>
</html>
