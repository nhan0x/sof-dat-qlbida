<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter,java.time.LocalDateTime" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    org.example.models.Locker myLockerObj = (org.example.models.Locker) request.getAttribute("myLocker");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy");
    if (myLockerObj != null) {
        if (myLockerObj.getStartDate() != null)
            request.setAttribute("startDateStr", myLockerObj.getStartDate().format(dtf));
        if (myLockerObj.getEndDate() != null) {
            request.setAttribute("endDateStr", myLockerObj.getEndDate().format(dtf));
            request.setAttribute("isOverdue", myLockerObj.getEndDate().isBefore(LocalDateTime.now()));
        }
    }
%>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Tủ Đựng Cơ Thành Viên</title>

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
                        'roll': 'roll 0.8s cubic-bezier(0.25, 1, 0.5, 1) forwards',
                    },
                    keyframes: {
                        float: {
                            '0%, 100%': { transform: 'translateY(0px)' },
                            '50%': { transform: 'translateY(-8px)' }
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

        .locker-card {
            background: linear-gradient(145deg, rgba(20,60,35,0.9) 0%, rgba(6,20,12,0.95) 100%);
            border: 1px solid rgba(212,175,55,0.15);
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
            transition: all 0.3s ease;
        }

        .locker-card:hover {
            border-color: rgba(212,175,55,0.4);
            box-shadow: 0 15px 35px rgba(0,0,0,0.5), 0 0 15px rgba(212,175,55,0.05);
            transform: translateY(-3px);
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
    </style>
</head>

<body class="bg-billiards-felt min-h-screen pt-24 text-gray-200 font-body pb-16">

<!-- NAVBAR -->
<nav class="wood-navbar fixed top-0 left-0 right-0 z-50 h-16 flex items-center justify-between px-6">
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
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Trang Chủ
        </a>
        <a href="${pageContext.request.contextPath}/datban"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Đặt Bàn
        </a>
        <a href="${pageContext.request.contextPath}/user/ghepkeo"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Ghép Kèo
        </a>
        <a href="${pageContext.request.contextPath}/user/tudungco"
           class="px-4 py-2 text-gold-base font-body text-sm font-medium border-b border-gold-base rounded-t-sm transition-all">
            Tủ Đựng Cơ
        </a>
        <a href="${pageContext.request.contextPath}/lichsudatban"
           class="px-4 py-2 text-gold-base/60 hover:text-gold-light font-body text-sm font-medium transition-all">
            Lịch Sử
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

<!-- MAIN CONTAINER -->
<div class="max-w-5xl mx-auto px-6">

    <!-- Header Section -->
    <div class="mb-8 pb-6 border-b border-gold-dark/20 text-center md:text-left">
        <h1 class="font-classic text-3xl font-bold text-white tracking-wide">Tủ Đựng Cơ Thành Viên 🎱</h1>
        <p class="text-xs text-gray-400 mt-1">Lưu trữ và bảo quản cơ cá nhân an toàn tại câu lạc bộ. Vui lòng liên hệ quầy thu ngân để đăng ký thuê tủ.</p>
    </div>

    <!-- Part 1: Rented Locker details -->
    <div class="mb-10">
        <h2 class="font-classic text-xl font-bold text-gold-light mb-4 flex items-center gap-2">
            <span>🔑</span> Tủ Đựng Cơ Của Bạn
        </h2>

        <c:choose>
            <c:when test="${not empty myLocker}">
                <div class="bg-gradient-to-b from-[#1b3d27] to-[#0c1f14] border-2 border-gold-base/40 rounded-2xl p-6 shadow-2xl relative">
                    <!-- Bolts decoration simulating pool tables -->
                    <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
                    <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
                    <div class="absolute bottom-3 left-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
                    <div class="absolute bottom-3 right-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>

                    <div class="flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
                        <div class="flex flex-col items-center md:items-start gap-4">
                            <div class="w-20 h-20 rounded-2xl bg-black/40 border border-gold-base/30 flex items-center justify-center text-4xl text-gold-light font-classic font-bold shadow-inner">
                                ${myLocker.lockerNumber}
                            </div>
                            <div class="text-center md:text-left">
                                <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                                    Đang Thuê
                                </span>
                                <h3 class="text-lg font-bold text-white mt-2">Tủ đựng cơ số ${myLocker.lockerNumber}</h3>
                            </div>
                        </div>

                        <div class="flex-1 w-full max-w-md bg-black/30 border border-gold-dark/15 rounded-xl p-4 font-mono text-xs text-gray-300">
                            <div class="grid grid-cols-2 gap-y-2">
                                <span class="text-gray-400">Người thuê:</span>
                                <span class="text-white font-semibold text-right">${myLocker.memberName}</span>

                                <span class="text-gray-400">Số điện thoại:</span>
                                <span class="text-white text-right">${myLocker.memberPhone}</span>

                                <span class="text-gray-400">Ngày bắt đầu:</span>
                                <span class="text-white text-right">${startDateStr}</span>

                                <span class="text-gray-400">Ngày kết thúc:</span>
                                <span class="text-white text-right ${isOverdue ? 'text-red-500 font-bold' : ''}">
                                    ${endDateStr}
                                </span>

                                <span class="text-gray-400">Phí thuê:</span>
                                <span class="text-gold-light font-bold text-right"><fmt:formatNumber value="${myLocker.price}" type="number"/>đ</span>

                                <c:if test="${not empty myLocker.note}">
                                    <span class="text-gray-400">Ghi chú:</span>
                                    <span class="text-white italic text-right">"${myLocker.note}"</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-black/20 border border-dashed border-gold-dark/30 rounded-2xl p-8 text-center">
                    <div class="text-3xl mb-3">🗝️</div>
                    <h3 class="text-sm font-semibold text-gray-300">Bạn chưa đăng ký thuê tủ đựng cơ</h3>
                    <p class="text-xs text-gray-500 mt-1 max-w-sm mx-auto">Bạn có thể mang cơ cá nhân của mình ký gửi tại câu lạc bộ. Hãy liên hệ với nhân viên lễ tân để đăng ký một chiếc tủ của riêng mình nhé!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Part 2: Lockers status list -->
    <div>
        <h2 class="font-classic text-xl font-bold text-gold-light mb-4 flex items-center gap-2">
            <span>📦</span> Bản Đồ Trạng Thái Tủ Đựng Cơ
        </h2>

        <c:choose>
            <c:when test="${not empty lockerList}">
                <div class="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 gap-4">
                    <c:forEach var="l" items="${lockerList}">
                        <div class="locker-card rounded-xl p-4 flex flex-col items-center justify-between text-center gap-3 relative overflow-hidden">
                            <span class="text-xs font-mono font-bold text-gray-400 uppercase">Tủ</span>
                            <span class="text-2xl font-classic font-bold text-white">${l.lockerNumber}</span>
                            
                            <c:choose>
                                <c:when test="${l.status == 'Available'}">
                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                                        Trống
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-amber-950/20 text-amber-500 border border-amber-500/20">
                                        Đầy
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-sm text-gray-500 italic text-center">Chưa có tủ đựng cơ nào được cấu hình trong hệ thống.</p>
            </c:otherwise>
        </c:choose>
    </div>

</div>
</body>
</html>
