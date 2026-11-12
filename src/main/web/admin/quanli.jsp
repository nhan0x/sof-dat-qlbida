<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.daos.TableBidaDAOImpl" %>
<%@ page import="org.example.daos.CueDAOImpl" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    int totalTables = 0; int totalCues = 0;
    try {
        totalTables = new TableBidaDAOImpl().getAll().size();
        totalCues   = new CueDAOImpl().getAll().size();
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Bảng Điều Khiển Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        classic: ['"Playfair Display"', 'serif'],
                        body:    ['"Inter"', 'sans-serif'],
                    },
                    colors: {
                        felt: { light: '#2a7a4d', dark: '#0f3622' },
                        wood: { light: '#6d4c41', base: '#3e2723', dark: '#1e110a' },
                        gold: { light: '#f9e596', base: '#d4af37', dark: '#997a15' }
                    },
                    animation: {
                        'roll':    'roll 0.8s cubic-bezier(0.25, 1, 0.5, 1) forwards',
                        'count-up': 'countup 1.2s ease-out forwards',
                    },
                    keyframes: {
                        roll: {
                            '0%':   { transform: 'rotate(0deg)' },
                            '100%': { transform: 'rotate(360deg)' }
                        },
                    }
                }
            }
        }
    </script>

    <style>
        body { font-family: 'Inter', sans-serif; }

        /* Billiards felt background */
        .bg-billiards-felt {
            background-color: #0c2617;
            background-image:
                radial-gradient(circle at 15% 15%, rgba(212,175,55,0.05) 0%, transparent 45%),
                radial-gradient(circle at 85% 85%, rgba(42,122,77,0.10) 0%, transparent 45%),
                url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.07'/%3E%3C/svg%3E");
        }

        /* Sidebar */
        .wood-sidebar {
            background: linear-gradient(180deg, #2c1a10 0%, #1e110a 100%);
            border-right: 1px solid rgba(212,175,55,0.2);
            box-shadow: 4px 0 20px rgba(0,0,0,0.5);
        }

        /* Top navbar */
        .wood-navbar {
            background: linear-gradient(180deg, #3e2723 0%, #2c1a10 100%);
            border-bottom: 1px solid rgba(212,175,55,0.2);
            box-shadow: 0 2px 15px rgba(0,0,0,0.5);
        }

        .gold-text-emboss {
            background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 1px 3px rgba(0,0,0,0.5));
        }

        /* Sidebar menu item */
        .menu-link {
            display: flex; align-items: center; gap: 12px;
            padding: 11px 16px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            color: rgba(212,175,55,0.6);
            text-decoration: none;
            transition: all 0.2s ease;
            margin: 3px 10px;
        }
        .menu-link:hover {
            background: rgba(212,175,55,0.08);
            color: #f9e596;
        }
        .menu-link.active {
            background: rgba(212,175,55,0.12);
            color: #f9e596;
            border: 1px solid rgba(212,175,55,0.2);
        }
        .menu-link i {
            width: 18px; text-align: center;
            font-size: 15px;
            opacity: 0.7;
            transition: all 0.2s;
        }
        .menu-link.active i, .menu-link:hover i { opacity: 1; color: #d4af37; }

        /* Stat cards */
        .stat-card {
            background: linear-gradient(145deg, rgba(20,55,35,0.85) 0%, rgba(6,18,11,0.95) 100%);
            border: 1px solid rgba(212,175,55,0.12);
            box-shadow: 0 8px 25px rgba(0,0,0,0.35);
            transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative; overflow: hidden;
        }
        .stat-card::after {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent-color, #d4af37), transparent);
        }
        .stat-card:hover {
            transform: translateY(-6px);
            border-color: rgba(212,175,55,0.3);
            box-shadow: 0 15px 40px rgba(0,0,0,0.5), 0 0 20px rgba(212,175,55,0.08);
        }

        /* Action buttons */
        .action-btn {
            background: linear-gradient(145deg, rgba(20,55,35,0.85) 0%, rgba(6,18,11,0.95) 100%);
            border: 1px solid rgba(212,175,55,0.15);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            position: relative; overflow: hidden;
        }
        .action-btn::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(circle at 50% 0%, rgba(212,175,55,0.08) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.3s;
        }
        .action-btn:hover {
            transform: translateY(-4px);
            border-color: rgba(212,175,55,0.35);
            box-shadow: 0 12px 35px rgba(0,0,0,0.5);
        }
        .action-btn:hover::before { opacity: 1; }

        /* Avatar ring */
        .avatar-ring {
            background: linear-gradient(135deg, #d4af37, #997a15);
            padding: 2px; border-radius: 50%;
        }
        .avatar-inner {
            background: #1a4a2e; border-radius: 50%;
            width: 34px; height: 34px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 13px; color: #d4af37;
        }

        .pocket-dot {
            width: 8px; height: 8px; border-radius: 50%;
            background: radial-gradient(circle at 35% 35%, #3a3a3a, #111);
            box-shadow: inset 0 1px 2px rgba(255,255,255,0.1);
        }

        .divider-gold {
            width: 50px; height: 1px;
            background: linear-gradient(90deg, transparent, #d4af37, transparent);
        }
    </style>
</head>

<body class="bg-billiards-felt min-h-screen flex">

<!-- SIDEBAR -->
<%@ include file="sidebar.jsp" %>

<!-- MAIN CONTENT AREA -->
<div class="flex-1 flex flex-col min-h-screen">

    <!-- TOP NAVBAR -->
    <nav class="wood-navbar h-16 flex items-center justify-between px-8 sticky top-0 z-30">
        <div class="flex items-center gap-2">
            <div class="pocket-dot"></div>
            <h1 class="font-classic text-lg text-gold-light/90 ml-2">Bảng Điều Khiển Quản Trị</h1>
        </div>

        <div class="flex items-center gap-3">
            <div class="text-right hidden sm:block">
                <div class="text-sm font-semibold text-gold-light font-body">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}</c:when>
                        <c:otherwise>Administrator</c:otherwise>
                    </c:choose>
                </div>
                <div class="text-[10px] text-gold-base/60 uppercase tracking-widest">Administrator</div>
            </div>
            <div class="avatar-ring">
                <div class="avatar-inner">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                        <c:otherwise>A</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
               class="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium text-red-400/70 border border-red-800/30 hover:bg-red-900/15 hover:text-red-400 transition-all">
                <i class="fas fa-right-from-bracket text-xs"></i>
                <span class="hidden md:inline">Đăng xuất</span>
            </a>
        </div>
    </nav>

    <!-- PAGE CONTENT -->
    <main class="flex-1 p-8">

        <!-- Welcome Header -->
        <div class="mb-8">
            <div class="font-classic text-xs tracking-[0.25em] text-gold-base/50 uppercase mb-1">Xin chào,</div>
            <h2 class="font-classic text-3xl font-bold text-white">
                Chào Mừng Đến Với
                <span class="gold-text-emboss">BIDA PRO</span>
            </h2>
            <div class="divider-gold mt-3"></div>
            <p class="font-body text-sm text-gray-400 mt-3 max-w-lg">
                Hệ thống quản lý Câu lạc bộ Bida chuyên nghiệp — Nhanh chóng, Tiện lợi, Hiệu quả.
            </p>
        </div>

        <!-- STAT CARDS ROW -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-8">
            <!-- Total Tables -->
            <div class="stat-card rounded-2xl p-6 flex items-center gap-5" style="--accent-color: #22c55e;">
                <div class="w-14 h-14 rounded-xl bg-green-900/30 border border-green-700/30 flex items-center justify-center text-green-400 text-2xl flex-shrink-0">
                    <i class="fas fa-table-cells-large"></i>
                </div>
                <div>
                    <div class="font-body text-xs text-gray-400 uppercase tracking-widest mb-1">Tổng số Bàn</div>
                    <div class="font-classic text-4xl font-bold text-white"><%= totalTables %></div>
                </div>
            </div>

            <!-- Total Cues -->
            <div class="stat-card rounded-2xl p-6 flex items-center gap-5" style="--accent-color: #3b82f6;">
                <div class="w-14 h-14 rounded-xl bg-blue-900/30 border border-blue-700/30 flex items-center justify-center text-blue-400 text-2xl flex-shrink-0">
                    <i class="fas fa-wand-magic-sparkles"></i>
                </div>
                <div>
                    <div class="font-body text-xs text-gray-400 uppercase tracking-widest mb-1">Tổng số Cơ</div>
                    <div class="font-classic text-4xl font-bold text-white"><%= totalCues %></div>
                </div>
            </div>

            <!-- Total Accounts -->
            <a href="${pageContext.request.contextPath}/admin/quanliAccount"
               class="stat-card rounded-2xl p-6 flex items-center gap-5 hover:no-underline" style="--accent-color: #d4af37;">
                <div class="w-14 h-14 rounded-xl bg-gold-dark/20 border border-gold-dark/30 flex items-center justify-center text-gold-base text-2xl flex-shrink-0">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <div class="font-body text-xs text-gray-400 uppercase tracking-widest mb-1">Tài Khoản</div>
                    <div class="font-classic text-4xl font-bold text-white">—</div>
                </div>
            </a>
        </div>

        <!-- QUICK ACTIONS SECTION -->
        <div class="mb-4">
            <div class="font-classic text-xs tracking-[0.2em] text-gold-base/50 uppercase mb-2">Thao tác nhanh</div>
            <h3 class="font-classic text-xl text-white font-semibold">Quản Lý Hệ Thống</h3>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Mở Ca / Tính Tiền Bàn -->
            <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-amber-900/30 border border-amber-700/30
                            flex items-center justify-center text-amber-400 text-2xl
                            group-hover:scale-110 group-hover:bg-amber-800/40 transition-all duration-300">
                    <i class="fas fa-cash-register"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Mở Ca / Tính Tiền Bàn</div>
                    <div class="font-body text-xs text-gray-500">Mở ca, gọi dịch vụ, thanh toán bàn</div>
                </div>
            </a>

            <!-- Quản lý Dịch Vụ -->
            <a href="${pageContext.request.contextPath}/admin/quanlidichvu"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-teal-900/30 border border-teal-700/30
                            flex items-center justify-center text-teal-400 text-2xl
                            group-hover:scale-110 group-hover:bg-teal-800/40 transition-all duration-300">
                    <i class="fas fa-concierge-bell"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Quản Lý Dịch Vụ</div>
                    <div class="font-body text-xs text-gray-500">Đồ uống, món ăn của quán</div>
                </div>
            </a>

            <!-- Quản lý Bàn -->
            <a href="${pageContext.request.contextPath}/admin/quanliTableBida"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-green-900/30 border border-green-700/30
                            flex items-center justify-center text-green-400 text-2xl
                            group-hover:scale-110 group-hover:bg-green-800/40 transition-all duration-300">
                    <i class="fas fa-table-cells-large"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Quản Lý Bàn</div>
                    <div class="font-body text-xs text-gray-500">Thêm, sửa, xoá bàn bida</div>
                </div>
            </a>

            <!-- Quản lý Loại Bàn -->
            <a href="${pageContext.request.contextPath}/admin/quanliloaiban"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-blue-900/30 border border-blue-700/30
                            flex items-center justify-center text-blue-400 text-2xl
                            group-hover:scale-110 group-hover:bg-blue-800/40 transition-all duration-300">
                    <i class="fas fa-layer-group"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Phân Loại Bàn</div>
                    <div class="font-body text-xs text-gray-500">VIP, Pool, Carom…</div>
                </div>
            </a>

            <!-- Quản lý Cơ -->
            <a href="${pageContext.request.contextPath}/admin/quanlico"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-purple-900/30 border border-purple-700/30
                            flex items-center justify-center text-purple-400 text-2xl
                            group-hover:scale-110 group-hover:bg-purple-800/40 transition-all duration-300">
                    <i class="fas fa-wand-magic-sparkles"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Quản Lý Cơ</div>
                    <div class="font-body text-xs text-gray-500">Cơ bida & phụ kiện</div>
                </div>
            </a>

            <!-- Quản lý Tài Khoản -->
            <a href="${pageContext.request.contextPath}/admin/quanliAccount"
               class="action-btn rounded-2xl p-6 flex flex-col items-center text-center gap-4 group">
                <div class="w-16 h-16 rounded-xl bg-red-900/30 border border-red-700/30
                            flex items-center justify-center text-red-400 text-2xl
                            group-hover:scale-110 group-hover:bg-red-800/40 transition-all duration-300">
                    <i class="fas fa-users-cog"></i>
                </div>
                <div>
                    <div class="font-classic text-base text-gold-light font-semibold mb-1">Người Dùng</div>
                    <div class="font-body text-xs text-gray-500">Quản lý tài khoản</div>
                </div>
            </a>
        </div>

        <!-- Footer -->
        <div class="text-center mt-12 pt-8 border-t border-gold-dark/10">
            <div class="font-classic text-xs tracking-[0.25em] text-gray-600 uppercase">
                Est. 2024 &bull; H.N.D.D Billiards Management System
            </div>
        </div>
    </main>
</div>

</body>
</html>