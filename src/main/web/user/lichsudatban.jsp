<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Lịch Sử Đặt Bàn</title>
    <%@ include file="../common/head.jsp" %>
    <style>
        .bida-table th {
            background: linear-gradient(180deg, #2c1a10, #1e110a);
            color: #d4af37;
            font-size: 11px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 14px 16px;
            border-bottom: 1px solid rgba(212,175,55,0.2);
            font-family: 'Inter', sans-serif;
            font-weight: 600;
        }
        .bida-table td {
            padding: 14px 16px;
            border-bottom: 1px solid rgba(212,175,55,0.06);
            font-family: 'Inter', sans-serif;
            font-size: 13.5px;
            color: #d1d5db;
            vertical-align: middle;
        }
        .bida-table tbody tr {
            transition: background 0.2s;
        }
        .bida-table tbody tr:hover {
            background: rgba(212,175,55,0.04);
        }
        .bida-table tbody tr:last-child td {
            border-bottom: none;
        }
    </style>
</head>
<body class="bg-billiards-felt min-h-screen">

<!-- NAVBAR -->
<nav class="sticky top-0 z-50 h-16 flex items-center justify-between px-6"
     style="background: linear-gradient(180deg,#4e342e,#2c1810); border-bottom: 1px solid rgba(212,175,55,0.25); box-shadow: 0 4px 20px rgba(0,0,0,0.5);">
    <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp" class="flex items-center gap-3 group">
        <span class="text-2xl group-hover:animate-roll inline-block">🎱</span>
        <div>
            <span class="font-classic font-bold text-xl gold-text-emboss">H.N.D.D</span>
            <div class="text-[10px] tracking-[0.2em] text-yellow-600/60 uppercase hidden sm:block">Premium Billiards</div>
        </div>
    </a>
    <div class="flex items-center gap-3">
        <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp"
           class="flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium text-yellow-500/70 hover:text-yellow-300 hover:bg-yellow-900/20 transition-all">
            <i class="fas fa-house text-xs"></i>
            <span class="hidden sm:inline">Trang Chủ</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/ghepkeo"
           class="flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-all"
           style="color:#c4b5fd;background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.25);">
            <i class="fas fa-people-arrows text-xs"></i>
            <span class="hidden sm:inline">Ghép Kèo</span>
        </a>
        <div class="text-right hidden sm:block">
            <div class="text-sm font-semibold text-yellow-200">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}</c:when>
                    <c:otherwise>Khách Hàng</c:otherwise>
                </c:choose>
            </div>
            <div class="text-[10px] text-yellow-600/60 uppercase tracking-widest">Khách Hàng VIP</div>
        </div>
        <div style="background:linear-gradient(135deg,#d4af37,#997a15);padding:2px;border-radius:50%;">
            <div style="background:#1a4a2e;border-radius:50%;width:34px;height:34px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#d4af37;">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                    <c:otherwise>K</c:otherwise>
                </c:choose>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
           class="flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-all"
           style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.25);color:#f87171;">
            <i class="fas fa-right-from-bracket text-xs"></i>
        </a>
    </div>
</nav>

