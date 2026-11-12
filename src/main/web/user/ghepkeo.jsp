<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    request.setAttribute("timeFormatter", DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
%>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Ghép Kèo</title>
    <%@ include file="../common/head.jsp" %>
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
        <a href="${pageContext.request.contextPath}/user/thongtincanhan"
           class="flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium text-yellow-500/70 hover:text-yellow-300 hover:bg-yellow-900/20 transition-all">
            <i class="fas fa-id-card text-xs"></i>
            <span class="hidden sm:inline">Thông Tin Cá Nhân</span>
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
<div class="max-w-6xl mx-auto px-4 py-10">

    <!-- Header -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
        <div>
            <div class="font-classic text-xs tracking-[0.25em] text-yellow-600/50 uppercase mb-1">Cộng Đồng Bida</div>
            <h1 id="page-title" class="font-classic text-2xl font-bold text-white">Danh Sách Người Chơi Ghép Kèo</h1>
            <div style="width:40px;height:1px;background:linear-gradient(90deg,transparent,#d4af37,transparent);margin-top:10px;"></div>
            <p id="page-subtitle" class="font-body text-sm text-gray-400 mt-3">Đăng ký hồ sơ để tìm đối thủ cùng trình, hoặc xem thông tin người chơi khác để liên hệ ghép kèo.</p>
        </div>
        <button type="button" id="btn-header-action" onclick="openRegisterModal()"
                class="flex items-center gap-2 px-5 py-2.5 rounded-xl font-body font-semibold text-sm transition-all flex-shrink-0"
                style="background:linear-gradient(180deg,#d4af37,#aa8511);color:#1e110a;box-shadow:0 4px 15px rgba(0,0,0,0.3);border:1px solid #8a6a09;"
                onmouseover="this.style.background='linear-gradient(180deg,#f9e596,#d4af37)'"
                onmouseout="this.style.background='linear-gradient(180deg,#d4af37,#aa8511)'">
            <i class="fas fa-people-arrows"></i> <span id="btn-header-action-text">Ghép Kèo</span>
        </button>
    </div>

    <!-- Main Tab Switcher -->
    <div class="flex gap-2 mb-8 border-b border-gold-dark/15">
        <button type="button" id="tab-btn-players" onclick="switchMainTab('players')"
                class="px-4 py-2.5 text-sm font-semibold transition-all border-b-2"
                style="color:#f9e596;border-color:#d4af37;">
            <i class="fas fa-users mr-1.5"></i>Danh Sách Người Chơi
        </button>
        <button type="button" id="tab-btn-matches" onclick="switchMainTab('matches')"
                class="px-4 py-2.5 text-sm font-semibold transition-all border-b-2"
                style="color:rgba(249,229,150,0.4);border-color:transparent;">
            <i class="fas fa-clock mr-1.5"></i>Kèo Theo Giờ
        </button>
    </div>

    <!-- Toast thông báo -->
    <c:if test="${not empty sessionScope.message}">
        <div class="flex items-center gap-3 px-5 py-4 rounded-xl mb-6 font-body text-sm"
             style="background:rgba(34,197,94,0.12);border:1px solid rgba(34,197,94,0.3);color:#86efac;">
            <i class="fas fa-circle-check text-base flex-shrink-0"></i>
            <span>${sessionScope.message}</span>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="flex items-center gap-3 px-5 py-4 rounded-xl mb-6 font-body text-sm"
             style="background:rgba(239,68,68,0.12);border:1px solid rgba(239,68,68,0.3);color:#f87171;">
            <i class="fas fa-circle-exclamation text-base flex-shrink-0"></i>
            <span>${sessionScope.error}</span>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- ═══════════ TAB: DANH SÁCH NGƯỜI CHƠI ═══════════ -->
    <div id="content-players">

    <!-- Hồ Sơ Ghép Kèo Của Bạn (hiện ngay sau khi lưu thông tin) -->
    <c:if test="${not empty myProfile}">
        <div class="rounded-2xl p-5 mb-8 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4"
             style="background:linear-gradient(145deg,rgba(212,175,55,0.12),rgba(212,175,55,0.03));border:1px solid rgba(212,175,55,0.35);box-shadow:0 8px 25px rgba(0,0,0,0.25);">
            <div class="flex items-center gap-4">
                <div style="background:linear-gradient(135deg,#d4af37,#997a15);padding:2px;border-radius:50%;flex-shrink:0;">
                    <div style="background:#1a4a2e;border-radius:50%;width:52px;height:52px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:20px;color:#d4af37;">
                        ${fn:toUpperCase(fn:substring(myProfile.fullName, 0, 1))}
                    </div>
                </div>
                <div>
                    <div class="text-[11px] uppercase tracking-widest text-gold-base/70 mb-1 font-classic">
                        <i class="fas fa-circle-check mr-1"></i>Hồ Sơ Ghép Kèo Của Bạn
                    </div>
                    <div class="font-classic font-bold text-white text-lg">
                        ${myProfile.fullName}
                        <span class="text-sm text-gray-400 font-body font-normal">(${myProfile.age} tuổi)</span>
                    </div>
                    <div class="flex flex-wrap items-center gap-3 mt-1.5">
                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                              style="background:rgba(212,175,55,0.12);color:#d4af37;border:1px solid rgba(212,175,55,0.3);">
                            <i class="fas fa-ranking-star text-[10px]"></i> ${myProfile.rank}
                        </span>
                        <span class="text-sm text-gold-light font-mono">
                            <i class="fas fa-comment-dots text-xs mr-1"></i>${myProfile.zaloPhone}
                        </span>
                    </div>
                </div>
            </div>
            <div class="flex items-center gap-2 flex-shrink-0">
                <button type="button" onclick="openRegisterModal()"
                        class="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all"
                        style="background:rgba(212,175,55,0.1);border:1px solid rgba(212,175,55,0.3);color:#d4af37;"
                        onmouseover="this.style.background='rgba(212,175,55,0.2)'"
                        onmouseout="this.style.background='rgba(212,175,55,0.1)'">
                    <i class="fas fa-pen"></i> Chỉnh Sửa
                </button>
                <a href="${pageContext.request.contextPath}/user/thongtincanhan"
                   class="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all"
                   style="background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.25);color:#c4b5fd;">
                    <i class="fas fa-id-card"></i> Thông Tin Cá Nhân
                </a>
            </div>
        </div>
    </c:if>

    <!-- Player Grid -->
    <c:choose>
        <c:when test="${empty playerList}">
            <div class="rounded-2xl text-center py-20 px-6" style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);box-shadow:0 10px 30px rgba(0,0,0,0.4);">
                <div class="text-6xl mb-5 opacity-40">🎱</div>
                <h3 class="font-classic text-xl text-yellow-200/60 font-semibold mb-2">Chưa có người chơi nào đăng ký</h3>
                <p class="font-body text-sm text-gray-500 mb-6">Hãy là người đầu tiên đăng ký hồ sơ Ghép Kèo!</p>
                <button type="button" onclick="openRegisterModal()"
                        class="inline-flex items-center gap-2 px-6 py-3 rounded-xl font-body font-semibold text-sm"
                        style="background:rgba(212,175,55,0.15);border:1px solid rgba(212,175,55,0.3);color:#d4af37;">
                    <i class="fas fa-people-arrows"></i> Ghép Kèo Ngay
                </button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="flex items-center justify-between mb-4">
                <h3 class="font-classic text-sm font-bold text-gold-base/80 uppercase tracking-widest">
                    <i class="fas fa-users mr-1.5"></i>Danh sách người chơi (${playerCount})
                </h3>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                <c:forEach var="p" items="${playerList}">
                    <c:set var="pAcc" value="${playerAccountMap[p.accountId]}"/>
                    <div class="rounded-2xl p-5 flex flex-col gap-3"
                         style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);box-shadow:0 8px 25px rgba(0,0,0,0.35);">
                        <div class="flex items-center gap-3">
                            <div style="background:linear-gradient(135deg,#d4af37,#997a15);padding:2px;border-radius:50%;flex-shrink:0;">
                                <div style="background:#1a4a2e;border-radius:50%;width:44px;height:44px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:16px;color:#d4af37;">
                                    ${fn:toUpperCase(fn:substring(p.fullName, 0, 1))}
                                </div>
                            </div>
                            <div class="min-w-0">
                                <div class="font-classic font-bold text-white text-base truncate">
                                    ${p.fullName}
                                    <c:if test="${p.accountId == sessionScope.account.id}">
                                        <span class="text-[10px] font-body font-normal" style="color:#c4b5fd;">(Bạn)</span>
                                    </c:if>
                                </div>
                                <div class="text-xs text-gray-400">${p.age} tuổi</div>
                            </div>
                        </div>
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                  style="background:rgba(212,175,55,0.12);color:#d4af37;border:1px solid rgba(212,175,55,0.3);">
                                <i class="fas fa-ranking-star text-[10px]"></i> ${p.rank}
                            </span>
                            <c:if test="${not empty pAcc.playingStyle}">
                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                      style="background:rgba(59,130,246,0.12);color:#93c5fd;border:1px solid rgba(59,130,246,0.25);">
                                    <i class="fas fa-hand-fist text-[10px]"></i> ${pAcc.playingStyle}
                                </span>
                            </c:if>
                            <c:if test="${not empty pAcc and pAcc.points > 0}">
                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                                      style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.25);">
                                    <i class="fas fa-trophy text-[10px]"></i> ${pAcc.points} điểm
                                </span>
                            </c:if>
                        </div>

                        <!-- Thông tin chi tiết hiển thị ngay trong danh sách -->
                        <div class="flex flex-col gap-1.5 text-xs pt-1" style="border-top:1px solid rgba(212,175,55,0.12);">
                            <div class="flex items-center justify-between pt-2">
                                <span class="text-gray-500 uppercase tracking-wider">Zalo</span>
                                <span class="font-mono text-gold-light">${p.zaloPhone}</span>
                            </div>
                            <c:if test="${not empty pAcc.phone}">
                                <div class="flex items-center justify-between">
                                    <span class="text-gray-500 uppercase tracking-wider">Điện thoại</span>
                                    <span class="font-mono text-gray-300">${pAcc.phone}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty p.createdAt}">
                                <div class="flex items-center justify-between">
                                    <span class="text-gray-500 uppercase tracking-wider">Tham gia</span>
                                    <span class="font-mono text-gray-300">${p.createdAt.format(timeFormatter)}</span>
                                </div>
                            </c:if>
                        </div>
                        <button type="button"
                                onclick="openDetailModal('${fn:escapeXml(p.fullName)}', ${p.age}, '${fn:escapeXml(p.rank)}', '${fn:escapeXml(p.zaloPhone)}', '${fn:escapeXml(pAcc.playingStyle)}')"
                                class="mt-1 w-full flex items-center justify-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all"
                                style="background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.25);color:#c4b5fd;"
                                onmouseover="this.style.background='rgba(139,92,246,0.22)'"
                                onmouseout="this.style.background='rgba(139,92,246,0.1)'">
                            <i class="fas fa-circle-info"></i> Xem Chi Tiết
                        </button>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    </div>
    <!-- ═══════════ END TAB: DANH SÁCH NGƯỜI CHƠI ═══════════ -->

    <!-- ═══════════ TAB: KÈO THEO GIỜ ═══════════ -->
    <div id="content-matches" class="hidden">

        <!-- Sub Tab Switcher -->
        <div class="flex gap-2 mb-6">
            <button type="button" id="subtab-btn-open" onclick="switchSubTab('open')"
                    class="px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition-all"
                    style="background:rgba(212,175,55,0.15);border:1px solid rgba(212,175,55,0.3);color:#d4af37;">
                <i class="fas fa-magnifying-glass mr-1"></i>Kèo Đang Tìm Bạn Chơi
            </button>
            <button type="button" id="subtab-btn-mine" onclick="switchSubTab('mine')"
                    class="px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition-all"
                    style="background:rgba(139,92,246,0.08);border:1px solid rgba(139,92,246,0.2);color:#c4b5fd;">
                <i class="fas fa-user mr-1"></i>Kèo Của Tôi
            </button>
        </div>

        <!-- OPEN MATCHES -->
        <div id="subcontent-open">
            <c:choose>
                <c:when test="${empty openMatches}">
                    <div class="rounded-2xl text-center py-16 px-6" style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);">
                        <div class="text-5xl mb-4 opacity-40">🀄</div>
                        <h3 class="font-classic text-lg text-yellow-200/60 font-semibold mb-2">Chưa có kèo nào đang chờ</h3>
                        <p class="font-body text-sm text-gray-500">Hãy là người đầu tiên lập kèo!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                        <c:forEach var="m" items="${openMatches}">
                            <div class="rounded-2xl p-5 flex flex-col gap-3"
                                 style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);box-shadow:0 8px 25px rgba(0,0,0,0.35);">
                                <div class="flex items-center justify-between">
                                    <div class="font-classic font-bold text-white text-base">${m.hostName}</div>
                                    <span class="text-xs text-gold-light font-mono">${m.playTime.format(timeFormatter)}</span>
                                </div>
                                <div class="inline-flex items-center gap-1.5 self-start px-2.5 py-1 rounded-full text-[11px] font-semibold"
                                     style="background:rgba(234,179,8,0.12);color:#fde047;border:1px solid rgba(234,179,8,0.3);">
                                    <span class="relative flex h-1.5 w-1.5">
                                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-yellow-400 opacity-75"></span>
                                        <span class="relative inline-flex rounded-full h-1.5 w-1.5 bg-yellow-400"></span>
                                    </span>
                                    Đang Chờ Ghép Với Khách Hàng Khác
                                </div>
                                <div class="flex flex-wrap gap-2">
                                    <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold" style="background:rgba(59,130,246,0.12);color:#93c5fd;border:1px solid rgba(59,130,246,0.25);">
                                        <i class="fas fa-table-cells"></i> ${m.tableType}
                                    </span>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold" style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.25);">
                                        <i class="fas fa-trophy"></i> ${m.format}
                                    </span>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold" style="background:rgba(212,175,55,0.12);color:#d4af37;border:1px solid rgba(212,175,55,0.3);">
                                        <i class="fas fa-ranking-star"></i> ${m.rankRequirement}
                                    </span>
                                </div>
                                <c:if test="${not empty m.note}">
                                    <p class="text-xs text-gray-400 italic">"${m.note}"</p>
                                </c:if>
                                <c:choose>
                                    <c:when test="${m.accountId == sessionScope.account.id}">
                                        <div class="mt-1 text-center text-xs font-semibold py-2 rounded-lg" style="background:rgba(139,92,246,0.08);color:#c4b5fd;border:1px solid rgba(139,92,246,0.2);">
                                            <i class="fas fa-crown mr-1"></i>Kèo Của Bạn
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/user/ghepkeo" method="post">
                                            <input type="hidden" name="action" value="joinMatch">
                                            <input type="hidden" name="matchId" value="${m.id}">
                                            <button type="submit" onclick="return confirm('Tham gia kèo này?')"
                                                    class="mt-1 w-full flex items-center justify-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all"
                                                    style="background:rgba(212,175,55,0.15);border:1px solid rgba(212,175,55,0.3);color:#d4af37;">
                                                <i class="fas fa-handshake"></i> Tham Gia
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- MY MATCHES -->
        <div id="subcontent-mine" class="hidden">
            <h4 class="font-classic text-sm font-bold text-gold-base/80 uppercase tracking-widest mb-3">Kèo Bạn Đã Lập</h4>
            <c:choose>
                <c:when test="${empty myHostedMatches}">
                    <p class="text-sm text-gray-500 italic mb-8">Bạn chưa lập kèo nào.</p>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 mb-8">
                        <c:forEach var="m" items="${myHostedMatches}">
                            <div class="rounded-2xl p-5 flex flex-col gap-3"
                                 style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs text-gold-light font-mono">${m.playTime.format(timeFormatter)}</span>
                                    <c:choose>
                                        <c:when test="${m.status == 'Waiting'}">
                                            <span class="text-[11px] font-bold uppercase px-2 py-0.5 rounded-full" style="background:rgba(234,179,8,0.12);color:#fde047;border:1px solid rgba(234,179,8,0.3);">Đang Chờ Ghép Với Khách Khác</span>
                                        </c:when>
                                        <c:when test="${m.status == 'Matched'}">
                                            <span class="text-[11px] font-bold uppercase px-2 py-0.5 rounded-full" style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.3);">Đã Ghép</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-[11px] font-bold uppercase px-2 py-0.5 rounded-full" style="background:rgba(239,68,68,0.12);color:#f87171;border:1px solid rgba(239,68,68,0.3);">Đã Hủy</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex flex-wrap gap-2 text-[11px] text-gray-300">
                                    <span>${m.tableType}</span> &bull; <span>${m.format}</span> &bull; <span>${m.rankRequirement}</span>
                                </div>
                                <c:if test="${m.status == 'Matched' and not empty m.partnerName}">
                                    <div class="text-xs text-gray-300">Đối thủ: <span class="font-semibold text-white">${m.partnerName}</span>
                                        <c:if test="${not empty m.partnerZalo}"> &mdash; Zalo: <span class="font-mono text-gold-light">${m.partnerZalo}</span></c:if>
                                    </div>
                                </c:if>
                                <c:if test="${m.status == 'Waiting'}">
                                    <form action="${pageContext.request.contextPath}/user/ghepkeo" method="post">
                                        <input type="hidden" name="action" value="cancelMatch">
                                        <input type="hidden" name="matchId" value="${m.id}">
                                        <button type="submit" onclick="return confirm('Hủy kèo này?')"
                                                class="mt-1 w-full flex items-center justify-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all"
                                                style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.25);color:#f87171;">
                                            <i class="fas fa-ban"></i> Hủy Kèo
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <h4 class="font-classic text-sm font-bold text-gold-base/80 uppercase tracking-widest mb-3">Kèo Bạn Đã Tham Gia</h4>
            <c:choose>
                <c:when test="${empty myJoinedMatches}">
                    <p class="text-sm text-gray-500 italic">Bạn chưa tham gia kèo nào.</p>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                        <c:forEach var="m" items="${myJoinedMatches}">
                            <div class="rounded-2xl p-5 flex flex-col gap-3"
                                 style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.12);">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs text-gold-light font-mono">${m.playTime.format(timeFormatter)}</span>
                                    <span class="text-[11px] font-bold uppercase px-2 py-0.5 rounded-full" style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.3);">Đã Ghép</span>
                                </div>
                                <div class="flex flex-wrap gap-2 text-[11px] text-gray-300">
                                    <span>${m.tableType}</span> &bull; <span>${m.format}</span> &bull; <span>${m.rankRequirement}</span>
                                </div>
                                <div class="text-xs text-gray-300">Chủ kèo: <span class="font-semibold text-white">${m.hostName}</span>
                                    <c:if test="${not empty m.hostZalo}"> &mdash; Zalo: <span class="font-mono text-gold-light">${m.hostZalo}</span></c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <!-- ═══════════ END TAB: KÈO THEO GIỜ ═══════════ -->

    <!-- Footer -->
    <div class="text-center mt-10 font-classic text-xs tracking-widest uppercase" style="color:rgba(156,163,175,0.4);">
        Est. 2024 &bull; H.N.D.D Management System
    </div>
