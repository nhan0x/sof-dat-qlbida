<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Trang Chủ</title>

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
                        body: ['"Inter"', 'sans-serif'],
                    },
                    colors: {
                        felt: { light: '#2a7a4d', dark: '#0f3622' },
                        wood: { light: '#6d4c41', base: '#3e2723', dark: '#1e110a' },
                        gold: { light: '#f9e596', base: '#d4af37', dark: '#997a15' }
                    },
                    animation: {
                        'float': 'float 4s ease-in-out infinite',
                        'shimmer': 'shimmer 2s linear infinite',
                        'roll': 'roll 0.8s cubic-bezier(0.25, 1, 0.5, 1) forwards',
                    },
                    keyframes: {
                        float: {
                            '0%, 100%': { transform: 'translateY(0px)' },
                            '50%': { transform: 'translateY(-8px)' }
                        },
                        shimmer: {
                            '0%': { backgroundPosition: '-200% center' },
                            '100%': { backgroundPosition: '200% center' }
                        },
                        roll: {
                            '0%': { transform: 'rotate(0deg)' },
                            '100%': { transform: 'rotate(360deg)' }
                        }
                    }
                }
            }
        }
    </script>

    <style>
        body { font-family: 'Inter', sans-serif; }

        .bg-billiards-felt {
            background-color: #0c2617;
            background-image:
                radial-gradient(circle at 20% 20%, rgba(212,175,55,0.06) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(42,122,77,0.12) 0%, transparent 50%),
                url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.08'/%3E%3C/svg%3E");
        }

        .wood-navbar {
            background: linear-gradient(180deg, #4e342e 0%, #3e2723 60%, #2c1810 100%);
            border-bottom: 2px solid rgba(212,175,55,0.3);
            box-shadow: 0 4px 20px rgba(0,0,0,0.6), inset 0 1px 0 rgba(255,255,255,0.05);
        }

        .gold-text-emboss {
            background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));
        }

        .service-card {
            background: linear-gradient(145deg, rgba(20,60,35,0.9) 0%, rgba(6,20,12,0.95) 100%);
            border: 1px solid rgba(212,175,55,0.15);
            box-shadow: 0 10px 30px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.05);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }

        .service-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, #d4af37, transparent);
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .service-card:hover::before { transform: scaleX(1); }

        .service-card:hover {
            transform: translateY(-10px);
            border-color: rgba(212,175,55,0.4);
            box-shadow: 0 20px 50px rgba(0,0,0,0.6), 0 0 30px rgba(212,175,55,0.1);
        }

        .service-icon-wrap {
            width: 72px; height: 72px;
            border-radius: 50%;
            background: rgba(212,175,55,0.1);
            border: 2px solid rgba(212,175,55,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 28px;
            transition: all 0.3s ease;
            color: #d4af37;
        }

        .service-card:hover .service-icon-wrap {
            background: rgba(212,175,55,0.2);
            border-color: rgba(212,175,55,0.5);
            box-shadow: 0 0 20px rgba(212,175,55,0.2);
            transform: scale(1.1) rotate(5deg);
        }

        .btn-card {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            border: 1px solid rgba(212,175,55,0.3);
            color: #d4af37;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .service-card:hover .btn-card {
            background: rgba(212,175,55,0.15);
            border-color: rgba(212,175,55,0.6);
        }

        .hero-section {
            background:
                linear-gradient(180deg, rgba(6,20,12,0.7) 0%, rgba(6,20,12,0.4) 50%, rgba(6,20,12,0.8) 100%),
                radial-gradient(ellipse at 50% 50%, rgba(42,122,77,0.3) 0%, transparent 70%);
            position: relative;
        }

        .divider-gold {
            width: 60px; height: 1px;
            background: linear-gradient(90deg, transparent, #d4af37, transparent);
            margin: 0 auto;
        }

        .avatar-ring {
            background: linear-gradient(135deg, #d4af37, #997a15);
            padding: 2px;
            border-radius: 50%;
        }

        .avatar-inner {
            background: #1a4a2e;
            border-radius: 50%;
            width: 36px; height: 36px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
            font-size: 14px;
            color: #d4af37;
        }

        .logout-btn {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.3);
            color: #f87171;
            transition: all 0.2s ease;
        }
        .logout-btn:hover {
            background: rgba(239,68,68,0.2);
            border-color: rgba(239,68,68,0.5);
        }

        /* Pocket dots decoration */
        .pocket-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            background: radial-gradient(circle at 35% 35%, #3a3a3a, #111);
            box-shadow: inset 0 1px 2px rgba(255,255,255,0.15), 0 1px 3px rgba(0,0,0,0.8);
        }
    </style>
</head>

<body class="bg-billiards-felt min-h-screen">

<!-- NAVBAR -->
<nav class="wood-navbar fixed top-0 left-0 right-0 z-50 h-16 flex items-center justify-between px-6">
    <!-- Brand -->
    <div class="flex items-center gap-3 group cursor-default">
        <span class="text-2xl group-hover:animate-roll inline-block">🎱</span>
        <div>
            <span class="font-classic font-bold text-xl gold-text-emboss">H.N.D.D</span>
            <div class="text-[10px] tracking-[0.2em] text-gold-base/60 uppercase">Premium Billiards</div>
        </div>
    </div>

    <!-- Nav Links (center) -->
    <div class="hidden md:flex items-center gap-1">
        <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp"
           class="px-4 py-2 text-gold-base font-body text-sm font-medium border-b border-gold-base rounded-t-sm transition-all">
            Trang Chủ
        </a>
        <a href="${pageContext.request.contextPath}/datban"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Đặt Bàn
        </a>
        <a href="${pageContext.request.contextPath}/lichsudatban"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Lịch Sử
        </a>
        <a href="${pageContext.request.contextPath}/user/ghepkeo"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Ghép Kèo
        </a>
        <a href="${pageContext.request.contextPath}/user/thongtincanhan"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Thông Tin Cá Nhân
        </a>
    </div>

    <!-- User Info -->
    <div class="flex items-center gap-3">
        <div class="text-right hidden sm:block">
            <div class="text-sm font-semibold text-gold-light font-body">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}</c:when>
                    <c:otherwise>Khách Hàng</c:otherwise>
                </c:choose>
            </div>
            <div class="text-[10px] text-gold-base/60 uppercase tracking-widest">Khách Hàng VIP</div>
            <c:if test="${sessionScope.account.role == 'Khách hàng'}">
                <div class="text-[10px] text-emerald-400 font-semibold tracking-wide mt-0.5">
                    🏆 ${sessionScope.account.points} điểm
                    <c:if test="${sessionScope.account.discountRate > 0}">
                        &bull; Giảm ${sessionScope.account.discountRate}%
                    </c:if>
                </div>
            </c:if>
        </div>
        <div class="avatar-ring">
            <div class="avatar-inner">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                    <c:otherwise>K</c:otherwise>
                </c:choose>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
           class="logout-btn flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium">
            <i class="fas fa-sign-out-alt text-xs"></i>
            <span class="hidden sm:inline">Đăng xuất</span>
        </a>
    </div>
</nav>

<!-- HERO SECTION -->
<div class="hero-section pt-16">
    <div class="max-w-5xl mx-auto px-6 py-20 text-center">
        <!-- Pocket decorations -->
        <div class="flex justify-between items-start mb-8">
            <div class="pocket-dot"></div>
            <div class="pocket-dot"></div>
        </div>

        <div class="font-classic text-xs tracking-[0.3em] text-gold-base/60 uppercase mb-4">Chào mừng trở lại</div>
        <h1 class="font-classic text-4xl md:text-5xl font-bold text-white mb-3 leading-tight">
            Trải Nghiệm <span class="gold-text-emboss">Bida Đỉnh Cao</span>
        </h1>
        <div class="divider-gold my-5"></div>
        <p class="font-body text-base text-gray-300/80 max-w-xl mx-auto leading-relaxed">
            Hệ thống bàn tiêu chuẩn quốc tế, cơ bida chuyên nghiệp và không gian đẳng cấp
            dành riêng cho <span class="text-gold-light font-medium">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}</c:when>
                    <c:otherwise>bạn</c:otherwise>
                </c:choose>
            </span>.
        </p>

        <div class="flex justify-between items-end mt-8">
            <div class="pocket-dot"></div>
            <div class="pocket-dot"></div>
        </div>
    </div>
