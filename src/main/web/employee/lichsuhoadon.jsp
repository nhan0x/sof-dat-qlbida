<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Lịch Sử Hóa Đơn Của Tôi</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen text-gray-100 flex flex-col relative overflow-x-hidden">

    <div class="absolute top-0 left-1/4 w-[500px] h-[500px] bg-white/5 rounded-full blur-[120px] pointer-events-none z-0"></div>

    <header class="relative z-10 w-full wood-frame border-b border-gold-base/20 px-6 py-4 flex items-center justify-between shadow-lg">
        <div class="flex items-center gap-3">
            <span class="text-3xl drop-shadow-xl">🧾</span>
            <div>
                <h1 class="font-classic text-2xl font-bold tracking-wider gold-text-emboss">H.N.D.D BIDA</h1>
                <p class="text-xs tracking-widest uppercase text-gold-base/80 font-classic">Lịch Sử Hóa Đơn Của Tôi</p>
            </div>
        </div>
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
               class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                <i class="fas fa-arrow-left mr-1"></i> Bàn Bida
            </a>
            <a href="${pageContext.request.contextPath}/employee/lichdatbanhomnay"
               class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                🗓️ Lịch Đặt Bàn
            </a>
            <div class="text-right">
                <span class="font-classic text-sm block font-semibold text-white">${sessionScope.account.name}</span>
                <span class="text-xs text-gold-base/90 tracking-wider font-mono">Nhân viên</span>
            </div>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
               class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
                Đăng xuất
            </a>
        </div>
    </header>

    <main class="relative z-10 flex-1 flex flex-col gap-6 p-6 max-w-[1400px] w-full mx-auto">

        <c:if test="${not empty sessionScope.message}">
            <div class="bg-green-950/50 border border-green-500/50 text-green-200 p-4 rounded-xl text-sm">${sessionScope.message}</div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-950/50 border border-red-500/50 text-red-200 p-4 rounded-xl text-sm">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Filter -->
        <div class="bg-black/20 border border-gold-base/10 rounded-xl p-4">
            <h2 class="text-lg font-classic font-bold text-white tracking-wide mb-1">Hóa Đơn Do Tôi Thực Hiện</h2>
            <p class="text-xs text-gray-400 mb-4">Danh sách các hóa đơn bạn đã mở bàn / thanh toán, kèm ngày giờ cụ thể.</p>

            <form method="get" action="${pageContext.request.contextPath}/employee/lichsuhoadon"
                  class="flex flex-wrap items-end gap-3">
                <div>
                    <label class="block text-[10px] uppercase tracking-wider text-gray-400 mb-1">Từ ngày</label>
                    <input type="date" name="fromDate" value="${fromDate}"
                           class="px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl text-sm text-gold-light shadow-inner">
                </div>
                <div>
                    <label class="block text-[10px] uppercase tracking-wider text-gray-400 mb-1">Đến ngày</label>
                    <input type="date" name="toDate" value="${toDate}"
                           class="px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl text-sm text-gold-light shadow-inner">
                </div>
                <div>
                    <label class="block text-[10px] uppercase tracking-wider text-gray-400 mb-1">Trạng thái</label>
                    <select name="status" class="px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl text-sm text-gold-light shadow-inner">
                        <option value="">Tất cả</option>
                        <option value="Paid" ${filterStatus == 'Paid' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="Unpaid" ${filterStatus == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
                    </select>
                </div>
                <div>
                    <label class="block text-[10px] uppercase tracking-wider text-gray-400 mb-1">Bàn</label>
                    <select name="tableId" class="px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl text-sm text-gold-light shadow-inner">
                        <option value="">Tất cả</option>
                        <c:forEach var="t" items="${tables}">
                            <option value="${t.id}" ${filterTableId == t.id ? 'selected' : ''}>${t.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit"
                        class="bg-gradient-to-b from-[#d4af37] to-[#aa8511] text-wood-dark font-bold px-5 py-2.5 rounded-xl text-xs uppercase tracking-wider border border-[#8a6a09]">
                    <i class="fas fa-filter mr-1"></i> Lọc
                </button>
            </form>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="bg-black/25 border border-gold-base/15 rounded-xl p-4">
                <div class="text-2xl font-bold text-gold-light">${totalCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Tổng hóa đơn</div>
            </div>
            <div class="bg-black/25 border border-emerald-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-emerald-300"><fmt:formatNumber value="${totalPaid}" pattern="#,###"/>đ</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Doanh thu đã thu</div>
            </div>
            <div class="bg-black/25 border border-blue-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-blue-300">${paidCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Đã thanh toán</div>
            </div>
            <div class="bg-black/25 border border-amber-500/25 rounded-xl p-4">
                <div class="text-2xl font-bold text-amber-300">${unpaidCount}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider mt-1">Chưa thanh toán</div>
            </div>
        </div>

        <!-- Table -->
        <div class="wood-frame rounded-2xl p-1 shadow-2xl relative">
            <div class="inner-felt rounded-xl p-5 overflow-hidden">
                <c:choose>
                    <c:when test="${not empty billRows}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gold-dark/10">
                                <thead>
                                    <tr class="text-left text-xs font-semibold uppercase tracking-wider text-gold-base border-b border-gold-dark/20">
                                        <th class="py-3 px-4">Mã HĐ</th>
                                        <th class="py-3 px-4">Bàn</th>
                                        <th class="py-3 px-4">Giờ Mở Bàn</th>
                                        <th class="py-3 px-4">Giờ Thanh Toán</th>
                                        <th class="py-3 px-4">Tổng Tiền</th>
                                        <th class="py-3 px-4">Trạng Thái</th>
                                        <th class="py-3 px-4 text-center">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gold-dark/10 text-sm">
                                    <c:forEach var="item" items="${billRows}">
                                        <tr class="hover:bg-black/10 transition-colors">
                                            <td class="py-4 px-4 font-mono text-gold-light">#${item.billId}</td>
                                            <td class="py-4 px-4 text-emerald-300 font-semibold">${item.tableName}</td>
                                            <td class="py-4 px-4 text-gray-300 font-mono text-xs">${item.timeStart}</td>
                                            <td class="py-4 px-4 text-gray-300 font-mono text-xs">${item.timeEnd}</td>
                                            <td class="py-4 px-4 text-gold-base font-semibold">
                                                <fmt:formatNumber value="${item.total}" pattern="#,###"/>đ
                                            </td>
                                            <td class="py-4 px-4">
                                                <span class="px-2.5 py-1 rounded-full text-xs font-semibold
                                                    ${item.status == 'Paid' ? 'bg-emerald-900/50 text-emerald-300 border border-emerald-500/30'
                                                      : 'bg-amber-900/50 text-amber-300 border border-amber-500/30'}">
                                                    ${item.status == 'Paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                                </span>
                                            </td>
                                            <td class="py-4 px-4 text-center">
                                                <div class="flex items-center justify-center gap-3">
                                                    <a href="${pageContext.request.contextPath}/employee/lichsuhoadon?billId=${item.billId}"
                                                       class="text-gold-light hover:text-white text-xs underline">Xem</a>
                                                    <a href="${pageContext.request.contextPath}/employee/lichsuhoadon?action=delete&billId=${item.billId}"
                                                       onclick="return confirm('Xác nhận xóa hóa đơn #${item.billId}? Admin sẽ nhận được thông báo ngay lập tức.')"
                                                       class="text-red-400 hover:text-red-300 text-xs px-2 py-1 rounded bg-red-950/40 border border-red-500/30 transition">
                                                        <i class="fas fa-trash-alt mr-1"></i> Xóa
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <div class="text-5xl mb-4 opacity-40">🧾</div>
                            <h3 class="font-classic text-lg text-yellow-200/60 font-semibold mb-2">Chưa có hóa đơn nào</h3>
                            <p class="text-sm text-gray-500">Không có hóa đơn nào của bạn trong khoảng thời gian đã chọn.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

</body>
</html>