</div>

<!-- REGISTER / UPDATE PROFILE MODAL -->
<div id="registerModal" class="fixed inset-0 bg-black/85 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="w-full max-w-[460px] rounded-2xl p-1 shadow-2xl relative"
         style="background:linear-gradient(180deg,#4e342e,#2c1810);border:1px solid rgba(212,175,55,0.25);">
        <div class="rounded-xl p-8" style="background:#0c2617;">
            <div class="flex items-center justify-between mb-1">
                <h3 class="font-classic text-xl font-bold text-white">
                    <i class="fas fa-people-arrows mr-2" style="color:#d4af37;"></i>Ghép Kèo
                </h3>
                <button type="button" onclick="closeRegisterModal()" class="text-gray-400 hover:text-white text-lg">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <p class="text-xs text-gray-400 mb-6">Điền thông tin để xuất hiện trong danh sách người chơi tìm kèo. Gửi lại form sẽ cập nhật hồ sơ hiện có của bạn.</p>

            <form action="${pageContext.request.contextPath}/user/ghepkeo" method="post" class="flex flex-col gap-4">
                <input type="hidden" name="action" value="register">

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Họ Và Tên</label>
                    <input type="text" name="fullName" id="reg-fullName" required maxlength="150"
                           value="${fn:escapeXml(myProfile.fullName)}"
                           placeholder="Nhập họ và tên của bạn..."
                           class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Tuổi</label>
                    <input type="number" name="age" id="reg-age" required min="1" max="120"
                           value="${empty myProfile ? '' : myProfile.age}"
                           placeholder="Nhập tuổi của bạn..."
                           class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Hạng (Rank)</label>
                    <select name="rank" id="reg-rank" required
                            class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                        <option value="Nghiệp dư">Nghiệp dư</option>
                        <option value="Bán chuyên">Bán chuyên</option>
                        <option value="Chuyên nghiệp">Chuyên nghiệp</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Số Zalo</label>
                    <input type="tel" name="zaloPhone" id="reg-zaloPhone" required maxlength="30"
                           value="${fn:escapeXml(myProfile.zaloPhone)}"
                           placeholder="Nhập số Zalo để người khác liên hệ..."
                           class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
                </div>

                <button type="submit"
                        class="w-full mt-2 font-classic font-bold text-base py-3.5 px-4 rounded-xl shadow-lg transition uppercase tracking-widest border"
                        style="background:linear-gradient(180deg,#d4af37,#aa8511);color:#1e110a;border-color:#8a6a09;">
                    Lưu Thông Tin
                </button>
            </form>
        </div>
    </div>
