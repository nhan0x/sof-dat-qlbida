<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setAttribute("serverNowMillis", System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Khu Vực Nhân Viên</title>
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

            <!-- Active Shift Card -->
            <c:if test="${not empty activeShift}">
                <div class="bg-amber-950/30 border border-gold-dark/30 rounded-xl p-3 text-xs space-y-1.5">
                    <div class="flex items-center justify-between text-gray-400">
                        <span>Ca làm việc:</span>
                        <span class="text-emerald-400 font-semibold">● Đang chạy</span>
                    </div>
                    <div class="flex items-center justify-between">
                        <span class="text-gray-400">Bắt đầu:</span>
                        <span class="font-mono text-gray-200">${activeShiftTimeStartStr}</span>
                    </div>
                    <div class="flex items-center justify-between pt-1 border-t border-gold-dark/20">
                        <span class="text-gray-400">Tiền đầu ca:</span>
                        <span class="font-mono font-bold text-gold-light"><fmt:formatNumber value="${activeShift.initialBalance}" type="number"/>đ</span>
                    </div>
                </div>
            </c:if>

            <!-- Navigation Links -->
            <nav class="space-y-1.5">
                <div class="text-[10px] font-bold uppercase tracking-widest text-gold-base/50 px-3 pt-2 pb-1">Vận Hành Ca</div>
                
                <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gold-light bg-gold-base/15 border border-gold-base/30 shadow-md transition">
                    <i class="fas fa-cash-register text-gold-base w-4 text-center"></i> Bàn Bida / Tính Tiền
                </a>

                <a href="${pageContext.request.contextPath}/employee/duyetdatban"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-gray-300 hover:text-gold-light hover:bg-gold-base/10 border border-transparent hover:border-gold-dark/30 transition">
                    <i class="fas fa-calendar-check text-gold-base/80 w-4 text-center"></i> Duyệt Đặt Bàn
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

            <c:if test="${not empty activeShift}">
                <button type="button" onclick="openCloseShiftModal()"
                        class="w-full flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl text-xs font-semibold uppercase tracking-wider text-red-200 bg-red-950/50 hover:bg-red-900 border border-red-500/50 shadow-md transition">
                    <i class="fas fa-power-off"></i> Đóng Ca Làm Việc
                </button>
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
            <a href="${pageContext.request.contextPath}/employee/duyetdatban" class="text-xs bg-gold-base/20 border border-gold-base/30 text-gold-light px-3 py-1.5 rounded-lg">📅 Duyệt</a>
            <a href="${pageContext.request.contextPath}/employee/quanlidichvu" class="text-xs bg-gold-base/20 border border-gold-base/30 text-gold-light px-3 py-1.5 rounded-lg">🛎️ Dịch vụ</a>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="text-xs bg-red-900/40 border border-red-500/30 text-red-200 px-3 py-1.5 rounded-lg">Đăng xuất</a>
        </div>
    </div>

    <!-- CONTENT BODY -->
    <main class="relative z-10 flex-1 flex flex-col lg:flex-row gap-6 p-6 max-w-[1600px] w-full mx-auto md:pl-[280px]">
        
        <!-- Left Side: Table Grid -->
        <div class="flex-1 flex flex-col gap-6">
            
            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="bg-green-950/50 border border-green-500/50 text-green-200 p-4 rounded-xl shadow-lg flex items-center justify-between transition-all" id="successAlert">
                    <div class="flex items-center gap-3">
                        <span>✨</span>
                        <span class="text-sm font-medium">${sessionScope.message}</span>
                    </div>
                    <button onclick="document.getElementById('successAlert').remove()" class="text-green-200 hover:text-white">✕</button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-950/50 border border-red-500/50 text-red-200 p-4 rounded-xl shadow-lg flex items-center justify-between transition-all" id="errorAlert">
                    <div class="flex items-center gap-3">
                        <span>🚨</span>
                        <span class="text-sm font-medium">${sessionScope.error}</span>
                    </div>
                    <button onclick="document.getElementById('errorAlert').remove()" class="text-red-200 hover:text-white">✕</button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Cảnh báo mở bàn: bàn đã có lịch đặt trước trong 3 giờ tới -->
            <c:if test="${not empty sessionScope.openTableWarnings}">
                <div class="bg-amber-950/40 border border-amber-500/50 text-amber-100 p-4 rounded-xl shadow-lg">
                    <div class="flex items-center gap-2 font-bold text-amber-300 mb-2">
                        <i class="fas fa-triangle-exclamation"></i>
                        Bàn ${sessionScope.openTableWarningTableName} đã có khách đặt trước trong 3 giờ tới
                    </div>
                    <div class="flex flex-col gap-2 text-xs mb-3">
                        <c:forEach var="ub" items="${sessionScope.openTableWarnings}">
                            <div class="bg-black/25 rounded-lg px-3 py-2">
                                <div><strong>${ub.customerName}</strong>
                                    <c:if test="${not empty ub.customerPhone}">&bull; <span class="font-mono">${ub.customerPhone}</span></c:if>
                                </div>
                                <div>${ub.playTime} → ${ub.endTime} (${ub.duration} giờ) &bull; ${ub.status} &bull; ${ub.paymentType}</div>
                            </div>
                        </c:forEach>
                    </div>
                    <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post" class="inline">
                        <input type="hidden" name="action" value="openTable">
                        <input type="hidden" name="tableId" value="${sessionScope.openTableWarningTableId}">
                        <input type="hidden" name="force" value="1">
                        <button type="submit" onclick="return confirm('Vẫn mở bàn cho khách hiện tại?')"
                                class="bg-amber-500/20 hover:bg-amber-500/35 border border-amber-500/50 text-amber-200 px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition">
                            Vẫn mở bàn
                        </button>
                    </form>
                </div>
                <c:remove var="openTableWarnings" scope="session"/>
                <c:remove var="openTableWarningTableId" scope="session"/>
                <c:remove var="openTableWarningTableName" scope="session"/>
            </c:if>

            <!-- ═══════════════════════════════════════════════════════ -->
            <!--  QR CALL NOTIFICATION PANEL (from customer QR scans)   -->
            <!-- ═══════════════════════════════════════════════════════ -->
            <c:if test="${not empty staffCalls}">
                <div class="bg-amber-950/30 border border-amber-500/40 rounded-2xl overflow-hidden shadow-lg" id="staffCallPanel">
                    <!-- Panel header with badge -->
                    <div class="flex items-center justify-between px-5 py-3.5 bg-amber-950/40 border-b border-amber-500/20">
                        <div class="flex items-center gap-3">
                            <span class="relative flex h-3 w-3">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                                <span class="relative inline-flex rounded-full h-3 w-3 bg-amber-500"></span>
                            </span>
                            <h3 class="font-classic font-bold text-amber-300 text-base">Yêu Cầu Phục Vụ Qua QR</h3>
                            <span class="bg-amber-500 text-black text-xs font-bold px-2 py-0.5 rounded-full">${staffCallCount}</span>
                        </div>
                        <button onclick="toggleStaffCallPanel()" class="text-amber-300/60 hover:text-amber-300 transition text-xs font-semibold uppercase tracking-wider">
                            Thu gọn ▲
                        </button>
                    </div>

                    <!-- Call list -->
                    <div id="staffCallList" class="divide-y divide-amber-500/10">
                        <c:forEach var="sc" items="${staffCalls}">
                            <div class="flex items-start justify-between gap-4 px-5 py-4 hover:bg-amber-950/20 transition" id="sc-${sc.id}">
                                <div class="flex items-start gap-3 flex-1 min-w-0">
                                    <div class="flex-shrink-0 w-10 h-10 rounded-xl flex items-center justify-center text-xl
                                        ${sc.note.contains('THANH TOAN') || sc.note.contains('THANH TO') ? 'bg-blue-900/50 border border-blue-500/30' :
                                          sc.note.contains('ORDER') ? 'bg-emerald-900/50 border border-emerald-500/30' :
                                          'bg-amber-900/50 border border-amber-500/30'}">
                                        <i class="fas ${sc.note.contains('THANH TO') ? 'fa-credit-card text-blue-400' : sc.note.contains('ORDER') ? 'fa-utensils text-emerald-400' : 'fa-bell text-amber-400'}"></i>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-center gap-2 flex-wrap">
                                            <span class="font-bold text-white text-sm">${sc.tableName}</span>
                                            <span class="text-[10px] font-bold uppercase px-2 py-0.5 rounded-full
                                                ${sc.note.contains('THANH TO') ? 'bg-blue-900/60 text-blue-300 border border-blue-500/25' :
                                                  sc.note.contains('ORDER') ? 'bg-emerald-900/60 text-emerald-300 border border-emerald-500/25' :
                                                  'bg-amber-900/60 text-amber-300 border border-amber-500/25'}">
                                                ${sc.note.contains('THANH TO') ? 'Thanh toan' : sc.note.contains('ORDER') ? 'Order' : 'Goi NV'}
                                            </span>
                                        </div>
                                        <p class="text-xs text-gray-300 mt-1 leading-relaxed line-clamp-2">${sc.note}</p>
                                        <p class="text-[10px] text-gray-500 mt-1 font-mono">${sc.callTime}</p>
                                    </div>
                                </div>
                                <!-- AJAX Dismiss button -->
                                <button type="button" onclick="dismissCall(${sc.id})" title="Da xu ly"
                                        class="w-8 h-8 rounded-lg bg-emerald-900/40 hover:bg-emerald-600 border border-emerald-500/30 text-emerald-300 hover:text-white transition flex items-center justify-center text-xs flex-shrink-0">
                                    <i class="fas fa-check"></i>
                                </button>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Dashboard Title and Info -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-black/20 border border-gold-base/10 rounded-xl p-4">
                <div>
                    <h2 class="text-lg font-classic font-bold text-white tracking-wide">Danh Sách Bàn Bida</h2>
                    <p class="text-xs text-gray-400">Chọn một bàn để mở bàn, gọi dịch vụ, tính tiền giờ và thanh toán.</p>
                </div>
                <div class="flex gap-2 text-xs font-semibold flex-wrap" id="table-filter-tabs">
                    <button type="button" onclick="filterTables('all')" data-filter="all"
                            class="filter-tab-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg border transition-all duration-200 uppercase tracking-wider">
                        Tất Cả <span id="count-all" class="bg-black/30 px-1.5 py-0.5 rounded-full">0</span>
                    </button>
                    <button type="button" onclick="filterTables('empty')" data-filter="empty"
                            class="filter-tab-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg border transition-all duration-200 uppercase tracking-wider">
                        <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]"></span>
                        Bàn Trống <span id="count-empty" class="bg-black/30 px-1.5 py-0.5 rounded-full">0</span>
                    </button>
                    <button type="button" onclick="filterTables('booked')" data-filter="booked"
                            class="filter-tab-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg border transition-all duration-200 uppercase tracking-wider">
                        <span class="w-2.5 h-2.5 rounded-full bg-amber-400 shadow-[0_0_8px_rgba(251,191,36,0.5)] animate-pulse"></span>
                        Bàn Đã Đặt <span id="count-booked" class="bg-black/30 px-1.5 py-0.5 rounded-full">0</span>
                    </button>
                    <button type="button" onclick="filterTables('inuse')" data-filter="inuse"
                            class="filter-tab-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg border transition-all duration-200 uppercase tracking-wider">
                        <span class="w-2.5 h-2.5 rounded-full bg-red-500 shadow-[0_0_8px_rgba(239,68,68,0.5)]"></span>
                        Đang Chơi <span id="count-inuse" class="bg-black/30 px-1.5 py-0.5 rounded-full">0</span>
                    </button>
                </div>
            </div>

            <!-- Table Grid Container -->
            <div class="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-6" id="table-grid">
                <c:forEach var="table" items="${tablesWithBills}">
                    <c:set var="trimmedStatus" value="${fn:trim(table.status)}"/>
                    <c:set var="isInUse" value="${trimmedStatus == 'Đang sử dụng' or trimmedStatus == 'In Use'}"/>
                    <c:set var="hasBooking" value="${not empty table.upcomingBookings}"/>

                    <%-- Render each card with explicit static classes to avoid Tailwind purge issues --%>
                    <c:choose>
                      <c:when test="${isInUse}">
                        <button onclick="selectTable(${table.id})" id="table-card-${table.id}" data-status="inuse"
                                class="wood-frame rounded-2xl p-1 relative flex flex-col items-center transition-all duration-300 hover:scale-[1.03] group shadow-[0_10px_20px_rgba(239,68,68,0.2)]">
                      </c:when>
                      <c:when test="${hasBooking}">
                        <button onclick="selectTable(${table.id})" id="table-card-${table.id}" data-status="booked"
                                class="wood-frame rounded-2xl p-1 relative flex flex-col items-center transition-all duration-300 hover:scale-[1.03] group border-2 border-amber-400/80 shadow-[0_10px_25px_rgba(245,158,11,0.35)]">
                      </c:when>
                      <c:otherwise>
                        <button onclick="selectTable(${table.id})" id="table-card-${table.id}" data-status="empty"
                                class="wood-frame rounded-2xl p-1 relative flex flex-col items-center transition-all duration-300 hover:scale-[1.03] group shadow-[0_10px_20px_rgba(0,0,0,0.4)]">
                      </c:otherwise>
                    </c:choose>
                        
                        <!-- Bolts simulating billiard table frames -->
                        <div class="absolute top-2 left-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>
                        <div class="absolute top-2 right-2 w-1.5 h-1.5 rounded-full bg-black/70 border border-white/10"></div>
                        
                        <!-- Inner felt -->
                        <div class="w-full inner-felt rounded-xl p-4 md:p-5 flex flex-col items-center gap-3 relative overflow-hidden">
                            
                            <!-- Status indicators -->
                            <div class="absolute top-2.5 right-2.5 flex items-center gap-1.5">
                                <c:if test="${hasBooking and not isInUse}">
                                    <span class="px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase bg-amber-400 text-black shadow-md border border-amber-300 animate-pulse flex items-center gap-1">
                                        <i class="fas fa-bookmark text-[9px]"></i> Đã Đặt
                                    </span>
                                </c:if>
                                <span class="relative flex h-2.5 w-2.5">
                                  <c:choose>
                                    <c:when test="${isInUse}">
                                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 bg-red-400"></span>
                                      <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-red-500"></span>
                                    </c:when>
                                    <c:when test="${hasBooking}">
                                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 bg-amber-400"></span>
                                      <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-amber-500"></span>
                                    </c:when>
                                    <c:otherwise>
                                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 bg-emerald-400"></span>
                                      <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
                                    </c:otherwise>
                                  </c:choose>
                                </span>
                            </div>

                            <!-- Billiard Ball / Icon -->
                            <div class="w-14 h-14 md:w-16 md:h-16 rounded-full flex items-center justify-center text-3xl md:text-4xl shadow-inner border border-gold-dark/10 group-hover:animate-roll bg-black/20 text-gray-200">
                                🎱
                            </div>

                            <span class="font-classic font-bold text-base md:text-lg text-white border-b border-gold-dark/20 pb-1 w-full text-center">
                                ${table.name}
                            </span>

                            <div class="flex flex-col items-center gap-1 w-full">
                                <c:choose>
                                  <c:when test="${isInUse}">
                                    <span class="text-xs uppercase tracking-widest font-mono font-bold text-red-400">Đang chơi</span>
                                  </c:when>
                                  <c:when test="${hasBooking}">
                                    <span class="text-xs uppercase tracking-widest font-mono font-bold text-amber-400">📌 ĐÃ ĐƯỢC ĐẶT</span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="text-xs uppercase tracking-widest font-mono font-bold text-emerald-400">Trống</span>
                                  </c:otherwise>
                                </c:choose>
                                
                                <span class="text-xs text-gray-300 mt-0.5">
                                    Loại: <span class="text-gold-light font-medium">${table.tableTypeName}</span>
                                </span>
                                <span class="text-xs text-gray-300">
                                    Giá: <span class="text-gold-base font-semibold"><fmt:formatNumber value="${table.pricePerHour}" type="number"/>đ/h</span>
                                </span>
                                

                                <c:choose>
                                    <c:when test="${isInUse}">
                                        <div class="text-xs font-mono text-gray-300 mt-1">
                                            <span>🕒 </span><span id="timer-${table.id}">00:00:00</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-[10px] text-gray-400 mt-1 italic">Sẵn sàng mở bàn</span>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Banner cảnh báo bàn đã được đặt trước --%>
                                <c:if test="${not empty table.upcomingBookings}">
                                    <div class="mt-2 w-full text-xs leading-snug rounded-xl p-2.5 bg-gradient-to-r from-amber-950/90 to-amber-900/70 border border-amber-400/50 text-amber-200 shadow-md">
                                        <div class="font-extrabold uppercase tracking-wider text-[11px] text-amber-300 flex items-center gap-1.5 mb-1">
                                            <i class="fas fa-calendar-check"></i> ĐÃ ĐƯỢC ĐẶT TRƯỚC
                                        </div>
                                        <c:forEach var="ub" items="${table.upcomingBookings}">
                                            <div class="font-bold text-white text-xs">🕒 ${ub.playTime} (${ub.duration}h)</div>
                                            <div class="text-[11px] text-amber-200 truncate">👤 Khách: ${ub.customerName}</div>
                                            <c:if test="${ub.paymentType == 'Trả trước'}">
                                                <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase mt-1 bg-emerald-500/20 text-emerald-300 border border-emerald-400/40">
                                                    <i class="fas fa-credit-card text-[9px]"></i> Đã TT Online
                                                </span>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </button>
                </c:forEach>
            </div>
            <div id="table-grid-empty" class="hidden text-center py-12 bg-black/20 border border-gold-base/10 rounded-xl">
                <span class="text-3xl block mb-2 opacity-50">🎱</span>
                <p class="text-sm text-gray-400">Không có bàn nào phù hợp với bộ lọc đã chọn.</p>
            </div>
        </div>

        <!-- Right Side: Sidebar Operation Drawer -->
        <div class="w-full lg:w-[420px] wood-frame rounded-2xl p-1 shadow-2xl relative">
            <!-- Bolts -->
            <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>
            <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>

            <div class="inner-felt rounded-xl p-6 h-full flex flex-col min-h-[500px]">
                
                <!-- Drawer Title -->
                <div class="border-b border-gold-dark/30 pb-4 mb-6">
                    <h3 class="font-classic text-xl text-white dark:text-gold-light flex items-center gap-2">
                        <span>⚙️</span> Chi Tiết & Thao Tác
                    </h3>
                </div>

                <!-- Empty State -->
                <div id="drawer-empty" class="flex-1 flex flex-col items-center justify-center text-center p-8">
                    <div class="w-16 h-16 rounded-full border border-dashed border-gold-dark/40 flex items-center justify-center text-2xl text-gold-base/50 mb-4">
                        👈
                    </div>
                    <h4 class="font-classic text-lg text-white mb-2">Chưa chọn bàn</h4>
                    <p class="text-xs text-gray-400">Chọn một bàn bida bên trái để tiến hành các thao tác phục vụ khách.</p>
                </div>

                <!-- Active Details Panel -->
                <div id="drawer-active" class="hidden flex-1 flex flex-col">
                    
                    <!-- Table Title details -->
                    <div class="flex justify-between items-start mb-6">
                        <div>
                            <h4 id="panel-table-name" class="font-classic text-2xl font-bold text-white">Bàn 01</h4>
                            <span id="panel-table-type" class="text-xs text-gold-base uppercase tracking-wider font-mono">Bàn Bida</span>
                        </div>
                        <span id="panel-table-status" class="px-3 py-1 rounded-full text-xs font-bold font-mono">
                            Trống
                        </span>
                    </div>

                    <!-- Operations based on status -->
                    
                    <!-- FORM 1: OPEN TABLE -->
                    <div id="op-open-table" class="hidden flex-1 flex flex-col justify-center py-8">
                        <div class="text-center mb-6">
                            <span class="text-5xl block mb-4">🚀</span>
                            <p class="text-sm text-gray-300">Bàn này đang trống. Bạn muốn mở bàn để khách bắt đầu chơi?</p>
                        </div>

                        <!-- Lịch đặt trước trong 3 giờ tới của bàn đang chọn -->
                        <div id="open-upcoming-warning" class="hidden rounded-xl p-4 mb-5"
                             style="background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.35);">
                            <div class="flex items-center gap-2 text-amber-300 font-bold text-sm mb-2">
                                <i class="fas fa-triangle-exclamation"></i>
                                Bàn này đã có khách đặt trước trong 3 giờ tới
                            </div>
                            <div id="open-upcoming-list" class="flex flex-col gap-2 text-xs text-amber-100/90"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post"
                              onsubmit="return confirmOpenTable()">
                            <input type="hidden" name="action" value="openTable">
                            <input type="hidden" name="tableId" id="open-table-id" value="">
                            <input type="hidden" name="force" id="open-table-force" value="0">
                            <button type="submit"
                                    class="w-full bg-gradient-to-b from-emerald-500 to-emerald-700 hover:from-emerald-400 hover:to-emerald-600 text-white font-classic font-bold py-3.5 px-4 rounded-xl shadow-lg border border-emerald-600 transition uppercase tracking-widest text-sm">
                                Bắt đầu chơi (Mở bàn)
                            </button>
                        </form>
                    </div>

                    <!-- FORM 2: ACTIVE SERVICES & BILLING -->
                    <div id="op-active-bill" class="hidden flex-1 flex flex-col">
                        
                        <!-- Play time details -->
                        <div class="bg-black/30 border border-gold-dark/20 rounded-xl p-4 mb-4">
                            <div class="grid grid-cols-2 gap-y-3 gap-x-4 text-xs font-mono">
                                <div>
                                    <span class="text-gray-400 block mb-0.5 uppercase tracking-wider">Mở lúc</span>
                                    <span id="bill-start-time" class="text-gray-200 text-sm">12:30 22/06</span>
                                </div>
                                <div>
                                    <span class="text-gray-400 block mb-0.5 uppercase tracking-wider">Thời gian chơi</span>
                                    <span id="bill-play-duration" class="text-gold-light text-sm font-bold">01h 15p</span>
                                </div>
                                <div>
                                    <span class="text-gray-400 block mb-0.5 uppercase tracking-wider">Tiền giờ hiện tại</span>
                                    <span id="bill-current-fee" class="text-gray-200 text-sm font-bold">0đ</span>
                                </div>
                                <div>
                                    <span class="text-gray-400 block mb-0.5 uppercase tracking-wider">Tiền giờ đã gộp</span>
                                    <span id="bill-merged-fee" class="text-gold-base text-sm font-bold">0đ</span>
                                </div>
                                <div class="col-span-2 h-px bg-gold-dark/10 my-1"></div>
                                <div class="col-span-2 flex justify-between items-center">
                                    <span class="text-gray-400 uppercase tracking-wider">Tổng tạm tính</span>
                                    <span id="bill-total-fee" class="text-gold-light text-base font-bold">0đ</span>
                                </div>
                            </div>
                        </div>

                        <!-- Services Ordered Section -->
                        <div class="mb-4">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-xs font-semibold uppercase tracking-wider text-gold-base/70">Dịch Vụ Đã Gọi</span>
                                <span id="services-count-badge" class="text-[10px] bg-gold-base/20 text-gold-light border border-gold-base/30 px-2 py-0.5 rounded-full font-bold">0 món</span>
                            </div>
                            <div id="services-list-container" class="bg-black/20 border border-gold-dark/15 rounded-xl overflow-hidden">
                                <!-- Empty state -->
                                <div id="services-empty-state" class="text-center py-4 px-3">
                                    <p class="text-xs text-gray-500 italic">Chưa có dịch vụ nào được gọi</p>
                                </div>
                                <!-- Services table -->
                                <div id="services-table" class="hidden">
                                    <table class="w-full text-xs">
                                        <thead>
                                            <tr class="border-b border-gold-dark/20">
                                                <th class="text-left px-3 py-2 text-gray-400 font-semibold uppercase tracking-wider">Tên</th>
                                                <th class="text-center px-2 py-2 text-gray-400 font-semibold uppercase tracking-wider">SL</th>
                                                <th class="text-right px-3 py-2 text-gray-400 font-semibold uppercase tracking-wider">T.Tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody id="services-tbody">
                                        </tbody>
                                        <tfoot>
                                            <tr class="border-t border-gold-dark/20 bg-black/20">
                                                <td colspan="2" class="px-3 py-2 text-gold-base font-bold uppercase tracking-wider text-xs">Tổng dịch vụ</td>
                                                <td class="px-3 py-2 text-right text-gold-light font-bold" id="services-total-cell">0đ</td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Action Buttons -->
                        <div class="flex flex-col gap-3 mb-4">
                            <a href="${pageContext.request.contextPath}/employee/quanlidichvu" id="btn-goi-dich-vu"
                               class="w-full flex items-center justify-center gap-2 bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold py-3 px-4 rounded-xl shadow-[0_5px_15px_rgba(0,0,0,0.3)] transition border border-[#8a6a09] uppercase tracking-widest text-sm">
                                🛎️ Gọi Dịch Vụ
                            </a>
                            <button type="button" onclick="openMergeModal()"
                                    class="w-full flex items-center justify-center gap-2 bg-gradient-to-b from-blue-500 to-blue-700 hover:from-blue-400 hover:to-blue-600 text-white font-classic font-bold py-3 px-4 rounded-xl shadow-[0_5px_15px_rgba(0,0,0,0.3)] transition border border-blue-800 uppercase tracking-widest text-sm">
                                🔄 Chuyển Bàn / Gộp Bill
                            </button>
                        </div>

                        <!-- Checkout & Billing button -->
                        <form id="checkout-form" action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post" class="mt-auto">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" name="tableId" id="checkout-table-id" value="">
                            <button type="button" onclick="showPaymentModal(event)"
                                    class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold py-3.5 px-4 rounded-xl shadow-[0_5px_15px_rgba(0,0,0,0.3)] transition border border-[#8a6a09] uppercase tracking-widest text-sm">
                                Thanh Toan & Dong Ban
                            </button>
                        </form>
                    </div>

                </div>

            </div>
        </div>

    </main>

    <!-- FOOTER -->
    <footer class="relative z-10 mt-auto text-center py-6 text-xs text-gray-300/40 uppercase tracking-widest border-t border-gold-dark/10">
        Est. 2024 &bull; H.N.D.D Bida Pro Club Management System
    </footer>

    <!-- OPEN SHIFT MODAL DIALOG OVERLAY -->
    <c:if test="${noActiveShift}">
        <div class="fixed inset-0 bg-black/85 backdrop-blur-md z-50 flex items-center justify-center p-4">
            <div class="w-full max-w-[440px] wood-frame rounded-2xl p-1 shadow-2xl relative animate-float">
                <!-- Bolts -->
                <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
                <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>

                <div class="inner-felt rounded-xl p-8 text-center">
                    <div class="flex justify-center items-center gap-2 text-4xl font-classic font-bold tracking-wider mb-2 text-white">
                        <span>🎱</span> <span class="gold-text-emboss">Mở Ca Làm Việc</span>
                    </div>
                    <div class="h-px bg-gold-dark/20 w-32 mx-auto my-4"></div>
                    
                    <p class="text-sm text-gray-300 mb-6">Chào mừng quay trở lại ca làm việc! Vui lòng nhập số dư két tiền mặt ban đầu để bắt đầu phục vụ.</p>
                    
                    <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post" class="flex flex-col gap-4">
                        <input type="hidden" name="action" value="openShift">
                        
                        <div class="text-left">
                            <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Số tiền đầu ca (VND)</label>
                            <input type="number" name="initialBalance" placeholder="Nhập số tiền mặt trong két..." required min="0" step="1000"
                                   class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-base text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>

                        <button type="submit" 
                                class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold text-base py-3.5 px-4 rounded-xl shadow-lg transition uppercase tracking-widest border border-[#8a6a09]">
                            Khai Ca & Mở Ca
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </c:if>

    <!-- REACTIVE JAVASCRIPT FOR DYNAMIC DATA -->
    <script>
        // Inject server-side table details into JS JSON
        const tableData = {
            <c:forEach var="t" items="${tablesWithBills}">
                "${t.id}": {
                    id: ${t.id},
                    name: "${t.name}",
                    status: "${t.status}",
                    tableTypeName: "${t.tableTypeName}",
                    rate: ${t.playTimeFee != null ? t.playTimeFee : 0},
                    hourlyRate: ${t.pricePerHour != null ? t.pricePerHour : 50000},
                    startTimeMillis: ${t.startTimeMillis != null ? t.startTimeMillis : 'null'},
                    startTime: "${t.startTimeStr}",
                    billId: ${t.bill != null ? t.bill.bill_id : 'null'},
                    services: [
                        <c:forEach var="s" items="${t.services}">
                            {
                                detailId: ${s.detailId},
                                name: "${s.serviceName}",
                                quantity: ${s.quantity},
                                price: ${s.price},
                                total: ${s.total}
                            },
                        </c:forEach>
                    ],
                    upcomingBookings: [
                        <c:forEach var="ub" items="${t.upcomingBookings}">
                            {
                                customerName: "${fn:escapeXml(ub.customerName)}",
                                customerPhone: "${fn:escapeXml(ub.customerPhone)}",
                                playTime: "${ub.playTime}",
                                endTime: "${ub.endTime}",
                                duration: ${ub.duration},
                                status: "${fn:escapeXml(ub.status)}"
                            },
                        </c:forEach>
                    ]
                },
            </c:forEach>
        };

        // Cache references
        const drawerEmpty = document.getElementById('drawer-empty');
        const drawerActive = document.getElementById('drawer-active');
        const panelTableName = document.getElementById('panel-table-name');
        const panelTableStatus = document.getElementById('panel-table-status');
        
        const opOpenTable = document.getElementById('op-open-table');
        const openTableId = document.getElementById('open-table-id');
        
        const opActiveBill = document.getElementById('op-active-bill');
        const billStartTime = document.getElementById('bill-start-time');
        const billPlayDuration = document.getElementById('bill-play-duration');
        const billCurrentFee = document.getElementById('bill-current-fee');
        const billMergedFee = document.getElementById('bill-merged-fee');
        const billTotalFee = document.getElementById('bill-total-fee');
        const checkoutTableId = document.getElementById('checkout-table-id');
        const MERGED_FEE_PREFIX = 'Tiền giờ ';

        // Use epoch milliseconds from server to avoid timezone parsing issues
        const serverNowMillis = ${serverNowMillis};
        const clientNowMillis = Date.now();
        const timeOffset = serverNowMillis - clientNowMillis;

        let selectedTableId = null;
        let selectedMergeTargetId = null;

        // ── MỞ BÀN: LỊCH ĐẶT TRƯỚC TRONG 3 GIỜ TỚI ────────────────
        function renderUpcomingBookings(data) {
            const box = document.getElementById('open-upcoming-warning');
            const list = document.getElementById('open-upcoming-list');
            const forceInput = document.getElementById('open-table-force');
            const bookings = data.upcomingBookings || [];

            list.innerHTML = '';
            if (bookings.length === 0) {
                box.classList.add('hidden');
                forceInput.value = '0';
                return;
            }

            bookings.forEach(b => {
                const row = document.createElement('div');
                row.className = 'rounded-lg px-3 py-2';
                row.style.background = 'rgba(0,0,0,0.25)';
                row.innerHTML =
                    '<div><strong>' + b.customerName + '</strong>'
                    + (b.customerPhone ? ' &bull; <span class="font-mono">' + b.customerPhone + '</span>' : '')
                    + '</div>'
                    + '<div>' + b.playTime + ' → ' + b.endTime + ' (' + b.duration + ' giờ) &bull; ' + b.status + '</div>';
                list.appendChild(row);
            });
            box.classList.remove('hidden');
            // Nhân viên đã nhìn thấy cảnh báo trên màn hình → cho phép gửi kèm xác nhận
            forceInput.value = '1';
        }

        function confirmOpenTable() {
            const box = document.getElementById('open-upcoming-warning');
            if (box.classList.contains('hidden')) return true;
            return confirm('Bàn này đã có khách đặt trước trong 3 giờ tới. Bạn vẫn muốn mở bàn cho khách hiện tại?');
        }

        // ── ĐÓNG CA: NHẬP SỐ TIỀN CUỐI CA ─────────────────────────
        function openCloseShiftModal() {
            document.getElementById('closeShiftModal').classList.remove('hidden');
            document.getElementById('closingBalanceInput').focus();
        }

        function closeCloseShiftModal() {
            document.getElementById('closeShiftModal').classList.add('hidden');
        }

        function confirmCloseShift() {
            const input = document.getElementById('closingBalanceInput');
            const value = parseFloat(input.value);
            if (isNaN(value) || value < 0) {
                alert('Vui lòng nhập số tiền cuối ca hợp lệ.');
                input.focus();
                return false;
            }
            return confirm('Xác nhận đóng ca với số tiền cuối ca là '
                + value.toLocaleString('vi-VN') + 'đ?\nBạn sẽ được đăng xuất khỏi hệ thống sau khi đóng ca.');
        }

        // ── CHUYỂN BÀN / GỘP BILL MODAL ───────────────────────────
        function openMergeModal() {
            if (!selectedTableId) return;
            document.getElementById('merge-source-table-id').value = selectedTableId;
            selectedMergeTargetId = null;
            document.getElementById('merge-submit-btn').disabled = true;

            const list = document.getElementById('merge-target-list');
            list.innerHTML = '';
            Object.keys(tableData).forEach(tId => {
                const t = tableData[tId];
                if (t.id === selectedTableId) return;
                const tIsInUse = t.status && (t.status.trim().toLowerCase() === 'đang sử dụng' || t.status.trim().toLowerCase() === 'in use');
                const row = document.createElement('div');
                row.className = 'merge-target-row cursor-pointer bg-black/30 hover:bg-black/40 border border-gold-dark/15 rounded-xl px-4 py-3 flex items-center justify-between transition';
                row.setAttribute('data-id', t.id);
                row.setAttribute('data-inuse', tIsInUse ? '1' : '0');
                row.innerHTML =
                    '<div>' +
                        '<div class="font-classic font-bold text-white text-sm">' + t.name + '</div>' +
                        '<div class="text-xs text-gray-400 font-mono">' + Math.round(t.hourlyRate || 0).toLocaleString('vi-VN') + 'đ/h</div>' +
                    '</div>' +
                    '<span class="px-3 py-1 rounded-full text-[11px] font-bold border ' +
                        (tIsInUse ? 'bg-red-500/15 text-red-400 border-red-500/30' : 'bg-emerald-500/15 text-emerald-400 border-emerald-500/30') + '">' +
                        (tIsInUse ? 'Đang chơi' : 'Trống') +
                    '</span>';
                row.addEventListener('click', function () { selectMergeTarget(t.id, row); });
                list.appendChild(row);
            });

            document.getElementById('mergeModal').classList.remove('hidden');
        }

        function selectMergeTarget(id, rowEl) {
            selectedMergeTargetId = id;
            document.getElementById('merge-target-table-id').value = id;
            document.querySelectorAll('.merge-target-row').forEach(el => {
                el.classList.remove('ring-2', 'ring-gold-base', 'bg-black/50');
            });
            rowEl.classList.add('ring-2', 'ring-gold-base', 'bg-black/50');
            document.getElementById('merge-submit-btn').disabled = false;
        }

        function closeMergeModal() {
            document.getElementById('mergeModal').classList.add('hidden');
        }

        function submitMerge() {
            if (!selectedMergeTargetId) return;
            const target = tableData[selectedMergeTargetId];
            const isInUse = target && target.status && (target.status.trim().toLowerCase() === 'đang sử dụng' || target.status.trim().toLowerCase() === 'in use');
            const msg = isInUse
                ? 'Bạn có chắc chắn muốn gộp hóa đơn bàn này vào bàn đã chọn?'
                : 'Bạn có chắc chắn muốn chuyển bàn này sang bàn trống đã chọn?';
            if (confirm(msg)) {
                document.getElementById('merge-table-form').submit();
            }
        }

        // Auto selection if there's only one table, or from localStorage
        window.addEventListener('DOMContentLoaded', () => {
            const lastSelected = localStorage.getItem('lastSelectedTable');
            if (lastSelected && tableData[lastSelected]) {
                selectTable(parseInt(lastSelected));
            }

            // Start clock timer loop for all active tables
            setInterval(updateAllTimers, 1000);
            updateAllTimers();

            // Restore last-used table filter (Tất Cả / Bàn Trống / Đang Chơi)
            updateFilterCounts();
            const lastFilter = localStorage.getItem('tableFilter') || 'all';
            filterTables(lastFilter);
        });

        // ── LỌC DANH SÁCH BÀN: TẤT CẢ / BÀN TRỐNG / ĐANG CHƠI ─────
        const FILTER_TAB_ACTIVE = 'bg-gold-dark/25 border-gold-base/50 text-gold-light';
        const FILTER_TAB_INACTIVE = 'bg-black/20 border-gold-dark/10 text-gray-400 hover:bg-black/30';

        function updateFilterCounts() {
            const cards = document.querySelectorAll('#table-grid [id^="table-card-"]');
            let empty = 0, inuse = 0, booked = 0;
            cards.forEach(card => {
                const st = card.getAttribute('data-status');
                if (st === 'inuse') inuse++;
                else if (st === 'booked') booked++;
                else empty++;
            });
            document.getElementById('count-all').textContent = cards.length;
            document.getElementById('count-empty').textContent = empty;
            document.getElementById('count-inuse').textContent = inuse;
            const countBookedEl = document.getElementById('count-booked');
            if (countBookedEl) countBookedEl.textContent = booked;
        }

        function filterTables(status) {
            localStorage.setItem('tableFilter', status);

            document.querySelectorAll('#table-filter-tabs .filter-tab-btn').forEach(btn => {
                const base = 'filter-tab-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg border transition-all duration-200 uppercase tracking-wider';
                const isActive = btn.getAttribute('data-filter') === status;
                btn.className = base + ' ' + (isActive ? FILTER_TAB_ACTIVE : FILTER_TAB_INACTIVE);
            });

            let visibleCount = 0;
            document.querySelectorAll('#table-grid [id^="table-card-"]').forEach(card => {
                const matches = status === 'all' || card.getAttribute('data-status') === status;
                card.style.display = matches ? '' : 'none';
                if (matches) visibleCount++;
            });

            document.getElementById('table-grid-empty').classList.toggle('hidden', visibleCount !== 0);
        }

        // Function to select and display table actions
        function selectTable(id) {
            selectedTableId = id;
            localStorage.setItem('lastSelectedTable', id);

            // Highlight selected table grid card
            document.querySelectorAll('[id^="table-card-"]').forEach(el => {
                el.classList.remove('ring-2', 'ring-gold-base', 'scale-[1.02]');
            });
            const activeCard = document.getElementById(`table-card-${id}`);
            if (activeCard) {
                activeCard.classList.add('ring-2', 'ring-gold-base', 'scale-[1.02]');
            }

            const data = tableData[id];
            if (!data) return;

            drawerEmpty.classList.add('hidden');
            drawerActive.classList.remove('hidden');

            panelTableName.textContent = data.name;
            const panelTableType = document.getElementById('panel-table-type');
            if (panelTableType) panelTableType.textContent = (data.tableTypeName || 'Bàn Bida').toUpperCase();
            const isInUse = data.status && (data.status.trim().toLowerCase() === 'đang sử dụng' || data.status.trim().toLowerCase() === 'in use');

            panelTableStatus.textContent = isInUse ? 'Đang chơi' : 'Trống';
            panelTableStatus.className = `px-3 py-1 rounded-full text-xs font-bold font-mono ${isInUse ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/40' : 'bg-gray-500/20 text-gray-300 border border-gray-500/40'}`;

            if (!isInUse) {
                opOpenTable.classList.remove('hidden');
                opActiveBill.classList.add('hidden');
                openTableId.value = data.id;
                renderUpcomingBookings(data);
            } else {
                opOpenTable.classList.add('hidden');
                opActiveBill.classList.remove('hidden');

                const btnGoiDichVu = document.getElementById('btn-goi-dich-vu');
                if (btnGoiDichVu) {
                    btnGoiDichVu.href = '${pageContext.request.contextPath}/employee/quanlidichvu?tableId=' + data.id;
                }
                checkoutTableId.value = data.id;
                document.getElementById('merge-source-table-id').value = data.id;

                // Set start time formatting using epoch ms (most reliable)
                let startDt = data.startTimeMillis ? new Date(data.startTimeMillis) : null;
                if (!startDt) {
                    // Fallback: try parsing ISO string
                    const raw = data.startTime || '';
                    if (raw) startDt = new Date(raw.replace(' ', 'T'));
                }
                if (startDt && !isNaN(startDt.getTime())) {
                    billStartTime.textContent = startDt.toLocaleTimeString('vi-VN') + ' ' + startDt.toLocaleDateString('vi-VN');
                } else {
                    billStartTime.textContent = data.startTime || '--';
                }

                // Split out synthetic "Tiền giờ <bàn>" lines (added by merging another table's
                // bill in) from the regular ordered-services list, so they can be shown as
                // a distinct "Tiền giờ đã gộp" stat instead of a line item.
                let mergedFee = 0;
                const regularServices = [];
                (data.services || []).forEach(s => {
                    if (s.name && s.name.indexOf(MERGED_FEE_PREFIX) === 0) {
                        mergedFee += s.total || (s.quantity * s.price);
                    } else {
                        regularServices.push(s);
                    }
                });
                data.mergedFee = mergedFee;
                renderServices(regularServices);

                // Update active table timers immediately
                updateSingleTimer(data);
            }
        }

        // Timer update logic
        function updateAllTimers() {
            Object.keys(tableData).forEach(id => {
                const data = tableData[id];
                const isInUse = data.status && (data.status.trim().toLowerCase() === 'đang sử dụng' || data.status.trim().toLowerCase() === 'in use');
                if (isInUse) {
                    updateSingleTimer(data);
                }
            });
        }

        function updateSingleTimer(data) {
            // Prefer epoch milliseconds (avoids all timezone/browser parsing issues)
            let startMs = data.startTimeMillis;
            if (!startMs) {
                // Fallback: parse ISO string
                const raw = data.startTime || '';
                if (!raw) {
                    console.warn('Timer: no startTime for table', data.id);
                    return;
                }
                const parsed = new Date(raw.replace(' ', 'T'));
                if (isNaN(parsed.getTime())) {
                    console.warn('Timer: cannot parse startTime for table', data.id, '->', raw);
                    return;
                }
                startMs = parsed.getTime();
            }

            // Current time adjusted by server-client clock offset
            const nowMs = Date.now() + timeOffset;
            let diffMs = nowMs - startMs;
            if (diffMs < 0) diffMs = 0;

            const hours   = Math.floor(diffMs / 3600000);
            const minutes = Math.floor((diffMs % 3600000) / 60000);
            const seconds = Math.floor((diffMs % 60000) / 1000);

            const hh = String(hours).padStart(2, '0');
            const mm = String(minutes).padStart(2, '0');
            const ss = String(seconds).padStart(2, '0');

            // Update timer display on the table grid card
            const timerEl = document.getElementById('timer-' + data.id);
            if (timerEl) {
                timerEl.textContent = hh + ':' + mm + ':' + ss;
            }

            // Update sidebar details panel if this table is selected
            if (selectedTableId === data.id) {
                billPlayDuration.textContent = hh + 'h ' + mm + 'm ' + ss + 's';

                // Live calculate table fee
                let elapsedMinutes = Math.floor(diffMs / 60000);
                if (elapsedMinutes < 1) elapsedMinutes = 0;
                const ratePerHour = data.hourlyRate || 50000;
                const computedFee = (elapsedMinutes / 60) * ratePerHour;
                const mergedFee = data.mergedFee || 0;
                billCurrentFee.textContent = Math.round(computedFee).toLocaleString('vi-VN') + 'đ';
                billMergedFee.textContent = Math.round(mergedFee).toLocaleString('vi-VN') + 'đ';
                billTotalFee.textContent = Math.round(computedFee + mergedFee).toLocaleString('vi-VN') + 'đ';
            }
        }

        // Payment Modal Scripts
        function updateDiscountOptionsForPoints(points, hasMemberCard) {
            const discountSelect = document.getElementById('checkout-discount-select');
            if (!discountSelect) return 0;

            const opts = discountSelect.options;
            let maxRateAllowed = 0;
            if (hasMemberCard && points !== undefined && points !== null) {
                const pts = parseInt(points) || 0;
                if (pts >= 2000) maxRateAllowed = 20;
                else if (pts >= 1000) maxRateAllowed = 15;
                else if (pts >= 500) maxRateAllowed = 10;
                else if (pts >= 300) maxRateAllowed = 5;
                else maxRateAllowed = 0;
            } else {
                maxRateAllowed = 0;
            }

            for (let i = 0; i < opts.length; i++) {
                const rateVal = parseFloat(opts[i].value || '0');
                if (rateVal === 0) {
                    opts[i].disabled = false;
                } else {
                    opts[i].disabled = (!hasMemberCard || rateVal > maxRateAllowed);
                }
            }

            // Ensure currently selected value is allowed
            const currentVal = parseFloat(discountSelect.value || '0');
            if (!hasMemberCard || currentVal > maxRateAllowed) {
                discountSelect.value = maxRateAllowed.toString();
            }

            return maxRateAllowed;
        }

        // Payment Modal Scripts
        function showPaymentModal(e) {
            e.preventDefault();
            document.getElementById('checkout-member-phone').value = '';
            document.getElementById('checkout-member-id').value = '';
            document.getElementById('member-lookup-result').innerHTML = '';
            document.getElementById('new-member-name').value = '';
            document.getElementById('new-member-phone').value = '';
            document.getElementById('quick-register-result').innerHTML = '';
            
            // Disable non-zero discounts by default until a member is verified
            updateDiscountOptionsForPoints(0, false);
            applyMemberDiscount();
            document.getElementById('paymentModal').classList.remove('hidden');
        }

        function closePaymentModal() {
            document.getElementById('paymentModal').classList.add('hidden');
        }

        function onMemberPhoneInputChanged() {
            // Phone was edited after a lookup — clear the stale selection so it isn't submitted by mistake.
            document.getElementById('checkout-member-id').value = '';
            document.getElementById('member-lookup-result').innerHTML = '';
            updateDiscountOptionsForPoints(0, false);
            applyMemberDiscount();
        }

        function lookupMemberByPhone() {
            const phone = document.getElementById('checkout-member-phone').value.trim();
            const resultBox = document.getElementById('member-lookup-result');
            if (!phone) {
                document.getElementById('checkout-member-id').value = '';
                resultBox.innerHTML = '<span class="text-gray-400">Khách hàng vãng lai (không có thẻ thành viên - không áp dụng giảm giá).</span>';
                updateDiscountOptionsForPoints(0, false);
                applyMemberDiscount();
                return;
            }
            resultBox.innerHTML = '<span class="text-gray-400">Đang tìm...</span>';
            fetch('${pageContext.request.contextPath}/employee/trangchunhanvien?action=lookupMember&phone=' + encodeURIComponent(phone))
                .then(r => r.json())
                .then(data => {
                    if (data.found) {
                        applyFoundMember(data);
                    } else {
                        document.getElementById('checkout-member-id').value = '';
                        resultBox.innerHTML = '<span class="text-amber-400">Không tìm thấy thành viên với SĐT này. Có thể đăng ký mới bên dưới (chưa được giảm giá).</span>';
                        updateDiscountOptionsForPoints(0, false);
                        applyMemberDiscount();
                    }
                })
                .catch(() => {
                    resultBox.innerHTML = '<span class="text-red-400">Lỗi tra cứu, vui lòng thử lại.</span>';
                    updateDiscountOptionsForPoints(0, false);
                    applyMemberDiscount();
                });
        }

        function applyFoundMember(member) {
            document.getElementById('checkout-member-id').value = member.id;
            const pts = member.points || 0;
            const maxRate = updateDiscountOptionsForPoints(pts, true);

            const discountSelect = document.getElementById('checkout-discount-select');
            discountSelect.value = maxRate.toString();

            let statusText = '✓ ' + member.name + ' - ' + member.phone + ' (' + pts + ' điểm tích lũy)';
            if (maxRate > 0) {
                statusText += ' - Đủ điều kiện giảm tối đa ' + maxRate + '%';
            } else {
                statusText += ' - Chưa đủ 300 điểm tích lũy để nhận mức giảm giá (cần thêm ' + (300 - pts) + ' điểm)';
            }

            document.getElementById('member-lookup-result').innerHTML =
                '<span class="' + (maxRate > 0 ? 'text-emerald-400' : 'text-amber-400') + '">' + statusText + '</span>';

            applyMemberDiscount();
        }

        function quickRegisterMember() {
            const name = document.getElementById('new-member-name').value.trim();
            const phone = document.getElementById('new-member-phone').value.trim();
            const resultBox = document.getElementById('quick-register-result');
            if (!name || !phone) {
                resultBox.innerHTML = '<span class="text-red-400">Vui lòng nhập đầy đủ tên và số điện thoại.</span>';
                return;
            }
            resultBox.innerHTML = '<span class="text-gray-400">Đang đăng ký...</span>';
            const body = new URLSearchParams();
            body.set('name', name);
            body.set('phone', phone);
            fetch('${pageContext.request.contextPath}/employee/trangchunhanvien?action=registerMember', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        resultBox.innerHTML = '<span class="text-emerald-400">✓ Đăng ký thẻ thành viên mới thành công (0 điểm tích lũy)!</span>';
                        document.getElementById('checkout-member-phone').value = data.phone;
                        applyFoundMember(data);
                    } else {
                        resultBox.innerHTML = '<span class="text-red-400">' + (data.error || 'Đăng ký thất bại.') + '</span>';
                    }
                })
                .catch(() => {
                    resultBox.innerHTML = '<span class="text-red-400">Lỗi kết nối, vui lòng thử lại.</span>';
                });
        }

        function applyMemberDiscount() {
            const memberId = document.getElementById('checkout-member-id').value;
            const discountSelect = document.getElementById('checkout-discount-select');
            
            if (!memberId) {
                discountSelect.value = "0";
            }

            const discountRate = parseFloat(discountSelect.value || '0');
            
            const data = tableData[selectedTableId];
            let serviceTotal = 0;
            if (data && data.services) {
                data.services.forEach(s => {
                    serviceTotal += s.total;
                });
            }
            
            let playFee = 0;
            if (data && data.startTimeMillis) {
                const nowMs = Date.now() + timeOffset;
                let diffMs = nowMs - data.startTimeMillis;
                if (diffMs < 0) diffMs = 0;
                let elapsedMinutes = Math.floor(diffMs / 60000);
                const ratePerHour = data.hourlyRate || 50000;
                playFee = Math.round((elapsedMinutes / 60) * ratePerHour);
            }
            
            const subtotal = playFee + serviceTotal;
            const discountAmount = Math.round((subtotal * discountRate) / 100);
            const finalTotal = subtotal - discountAmount;
            const pointsEarned = Math.floor(finalTotal / 1000); // 1 point per 1,000 VND
            
            document.getElementById('modal-subtotal').textContent = subtotal.toLocaleString('vi-VN') + 'đ';
            document.getElementById('modal-discount').textContent = '-' + discountAmount.toLocaleString('vi-VN') + 'đ (' + discountRate + '%)';
            document.getElementById('modal-total').textContent = finalTotal.toLocaleString('vi-VN') + 'đ';
            document.getElementById('modal-points-earned').textContent = '+' + pointsEarned + ' điểm';
        }

        function submitCheckout(method) {
            if (confirm("Xác nhận thanh toán hóa đơn bằng " + (method === 'cash' ? 'tiền mặt' : 'chuyển khoản (PayOS)') + "?")) {
                const form = document.getElementById('checkout-form');
                
                let methodInput = document.getElementById('payment-method-input');
                if (!methodInput) {
                    methodInput = document.createElement('input');
                    methodInput.type = 'hidden';
                    methodInput.name = 'paymentMethod';
                    methodInput.id = 'payment-method-input';
                    form.appendChild(methodInput);
                }
                methodInput.value = method;

                let memberInput = document.getElementById('member-id-input');
                if (!memberInput) {
                    memberInput = document.createElement('input');
                    memberInput.type = 'hidden';
                    memberInput.name = 'memberId';
                    memberInput.id = 'member-id-input';
                    form.appendChild(memberInput);
                }
                memberInput.value = document.getElementById('checkout-member-id').value;
                
                const discountSelect = document.getElementById('checkout-discount-select');
                let discountInput = document.getElementById('discount-rate-input');
                if (!discountInput) {
                    discountInput = document.createElement('input');
                    discountInput.type = 'hidden';
                    discountInput.name = 'discountRate';
                    discountInput.id = 'discount-rate-input';
                    form.appendChild(discountInput);
                }
                discountInput.value = discountSelect.value;
                form.submit();
            }
        }

        // ── RENDER SERVICES IN DETAIL PANEL ──────────────────────
        function renderServices(services) {
            const emptyState = document.getElementById('services-empty-state');
            const servicesTable = document.getElementById('services-table');
            const tbody = document.getElementById('services-tbody');
            const totalCell = document.getElementById('services-total-cell');
            const countBadge = document.getElementById('services-count-badge');
            if (!emptyState || !servicesTable || !tbody) return;

            tbody.innerHTML = '';
            if (!services || services.length === 0) {
                emptyState.classList.remove('hidden');
                servicesTable.classList.add('hidden');
                if (countBadge) countBadge.textContent = '0 mon';
                return;
            }

            emptyState.classList.add('hidden');
            servicesTable.classList.remove('hidden');
            if (countBadge) countBadge.textContent = services.length + ' mon';

            let grandTotal = 0;
            services.forEach(s => {
                const total = s.total || (s.quantity * s.price);
                grandTotal += total;
                const tr = document.createElement('tr');
                tr.className = 'border-b border-gold-dark/10 hover:bg-black/10 transition';
                tr.innerHTML = '<td class="px-3 py-2 text-gray-200 max-w-[100px] truncate" title="' + s.name + '">' + s.name + '</td>' +
                               '<td class="px-2 py-2 text-center text-gold-base font-bold">' + s.quantity + '</td>' +
                               '<td class="px-3 py-2 text-right text-gray-200 font-mono">' + Math.round(total).toLocaleString('vi-VN') + 'd</td>';
                tbody.appendChild(tr);
            });
            if (totalCell) totalCell.textContent = Math.round(grandTotal).toLocaleString('vi-VN') + 'd';
        }

        // ── AJAX DISMISS STAFF CALL ───────────────────────────────
        async function dismissCall(callId) {
            const el = document.getElementById('sc-' + callId);
            if (el) {
                el.style.opacity = '0.4';
                el.style.pointerEvents = 'none';
            }
            try {
                const resp = await fetch('${pageContext.request.contextPath}/employee/api/staffcalls?action=dismiss&id=' + callId, {method: 'POST'});
                const data = await resp.json();
                if (data.success) {
                    if (el) el.remove();
                    // Update badge count
                    const panel = document.getElementById('staffCallPanel');
                    if (panel) {
                        const remaining = panel.querySelectorAll('[id^="sc-"]').length;
                        const badge = panel.querySelector('.bg-amber-500.text-black');
                        if (badge) badge.textContent = remaining;
                        if (remaining === 0) panel.classList.add('hidden');
                    }
                } else {
                    if (el) { el.style.opacity = '1'; el.style.pointerEvents = ''; }
                }
            } catch(err) {
                console.error('Dismiss failed:', err);
                if (el) { el.style.opacity = '1'; el.style.pointerEvents = ''; }
            }
        }

        // ── REAL-TIME QR POLLING ──────────────────────────────────
        const POLL_INTERVAL = 5000; // 5 seconds
        let knownCallIds = new Set();

        // Initialize known IDs from server-rendered calls
        document.querySelectorAll('[id^="sc-"]').forEach(el => {
            const id = parseInt(el.id.replace('sc-', ''));
            if (!isNaN(id)) knownCallIds.add(id);
        });

        function showToast(call) {
            const typeColors = {
                pay:   { bg: 'bg-blue-900',   border: 'border-blue-500/50',   icon: 'fa-credit-card', text: 'text-blue-300',   label: 'THANH TOAN' },
                order: { bg: 'bg-emerald-900', border: 'border-emerald-500/50', icon: 'fa-utensils',   text: 'text-emerald-300', label: 'ORDER DO' },
                call:  { bg: 'bg-amber-900',   border: 'border-amber-500/50',  icon: 'fa-bell',        text: 'text-amber-300',   label: 'GOI NHAN VIEN' }
            };
            const c = typeColors[call.callType] || typeColors.call;

            const toast = document.createElement('div');
            toast.className = 'fixed top-5 right-5 z-[9999] flex items-start gap-3 p-4 rounded-xl border shadow-2xl max-w-xs animate-slide-in ' + c.bg + ' ' + c.border;
            toast.style.cssText = 'animation: slideInRight 0.4s ease forwards; min-width: 260px;';
            toast.innerHTML =
                '<div class="w-9 h-9 rounded-lg flex items-center justify-center text-sm ' + c.bg + ' border ' + c.border + '">' +
                    '<i class="fas ' + c.icon + ' ' + c.text + '"></i>' +
                '</div>' +
                '<div class="flex-1 min-w-0">' +
                    '<div class="flex items-center gap-2 mb-1">' +
                        '<span class="font-bold text-white text-sm">' + call.tableName + '</span>' +
                        '<span class="text-[9px] font-bold uppercase px-1.5 py-0.5 rounded ' + c.text + ' border ' + c.border + '">' + c.label + '</span>' +
                    '</div>' +
                    '<p class="text-xs text-gray-300 leading-relaxed line-clamp-2">' + call.note + '</p>' +
                    '<p class="text-[10px] text-gray-500 mt-1 font-mono">' + call.callTime + '</p>' +
                '</div>' +
                '<button onclick="this.parentElement.remove()" class="text-gray-400 hover:text-white text-xs ml-1 mt-0.5 flex-shrink-0"><i class="fas fa-times"></i></button>';

            document.body.appendChild(toast);

            // Play a soft notification beep using Web Audio API
            try {
                const ctx = new (window.AudioContext || window.webkitAudioContext)();
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.connect(gain); gain.connect(ctx.destination);
                osc.frequency.value = call.callType === 'pay' ? 880 : call.callType === 'order' ? 660 : 440;
                gain.gain.setValueAtTime(0.3, ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.5);
                osc.start(); osc.stop(ctx.currentTime + 0.5);
            } catch(e) {}

            // Auto-remove after 8 seconds
            setTimeout(() => { if (toast.parentElement) toast.remove(); }, 8000);
        }

        function addCallToPanel(call) {
            const panel = document.getElementById('staffCallPanel');
            const list = document.getElementById('staffCallList');
            if (!panel || !list) return;

            panel.classList.remove('hidden');
            // Update badge
            const badge = panel.querySelector('.bg-amber-500.text-black');
            if (badge) badge.textContent = parseInt(badge.textContent || '0') + 1;

            const typeIcon = call.callType === 'pay' ? 'fa-credit-card text-blue-400' : call.callType === 'order' ? 'fa-utensils text-emerald-400' : 'fa-bell text-amber-400';
            const typeBg = call.callType === 'pay' ? 'bg-blue-900/50 border border-blue-500/30' : call.callType === 'order' ? 'bg-emerald-900/50 border border-emerald-500/30' : 'bg-amber-900/50 border border-amber-500/30';
            const labelCls = call.callType === 'pay' ? 'bg-blue-900/60 text-blue-300 border-blue-500/25' : call.callType === 'order' ? 'bg-emerald-900/60 text-emerald-300 border-emerald-500/25' : 'bg-amber-900/60 text-amber-300 border-amber-500/25';
            const labelText = call.callType === 'pay' ? 'Thanh Toan' : call.callType === 'order' ? 'Order' : 'Goi NV';

            const div = document.createElement('div');
            div.id = 'sc-' + call.id;
            div.className = 'flex items-start justify-between gap-4 px-5 py-4 hover:bg-amber-950/20 transition border-t border-amber-500/10';
            div.innerHTML =
                '<div class="flex items-start gap-3 flex-1 min-w-0">' +
                    '<div class="flex-shrink-0 w-10 h-10 rounded-xl flex items-center justify-center ' + typeBg + '">' +
                        '<i class="fas ' + typeIcon + '"></i>' +
                    '</div>' +
                    '<div class="flex-1 min-w-0">' +
                        '<div class="flex items-center gap-2 flex-wrap">' +
                            '<span class="font-bold text-white text-sm">' + call.tableName + '</span>' +
                            '<span class="text-[10px] font-bold uppercase px-2 py-0.5 rounded-full border ' + labelCls + '">' + labelText + '</span>' +
                        '</div>' +
                        '<p class="text-xs text-gray-300 mt-1 leading-relaxed line-clamp-2">' + call.note + '</p>' +
                        '<p class="text-[10px] text-gray-500 mt-1 font-mono">' + call.callTime + '</p>' +
                    '</div>' +
                '</div>' +
                '<button type="button" onclick="dismissCall(' + call.id + ')" title="Da xu ly" ' +
                    'class="w-8 h-8 rounded-lg bg-emerald-900/40 hover:bg-emerald-600 border border-emerald-500/30 text-emerald-300 hover:text-white transition flex items-center justify-center text-xs flex-shrink-0">' +
                    '<i class="fas fa-check"></i>' +
                '</button>';
            list.appendChild(div);
            knownCallIds.add(call.id);
        }

        async function pollStaffCalls() {
            try {
                const resp = await fetch('${pageContext.request.contextPath}/employee/api/staffcalls', {
                    method: 'GET',
                    headers: {'Accept': 'application/json'}
                });
                if (!resp.ok) return;
                const data = await resp.json();
                if (!data.calls) return;

                // Process calls: show toast & add to panel for new IDs, or update note/time for existing IDs
                data.calls.forEach(call => {
                    if (!knownCallIds.has(call.id)) {
                        knownCallIds.add(call.id); // Mark FIRST to prevent repeated toasts regardless of panel state
                        showToast(call);
                        addCallToPanel(call);
                    } else {
                        // Update content if call note or time changed, without creating duplicate toast/panel
                        const el = document.getElementById('sc-' + call.id);
                        if (el) {
                            const noteEl = el.querySelector('p.text-gray-300');
                            if (noteEl && noteEl.textContent !== call.note) {
                                noteEl.textContent = call.note;
                            }
                            const timeEl = el.querySelector('p.text-gray-500');
                            if (timeEl && timeEl.textContent !== call.callTime) {
                                timeEl.textContent = call.callTime;
                            }
                        }
                    }
                });

                // Remove dismissed calls from panel (calls no longer in Pending)
                const currentIds = new Set(data.calls.map(c => c.id));
                knownCallIds.forEach(id => {
                    if (!currentIds.has(id)) {
                        knownCallIds.delete(id);
                        const el = document.getElementById('sc-' + id);
                        if (el) el.remove();
                    }
                });
            } catch (err) {
                // Silently fail - network issues should not disrupt the UI
            }
        }

        // Start polling after page loads
        window.addEventListener('DOMContentLoaded', () => {
            setInterval(pollStaffCalls, POLL_INTERVAL);
        });

        // Shift close calculation helper
        const shiftRevenueValue = ${not empty shiftRevenue ? shiftRevenue : 0};

        function openCloseShiftModal() {
            const modal = document.getElementById('closeShiftModal');
            if (modal) {
                modal.classList.remove('hidden');
                calculateShiftDiff();
            }
        }

        function closeCloseShiftModal() {
            const modal = document.getElementById('closeShiftModal');
            if (modal) modal.classList.add('hidden');
        }

        function calculateShiftDiff() {
            const initInput = document.getElementById('initialBalanceInput');
            const closeInput = document.getElementById('closingBalanceInput');
            const expectedEl = document.getElementById('expectedBalanceDisplay');
            const diffEl = document.getElementById('diffAmountDisplay');
            const statusBadge = document.getElementById('diffStatusBadge');

            if (!initInput || !closeInput) return;

            const initVal = parseFloat(initInput.value) || 0;
            const closeVal = parseFloat(closeInput.value) || 0;
            const expected = initVal + shiftRevenueValue;
            const diff = closeVal - expected;

            if (expectedEl) {
                expectedEl.textContent = expected.toLocaleString('vi-VN') + 'đ';
            }

            if (diffEl && statusBadge) {
                if (closeInput.value.trim() === '') {
                    diffEl.textContent = '---';
                    statusBadge.className = 'px-2.5 py-1 rounded-md text-xs font-bold bg-gray-800 text-gray-400 border border-gray-700';
                    statusBadge.textContent = 'Chưa kiểm đếm';
                } else if (diff === 0) {
                    diffEl.textContent = '0đ (Khớp két)';
                    statusBadge.className = 'px-2.5 py-1 rounded-md text-xs font-bold bg-emerald-950/80 text-emerald-300 border border-emerald-500/50';
                    statusBadge.textContent = '✓ KHỚP KÉT';
                } else if (diff < 0) {
                    diffEl.textContent = Math.abs(diff).toLocaleString('vi-VN') + 'đ (Thiếu)';
                    statusBadge.className = 'px-2.5 py-1 rounded-md text-xs font-bold bg-red-950/80 text-red-300 border border-red-500/50 animate-pulse';
                    statusBadge.textContent = '⚠ THIẾU KÉT';
                } else {
                    diffEl.textContent = '+' + diff.toLocaleString('vi-VN') + 'đ (Thừa)';
                    statusBadge.className = 'px-2.5 py-1 rounded-md text-xs font-bold bg-blue-950/80 text-blue-300 border border-blue-500/50';
                    statusBadge.textContent = '★ DƯ KÉT';
                }
            }
        }

        function confirmCloseShift() {
            const initInput = document.getElementById('initialBalanceInput');
            const closeInput = document.getElementById('closingBalanceInput');
            const noteInput = document.getElementById('shiftNoteInput');

            if (!closeInput || closeInput.value.trim() === '') {
                alert('Vui lòng nhập số tiền thực tế trong két khi đóng ca!');
                return false;
            }

            const initVal = parseFloat(initInput.value) || 0;
            const closeVal = parseFloat(closeInput.value) || 0;
            const expected = initVal + shiftRevenueValue;
            const diff = closeVal - expected;

            if (diff !== 0 && (!noteInput || noteInput.value.trim() === '')) {
                const proceed = confirm('Tiền két hiện đang CHÊNH LỆCH (' + (diff < 0 ? 'THIẾU ' : 'DƯ +') + Math.abs(diff).toLocaleString('vi-VN') + 'đ) mà bạn chưa nhập ghi chú giải trình.\n\nBạn có chắc chắn muốn đóng ca không?');
                if (!proceed) {
                    if (noteInput) noteInput.focus();
                    return false;
                }
            }

            return confirm('Bạn có chắc chắn muốn chốt số dư và ĐÓNG CA làm việc? Bạn sẽ được đăng xuất sau khi đóng ca.');
        }

        // Inject toast animation style
        const styleEl = document.createElement('style');
        styleEl.textContent = '@keyframes slideInRight { from { opacity:0; transform:translateX(60px); } to { opacity:1; transform:translateX(0); } }';
        document.head.appendChild(styleEl);

    </script>


    <!-- MERGE / TRANSFER TABLE FORM (submitted from the modal below) -->
    <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post" id="merge-table-form">
        <input type="hidden" name="action" value="mergeTable">
        <input type="hidden" name="sourceTableId" id="merge-source-table-id" value="">
        <input type="hidden" name="targetTableId" id="merge-target-table-id" value="">
    </form>

    <!-- ĐÓNG CA: NHẬP SỐ TIỀN ĐẦU CA & CUỐI CA MODAL -->
    <div id="closeShiftModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
        <div class="w-full max-w-[460px] wood-frame rounded-2xl p-1 shadow-2xl relative animate-float">
            <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>
            <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>

            <div class="inner-felt rounded-xl p-6">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="font-classic text-xl font-bold text-white gold-text-emboss">Đóng Ca Làm Việc</h3>
                    <button type="button" onclick="closeCloseShiftModal()" class="text-gray-400 hover:text-white text-lg">✕</button>
                </div>
                <p class="text-xs text-gray-400 mb-4">
                    Kiểm tra lại tiền đầu ca và nhập số tiền thực tế trong két để hệ thống so sánh dư/thiếu.
                </p>

                <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post"
                      onsubmit="return confirmCloseShift()">
                    <input type="hidden" name="action" value="closeShift">

                    <!-- 1. Tiền đầu ca -->
                    <div class="mb-3">
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1 uppercase">
                            1. Số tiền đầu ca (VNĐ)
                        </label>
                        <input type="number" name="initialBalance" id="initialBalanceInput" required min="0" step="1000"
                               value="${not empty activeShift ? activeShift.initialBalance : 0}"
                               oninput="calculateShiftDiff()"
                               placeholder="Xác nhận số tiền tiền đầu ca..."
                               class="w-full px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base font-mono text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
                    </div>

                    <!-- 2. Doanh thu & Tiền két kỳ vọng -->
                    <div class="bg-black/40 border border-gold-dark/20 rounded-xl p-3 mb-3 text-xs flex flex-col gap-1.5">
                        <div class="flex justify-between text-gray-300">
                            <span>+ Doanh thu ca:</span>
                            <span class="font-mono text-emerald-400 font-semibold"><fmt:formatNumber value="${not empty shiftRevenue ? shiftRevenue : 0}" type="number"/>đ</span>
                        </div>
                        <div class="h-px bg-gold-dark/20 my-0.5"></div>
                        <div class="flex justify-between font-bold text-gold-light">
                            <span>= Tổng két kỳ vọng:</span>
                            <span class="font-mono text-sm" id="expectedBalanceDisplay">0đ</span>
                        </div>
                    </div>

                    <!-- 3. Tiền cuối ca thực tế -->
                    <div class="mb-3">
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1 uppercase">
                            2. Số tiền cuối ca đếm thực tế (VNĐ)
                        </label>
                        <input type="number" name="closingBalance" id="closingBalanceInput" required min="0" step="1000"
                               oninput="calculateShiftDiff()"
                               placeholder="Nhập số tiền đếm được trong két..."
                               class="w-full px-4 py-2.5 bg-black/40 border border-gold-dark/40 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base font-mono text-base text-gold-light transition placeholder-gray-500 shadow-inner font-bold">
                    </div>

                    <!-- Live Difference Result -->
                    <div class="bg-black/50 border border-gold-dark/25 rounded-xl p-3 mb-4 flex items-center justify-between">
                        <div>
                            <span class="text-[11px] uppercase tracking-wider text-gray-400 block">Chênh lệch két (Dư / Thiếu)</span>
                            <span id="diffAmountDisplay" class="font-mono text-sm font-bold text-white">---</span>
                        </div>
                        <div>
                            <span id="diffStatusBadge" class="px-2.5 py-1 rounded-md text-xs font-bold bg-gray-800 text-gray-400 border border-gray-700">Chưa kiểm đếm</span>
                        </div>
                    </div>

                    <!-- 4. Ghi chú bàn giao & Giải trình -->
                    <div class="mb-4">
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1 uppercase">
                            3. Ghi chú bàn giao ca &amp; Giải trình chênh lệch
                        </label>
                        <textarea name="note" id="shiftNoteInput" rows="2"
                                  placeholder="Nhập lý do dư/thiếu tiền (nếu có) hoặc ghi chú bàn giao cho ca sau..."
                                  class="w-full px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-xs text-gray-200 transition placeholder-gray-500 shadow-inner"></textarea>
                    </div>

                    <button type="submit"
                            class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold py-3 px-4 rounded-xl shadow-lg border border-[#8a6a09] transition uppercase tracking-widest text-sm">
                        Xác Nhận Đóng Ca &amp; Đăng Xuất
                    </button>
                </form>
                <button type="button" onclick="closeCloseShiftModal()"
                        class="w-full mt-2.5 text-gray-400 hover:text-white text-xs py-1.5 transition">
                    Hủy bỏ
                </button>
            </div>
        </div>
    </div>

    <!-- CHUYỂN BÀN & GỘP BILL MODAL -->
    <div id="mergeModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
        <div class="w-full max-w-[420px] wood-frame rounded-2xl p-1 shadow-2xl relative animate-float">
            <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>
            <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>

            <div class="inner-felt rounded-xl p-6">
                <h3 class="font-classic text-xl font-bold text-white text-center gold-text-emboss">Chuyển Bàn &amp; Gộp Bill</h3>
                <p class="text-xs text-gray-400 text-center mt-1 mb-4">Chọn bàn đích để chuyển bàn chơi hoặc gộp hóa đơn.</p>

                <div id="merge-target-list" class="flex flex-col gap-2 max-h-[320px] overflow-y-auto pr-1 mb-4"></div>

                <button type="button" id="merge-submit-btn" onclick="submitMerge()" disabled
                        class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold py-3 px-4 rounded-xl shadow-lg border border-[#8a6a09] transition uppercase tracking-widest text-sm disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:from-[#d4af37]">
                    Xác Nhận Chuyển
                </button>
                <button type="button" onclick="closeMergeModal()"
                        class="w-full mt-3 text-gray-400 hover:text-white text-sm py-2 transition">
                    Hủy bỏ
                </button>
            </div>
        </div>
    </div>

    <!-- PAYMENT METHOD SELECT MODAL -->
    <div id="paymentModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
        <div class="w-full max-w-[420px] wood-frame rounded-2xl p-1 shadow-2xl relative animate-float">
            <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>
            <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/70"></div>

            <div class="inner-felt rounded-xl p-8 text-center">
                <h3 class="font-classic text-2xl font-bold text-white mb-2 gold-text-emboss">Hình Thức Thanh Toán</h3>
                <div class="h-px bg-gold-dark/20 w-32 mx-auto my-4"></div>
                <p class="text-xs text-gray-300 mb-6">Chọn phương thức thanh toán cho bàn bida hiện tại.</p>

                <!-- Member Lookup by Phone -->
                <div class="text-left mb-4">
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Thành viên / Khách hàng</label>
                    <div class="flex gap-2">
                        <input type="tel" id="checkout-member-phone" placeholder="SĐT thành viên (bỏ trống nếu khách vãng lai)"
                               oninput="onMemberPhoneInputChanged()"
                               class="flex-1 min-w-0 px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-sm text-gold-light">
                        <button type="button" onclick="lookupMemberByPhone()"
                                class="flex-shrink-0 px-3 py-2 rounded-xl bg-gold-dark/20 border border-gold-dark/40 text-gold-light text-xs font-bold hover:bg-gold-dark/30 transition">
                            🔍 Tìm
                        </button>
                    </div>
                    <input type="hidden" id="checkout-member-id" value="">
                    <div id="member-lookup-result" class="mt-2 text-xs"></div>
                </div>

                <!-- Quick Membership Registration (first-time customers) -->
                <div class="text-left mb-4 bg-black/25 border border-gold-dark/15 rounded-xl p-3">
                    <p class="text-[11px] text-gray-400 mb-2">Khách lần đầu tới chơi? Đăng ký thẻ thành viên nhanh:</p>
                    <div class="flex flex-col gap-2">
                        <input type="text" id="new-member-name" placeholder="Họ tên khách hàng"
                               class="w-full px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-sm text-gold-light">
                        <input type="tel" id="new-member-phone" placeholder="Số điện thoại"
                               class="w-full px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-sm text-gold-light">
                        <button type="button" onclick="quickRegisterMember()"
                                class="w-full py-2 rounded-xl bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] text-wood-dark text-xs font-bold uppercase tracking-wider transition">
                            + Đăng Ký Thẻ Thành Viên
                        </button>
                    </div>
                    <div id="quick-register-result" class="mt-2 text-xs"></div>
                </div>

                <!-- Discount Selector -->
                <div class="text-left mb-4">
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Mức giảm giá bàn (%)</label>
                    <select id="checkout-discount-select" onchange="applyMemberDiscount()"
                            class="w-full px-3 py-2 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base text-sm text-gold-light disabled:opacity-50 disabled:cursor-not-allowed">
                        <option value="0">0% (Không giảm giá)</option>
                        <option value="5">5% (Từ 300 điểm tích lũy)</option>
                        <option value="10">10% (Từ 500 điểm tích lũy)</option>
                        <option value="15">15% (Từ 1000 điểm tích lũy)</option>
                        <option value="20">20% (Từ 2000 điểm tích lũy)</option>
                    </select>
                    <p class="text-[10px] text-gray-400 mt-1 italic">* Giảm giá chỉ áp dụng cho khách có thẻ thành viên và đạt đủ điểm tích lũy.</p>
                </div>

                <!-- Receipt details in modal -->
                <div class="bg-black/40 border border-gold-dark/20 rounded-xl p-4 mb-6 text-left text-xs font-mono">
                    <div class="flex justify-between py-1">
                        <span class="text-gray-400">Tạm tính:</span>
                        <span id="modal-subtotal" class="text-gray-200">0đ</span>
                    </div>
                    <div class="flex justify-between py-1">
                        <span class="text-gray-400">Giảm giá áp dụng:</span>
                        <span id="modal-discount" class="text-gold-base">0đ (0%)</span>
                    </div>
                    <div class="h-px bg-gold-dark/20 my-2"></div>
                    <div class="flex justify-between py-1 text-sm font-bold">
                        <span class="text-gray-300">Tổng cộng:</span>
                        <span id="modal-total" class="text-gold-light">0đ</span>
                    </div>
                    <div class="flex justify-between py-1 text-[10px] text-emerald-400 italic">
                        <span>Điểm thưởng tích lũy:</span>
                        <span id="modal-points-earned">+0 điểm</span>
                    </div>
                </div>

                <div class="flex flex-col gap-4">
                    <button type="button" onclick="submitCheckout('cash')"
                            class="w-full bg-gradient-to-b from-emerald-500 to-emerald-700 hover:from-emerald-400 hover:to-emerald-600 text-white font-classic font-bold py-3.5 px-4 rounded-xl shadow-lg border border-emerald-600 transition uppercase tracking-widest text-sm">
                        💵 Tiền Mặt
                    </button>
                    
                    <button type="button" onclick="submitCheckout('transfer')"
                            class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold py-3.5 px-4 rounded-xl shadow-lg border border-[#8a6a09] transition uppercase tracking-widest text-sm">
                        💳 Chuyển Khoản (PayOS)
                    </button>
                    
                    <button type="button" onclick="closePaymentModal()"
                            class="w-full bg-black/40 hover:bg-black/60 text-gray-300 font-classic py-2.5 px-4 rounded-xl border border-gold-dark/20 transition text-sm">
                        Hủy bỏ
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>

<!-- =====================================================
     BOOKING NOTIFICATION SYSTEM — SSE Toast
     ===================================================== -->
<style>
    /* Toast container */
    #notif-container {
        position: fixed; bottom: 24px; right: 24px;
        display: flex; flex-direction: column-reverse; gap: 12px;
        z-index: 9999; pointer-events: none;
        max-width: 360px;
    }
    .notif-toast {
        pointer-events: all;
        background: linear-gradient(145deg, rgba(20,40,25,0.98), rgba(8,18,12,0.98));
        border: 1px solid rgba(212,175,55,0.35);
        border-radius: 16px;
        padding: 16px 18px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.6), 0 0 0 1px rgba(212,175,55,0.08);
        display: flex; gap: 12px; align-items: flex-start;
        animation: toastSlideIn 0.4s cubic-bezier(0.34,1.56,0.64,1) both;
        font-family: 'Inter', sans-serif;
        position: relative; overflow: hidden;
    }
    .notif-toast.hiding {
        animation: toastSlideOut 0.35s ease-in both;
    }
    @keyframes toastSlideIn {
        from { opacity: 0; transform: translateX(110%) scale(0.9); }
        to   { opacity: 1; transform: translateX(0) scale(1); }
    }
    @keyframes toastSlideOut {
        from { opacity: 1; transform: translateX(0); }
        to   { opacity: 0; transform: translateX(110%); }
    }
    /* Progress bar at bottom */
    .notif-progress {
        position: absolute; bottom: 0; left: 0;
        height: 3px;
        background: linear-gradient(90deg, #d4af37, #f9e596);
        border-radius: 0 0 16px 16px;
        animation: progressShrink 8s linear forwards;
    }
    @keyframes progressShrink {
        from { width: 100%; }
        to   { width: 0%; }
    }
    /* Bell pulse icon */
    .notif-bell {
        width: 42px; height: 42px; border-radius: 12px; flex-shrink: 0;
        background: rgba(212,175,55,0.12);
        border: 1px solid rgba(212,175,55,0.25);
        display: flex; align-items: center; justify-content: center;
        font-size: 20px;
        animation: bellPulse 1.2s ease-in-out 2;
    }
    @keyframes bellPulse {
        0%,100% { transform: rotate(0); }
        15%      { transform: rotate(12deg); }
        30%      { transform: rotate(-12deg); }
        45%      { transform: rotate(8deg); }
        60%      { transform: rotate(-8deg); }
    }
    .notif-body { flex: 1; min-width: 0; }
    .notif-header { font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(212,175,55,0.7); margin-bottom: 4px; }
    .notif-name { font-size: 14px; font-weight: 700; color: #f9e596; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .notif-detail { font-size: 12px; color: rgba(209,213,219,0.8); margin-top: 2px; line-height: 1.5; }
    .notif-detail strong { color: #d4af37; }
    .notif-actions { display: flex; gap: 7px; margin-top: 10px; }
    .notif-btn-view {
        font-size: 11.5px; font-weight: 600; padding: 5px 12px; border-radius: 8px;
        background: linear-gradient(180deg,#d4af37,#aa8511); color: #1e110a;
        border: none; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;
        transition: filter 0.15s;
    }
    .notif-btn-view:hover { filter: brightness(1.15); }
    .notif-btn-close {
        font-size: 11.5px; font-weight: 600; padding: 5px 10px; border-radius: 8px;
        background: rgba(100,116,139,0.15); color: #94a3b8;
        border: 1px solid rgba(100,116,139,0.25); cursor: pointer;
        transition: background 0.15s;
    }
    .notif-btn-close:hover { background: rgba(100,116,139,0.3); }
    /* Badge on booking button in header */
    .notif-badge {
        display: inline-flex; align-items: center; justify-content: center;
        background: #ef4444; color: white;
        font-size: 10px; font-weight: 800;
        width: 17px; height: 17px; border-radius: 50%;
        margin-left: 5px; vertical-align: top;
        animation: badgePop 0.4s cubic-bezier(0.34,1.56,0.64,1);
    }
    @keyframes badgePop { from{transform:scale(0)} to{transform:scale(1)} }
</style>

<div id="notif-container"></div>

<script>
(function () {
    const ctx = '${pageContext.request.contextPath}';
    let lastSince = 0;    // 0 → SSE init will set to server time
    let pendingCount = 0;
    const container = document.getElementById('notif-container');

    function showToast(data) {
        const isPrepaid = (data.paymentType === 'Trả trước');
        const headerTitle = isPrepaid ? '💳 ĐÃ THANH TOÁN ONLINE (PayOS)' : '📅 Đặt Bàn Mới (Trả Sau)';
        const statusNote = isPrepaid ? '<div class="text-xs font-bold text-emerald-400 mt-1">✓ Khách đã thanh toán • Thao tác chờ duyệt</div>' : '<div class="text-xs text-amber-400 mt-1">Thao tác chờ duyệt</div>';

        const toast = document.createElement('div');
        toast.className = 'notif-toast';
        toast.innerHTML =
            '<div class="notif-bell">' + (isPrepaid ? '💳' : '🔔') + '</div>' +
            '<div class="notif-body">' +
                '<div class="notif-header">' + headerTitle + '</div>' +
                '<div class="notif-name">' + escHtml(data.customerName) + '</div>' +
                '<div class="notif-detail">' +
                    '<strong>' + escHtml(data.tableName) + '</strong> &bull; ' +
                    escHtml(data.playTime) + ' &bull; ' +
                    '<strong>' + data.duration + 'h</strong>' +
                '</div>' +
                statusNote +
                '<div class="notif-actions mt-2">' +
                    '<a href="' + ctx + '/employee/duyetdatban" class="notif-btn-view">' +
                        '<i class="fas fa-calendar-check"></i> Xem Duyệt' +
                    '</a>' +
                    '<button class="notif-btn-close" onclick="dismissToast(this.closest(\'.notif-toast\'))">' +
                        'Bỏ qua' +
                    '</button>' +
                '</div>' +
            '</div>' +
            '<div class="notif-progress"></div>';
        container.appendChild(toast);
        // Auto dismiss after 10s
        setTimeout(() => dismissToast(toast), 10000);

        // Update badge on header booking button
        pendingCount++;
        updateBadge();
    }

    function dismissToast(toast) {
        if (!toast || toast.classList.contains('hiding')) return;
        toast.classList.add('hiding');
        toast.addEventListener('animationend', () => toast.remove(), { once: true });
    }

    function updateBadge() {
        const btns = document.querySelectorAll('a[href*="duyetdatban"]');
        btns.forEach(btn => {
            let badge = btn.querySelector('.notif-badge');
            if (!badge) {
                badge = document.createElement('span');
                badge.className = 'notif-badge';
                btn.appendChild(badge);
            }
            badge.textContent = pendingCount > 9 ? '9+' : pendingCount;
        });
    }

    function escHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function connectSSE() {
        if (!window.EventSource) return; // old browser fallback
        const url = ctx + '/notify/stream?since=' + lastSince;
        const es = new EventSource(url);

        es.addEventListener('booking', function(e) {
            try {
                const data = JSON.parse(e.data);
                lastSince = Math.max(lastSince, data.timestamp || 0);
                showToast(data);
            } catch(err) { /* ignore parse error */ }
        });

        es.onerror = function() {
            es.close();
            // Reconnect after 3s (browser would do this automatically, but
            // we also update 'since' so we need our own reconnect)
            setTimeout(connectSSE, 3000);
        };

        // The SSE servlet closes after 25s; onerror fires → we reconnect.
        // That's the normal flow — no extra handling needed.
    }

    // Start SSE when page is visible
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', connectSSE);
    } else {
        connectSSE();
    }
})();
</script>
</html>