</div>

<!-- SERVICES SECTION -->
<div class="max-w-5xl mx-auto px-6 pb-16 -mt-6 relative z-10">

    <!-- Section Title -->
    <div class="text-center mb-10">
        <div class="font-classic text-xs tracking-[0.25em] text-gold-base/60 uppercase mb-2">Dịch vụ của chúng tôi</div>
        <h2 class="font-classic text-2xl text-white font-semibold">Khám Phá Không Gian Bida</h2>
        <div class="divider-gold mt-3"></div>
    </div>

    <!-- Cards Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">

        <!-- Đặt Bàn -->
        <a href="${pageContext.request.contextPath}/datban" class="service-card rounded-2xl p-7 flex flex-col items-center text-center gap-4 group">
            <div class="service-icon-wrap">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <h3 class="font-classic text-xl text-gold-light font-semibold mb-2">Đặt Bàn Trước</h3>
                <p class="font-body text-sm text-gray-400 leading-relaxed">
                    Giữ chỗ ngay hôm nay để không bỏ lỡ những trận đấu hấp dẫn cùng bạn bè.
                </p>
            </div>
            <span class="btn-card mt-auto">Đặt ngay →</span>
        </a>



        <!-- Lịch Sử -->
        <a href="${pageContext.request.contextPath}/lichsudatban" class="service-card rounded-2xl p-7 flex flex-col items-center text-center gap-4 group">
            <div class="service-icon-wrap">
                <i class="fas fa-clock-rotate-left"></i>
            </div>
            <div>
                <h3 class="font-classic text-xl text-gold-light font-semibold mb-2">Lịch Sử Chơi</h3>
                <p class="font-body text-sm text-gray-400 leading-relaxed">
                    Xem lại lịch sử đặt bàn, số giờ chơi và ưu đãi cá nhân của bạn trên hệ thống.
                </p>
            </div>
            <span class="btn-card mt-auto">Xem chi tiết →</span>
        </a>

        <!-- Thông Tin Cá Nhân -->
        <a href="${pageContext.request.contextPath}/user/thongtincanhan" class="service-card rounded-2xl p-7 flex flex-col items-center text-center gap-4 group">
            <div class="service-icon-wrap">
                <i class="fas fa-id-card"></i>
            </div>
            <div>
                <h3 class="font-classic text-xl text-gold-light font-semibold mb-2">Thông Tin Cá Nhân</h3>
                <p class="font-body text-sm text-gray-400 leading-relaxed">
                    Cập nhật họ tên, liên hệ, cấp độ và phong cách chơi của bạn trên hệ thống.
                </p>
            </div>
            <span class="btn-card mt-auto">Chỉnh sửa →</span>
        </a>

        <!-- Danh Sách Người Chơi -->
        <a href="${pageContext.request.contextPath}/user/ghepkeo" class="service-card rounded-2xl p-7 flex flex-col items-center text-center gap-4 group">
            <div class="service-icon-wrap">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <h3 class="font-classic text-xl text-gold-light font-semibold mb-2">Danh Sách Người Chơi</h3>
                <p class="font-body text-sm text-gray-400 leading-relaxed">
                    Xem thông tin các người chơi khác: cấp độ, phong cách, tuổi và cách liên hệ.
                </p>
            </div>
            <span class="btn-card mt-auto">Xem danh sách →</span>
        </a>

        <!-- Ghép Kèo -->
        <a href="${pageContext.request.contextPath}/user/ghepkeo" class="service-card rounded-2xl p-7 flex flex-col items-center text-center gap-4 group" style="grid-column: 1 / -1;">
            <div class="service-icon-wrap" style="background:linear-gradient(135deg,rgba(139,92,246,0.25),rgba(109,40,217,0.15));border-color:rgba(139,92,246,0.35);">
                <i class="fas fa-people-arrows" style="color:#a78bfa;"></i>
            </div>
            <div>
                <h3 class="font-classic text-xl font-semibold mb-2" style="color:#c4b5fd;">Ghép Kèo Bida</h3>
                <p class="font-body text-sm text-gray-400 leading-relaxed">
                    Tìm đối thủ phù hợp, tạo phòng ghép kèo hoặc tham gia kèo có sẵn — chơi cùng người lạ, thắng cùng đam mê.
                </p>
            </div>
            <span class="btn-card mt-auto" style="background:linear-gradient(135deg,rgba(139,92,246,0.2),rgba(109,40,217,0.15));border-color:rgba(139,92,246,0.4);color:#c4b5fd;">Ghép ngay →</span>
        </a>
    </div>

    <!-- Footer -->
    <div class="text-center mt-12 pt-8 border-t border-gold-dark/20">
        <div class="font-classic text-xs tracking-[0.25em] text-gray-400/50 uppercase">
            Est. 2024 &bull; H.N.D.D Management System
        </div>
    </div>
</div>

<script>
    // Hiệu ứng parallax nhẹ cho hero
    window.addEventListener('scroll', () => {
        const hero = document.querySelector('.hero-section');
        if (hero) {
            hero.style.backgroundPositionY = (window.scrollY * 0.3) + 'px';
        }
    });
</script>
</body>
</html>