</div>

<!-- PLAYER DETAIL MODAL -->
<div id="detailModal" class="fixed inset-0 bg-black/85 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="w-full max-w-[400px] rounded-2xl p-1 shadow-2xl relative"
         style="background:linear-gradient(180deg,#4e342e,#2c1810);border:1px solid rgba(212,175,55,0.25);">
        <div class="rounded-xl p-8 text-center" style="background:#0c2617;">
            <button type="button" onclick="closeDetailModal()" class="absolute top-5 right-5 text-gray-400 hover:text-white text-lg">
                <i class="fas fa-times"></i>
            </button>

            <div style="background:linear-gradient(135deg,#d4af37,#997a15);padding:3px;border-radius:50%;margin:0 auto 16px;width:72px;height:72px;">
                <div style="background:#1a4a2e;border-radius:50%;width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:26px;color:#d4af37;" id="detail-avatar">
                    A
                </div>
            </div>

            <h3 id="detail-fullName" class="font-classic text-xl font-bold text-white mb-1">--</h3>
            <p id="detail-age" class="text-sm text-gray-400 mb-4">--</p>

            <div class="h-px bg-gold-dark/20 my-2"></div>

            <div class="text-left mt-4 flex flex-col gap-3">
                <div class="flex items-center justify-between">
                    <span class="text-xs text-gray-400 uppercase tracking-wider">Hạng</span>
                    <span id="detail-rank" class="text-sm font-semibold" style="color:#d4af37;">--</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-xs text-gray-400 uppercase tracking-wider">Phong cách</span>
                    <span id="detail-style" class="text-sm font-semibold" style="color:#93c5fd;">--</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-xs text-gray-400 uppercase tracking-wider">Số Zalo</span>
                    <span id="detail-zalo" class="text-sm font-semibold text-gold-light font-mono">--</span>
                </div>
            </div>

            <a id="detail-zalo-link" href="#" target="_blank" rel="noopener"
               class="mt-6 w-full flex items-center justify-center gap-2 px-4 py-3 rounded-xl text-sm font-semibold transition-all"
               style="background:rgba(59,130,246,0.15);border:1px solid rgba(59,130,246,0.35);color:#93c5fd;">
                <i class="fas fa-comment-dots"></i> Nhắn Zalo
            </a>
        </div>
    </div>
