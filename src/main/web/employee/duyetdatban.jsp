<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Duyệt Đặt Bàn Nhân Viên</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen text-gray-100 flex flex-col transition-colors duration-700 relative overflow-x-hidden">

    <!-- Blur Background Lights -->
    <div class="absolute top-0 left-1/4 w-[500px] h-[500px] bg-white/5 rounded-full blur-[120px] pointer-events-none z-0"></div>
    <div class="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-gold-base/5 rounded-full blur-[120px] pointer-events-none z-0"></div>

    <!-- LEFT SIDEBAR FOR STAFF -->
    <aside class="fixed top-0 left-0 bottom-0 w-[260px] bg-gradient-to-b from-[#2c1a10] via-[#22130b] to-[#170c07] border-r border-gold-base/20 shadow-2xl z-40 flex flex-col justify-between p-4 overflow-y-auto hidden md:flex">
        <div class="flex flex-col gap-5">
            <!-- Brand -->
            <a href="${pageContext.request.contextPath}/employee/trangchunhanvien" class="flex items-center gap-3 px-2 py-1">
                <span class="text-3xl drop-shadow-xl animate-bounce">🎱</span>
                <div>
                    <h1 class="font-classic text-xl font-bold tracking-wider gold-text-emboss">H.N.D.D BIDA</h1>
                    <p class="text-[10px] tracking-widest uppercase text-gold-base/80 font-classic">Staff Portal // Navigation</p>
                </div>
            </a>

            <!-- Staff Profile Card -->
            <div class="bg-black/30 border border-gold-dark/20 rounded-xl p-3 flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-gold-dark/30 border border-gold-base/40 flex items-center justify-center font-bold text-gold-light text-base">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.name}">${fn:toUpperCase(fn:substring(sessionScope.account.name, 0, 1))}</c:when>
                        <c:otherwise>NV</c:otherwise>
                    </c:choose>
                </div>
                <div class="min-w-0 flex-1">
                    <span class="font-classic text-sm font-semibold text-white truncate block">${sessionScope.account.name}</span>
                    <span class="text-[11px] text-gold-base/80 tracking-wider font-mono">Nhân viên</span>
                </div>
            </div>

            <!-- Navigation Links -->
            <nav class="space-y-1.5">
                <div class="text-[10px] font-bold uppercase tracking-widest text-gold-base/50 px-3 pt-2 pb-1">Vận Hành Ca</div>
                
                <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-300 hover:text-gold-light hover:bg-gold-base/10 border border-transparent hover:border-gold-dark/30 transition">
                    <i class="fas fa-cash-register text-gold-base/80 w-4 text-center"></i> Bàn Bida / Tính Tiền
                </a>

                <a href="${pageContext.request.contextPath}/employee/duyetdatban"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gold-light bg-gold-base/15 border border-gold-base/30 shadow-md transition">
                    <i class="fas fa-calendar-check text-gold-base w-4 text-center"></i> Duyệt Đặt Bàn
                </a>

                <a href="${pageContext.request.contextPath}/employee/lichdatbanhomnay"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-300 hover:text-gold-light hover:bg-gold-base/10 border border-transparent hover:border-gold-dark/30 transition">
                    <i class="fas fa-calendar-day text-gold-base/80 w-4 text-center"></i> Lịch Hôm Nay
                </a>

                <a href="${pageContext.request.contextPath}/employee/lichsuhoadon"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-300 hover:text-gold-light hover:bg-gold-base/10 border border-transparent hover:border-gold-dark/30 transition">
                    <i class="fas fa-file-invoice-dollar text-gold-base/80 w-4 text-center"></i> Hóa Đơn Của Tôi
                </a>

                <a href="${pageContext.request.contextPath}/employee/quanlidichvu"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-300 hover:text-gold-light hover:bg-gold-base/10 border border-transparent hover:border-gold-dark/30 transition">
                    <i class="fas fa-concierge-bell text-gold-base/80 w-4 text-center"></i> Dịch Vụ
                </a>
            </nav>
        </div>

        <!-- Sidebar Footer Actions -->
        <div class="space-y-2 pt-4 border-t border-gold-base/15">
            <c:if test="${fn:toLowerCase(sessionScope.account.role) == 'admin'}">
                <a href="${pageContext.request.contextPath}/admin/quanli.jsp"
                   class="w-full flex items-center justify-center gap-2 px-3 py-2 rounded-xl text-xs font-semibold uppercase tracking-wider text-amber-300 bg-amber-950/40 hover:bg-amber-900/60 border border-amber-500/30 transition">
                    <i class="fas fa-shield-halved"></i> Trang Admin
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
               class="w-full flex items-center justify-center gap-2 px-3 py-2 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-400 hover:text-white bg-black/30 hover:bg-black/50 border border-white/10 transition">
                <i class="fas fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </aside>

    <!-- MOBILE TOPBAR -->
    <div class="md:hidden wood-frame border-b border-gold-base/20 p-4 flex items-center justify-between z-30">
        <div class="flex items-center gap-2">
            <span class="text-2xl">🎱</span>
            <span class="font-classic font-bold text-gold-light">H.N.D.D BIDA</span>
        </div>
        <div class="flex items-center gap-2">
            <a href="${pageContext.request.contextPath}/employee/trangchunhanvien" class="text-xs bg-gold-base/20 border border-gold-base/30 text-gold-light px-3 py-1.5 rounded-lg">🎱 Bàn Bida</a>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="text-xs bg-red-900/40 border border-red-500/30 text-red-200 px-3 py-1.5 rounded-lg">Đăng xuất</a>
        </div>
    </div>

    <!-- CONTENT BODY -->
    <main class="relative z-10 flex-1 flex flex-col gap-6 p-6 max-w-[1400px] w-full mx-auto md:pl-[280px]">
        
        <!-- Dashboard Title and Filter Tabs -->
        <div class="flex flex-col gap-4 bg-black/20 border border-gold-base/10 rounded-xl p-4">
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                    <h2 class="text-lg font-classic font-bold text-white tracking-wide flex items-center gap-2">
                        <span>📋</span> Duyệt Yêu Cầu Đặt Bàn
                    </h2>
                    <p class="text-xs text-gray-400">Xem và phê duyệt các đơn đặt bàn trước của khách hàng gửi đến hệ thống.</p>
                </div>
                <div class="relative w-full sm:w-64">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-400">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" id="searchInput" placeholder="Tìm tên, SĐT, mã đơn..." onkeyup="filterTable()"
                           class="w-full pl-9 pr-4 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base text-sm text-gold-light transition placeholder-gray-500 shadow-inner" />
                </div>
            </div>

            <!-- Filter Status Tabs -->
            <div class="flex items-center gap-2 flex-wrap pt-2 border-t border-gold-base/10" id="filterTabs">
                <button onclick="setFilter('all', this)" class="filter-tab active px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-gold-base/20 text-gold-light border border-gold-base/40">
                    Tất Cả
                </button>
                <button onclick="setFilter('payos', this)" class="filter-tab px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-black/30 text-gray-300 border border-white/10 hover:text-white">
                    💳 Đã Thanh Toán PayOS
                </button>
                <button onclick="setFilter('pending', this)" class="filter-tab px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-black/30 text-gray-300 border border-white/10 hover:text-white">
                    🕒 Chờ Duyệt (Trả Sau)
                </button>
                <button onclick="setFilter('approved', this)" class="filter-tab px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-black/30 text-gray-300 border border-white/10 hover:text-white">
                    ✓ Đã Duyệt
                </button>
                <button onclick="setFilter('cancelled', this)" class="filter-tab px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-black/30 text-gray-300 border border-white/10 hover:text-white">
                    ✕ Đã Hủy
                </button>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="bg-emerald-950/70 border border-emerald-500/50 text-emerald-200 p-4 rounded-xl shadow-lg flex items-center justify-between transition-all" id="successAlert">
                <div class="flex items-center gap-3">
                    <span class="text-xl">✅</span>
                    <span class="text-sm font-semibold">${sessionScope.message}</span>
                </div>
                <button onclick="document.getElementById('successAlert').remove()" class="text-emerald-200 hover:text-white">✕</button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-950/70 border border-red-500/50 text-red-200 p-4 rounded-xl shadow-lg flex items-center justify-between transition-all" id="errorAlert">
                <div class="flex items-center gap-3">
                    <span class="text-xl">🚨</span>
                    <span class="text-sm font-semibold">${sessionScope.error}</span>
                </div>
                <button onclick="document.getElementById('errorAlert').remove()" class="text-red-200 hover:text-white">✕</button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Booking Table Container -->
        <div class="wood-frame rounded-2xl p-1 shadow-2xl relative">
            <div class="absolute top-2 left-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>
            <div class="absolute top-2 right-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>
            
            <div class="inner-felt rounded-xl p-5 overflow-hidden">
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gold-dark/10" id="tableMain">
                                <thead>
                                    <tr class="text-left text-xs font-bold uppercase tracking-wider text-gold-base border-b border-gold-dark/20">
                                        <th class="py-3.5 px-4">Mã Đơn</th>
                                        <th class="py-3.5 px-4">Khách Hàng</th>
                                        <th class="py-3.5 px-4">Bàn Đặt</th>
                                        <th class="py-3.5 px-4">Giờ Chơi Mong Muốn</th>
                                        <th class="py-3.5 px-4">Thời Lượng</th>
                                        <th class="py-3.5 px-4">Thanh Toán</th>
                                        <th class="py-3.5 px-4">Trạng Thái Đơn</th>
                                        <th class="py-3.5 px-4 text-center">Thao Tác Duyệt</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gold-dark/10 text-sm">
                                    <c:forEach var="item" items="${bookings}">
                                        <c:set var="isPayOS" value="${item.paymentType == 'Trả trước'}"/>
                                        <c:set var="isPending" value="${item.status == 'Chờ Xác Nhận' || item.status == 'Pending'}"/>
                                        <c:set var="isApproved" value="${item.status == 'Đã Xác Nhận' || item.status == 'Approved'}"/>
                                        
                                        <c:set var="rowCategory" value="${(isPending and isPayOS) ? 'payos' : (isPending ? 'pending' : (isApproved ? 'approved' : 'cancelled'))}"/>

                                        <tr class="hover:bg-black/20 transition-colors" data-category="${rowCategory}">
                                            <td class="py-4 px-4 font-mono font-bold text-gold-light">#BK${item.id}</td>
                                            <td class="py-4 px-4">
                                                <div class="font-bold text-white text-sm">${item.customerName}</div>
                                                <div class="text-xs text-gray-400 font-mono flex items-center gap-1 mt-0.5">
                                                    <i class="fas fa-phone text-[10px] text-gold-base/70"></i> ${item.customerPhone}
                                                </div>
                                            </td>
                                            <td class="py-4 px-4">
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold bg-emerald-950/60 text-emerald-300 border border-emerald-500/30">
                                                    🎱 ${item.tableName}
                                                </span>
                                            </td>
                                            <td class="py-4 px-4">
                                                <div class="font-bold font-mono text-gold-base text-sm">${item.playTime}</div>
                                                <div class="text-[11px] text-gray-400">Tạo lúc: ${item.bookingTime}</div>
                                            </td>
                                            <td class="py-4 px-4 font-semibold text-gray-200">${item.duration} Giờ</td>
                                            <td class="py-4 px-4">
                                                <c:choose>
                                                    <c:when test="${isPayOS}">
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-extrabold bg-emerald-500/20 text-emerald-300 border border-emerald-400/30">
                                                            💳 PayOS Online
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-semibold bg-gray-800 text-gray-300 border border-gray-600/30">
                                                            💵 Trả Sau Tại Quán
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-4 px-4">
                                                <c:choose>
                                                    <c:when test="${isPending}">
                                                        <c:choose>
                                                            <c:when test="${isPayOS}">
                                                                <div class="inline-flex flex-col">
                                                                    <span class="px-3 py-1 rounded-full text-xs font-extrabold bg-gradient-to-r from-emerald-600 to-teal-600 text-white border border-emerald-400/50 shadow-[0_0_12px_rgba(16,185,129,0.35)] flex items-center gap-1.5">
                                                                        <i class="fas fa-check-circle text-[11px]"></i> ĐÃ THANH TOÁN ONLINE
                                                                    </span>
                                                                    <span class="text-[10px] text-emerald-300 font-medium italic mt-1 text-center">⏳ Chờ nhân viên duyệt</span>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-amber-500/20 text-amber-300 border border-amber-500/40 inline-flex items-center gap-1.5">
                                                                    <i class="fas fa-clock text-[11px]"></i> Chờ Duyệt (Trả Sau)
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:when test="${isApproved}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-emerald-950/80 text-emerald-300 border border-emerald-500/40 inline-flex items-center gap-1.5">
                                                            <i class="fas fa-check text-[11px]"></i> ✓ Đã Duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-3 py-1 rounded-full text-xs font-semibold bg-red-950/80 text-red-300 border border-red-500/40 inline-flex items-center gap-1.5">
                                                            <i class="fas fa-times text-[11px]"></i> ✕ Đã Hủy
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-4 px-4 text-center">
                                                <div class="flex justify-center gap-2">
                                                    <c:if test="${isPending}">
                                                        <form action="${pageContext.request.contextPath}/employee/duyetdatban" method="POST" class="inline">
                                                            <input type="hidden" name="bookingId" value="${item.id}">
                                                            <input type="hidden" name="action" value="approve">
                                                            <button type="submit" class="px-3.5 py-1.5 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white rounded-lg text-xs font-extrabold uppercase tracking-wider transition shadow-lg active:scale-95 flex items-center gap-1"
                                                                    onclick="return confirm('Bạn có chắc muốn duyệt đơn đặt bàn này?')">
                                                                <i class="fas fa-check"></i> Duyệt
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/employee/duyetdatban" method="POST" class="inline">
                                                            <input type="hidden" name="bookingId" value="${item.id}">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <button type="submit" class="px-3.5 py-1.5 bg-gradient-to-r from-red-800 to-rose-900 hover:from-red-700 hover:to-rose-800 text-white rounded-lg text-xs font-bold uppercase tracking-wider transition shadow-md active:scale-95 flex items-center gap-1"
                                                                    onclick="return confirm('Bạn có chắc muốn hủy đơn đặt bàn này?')">
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
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-16">
                            <span class="text-5xl block mb-4">📅</span>
                            <h3 class="font-classic text-xl text-white mb-2">Không Có Đơn Đặt Bàn Nào</h3>
                            <p class="text-xs text-gray-400">Tất cả các yêu cầu đặt bàn đã được xử lý xong.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </main>

    <!-- FOOTER -->
    <footer class="relative z-10 mt-auto text-center py-6 text-xs text-gray-300/40 uppercase tracking-widest border-t border-gold-dark/10">
        Est. 2024 &bull; H.N.D.D Bida Pro Club Management System
    </footer>

    <script>
        let currentFilter = 'all';

        function setFilter(cat, btn) {
            currentFilter = cat;
            document.querySelectorAll('#filterTabs .filter-tab').forEach(b => {
                b.className = 'filter-tab px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-black/30 text-gray-300 border border-white/10 hover:text-white';
            });
            btn.className = 'filter-tab active px-3 py-1.5 rounded-lg text-xs font-bold uppercase transition bg-gold-base/20 text-gold-light border border-gold-base/40';
            filterTable();
        }

        function filterTable() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('#tableMain tbody tr').forEach(row => {
                const cat = row.getAttribute('data-category');
                const textMatch = row.textContent.toLowerCase().includes(query);
                const catMatch = (currentFilter === 'all') || (cat === currentFilter);
                row.style.display = (textMatch && catMatch) ? '' : 'none';
            });
        }
        
        // Auto-dismiss alerts
        setTimeout(() => {
            const success = document.getElementById('successAlert');
            const error = document.getElementById('errorAlert');
            if (success) success.remove();
            if (error) error.remove();
        }, 4000);
    </script>
</body>
</html>
