<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu - H.N.D.D Management</title>
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
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; flex-wrap: wrap; gap: 16px; }
        .page-header .page-title { font-size: 28px; font-weight: 800; color: white; }
        .page-header .page-subtitle { font-size: 14px; color: rgba(255,255,255,0.7); margin-top: 4px; }

        /* FILTER BAR */
        .filter-card {
            background: var(--bg-card); border: 1px solid var(--border-color);
            border-radius: var(--radius-lg); padding: 20px 24px; margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 16px; }
        .filter-tab {
            padding: 8px 18px; border-radius: var(--radius-sm); border: 1px solid var(--border-color);
            background: var(--bg-input); color: var(--text-secondary); font-size: 13px; font-weight: 700;
            cursor: pointer; text-decoration: none; transition: all 0.2s;
        }
        .filter-tab:hover { border-color: var(--accent-primary); color: var(--accent-primary); }
        .filter-tab.active { background: var(--accent-gradient); color: white; border-color: transparent; }
        .filter-form { display: flex; align-items: flex-end; gap: 14px; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 6px; }
        .filter-group label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px; color: var(--text-muted); }
        .filter-group select, .filter-group input {
            background: var(--bg-input); border: 1px solid var(--border-color); border-radius: var(--radius-sm);
            padding: 10px 14px; font-size: 13.5px; font-family: inherit; color: var(--text-primary);
        }
        .filter-group select:focus, .filter-group input:focus { outline: none; border-color: var(--border-focus); box-shadow: 0 0 0 3px rgba(12,118,74,0.15); }
        .btn-filter-submit {
            background: var(--accent-gradient); color: white; border: none;
            padding: 11px 22px; border-radius: var(--radius-sm); font-size: 13.5px; font-weight: 700;
            cursor: pointer; transition: all 0.3s; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-filter-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(12,118,74,0.35); }

        /* STATS */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; transition: all 0.3s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-icon { width: 48px; height: 48px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 20px; margin-bottom: 16px; }
        .stat-value { font-size: 26px; font-weight: 800; color: var(--text-primary); }
        .stat-label { font-size: 13px; color: var(--text-secondary); margin-top: 4px; font-weight: 500; }
        .stat-icon.gold { background: rgba(212,175,55,0.15); color: #b89114; }
        .stat-icon.blue { background: var(--info-bg); color: var(--info); }
        .stat-icon.green { background: var(--success-bg); color: var(--success); }

        /* TABLE CARD */
        .table-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); overflow: hidden; box-shadow: var(--shadow-sm); }
        .table-card-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid var(--border-color); flex-wrap: wrap; gap: 12px; }
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
        .item-time { font-family: monospace; font-size: 13px; }
        .item-total { font-weight: 700; color: #b89114; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 48px; color: var(--text-muted); margin-bottom: 16px; }
        .empty-state h4 { font-size: 18px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: var(--text-muted); }

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
            <h1 style="font-size: 18px; color: #0c764a; font-weight: 700; margin: 0;">Doanh Thu &amp; Hóa Đơn</h1>
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
                <h1 class="page-title">Doanh Thu &amp; Hóa Đơn</h1>
                <p class="page-subtitle">Thống kê tổng doanh thu và danh sách hóa đơn đã thanh toán theo ngày / tháng / năm</p>
            </div>
        </div>

        <!-- Filter Card -->
        <div class="filter-card">
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/admin/doanhthu?mode=day"
                   class="filter-tab ${mode == 'day' ? 'active' : ''}">Theo Ngày</a>
                <a href="${pageContext.request.contextPath}/admin/doanhthu?mode=month"
                   class="filter-tab ${mode == 'month' ? 'active' : ''}">Theo Tháng</a>
                <a href="${pageContext.request.contextPath}/admin/doanhthu?mode=year"
                   class="filter-tab ${mode == 'year' ? 'active' : ''}">Theo Năm</a>
            </div>

            <form class="filter-form" action="${pageContext.request.contextPath}/admin/doanhthu" method="get">
                <input type="hidden" name="mode" value="${mode}">

                <c:if test="${mode == 'day'}">
                    <div class="filter-group">
                        <label for="date">Chọn ngày</label>
                        <input type="date" id="date" name="date" value="${selectedDate}">
                    </div>
                </c:if>

                <c:if test="${mode == 'month'}">
                    <div class="filter-group">
                        <label for="month">Tháng</label>
                        <select id="month" name="month">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="year">Năm</label>
                        <input type="number" id="year" name="year" value="${selectedYear}" min="2000" max="2100">
                    </div>
                </c:if>

                <c:if test="${mode == 'year'}">
                    <div class="filter-group">
                        <label for="year">Năm</label>
                        <input type="number" id="year" name="year" value="${selectedYear}" min="2000" max="2100">
                    </div>
                </c:if>

                <button type="submit" class="btn-filter-submit">
                    <i class="fas fa-filter"></i> Xem Thống Kê
                </button>
            </form>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon gold"><i class="fas fa-sack-dollar"></i></div>
                <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,###"/>đ</div>
                <div class="stat-label">Tổng Doanh Thu &bull; ${rangeLabel}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-receipt"></i></div>
                <div class="stat-value">${totalBillCount}</div>
                <div class="stat-label">Tổng Số Hóa Đơn</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-chart-line"></i></div>
                <div class="stat-value"><fmt:formatNumber value="${avgPerBill}" pattern="#,###"/>đ</div>
                <div class="stat-label">Trung Bình / Hóa Đơn</div>
            </div>
        </div>

        <!-- Table Card -->
        <div class="table-card">
            <div class="table-card-header">
                <h3><i class="fas fa-file-invoice-dollar" style="color: var(--accent-primary)"></i> Danh Sách Hóa Đơn (${rangeLabel})</h3>
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm hóa đơn..." onkeyup="filterTable()">
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty bills}">
                    <table class="data-table" id="tableMain">
                        <thead>
                            <tr>
                                <th>Mã Hóa Đơn</th>
                                <th>Bàn</th>
                                <th>Nhân Viên</th>
                                <th>Giờ Mở Bàn</th>
                                <th>Giờ Thanh Toán</th>
                                <th>Tổng Tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${bills}">
                                <tr>
                                    <td class="item-id">#${item.billId}</td>
                                    <td>${item.tableName}</td>
                                    <td>${item.staffName}</td>
                                    <td class="item-time text-gray-500">${item.timeStart}</td>
                                    <td class="item-time text-gray-500">${item.timeEnd}</td>
                                    <td class="item-total"><fmt:formatNumber value="${item.total}" pattern="#,###"/>đ</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-file-invoice"></i>
                        <h4>Không có hóa đơn nào</h4>
                        <p>Không có hóa đơn đã thanh toán trong khoảng thời gian đã chọn.</p>
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
    </script>

</body>
</html>