</div>

<!-- LẬP KÈO MỚI MODAL -->
<div id="createMatchModal" class="fixed inset-0 bg-black/85 backdrop-blur-md z-50 hidden flex items-center justify-center p-4">
    <div class="w-full max-w-[460px] rounded-2xl p-1 shadow-2xl relative"
         style="background:linear-gradient(180deg,#4e342e,#2c1810);border:1px solid rgba(212,175,55,0.25);">
        <div class="rounded-xl p-8 max-h-[85vh] overflow-y-auto" style="background:#0c2617;">
            <div class="flex items-center justify-between mb-1">
                <h3 class="font-classic text-xl font-bold text-white">
                    <i class="fas fa-plus mr-2" style="color:#d4af37;"></i>Lập Kèo Mới
                </h3>
                <button type="button" onclick="closeCreateMatchModal()" class="text-gray-400 hover:text-white text-lg">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <p class="text-xs text-gray-400 mb-6">Tạo kèo mới để tìm bạn chơi cùng khung giờ.</p>

            <form action="${pageContext.request.contextPath}/user/ghepkeo" method="post" class="flex flex-col gap-4">
                <input type="hidden" name="action" value="createMatch">

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Ngày Giờ Chơi</label>
                    <input type="datetime-local" name="playTime" id="match-playTime" required
                           class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Loại Bàn</label>
                    <select name="tableType" required
                            class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                        <option value="Bàn lỗ">Bàn lỗ</option>
                        <option value="Bàn phẳng">Bàn phẳng</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Thể Thức</label>
                    <select name="format" required
                            class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                        <option value="Giao lưu">Giao lưu</option>
                        <option value="Thi đấu">Thi đấu</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Yêu Cầu Đối Thủ</label>
                    <select name="rankRequirement" required
                            class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                        <option value="Không giới hạn">Không giới hạn</option>
                        <option value="Nghiệp dư">Nghiệp dư</option>
                        <option value="Bán chuyên">Bán chuyên</option>
                        <option value="Chuyên nghiệp">Chuyên nghiệp</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Ghi Chú Thêm</label>
                    <textarea name="note" rows="3" maxlength="500" placeholder="Ví dụ: Giao lưu vui vẻ, chia tiền giờ sòng phẳng..."
                              class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner resize-none"></textarea>
                </div>

                <button type="submit"
                        class="w-full mt-2 font-classic font-bold text-base py-3.5 px-4 rounded-xl shadow-lg transition uppercase tracking-widest border"
                        style="background:linear-gradient(180deg,#d4af37,#aa8511);color:#1e110a;border-color:#8a6a09;">
                    Xác Nhận Tạo
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    // ── MAIN TAB SWITCHER: Danh Sách Người Chơi / Kèo Theo Giờ ──
    const TAB_ACTIVE_STYLE = 'color:#f9e596;border-color:#d4af37;';
    const TAB_INACTIVE_STYLE = 'color:rgba(249,229,150,0.4);border-color:transparent;';

    function switchMainTab(tab) {
        const isPlayers = tab === 'players';
        document.getElementById('content-players').classList.toggle('hidden', !isPlayers);
        document.getElementById('content-matches').classList.toggle('hidden', isPlayers);

        document.getElementById('tab-btn-players').setAttribute('style', isPlayers ? TAB_ACTIVE_STYLE : TAB_INACTIVE_STYLE);
        document.getElementById('tab-btn-matches').setAttribute('style', !isPlayers ? TAB_ACTIVE_STYLE : TAB_INACTIVE_STYLE);

        if (isPlayers) {
            document.getElementById('page-title').textContent = 'Danh Sách Người Chơi Ghép Kèo';
            document.getElementById('page-subtitle').textContent = 'Đăng ký hồ sơ để tìm đối thủ cùng trình, hoặc xem thông tin người chơi khác để liên hệ ghép kèo.';
            document.getElementById('btn-header-action-text').textContent = 'Ghép Kèo';
            document.getElementById('btn-header-action').setAttribute('onclick', 'openRegisterModal()');
        } else {
            document.getElementById('page-title').textContent = 'Ghép Kèo Theo Giờ';
            document.getElementById('page-subtitle').textContent = 'Lập kèo mới theo khung giờ chơi hoặc tham gia kèo có sẵn của người khác.';
            document.getElementById('btn-header-action-text').textContent = 'Lập Kèo Mới';
            document.getElementById('btn-header-action').setAttribute('onclick', 'openCreateMatchModal()');
        }

        localStorage.setItem('ghepKeoMainTab', tab);
    }

    // ── SUB TAB SWITCHER (within Kèo Theo Giờ): Đang Tìm Bạn Chơi / Kèo Của Tôi ──
    const SUBTAB_ACTIVE_STYLE = 'background:rgba(212,175,55,0.15);border:1px solid rgba(212,175,55,0.3);color:#d4af37;';
    const SUBTAB_INACTIVE_STYLE = 'background:rgba(139,92,246,0.08);border:1px solid rgba(139,92,246,0.2);color:#c4b5fd;';

    function switchSubTab(tab) {
        const isOpen = tab === 'open';
        document.getElementById('subcontent-open').classList.toggle('hidden', !isOpen);
        document.getElementById('subcontent-mine').classList.toggle('hidden', isOpen);
        document.getElementById('subtab-btn-open').setAttribute('style', isOpen ? SUBTAB_ACTIVE_STYLE : SUBTAB_INACTIVE_STYLE);
        document.getElementById('subtab-btn-mine').setAttribute('style', !isOpen ? SUBTAB_ACTIVE_STYLE : SUBTAB_INACTIVE_STYLE);
    }

    // Restore last-used main tab
    (function () {
        const lastTab = localStorage.getItem('ghepKeoMainTab');
        if (lastTab === 'matches') switchMainTab('matches');
    })();

    // ── LẬP KÈO MỚI MODAL ──
    function openCreateMatchModal() {
        const input = document.getElementById('match-playTime');
        if (input && !input.value) {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            input.min = now.toISOString().slice(0, 16);
            input.value = now.toISOString().slice(0, 16);
        }
        document.getElementById('createMatchModal').classList.remove('hidden');
    }
    function closeCreateMatchModal() {
        document.getElementById('createMatchModal').classList.add('hidden');
    }
    document.getElementById('createMatchModal').addEventListener('click', function (e) {
        if (e.target === this) closeCreateMatchModal();
    });

    function openRegisterModal() {
        document.getElementById('registerModal').classList.remove('hidden');
    }
    function closeRegisterModal() {
        document.getElementById('registerModal').classList.add('hidden');
    }

    function openDetailModal(fullName, age, rank, zaloPhone, playingStyle) {
        document.getElementById('detail-avatar').textContent = fullName ? fullName.trim().charAt(0).toUpperCase() : '?';
        document.getElementById('detail-fullName').textContent = fullName;
        document.getElementById('detail-age').textContent = age + ' tuổi';
        document.getElementById('detail-rank').textContent = rank;
        document.getElementById('detail-style').textContent = playingStyle ? playingStyle : 'Chưa cập nhật';
        document.getElementById('detail-zalo').textContent = zaloPhone;
        document.getElementById('detail-zalo-link').href = 'https://zalo.me/' + encodeURIComponent(zaloPhone.replace(/\s+/g, ''));
        document.getElementById('detailModal').classList.remove('hidden');
    }
    function closeDetailModal() {
        document.getElementById('detailModal').classList.add('hidden');
    }

    // Close modals on outside click / Escape
    document.getElementById('registerModal').addEventListener('click', function (e) {
        if (e.target === this) closeRegisterModal();
    });
    document.getElementById('detailModal').addEventListener('click', function (e) {
        if (e.target === this) closeDetailModal();
    });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') { closeRegisterModal(); closeDetailModal(); closeCreateMatchModal(); }
    });

    <c:if test="${not empty myProfile}">
    document.getElementById('reg-rank').value = '${fn:escapeXml(myProfile.rank)}';
    </c:if>

    <%-- Vừa lập kèo xong: nhảy thẳng tới tab "Kèo Của Tôi" để thấy trạng thái đang chờ ghép --%>
    <c:if test="${gotoMyMatches}">
    switchMainTab('matches');
    switchSubTab('mine');
    </c:if>
</script>

</body>
</html>
