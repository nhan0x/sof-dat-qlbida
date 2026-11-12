<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPath = request.getRequestURI();
%>

<!-- BILLIARDS THEME SHARED CSS FOR ADMIN -->
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<script>
    tailwind.config = {
        darkMode: 'class',
        theme: {
            extend: {
                fontFamily: {
                    classic: ['"Playfair Display"', 'serif'],
                    body: ['"Inter"', 'sans-serif'],
                },
            }
        }
    }
</script>

<style>
    *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
    body { font-family: 'Inter', sans-serif; }

    /* ===== BACKGROUND ===== */
    .bg-billiards {
        background-color: #0c2617;
        background-image:
            radial-gradient(circle at 15% 15%, rgba(212,175,55,0.04) 0%, transparent 45%),
            radial-gradient(circle at 85% 85%, rgba(42,122,77,0.08) 0%, transparent 45%),
            url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.06'/%3E%3C/svg%3E");
    }

    /* ===== SIDEBAR ===== */
    .bida-sidebar {
        width: 240px;
        position: fixed; top:0; left:0; bottom:0;
        background: linear-gradient(180deg, #2c1a10 0%, #1e110a 100%);
        border-right: 1px solid rgba(212,175,55,0.15);
        box-shadow: 4px 0 20px rgba(0,0,0,0.5);
        display: flex; flex-direction: column;
        z-index: 40;
    }

    .sidebar-brand {
        display: flex; align-items: center; gap: 12px;
        padding: 20px 20px;
        border-bottom: 1px solid rgba(212,175,55,0.12);
        text-decoration: none;
    }

    .sidebar-brand .brand-text {
        background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-family: 'Playfair Display', serif;
        font-weight: 700;
        font-size: 20px;
        filter: drop-shadow(0 1px 3px rgba(0,0,0,0.5));
    }

    .sidebar-label {
        padding: 16px 20px 6px;
        font-size: 10px; font-weight: 700;
        letter-spacing: 0.15em; text-transform: uppercase;
        color: rgba(212,175,55,0.4);
        font-family: 'Inter', sans-serif;
    }

    .sidebar-link {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 14px;
        margin: 2px 10px;
        border-radius: 10px;
        font-size: 13.5px; font-weight: 500;
        color: rgba(212,175,55,0.55);
        text-decoration: none;
        transition: all 0.2s ease;
        font-family: 'Inter', sans-serif;
    }
    .sidebar-link i {
        width: 18px; text-align: center; font-size: 14px;
        opacity: 0.7; transition: all 0.2s;
    }
    .sidebar-link:hover {
        background: rgba(212,175,55,0.07);
        color: #f9e596;
    }
    .sidebar-link:hover i { opacity: 1; color: #d4af37; }
    .sidebar-link.active {
        background: rgba(212,175,55,0.1);
        color: #f9e596;
        border: 1px solid rgba(212,175,55,0.18);
    }
    .sidebar-link.active i { opacity: 1; color: #d4af37; }

    .sidebar-footer {
        padding: 16px;
        border-top: 1px solid rgba(212,175,55,0.12);
    }

    /* ===== TOP NAVBAR ===== */
    .bida-topnav {
        height: 64px;
        background: linear-gradient(180deg, #3e2723 0%, #2c1a10 100%);
        border-bottom: 1px solid rgba(212,175,55,0.15);
        box-shadow: 0 2px 15px rgba(0,0,0,0.4);
        display: flex; align-items: center; justify-content: space-between;
        padding: 0 28px;
        position: sticky; top:0; z-index:30;
    }

    /* ===== CARDS ===== */
    .bida-card {
        background: linear-gradient(145deg, rgba(20,55,35,0.85) 0%, rgba(6,18,11,0.95) 100%);
        border: 1px solid rgba(212,175,55,0.12);
        box-shadow: 0 8px 25px rgba(0,0,0,0.35);
        border-radius: 16px;
    }
    .bida-card:hover {
        border-color: rgba(212,175,55,0.25);
    }

    /* ===== TABLE ===== */
    .bida-table { width: 100%; border-collapse: collapse; }
    .bida-table thead th {
        background: linear-gradient(180deg, #2c1a10, #1e110a);
        color: #d4af37;
        font-size: 11px; letter-spacing: 0.1em;
        text-transform: uppercase; padding: 14px 18px;
        border-bottom: 1px solid rgba(212,175,55,0.2);
        font-weight: 600; white-space: nowrap;
    }
    .bida-table tbody td {
        padding: 13px 18px;
        border-bottom: 1px solid rgba(212,175,55,0.06);
        font-size: 13.5px; color: #d1d5db; vertical-align: middle;
    }
    .bida-table tbody tr { transition: background 0.2s; }
    .bida-table tbody tr:hover { background: rgba(212,175,55,0.04); }
    .bida-table tbody tr:last-child td { border-bottom: none; }

    /* ===== STATUS BADGES ===== */
    .badge {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 4px 10px; border-radius: 20px;
        font-size: 11.5px; font-weight: 600;
    }
    .badge-green { background: rgba(34,197,94,0.1); border:1px solid rgba(34,197,94,0.25); color:#86efac; }
    .badge-yellow { background: rgba(234,179,8,0.1); border:1px solid rgba(234,179,8,0.25); color:#fde047; }
    .badge-red { background: rgba(239,68,68,0.1); border:1px solid rgba(239,68,68,0.25); color:#f87171; }
    .badge-blue { background: rgba(59,130,246,0.1); border:1px solid rgba(59,130,246,0.25); color:#93c5fd; }
    .badge-gold { background: rgba(212,175,55,0.1); border:1px solid rgba(212,175,55,0.25); color:#d4af37; }
    .badge-dot { width:6px; height:6px; border-radius:50%; background:currentColor; }

    /* ===== ACTION BUTTONS ===== */
    .btn-icon {
        width: 34px; height: 34px; border: none; border-radius: 8px;
        display: inline-flex; align-items: center; justify-content: center;
        font-size: 13px; cursor: pointer; transition: all 0.25s; text-decoration: none;
    }
    .btn-edit { background: rgba(59,130,246,0.12); border:1px solid rgba(59,130,246,0.2); color:#93c5fd; }
    .btn-edit:hover { background: #3b82f6; color:white; transform:translateY(-2px); }
    .btn-del { background: rgba(239,68,68,0.12); border:1px solid rgba(239,68,68,0.2); color:#f87171; }
    .btn-del:hover { background: #ef4444; color:white; transform:translateY(-2px); }
    .btn-view { background: rgba(212,175,55,0.12); border:1px solid rgba(212,175,55,0.2); color:#d4af37; }
    .btn-view:hover { background: rgba(212,175,55,0.25); transform:translateY(-2px); }

    /* ===== GOLD BUTTON ===== */
    .btn-gold {
        background: linear-gradient(180deg,#d4af37,#aa8511);
        color: #1e110a; border: 1px solid #8a6a09;
        padding: 10px 20px; border-radius: 10px;
        font-weight: 700; font-size: 13.5px; cursor: pointer;
        display: inline-flex; align-items: center; gap: 8px;
        text-decoration: none; transition: all 0.2s;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        font-family: 'Inter', sans-serif;
    }
    .btn-gold:hover { background: linear-gradient(180deg,#f9e596,#d4af37); transform:translateY(-1px); }

    /* ===== SEARCH BOX ===== */
    .bida-search {
        position: relative;
    }
    .bida-search input {
        background: rgba(0,0,0,0.3);
        border: 1px solid rgba(212,175,55,0.18);
        border-radius: 10px; padding: 9px 14px 9px 36px;
        color: #f9e596; font-size: 13px;
        font-family: 'Inter', sans-serif;
        width: 240px; transition: all 0.3s; outline: none;
    }
    .bida-search input::placeholder { color: rgba(212,175,55,0.4); }
    .bida-search input:focus { border-color: rgba(212,175,55,0.5); box-shadow: 0 0 0 3px rgba(212,175,55,0.08); }
    .bida-search i {
        position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
        color: rgba(212,175,55,0.4); font-size: 13px;
    }

    /* ===== MODAL ===== */
    .bida-modal-overlay {
        display: none; position: fixed; inset:0;
        background: rgba(0,0,0,0.7); backdrop-filter: blur(8px);
        z-index: 1000; align-items: center; justify-content: center;
        animation: fadeIn 0.2s ease;
    }
    .bida-modal-overlay.active { display: flex; }
    @keyframes fadeIn { from{opacity:0} to{opacity:1} }

    .bida-modal {
        background: linear-gradient(145deg, #1a3a25, #0c1f14);
        border: 1px solid rgba(212,175,55,0.2);
        border-radius: 20px;
        width: 100%; max-width: 520px; max-height: 90vh; overflow-y: auto;
        box-shadow: 0 25px 60px rgba(0,0,0,0.7);
        animation: slideUp 0.3s ease;
    }
    @keyframes slideUp { from{opacity:0;transform:translateY(24px) scale(0.97)} to{opacity:1;transform:translateY(0) scale(1)} }

    .modal-header {
        display: flex; align-items: center; justify-content: space-between;
        padding: 22px 26px 16px;
        border-bottom: 1px solid rgba(212,175,55,0.12);
    }
    .modal-header h3 {
        font-size: 18px; font-weight: 700;
        color: #f9e596; font-family: 'Playfair Display', serif;
        display: flex; align-items: center; gap: 10px;
    }
    .modal-header h3 i { color: #d4af37; }
    .modal-close {
        width: 34px; height: 34px; border-radius: 8px; cursor: pointer;
        background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.2); color: #f87171;
        display: flex; align-items: center; justify-content: center; font-size: 16px; transition: all 0.2s;
    }
    .modal-close:hover { background: #ef4444; color: white; }

    .modal-body { padding: 22px 26px; }

    .modal-form-group { margin-bottom: 18px; }
    .modal-label {
        display: block; font-size: 11px; font-weight: 600;
        letter-spacing: 0.1em; text-transform: uppercase;
        color: rgba(212,175,55,0.7); margin-bottom: 7px;
        font-family: 'Inter', sans-serif;
    }
    .modal-input {
        width: 100%; padding: 11px 14px;
        background: rgba(0,0,0,0.3);
        border: 1px solid rgba(212,175,55,0.18);
        border-radius: 10px; color: #f9e596;
        font-size: 13.5px; font-family: 'Inter', sans-serif;
        transition: all 0.3s; outline: none;
    }
    .modal-input::placeholder { color: rgba(212,175,55,0.3); }
    .modal-input:focus { border-color: rgba(212,175,55,0.5); box-shadow: 0 0 0 3px rgba(212,175,55,0.08); }
    select.modal-input {
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23d4af37' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat; background-position: right 12px center; padding-right: 32px;
    }
    select.modal-input option { background: #1a3a25; }

    .modal-footer {
        display: flex; gap: 10px; justify-content: flex-end;
        padding: 14px 26px 22px;
        border-top: 1px solid rgba(212,175,55,0.1);
    }
    .btn-modal-cancel {
        padding: 10px 20px; border-radius: 9px;
        background: rgba(100,116,139,0.15);
        border: 1px solid rgba(100,116,139,0.25);
        color: #94a3b8; font-size: 13.5px; font-weight: 600;
        cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
        display: inline-flex; align-items: center; gap: 7px;
    }
    .btn-modal-cancel:hover { background: rgba(100,116,139,0.25); color: #cbd5e1; }
    .btn-modal-submit {
        padding: 10px 22px; border-radius: 9px;
        background: linear-gradient(180deg,#d4af37,#aa8511);
        border: 1px solid #8a6a09;
        color: #1e110a; font-size: 13.5px; font-weight: 700;
        cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
        display: inline-flex; align-items: center; gap: 7px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }
    .btn-modal-submit:hover { background: linear-gradient(180deg,#f9e596,#d4af37); transform:translateY(-1px); }
    .btn-modal-danger {
        padding: 10px 22px; border-radius: 9px;
        background: rgba(239,68,68,0.15);
        border: 1px solid rgba(239,68,68,0.3);
        color: #f87171; font-size: 13.5px; font-weight: 700;
        cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
        display: inline-flex; align-items: center; gap: 7px;
    }
    .btn-modal-danger:hover { background: #ef4444; color:white; }

    /* ===== ALERTS ===== */
    .bida-alert {
        display: flex; align-items: center; gap: 12px;
        padding: 13px 18px; border-radius: 12px; margin-bottom: 20px;
        font-size: 13.5px; font-weight: 500; animation: slideDown 0.3s ease;
        font-family: 'Inter', sans-serif;
    }
    @keyframes slideDown { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }
    .alert-success { background: rgba(34,197,94,0.1); border:1px solid rgba(34,197,94,0.25); color:#86efac; }
    .alert-danger  { background: rgba(239,68,68,0.1); border:1px solid rgba(239,68,68,0.25); color:#f87171; }
    .alert-close { margin-left:auto; background:none; border:none; color:inherit; font-size:17px; cursor:pointer; opacity:0.7; }
    .alert-close:hover { opacity:1; }

    /* ===== AVATAR ===== */
    .gold-avatar-ring { background:linear-gradient(135deg,#d4af37,#997a15); padding:2px; border-radius:50%; }
    .gold-avatar { background:#1a4a2e; border-radius:50%; width:34px; height:34px; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px; color:#d4af37; }

    /* ===== EMPTY STATE ===== */
    .bida-empty { text-align:center; padding:60px 20px; }
    .bida-empty .empty-icon { font-size:48px; opacity:0.3; margin-bottom:16px; }
    .bida-empty h4 { font-family:'Playfair Display',serif; font-size:18px; color:rgba(249,229,150,0.5); margin-bottom:8px; }
    .bida-empty p { font-size:13px; color:#4b5563; }

    /* ===== PAGE CONTENT WITH SIDEBAR ===== */
    .with-sidebar { padding-left: 240px; }

    /* ===== GOLD TEXT ===== */
    .gold-text {
        background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
        -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        filter: drop-shadow(0 1px 3px rgba(0,0,0,0.4));
    }

    /* ===== SCROLLBAR ===== */
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: rgba(0,0,0,0.1); }
    ::-webkit-scrollbar-thumb { background: rgba(212,175,55,0.25); border-radius: 3px; }
    ::-webkit-scrollbar-thumb:hover { background: rgba(212,175,55,0.45); }

    @media (max-width: 992px) {
        .bida-sidebar { transform: translateX(-100%); }
        .with-sidebar { padding-left: 0; }
    }
</style>

<!-- ===== SIDEBAR HTML ===== -->
<aside class="bida-sidebar" id="sidebar">
    <a href="${pageContext.request.contextPath}/admin/quanli.jsp" class="sidebar-brand">
        <span style="font-size:22px;">🎱</span>
        <span class="brand-text">H.N.D.D</span>
    </a>

    <nav style="flex:1; padding: 8px 0; overflow-y:auto;">
        <div class="sidebar-label">Chính</div>
        <a href="${pageContext.request.contextPath}/admin/quanli.jsp"
           class="sidebar-link <%= currentPath.contains("quanli.jsp") && !currentPath.contains("quanliAccount") && !currentPath.contains("quanliTable") && !currentPath.contains("quanlico") && !currentPath.contains("quanliloaiban") ? "active" : "" %>">
            <i class="fas fa-gauge-high"></i> Bảng Điều Khiển
        </a>

        <div class="sidebar-label">Quản Lý</div>
        <a href="${pageContext.request.contextPath}/admin/quanliTableBida"
           class="sidebar-link <%= currentPath.contains("quanliTableBida") ? "active" : "" %>">
            <i class="fas fa-table-cells-large"></i> Bàn Bida
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanliloaiban"
           class="sidebar-link <%= currentPath.contains("quanliloaiban") || currentPath.contains("TableType") ? "active" : "" %>">
            <i class="fas fa-layer-group"></i> Loại Bàn
        </a>
        <a href="${pageContext.request.contextPath}/admin/camera"
           class="sidebar-link <%= currentPath.contains("/admin/camera") || currentPath.contains("xemCamera") ? "active" : "" %>">
            <i class="fas fa-video"></i> Camera
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanlico"
           class="sidebar-link <%= currentPath.contains("quanlico") ? "active" : "" %>">
            <i class="fas fa-wand-magic-sparkles"></i> Cơ Bida
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanlidichvu"
           class="sidebar-link <%= currentPath.contains("quanlidichvu") ? "active" : "" %>">
            <i class="fas fa-concierge-bell"></i> Dịch Vụ
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanlidanhmuc"
           class="sidebar-link <%= currentPath.contains("quanlidanhmuc") ? "active" : "" %>">
            <i class="fas fa-list"></i> Danh Mục Dịch Vụ
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanliAccount"
           class="sidebar-link <%= currentPath.contains("quanliAccount") ? "active" : "" %>">
            <i class="fas fa-users-cog"></i> Tài Khoản
        </a>

        <div class="sidebar-label">Thành Viên</div>
        <a href="${pageContext.request.contextPath}/admin/quanlithanhvien"
           class="sidebar-link <%= currentPath.contains("quanlithanhvien") ? "active" : "" %>">
            <i class="fas fa-id-card"></i> Thành Viên
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanlilocker"
           class="sidebar-link <%= currentPath.contains("quanlilocker") ? "active" : "" %>">
            <i class="fas fa-key"></i> Tủ Đựng Cơ
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanliqr"
           class="sidebar-link <%= currentPath.contains("quanliqr") ? "active" : "" %>">
            <i class="fas fa-qrcode"></i> Mã QR Bàn
        </a>

        <div class="sidebar-label">Vận Hành</div>
        <a href="${pageContext.request.contextPath}/admin/doanhthu"
           class="sidebar-link <%= currentPath.contains("doanhthu") ? "active" : "" %>">
            <i class="fas fa-sack-dollar"></i> Doanh Thu
        </a>
        <a href="${pageContext.request.contextPath}/admin/quanlihoadon"
           class="sidebar-link <%= currentPath.contains("quanlihoadon") ? "active" : "" %>">
            <i class="fas fa-file-invoice-dollar"></i> Hóa Đơn
        </a>
        <a href="${pageContext.request.contextPath}/admin/duyetdatban"
           id="sidebar-booking-link"
           class="sidebar-link <%= currentPath.contains("duyetdatban") ? "active" : "" %>">
            <i class="fas fa-calendar-check"></i>
            <span style="flex:1;">Duyệt Đặt Bàn</span>
            <span id="sidebar-booking-badge" style="display:none; background:#ef4444; color:#fff; font-size:10px; font-weight:800; min-width:17px; height:17px; border-radius:9px; padding:0 4px; display:none; align-items:center; justify-content:center;"></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/lichdatbanhomnay"
           class="sidebar-link <%= currentPath.contains("lichdatbanhomnay") ? "active" : "" %>">
            <i class="fas fa-calendar-day"></i> Lịch Đặt Bàn Hôm Nay
        </a>
        <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
           class="sidebar-link <%= currentPath.contains("trangchunhanvien") ? "active" : "" %>">
            <i class="fas fa-cash-register"></i> Mở Ca / Tính Tiền Bàn
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
           class="sidebar-link" style="color:rgba(248,113,113,0.65); margin:0;">
            <i class="fas fa-right-from-bracket"></i> Đăng Xuất
        </a>
    </div>
</aside>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.body.classList.add('with-sidebar');
        document.body.classList.add('bg-billiards');
    });

    // Called by the SSE notification script on each admin page
    // to update the sidebar badge count.
    window.updateSidebarBadge = function(count) {
        const badge = document.getElementById('sidebar-booking-badge');
        if (!badge) return;
        if (count > 0) {
            badge.textContent = count > 9 ? '9+' : count;
            badge.style.display = 'inline-flex';
        } else {
            badge.style.display = 'none';
        }
    };

    // Global SSE listener for Admin: Real-time alert when staff deletes a bill
    (function initAdminRealtimeSSENotifier() {
        let lastSince = Date.now();
        function connectSSE() {
            const ctx = '${pageContext.request.contextPath}';
            const es = new EventSource(ctx + '/notify/stream?since=' + lastSince);

            es.addEventListener('bill_deleted', function(e) {
                try {
                    const data = JSON.parse(e.data);
                    lastSince = Math.max(lastSince, data.timestamp || 0);
                    showAdminBillDeletedToast(data);
                } catch(err) {}
            });

            es.onerror = function() {
                es.close();
                setTimeout(connectSSE, 5000);
            };
        }

        function showAdminBillDeletedToast(data) {
            let toast = document.createElement('div');
            toast.style.cssText = 'position:fixed; top:20px; right:20px; z-index:99999; background:linear-gradient(135deg, #450a0a, #7f1d1d); border:2px solid #ef4444; color:white; padding:16px 20px; border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,0.8); font-family:sans-serif; min-width:320px; animation: slideDown 0.3s ease;';
            toast.innerHTML = `
                <div style="font-weight:800; font-size:14px; color:#fca5a5; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid rgba(255,255,255,0.15); padding-bottom:6px; margin-bottom:8px;">
                    <span>🚨 CẢNH BÁO: HÓA ĐƠN ĐÃ BỊ XÓA!</span>
                    <button onclick="this.parentElement.parentElement.remove()" style="background:none; border:none; color:white; font-size:16px; cursor:pointer;">✕</button>
                </div>
                <div style="font-size:13px; margin-top:4px;">
                    Nhân viên <strong style="color:#f9e596;">\${data.staffName}</strong> vừa xóa hóa đơn <strong style="color:#86efac;">#\${data.billId}</strong> (\${data.tableName}).
                </div>
                <div style="font-size:12px; color:#fde047; margin-top:4px; font-weight:600;">
                    💰 Tổng tiền: \${data.total ? Number(data.total).toLocaleString('vi-VN') : 0}đ
                </div>
            `;
            document.body.appendChild(toast);
            setTimeout(() => { if (toast.parentNode) toast.remove(); }, 12000);
        }

        if (window.EventSource) {
            connectSSE();
        }
    })();
</script>