<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Thông Tin Cá Nhân</title>
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
        <a href="${pageContext.request.contextPath}/dangnhap?action=logout"
           class="flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-all"
           style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.25);color:#f87171;">
            <i class="fas fa-right-from-bracket text-xs"></i>
        </a>
    </div>
</nav>

<div class="max-w-3xl mx-auto px-4 py-10">

    <!-- Header -->
    <div class="mb-6">
        <div class="font-classic text-xs tracking-[0.25em] text-yellow-600/50 uppercase mb-1">Tài khoản của tôi</div>
        <h1 class="font-classic text-2xl font-bold text-white">Thông Tin Cá Nhân</h1>
        <div style="width:40px;height:1px;background:linear-gradient(90deg,transparent,#d4af37,transparent);margin-top:10px;"></div>
        <p class="font-body text-sm text-gray-400 mt-3">
            Cập nhật thông tin liên hệ và cấp độ chơi của bạn. Thông tin này cũng được dùng
            để hiển thị trong danh sách người chơi ghép kèo.
        </p>
    </div>

    <!-- Toast -->
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

    <!-- Thẻ tóm tắt -->
    <div class="rounded-2xl p-5 mb-8 flex flex-col sm:flex-row items-start sm:items-center gap-4"
         style="background:linear-gradient(145deg,rgba(212,175,55,0.12),rgba(212,175,55,0.03));border:1px solid rgba(212,175,55,0.35);">
        <div style="background:linear-gradient(135deg,#d4af37,#997a15);padding:2px;border-radius:50%;flex-shrink:0;">
            <div style="background:#1a4a2e;border-radius:50%;width:56px;height:56px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:22px;color:#d4af37;">
                <c:choose>
                    <c:when test="${not empty profileAccount.name}">${fn:toUpperCase(fn:substring(profileAccount.name, 0, 1))}</c:when>
                    <c:otherwise>K</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="flex-1">
            <div class="font-classic font-bold text-white text-lg">${profileAccount.name}</div>
            <div class="text-xs text-gray-400 font-mono mt-0.5">@${profileAccount.username}</div>
            <div class="flex flex-wrap items-center gap-2 mt-2">
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                      style="background:rgba(212,175,55,0.12);color:#d4af37;border:1px solid rgba(212,175,55,0.3);">
                    <i class="fas fa-ranking-star text-[10px]"></i>
                    Cấp độ: ${empty profileAccount.memberRank ? 'Chưa cập nhật' : profileAccount.memberRank}
                </span>
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                      style="background:rgba(34,197,94,0.12);color:#86efac;border:1px solid rgba(34,197,94,0.25);">
                    <i class="fas fa-trophy text-[10px]"></i> ${profileAccount.points} điểm
                </span>
                <c:if test="${profileAccount.discountRate > 0}">
                    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold"
                          style="background:rgba(59,130,246,0.12);color:#93c5fd;border:1px solid rgba(59,130,246,0.25);">
                        <i class="fas fa-tag text-[10px]"></i> Giảm ${profileAccount.discountRate}%
                    </span>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Form chỉnh sửa -->
    <form action="${pageContext.request.contextPath}/user/thongtincanhan" method="post"
          class="rounded-2xl p-6 sm:p-8 flex flex-col gap-5"
          style="background:linear-gradient(145deg,rgba(20,55,35,0.85),rgba(6,18,11,0.95));border:1px solid rgba(212,175,55,0.15);box-shadow:0 10px 30px rgba(0,0,0,0.4);">

        <h2 class="font-classic text-base font-bold text-gold-base/90 uppercase tracking-widest">
            <i class="fas fa-id-card mr-2"></i>Thông Tin Liên Hệ
        </h2>

        <div>
            <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Họ Và Tên</label>
            <input type="text" name="name" required maxlength="150"
                   value="${fn:escapeXml(profileAccount.name)}"
                   class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Số Điện Thoại</label>
                <input type="tel" name="phone" required maxlength="30"
                       value="${fn:escapeXml(profileAccount.phone)}"
                       class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
            </div>
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Email</label>
                <input type="email" name="email" required maxlength="150"
                       value="${fn:escapeXml(profileAccount.email)}"
                       class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
            </div>
        </div>

        <div class="h-px bg-gold-dark/20 my-1"></div>

        <h2 class="font-classic text-base font-bold text-gold-base/90 uppercase tracking-widest">
            <i class="fas fa-ranking-star mr-2"></i>Hồ Sơ Người Chơi
        </h2>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Cấp Độ (Hạng)</label>
                <select name="memberRank" id="memberRank" required
                        class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                    <option value="Nghiệp dư">Nghiệp dư</option>
                    <option value="Bán chuyên">Bán chuyên</option>
                    <option value="Chuyên nghiệp">Chuyên nghiệp</option>
                </select>
            </div>
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Phong Cách Chơi</label>
                <select name="playingStyle" id="playingStyle"
                        class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition shadow-inner">
                    <option value="">-- Chưa chọn --</option>
                    <option value="Giải trí">Giải trí</option>
                    <option value="Thi đấu">Thi đấu</option>
                    <option value="Tấn công">Tấn công</option>
                    <option value="Phòng thủ">Phòng thủ</option>
                </select>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Tuổi</label>
                <input type="number" name="age" min="1" max="120"
                       value="${empty myProfile ? '' : myProfile.age}"
                       placeholder="Nhập tuổi của bạn..."
                       class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
            </div>
            <div>
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">Số Zalo</label>
                <input type="tel" name="zaloPhone" maxlength="30"
                       value="${empty myProfile ? '' : fn:escapeXml(myProfile.zaloPhone)}"
                       placeholder="Số Zalo để người chơi khác liên hệ..."
                       class="w-full px-4 py-3 bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gold-light transition placeholder-gray-500 shadow-inner">
            </div>
        </div>

        <p class="text-xs text-gray-500 font-body">
            <i class="fas fa-circle-info mr-1"></i>
            Nếu bạn đã có hồ sơ ghép kèo, thông tin ở đây sẽ được đồng bộ sang danh sách người chơi.
        </p>

        <div class="flex flex-col sm:flex-row gap-3 mt-2">
            <button type="submit"
                    class="flex-1 font-classic font-bold text-base py-3.5 px-4 rounded-xl shadow-lg transition uppercase tracking-widest border"
                    style="background:linear-gradient(180deg,#d4af37,#aa8511);color:#1e110a;border-color:#8a6a09;">
                Lưu Thay Đổi
            </button>
            <a href="${pageContext.request.contextPath}/user/ghepkeo"
               class="flex-1 text-center font-body font-semibold text-sm py-3.5 px-4 rounded-xl transition"
               style="background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.25);color:#c4b5fd;">
                Xem Danh Sách Người Chơi
            </a>
        </div>
    </form>

    <div class="text-center mt-10 font-classic text-xs tracking-widest uppercase" style="color:rgba(156,163,175,0.4);">
        Est. 2024 &bull; H.N.D.D Management System
    </div>
</div>

<script>
    // Chọn sẵn giá trị hiện tại cho các ô select
    (function () {
        const rank = '${fn:escapeXml(profileAccount.memberRank)}';
        const style = '${fn:escapeXml(profileAccount.playingStyle)}';
        if (rank) document.getElementById('memberRank').value = rank;
        if (style) document.getElementById('playingStyle').value = style;
    })();
</script>
</body>
</html>
