<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Xác Nhận Đặt Bàn</title>
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
    <div class="flex items-center gap-4">
        <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp"
           class="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium text-yellow-500/70 hover:text-yellow-300 hover:bg-yellow-900/20 transition-all">
            <i class="fas fa-house text-xs"></i>
            <span class="hidden sm:inline">Trang Chủ</span>
        </a>
        <div class="text-right hidden sm:block">
            <div class="text-sm font-semibold text-yellow-200 font-body">${sessionScope.account.name}</div>
            <div class="text-[10px] text-yellow-600/60 uppercase tracking-widest">Khách Hàng VIP</div>
        </div>
        <div style="background: linear-gradient(135deg,#d4af37,#997a15); padding:2px; border-radius:50%;">
            <div style="background:#1a4a2e; border-radius:50%; width:34px; height:34px; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px; color:#d4af37;">
                ${sessionScope.account.name.substring(0,1).toUpperCase()}
            </div>
        </div>
    </div>
</nav>

<!-- PAGE CONTENT -->
<div class="min-h-screen flex items-center justify-center px-4 py-12">
    <div class="w-full max-w-lg">

        <!-- Title -->
        <div class="text-center mb-8">
            <div class="font-classic text-xs tracking-[0.25em] text-yellow-600/60 uppercase mb-2">H.N.D.D Billiards</div>
            <h1 class="font-classic text-3xl font-bold text-white mb-2">Hóa Đơn Đặt Bàn</h1>
            <div style="width:50px; height:1px; background: linear-gradient(90deg,transparent,#d4af37,transparent); margin:12px auto;"></div>
            <p class="font-body text-sm text-gray-400">Vui lòng kiểm tra lại thông tin chi tiết đặt bàn trước khi xác nhận</p>
        </div>

        <!-- Bill Card -->
        <div class="wood-frame rounded-2xl p-3 relative shadow-2xl">
            <!-- Corner bolts -->
            <div class="absolute top-3 left-3 w-2 h-2 rounded-full bg-black/80 shadow-inner"></div>
            <div class="absolute top-3 right-3 w-2 h-2 rounded-full bg-black/80 shadow-inner"></div>
            <div class="absolute bottom-3 left-3 w-2 h-2 rounded-full bg-black/80 shadow-inner"></div>
            <div class="absolute bottom-3 right-3 w-2 h-2 rounded-full bg-black/80 shadow-inner"></div>

            <div class="inner-felt rounded-xl p-8">
                <form action="${pageContext.request.contextPath}/datban" method="post" class="space-y-6">
                    <input type="hidden" name="action" value="confirm">
                    <input type="hidden" name="tableId" value="${table.id}">
                    <input type="hidden" name="playTime" value="${playTime}">
                    <input type="hidden" name="duration" value="${duration}">

                    <!-- Bill details container -->
                    <div class="bg-black/30 border border-gold-dark/20 rounded-xl p-6 space-y-4">
                        <!-- Table Info -->
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-body font-semibold tracking-wider text-yellow-600/80 uppercase">Bàn Bida</span>
                            <span class="text-base font-classic font-bold text-yellow-100">${table.name} (${table.tableTypeName})</span>
                        </div>
                        
                        <div class="h-px bg-gold-dark/10"></div>

                        <!-- Date Time -->
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-body font-semibold tracking-wider text-yellow-600/80 uppercase">Thời Gian Bắt Đầu</span>
                            <span class="text-sm font-mono font-semibold text-yellow-100">${playTimeFormatted}</span>
                        </div>

                        <div class="h-px bg-gold-dark/10"></div>

                        <!-- Play Duration -->
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-body font-semibold tracking-wider text-yellow-600/80 uppercase">Thời Lượng Chơi</span>
                            <span class="text-sm font-body font-semibold text-yellow-100">${duration} Giờ</span>
                        </div>

                        <div class="h-px bg-gold-dark/10"></div>

                        <!-- Price per hour -->
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-body font-semibold tracking-wider text-yellow-600/80 uppercase">Đơn Giá</span>
                            <span class="text-sm font-mono text-yellow-100"><fmt:formatNumber value="${hourlyRate}" type="number"/>đ/giờ</span>
                        </div>

                        <div class="h-px bg-gold-dark/15 border-dashed border-t"></div>

                        <!-- Total Table Price -->
                        <div class="flex justify-between items-center pt-2">
                            <span class="text-sm font-body font-bold tracking-wider text-yellow-500 uppercase">Tổng Tiền Bàn</span>
                            <span class="text-xl font-classic font-bold text-yellow-300"><fmt:formatNumber value="${totalPrice}" type="number"/>đ</span>
                        </div>
                    </div>

                    <!-- Payment Type Selection -->
                    <div>
                        <label class="block text-xs font-body font-semibold tracking-widest uppercase mb-3"
                               style="color: rgba(212,175,55,0.8);">
                            <i class="fas fa-credit-card mr-1"></i> Phương Thức Thanh Toán
                        </label>
                        <div class="grid grid-cols-2 gap-3">
                            <!-- Trả sau -->
                            <label id="card-trasau" for="pt_trasau"
                                   class="flex flex-col items-center gap-2 p-4 rounded-xl cursor-pointer transition-all"
                                   style="background:rgba(212,175,55,0.08);border:2px solid rgba(212,175,55,0.5);">
                                <input type="radio" id="pt_trasau" name="paymentType" value="Trả sau"
                                       class="sr-only" checked onchange="updatePaymentUI()">
                                <i class="fas fa-money-bill-wave text-2xl" style="color:#d4af37;"></i>
                                <div class="text-center">
                                    <div class="font-body font-bold text-sm" style="color:#f9e596;">Trả Sau</div>
                                    <div class="font-body text-xs mt-0.5" style="color:rgba(212,175,55,0.55);">Thanh toán tại quầy</div>
                                </div>
                            </label>
                            <!-- Trả trước (PayOS) -->
                            <label id="card-tratruoc" for="pt_tratruoc"
                                   class="flex flex-col items-center gap-2 p-4 rounded-xl cursor-pointer transition-all"
                                   style="background:rgba(0,0,0,0.2);border:2px solid rgba(212,175,55,0.15);">
                                <input type="radio" id="pt_tratruoc" name="paymentType" value="Trả trước"
                                       class="sr-only" onchange="updatePaymentUI()">
                                <i class="fas fa-qrcode text-2xl" style="color:#93c5fd;"></i>
                                <div class="text-center">
                                    <div class="font-body font-bold text-sm" style="color:#93c5fd;">Trả Trước</div>
                                    <div class="font-body text-xs mt-0.5" style="color:rgba(147,197,253,0.55);">Thanh toán online (PayOS)</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn"
                            class="w-full py-3.5 rounded-xl font-classic font-bold text-lg tracking-widest uppercase transition-all active:translate-y-0.5"
                            style="background: linear-gradient(180deg,#d4af37,#aa8511); color: #1e110a; box-shadow: 0 5px 15px rgba(0,0,0,0.4), inset 0 1px 1px rgba(255,255,255,0.3); border: 1px solid #8a6a09;"
                            onmouseover="this.style.background='linear-gradient(180deg,#f9e596,#d4af37)'"
                            onmouseout="this.style.background='linear-gradient(180deg,#d4af37,#aa8511)'">
                        <i class="fas fa-check-circle mr-2" id="submitIcon"></i>
                        <span id="submitText">Xác Nhận Đặt Bàn</span>
                    </button>
                </form>

                <script>
                function updatePaymentUI() {
                    var isTratruoc = document.getElementById('pt_tratruoc').checked;
                    var cardSau = document.getElementById('card-trasau');
                    var cardTruoc = document.getElementById('card-tratruoc');
                    var submitText = document.getElementById('submitText');
                    var submitIcon = document.getElementById('submitIcon');

                    if (isTratruoc) {
                        cardTruoc.style.background = 'rgba(59,130,246,0.1)';
                        cardTruoc.style.borderColor = 'rgba(147,197,253,0.7)';
                        cardSau.style.background = 'rgba(0,0,0,0.2)';
                        cardSau.style.borderColor = 'rgba(212,175,55,0.15)';
                        submitText.textContent = 'Thanh Toán Online (PayOS)';
                        submitIcon.className = 'fas fa-qrcode mr-2';
                    } else {
                        cardSau.style.background = 'rgba(212,175,55,0.08)';
                        cardSau.style.borderColor = 'rgba(212,175,55,0.5)';
                        cardTruoc.style.background = 'rgba(0,0,0,0.2)';
                        cardTruoc.style.borderColor = 'rgba(212,175,55,0.15)';
                        submitText.textContent = 'Xác Nhận Đặt Bàn';
                        submitIcon.className = 'fas fa-check-circle mr-2';
                    }
                }
                // Init on load
                document.getElementById('pt_trasau').addEventListener('change', updatePaymentUI);
                document.getElementById('pt_tratruoc').addEventListener('change', updatePaymentUI);
                </script>

                <!-- Back link -->
                <div class="mt-6 pt-5 border-t text-center" style="border-color: rgba(212,175,55,0.15);">
                    <a href="${pageContext.request.contextPath}/datban"
                       class="font-body text-sm transition-colors"
                       style="color: rgba(212,175,55,0.6);"
                       onmouseover="this.style.color='#f9e596'"
                       onmouseout="this.style.color='rgba(212,175,55,0.6)'">
                        <i class="fas fa-arrow-left mr-1"></i> Quay lại chỉnh sửa
                    </a>
                </div>
            </div>
        </div>

        <div class="text-center mt-8 font-classic text-xs tracking-widest uppercase" style="color: rgba(156,163,175,0.4);">
            Est. 2024 &bull; H.N.D.D Management System
        </div>
    </div>
</div>

</body>
</html>
