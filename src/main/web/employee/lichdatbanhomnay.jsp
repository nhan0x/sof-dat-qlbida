<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Lịch Đặt Bàn Hôm Nay</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen text-gray-100 flex flex-col transition-colors duration-700 relative overflow-x-hidden">

    <div class="absolute top-0 left-1/4 w-[500px] h-[500px] bg-white/5 rounded-full blur-[120px] pointer-events-none z-0"></div>
    <div class="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-gold-base/5 rounded-full blur-[120px] pointer-events-none z-0"></div>

    <!-- HEADER -->
    <header class="relative z-10 w-full wood-frame border-b border-gold-base/20 px-6 py-4 flex items-center justify-between shadow-lg">
        <div class="flex items-center gap-3">
            <span class="text-3xl drop-shadow-xl">🗓️</span>
            <div>
                <h1 class="font-classic text-2xl font-bold tracking-wider gold-text-emboss">H.N.D.D BIDA</h1>
                <p class="text-xs tracking-widest uppercase text-gold-base/80 font-classic">Lịch Đặt Bàn Trong Ngày</p>
            </div>
        </div>

        <div class="flex items-center gap-4">
            <c:choose>
                <c:when test="${isAdminView}">
                    <a href="${pageContext.request.contextPath}/admin/quanli.jsp"
                       class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                        <i class="fas fa-arrow-left mr-1"></i> Bảng Điều Khiển
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/duyetdatban"
                       class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                        📅 Duyệt Đặt Bàn
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
                       class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                        <i class="fas fa-arrow-left mr-1"></i> Bàn Bida
                    </a>
                    <a href="${pageContext.request.contextPath}/employee/duyetdatban"
                       class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                        📅 Duyệt Đặt Bàn
                    </a>
                </c:otherwise>
            </c:choose>

            <div class="text-right">
                <span class="font-classic text-sm block font-semibold text-white">${sessionScope.account.name}</span>
                <span class="text-xs text-gold-base/90 tracking-wider font-mono">${sessionScope.account.role}</span>
            </div>

            <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
               class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                Đăng xuất
            </a>
        </div>
    </header>

    <main class="relative z-10 flex-1 flex flex-col gap-6 p-6 max-w-[1400px] w-full mx-auto">

        <!-- Title + date picker -->
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-black/20 border border-gold-base/10 rounded-xl p-4">
            <div>
                <h2 class="text-lg font-classic font-bold text-white tracking-wide">
                    Lịch Đặt Bàn ${isToday ? 'Hôm Nay' : ''} &bull; ${selectedDateLabel}
                </h2>
                <p class="text-xs text-gray-400">Toàn bộ đơn đặt bàn có giờ chơi trong ngày (không tính đơn đã hủy).</p>
            </div>
            <form method="get" action="" class="flex items-end gap-2">
                <div>
                    <label for="date" class="block text-[10px] uppercase tracking-wider text-gray-400 mb-1">Chọn ngày</label>
                    <input type="date" id="date" name="date" value="${selectedDate}"
                           class="px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-sm text-gold-light shadow-inner">
                </div>
                <button type="submit"
                        class="bg-gradient-to-b from-[#d4af37] to-[#aa8511] text-wood-dark font-bold px-4 py-2 rounded-xl text-xs uppercase tracking-wider border border-[#8a6a09]">
                    Xem
                </button>
            </form>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="bg-black/25 border border-gold-base/15 rounded-xl p-4">
                <div class="text-2xl font-bold text-gold-light">${totalCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Tổng đơn trong ngày</div>
            </div>
            <div class="bg-black/25 border border-amber-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-amber-300">${upcomingCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Sắp tới</div>
            </div>
            <div class="bg-black/25 border border-emerald-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-emerald-300">${playingCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Đang trong giờ chơi</div>
            </div>
            <div class="bg-black/25 border border-gray-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-gray-300">${doneCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Đã qua giờ</div>
            </div>
        </div>

        <!-- Table -->
        <div class="wood-frame rounded-2xl p-1 shadow-2xl relative">
            <div class="absolute top-2 left-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>
            <div class="absolute top-2 right-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>

            <div class="inner-felt rounded-xl p-5 overflow-hidden">
                <c:choose>
                    <c:when test="${not empty bookingRows}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gold-dark/10">
                                <thead>
                                    <tr class="text-left text-xs font-semibold uppercase tracking-wider text-gold-base border-b border-gold-dark/20">
                                        <th class="py-3 px-4">Giờ Chơi</th>
                                        <th class="py-3 px-4">Bàn</th>
                                        <th class="py-3 px-4">Khách Hàng</th>
                                        <th class="py-3 px-4">Điện Thoại</th>
                                        <th class="py-3 px-4">Thời Lượng</th>
                                        <th class="py-3 px-4">Thanh Toán</th>
                                        <th class="py-3 px-4">Trạng Thái Đơn</th>
                                        <th class="py-3 px-4">Tình Trạng</th>
                                        <th class="py-3 px-4">Đặt Lúc</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gold-dark/10 text-sm">
                                    <c:forEach var="item" items="${bookingRows}">
                                        <tr class="hover:bg-black/10 transition-colors">
                                            <td class="py-4 px-4 font-mono text-gold-light font-bold">
                                                ${item.startTime} → ${item.endTime}
                                            </td>
                                            <td class="py-4 px-4 text-emerald-300 font-semibold">${item.tableName}</td>
                                            <td class="py-4 px-4 font-medium text-white">${item.customerName}</td>
                                            <td class="py-4 px-4 text-gray-300 font-mono">${item.customerPhone}</td>
                                            <td class="py-4 px-4 text-gray-300">${item.duration} giờ</td>
                                            <td class="py-4 px-4 text-gray-300">${item.paymentType}</td>
                                            <td class="py-4 px-4">
                                                <span class="px-2.5 py-1 rounded-full text-xs font-semibold
                                                    ${item.status == 'Đã Xác Nhận' ? 'bg-emerald-900/50 text-emerald-300 border border-emerald-500/30'
                                                      : (item.status == 'Chờ Thanh Toán' ? 'bg-blue-900/50 text-blue-300 border border-blue-500/30'
                                                      : 'bg-amber-900/50 text-amber-300 border border-amber-500/30')}">
                                                    ${item.status}
                                                </span>
                                            </td>
                                            <td class="py-4 px-4">
                                                <c:choose>
                                                    <c:when test="${item.timeState == 'playing'}">
                                                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-900/50 text-emerald-300 border border-emerald-500/30">
                                                            Đang trong giờ
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${item.timeState == 'upcoming'}">
                                                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-900/50 text-amber-300 border border-amber-500/30">
                                                            Sắp tới
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-gray-800/60 text-gray-400 border border-gray-500/30">
                                                            Đã qua
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-4 px-4 text-gray-400 font-mono text-xs">${item.bookingTime}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-5xl mb-4 opacity-40">🗓️</div>
                            <h3 class="font-classic text-lg text-yellow-200/60 font-semibold mb-2">Không có lịch đặt bàn</h3>
                            <p class="text-sm text-gray-500">Ngày ${selectedDateLabel} chưa có đơn đặt bàn nào.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

</body>
</html>