<!-- MAIN -->
<div class="max-w-5xl mx-auto px-4 py-10">

    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
        <div>
            <div class="font-classic text-xs tracking-[0.25em] text-yellow-600/50 uppercase mb-1">Tài Khoản Của Bạn</div>
            <h1 class="font-classic text-2xl font-bold text-white">Lịch Sử Đặt Bàn</h1>
            <div style="width:40px;height:1px;background:linear-gradient(90deg,transparent,#d4af37,transparent);margin-top:10px;"></div>
        </div>
        <a href="${pageContext.request.contextPath}/datban"
           class="flex items-center gap-2 px-5 py-2.5 rounded-xl font-body font-semibold text-sm transition-all"
           style="background:linear-gradient(180deg,#d4af37,#aa8511);color:#1e110a;box-shadow:0 4px 15px rgba(0,0,0,0.3);border:1px solid #8a6a09;"
           onmouseover="this.style.background='linear-gradient(180deg,#f9e596,#d4af37)'"
           onmouseout="this.style.background='linear-gradient(180deg,#d4af37,#aa8511)'">
            <i class="fas fa-plus"></i> Đặt Chỗ Mới
        </a>
    </div>

    <!-- Toast thông báo -->
    <c:if test="${not empty sessionScope.booking_success}">
        <div id="toastSuccess" class="flex items-center gap-3 px-5 py-4 rounded-xl mb-6 font-body text-sm"
             style="background:rgba(34,197,94,0.12);border:1px solid rgba(34,197,94,0.3);color:#86efac;">
            <i class="fas fa-circle-check text-base flex-shrink-0"></i>
            <span>${sessionScope.booking_success}</span>
        </div>
        <c:remove var="booking_success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.booking_error}">
        <div id="toastError" class="flex items-center gap-3 px-5 py-4 rounded-xl mb-6 font-body text-sm"
             style="background:rgba(239,68,68,0.12);border:1px solid rgba(239,68,68,0.3);color:#f87171;">
            <i class="fas fa-circle-exclamation text-base flex-shrink-0"></i>
            <span>${sessionScope.booking_error}</span>
        </div>
        <c:remove var="booking_error" scope="session"/>
    </c:if>

    <div class="rounded-2xl overflow-hidden" style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);box-shadow:0 10px 30px rgba(0,0,0,0.4);">

        <c:choose>
            <c:when test="${empty bookingHistory}">
                <!-- Empty state -->
                <div class="text-center py-20 px-6">
                    <div class="text-6xl mb-5 opacity-40">📅</div>
                    <h3 class="font-classic text-xl text-yellow-200/60 font-semibold mb-2">Chưa có lịch sử đặt bàn</h3>
                    <p class="font-body text-sm text-gray-500 mb-6">Hãy đặt chỗ ngay để tận hưởng không gian Bida Đỉnh Cao!</p>
                    <a href="${pageContext.request.contextPath}/datban"
                       class="inline-flex items-center gap-2 px-6 py-3 rounded-xl font-body font-semibold text-sm"
                       style="background:rgba(212,175,55,0.15);border:1px solid rgba(212,175,55,0.3);color:#d4af37;">
                        <i class="fas fa-calendar-plus"></i> Đặt Bàn Ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="bida-table w-full border-collapse">
                        <thead>
                            <tr>
                                <th>Mã Đặt</th>
                                <th>Bàn</th>
                                <th>Giờ Chơi</th>
                                <th>Thời Lượng</th>
                                <th>Thanh Toán</th>
                                <th>Giờ Lập Đơn</th>
                                <th>Trạng Thái</th>
                                <th style="text-align:center;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="bk" items="${bookingHistory}">
                                <tr>
                                    <td>
                                        <span class="font-classic font-bold" style="color:#d4af37;">#BK${bk.id}</span>
                                    </td>
                                    <td>
                                        <span class="flex items-center gap-2">
                                            <i class="fas fa-table-cells-large text-xs" style="color:#d4af37;"></i>
                                            ${tableNameMap[bk.table_id]}
                                        </span>
                                    </td>
                                    <td class="font-semibold" style="color:#f9e596;">${bk.playTime}</td>
                                    <td style="color:#d1d5db;">${bk.duration} Giờ</td>
                                    <td style="color:#d1d5db;">${bk.paymentType}</td>
                                    <td style="color:#6b7280;">${bk.bookingTime}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bk.status == 'Đã Hủy'}">
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                                      style="background:rgba(239,68,68,0.12);color:#f87171;border:1px solid rgba(239,68,68,0.3);">
                                                    <span class="w-1.5 h-1.5 rounded-full" style="background:currentColor;"></span>
                                                    Đã Hủy
                                                </span>
                                            </c:when>
                                            <c:when test="${bk.status == 'Đã Xác Nhận' || bk.status == 'Chấp Nhận'}">
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                                      style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.3);">
                                                    <span class="w-1.5 h-1.5 rounded-full" style="background:currentColor;"></span>
                                                    ✓ Đã Duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${bk.status == 'Chờ Xác Nhận' || bk.status == 'Pending'}">
                                                <c:choose>
                                                    <c:when test="${bk.paymentType == 'Trả trước'}">
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold"
                                                              style="background:rgba(16,185,129,0.15);color:#6ee7b7;border:1px solid rgba(16,185,129,0.4);box-shadow:0 0 10px rgba(16,185,129,0.2);">
                                                            <i class="fas fa-credit-card text-[11px]"></i> Đã thanh toán, chờ duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                                              style="background:rgba(234,179,8,0.12);color:#fde047;border:1px solid rgba(234,179,8,0.3);">
                                                            <span class="w-1.5 h-1.5 rounded-full" style="background:currentColor;"></span>
                                                            🕒 Chờ duyệt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                                      style="background:rgba(239,68,68,0.12);color:#f87171;border:1px solid rgba(239,68,68,0.3);">
                                                    <span class="w-1.5 h-1.5 rounded-full" style="background:currentColor;"></span>
                                                    Đã Hủy
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <div class="flex items-center justify-center gap-2">

                                            <%-- Nút Hủy --%>
                                            <c:choose>
                                            <c:when test="${bk.status == 'Đã Hủy' || bk.status == 'Đã Xác Nhận' || bk.status == 'Chấp Nhận' || (bk.status == 'Chờ Xác Nhận' && bk.paymentType == 'Trả trước')}">
                                                    <button disabled
                                                            class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold"
                                                            style="background:rgba(100,116,139,0.08);border:1px solid rgba(100,116,139,0.2);color:#4b5563;cursor:not-allowed;opacity:0.45;">
                                                        <i class="fas fa-ban text-[10px]"></i> Hủy
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/lichsudatban" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <input type="hidden" name="bookingId" value="${bk.id}">
                                                        <button type="submit"
                                                                onclick="return confirm('Bạn có chắc muốn hủy đặt bàn này?')"
                                                                class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all"
                                                                style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.25);color:#f87171;cursor:pointer;"
                                                                onmouseover="this.style.background='rgba(239,68,68,0.25)'"
                                                                onmouseout="this.style.background='rgba(239,68,68,0.1)'">
                                                            <i class="fas fa-ban text-[10px]"></i> Hủy
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <div class="text-center mt-10 font-classic text-xs tracking-widest uppercase" style="color:rgba(156,163,175,0.4);">
        Est. 2024 &bull; H.N.D.D Management System
    </div>
</div>

</body>
</html>