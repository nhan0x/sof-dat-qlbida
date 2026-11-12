<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán PayOS (VietQR) - H.N.D.D Bida</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&family=IBM+Plex+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: #0a180f;
            background-image:
                radial-gradient(ellipse at top left, rgba(212,175,55,0.12) 0%, transparent 60%),
                radial-gradient(ellipse at bottom right, rgba(16,185,129,0.12) 0%, transparent 60%);
            font-family: 'Inter', sans-serif;
            color: #e5e7eb;
            min-height: 100vh;
        }
        .gold-emboss {
            background: linear-gradient(180deg, #f9e596 0%, #d4af37 50%, #aa8511 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .wood-border {
            background: linear-gradient(135deg, #3d2516 0%, #1e110a 100%);
            border: 1px solid rgba(212,175,55,0.3);
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <!-- TOP TOOLBAR / NAVIGATION WITH PROMINENT BACK BUTTON -->
    <header class="sticky top-0 z-50 bg-[#160c07]/90 backdrop-blur-md border-b border-[#d4af37]/30 px-4 py-3 shadow-xl">
        <div class="max-w-4xl mx-auto flex items-center justify-between">
            <!-- PROMINENT BACK BUTTON -->
            <a href="${not empty cancelUrl ? cancelUrl : pageContext.request.contextPath}"
               class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-bold bg-gradient-to-b from-[#d4af37]/20 to-[#aa8511]/30 hover:from-[#d4af37]/40 hover:to-[#aa8511]/50 text-[#f9e596] border border-[#d4af37]/50 shadow-md transition-all active:scale-95">
                <i class="fas fa-arrow-left text-xs"></i>
                <span>Quay Lại</span>
            </a>

            <div class="flex items-center gap-2">
                <span class="text-xl">🎱</span>
                <span class="font-bold text-base gold-emboss tracking-wider font-serif">H.N.D.D BIDA</span>
            </div>

            <!-- Cancel Button as Secondary Back -->
            <a href="${not empty cancelUrl ? cancelUrl : pageContext.request.contextPath}"
               class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-gray-400 hover:text-white hover:bg-white/10 transition">
                <i class="fas fa-times"></i>
                <span class="hidden sm:inline">Hủy Thanh Toán</span>
            </a>
        </div>
    </header>

    <!-- MAIN CONTENT CONTAINER -->
    <main class="flex-1 max-w-4xl w-full mx-auto p-4 md:p-6 flex flex-col items-center justify-center">

        <div class="w-full wood-border rounded-2xl p-4 md:p-6 space-y-6 relative overflow-hidden">
            <!-- Header title -->
            <div class="text-center space-y-2">
                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-xs font-semibold">
                    <span class="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></span>
                    Thanh Toán Chuyển Khoản Mã QR (PayOS)
                </div>
                <h1 class="text-2xl md:text-3xl font-bold font-serif text-white">Quét Mã QR Trực Tiếp</h1>
                <p class="text-xs md:text-sm text-gray-400">Sử dụng ứng dụng ngân hàng hoặc MoMo/ZaloPay để quét mã QR</p>
            </div>

            <!-- Summary details grid -->
            <div class="bg-black/40 border border-[#d4af37]/20 rounded-xl p-4 grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs font-mono">
                <div class="text-center sm:text-left">
                    <span class="text-gray-500 block uppercase text-[10px]">Mã đơn hàng</span>
                    <span class="font-bold text-yellow-200">#${orderCode}</span>
                </div>
                <div class="text-center">
                    <span class="text-gray-500 block uppercase text-[10px]">Nội dung</span>
                    <span class="font-bold text-gray-200 truncate block">${description}</span>
                </div>
                <div class="text-center sm:text-right">
                    <span class="text-gray-500 block uppercase text-[10px]">Số tiền cần trả</span>
                    <span class="font-bold text-emerald-400 text-base">
                        <fmt:formatNumber value="${amount}" type="number"/>đ
                    </span>
                </div>
            </div>

            <!-- Embedded QR Code Frame / PayOS Checkout View -->
            <div class="relative w-full rounded-xl overflow-hidden bg-white/5 border border-[#d4af37]/20 shadow-inner flex flex-col items-center justify-center">
                <c:choose>
                    <c:when test="${not empty checkoutUrl}">
                        <div class="p-6 md:p-8 text-center space-y-4 w-full">
                            <div class="inline-flex items-center justify-center w-14 h-14 rounded-full bg-emerald-500/20 text-emerald-400 text-2xl border border-emerald-500/30">
                                <i class="fas fa-qrcode"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white">Thanh Toán Trực Tuyến VietQR (PayOS)</h3>
                            <p class="text-xs md:text-sm text-gray-300 max-w-lg mx-auto leading-relaxed">
                                Nhấn vào nút bên dưới để mở giao diện thanh toán quét mã QR của PayOS. Sau khi quét mã và chuyển khoản thành công, hệ thống sẽ tự động xác nhận đơn đặt của bạn.
                            </p>
                            <div class="py-2">
                                <a href="${checkoutUrl}" id="payos-link"
                                   class="inline-flex items-center justify-center gap-3 px-8 py-3.5 rounded-xl text-base font-bold bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-400 hover:to-teal-500 text-white shadow-lg hover:shadow-emerald-500/30 transition-all active:scale-95 border border-emerald-400/40">
                                    <i class="fas fa-external-link-alt text-sm"></i>
                                    <span>Mở Trang Thanh Toán PayOS (VietQR)</span>
                                </a>
                            </div>
                            <div class="pt-4 border-t border-white/10 w-full">
                                <p class="text-xs text-gray-400 mb-3">Khung nhúng trực tiếp (tùy thuộc hỗ trợ của trình duyệt):</p>
                                <iframe src="${checkoutUrl}" class="w-full h-[500px] border-0 rounded-xl bg-white" title="PayOS Payment Interface"></iframe>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-8 text-center space-y-4">
                            <i class="fas fa-exclamation-triangle text-amber-400 text-4xl"></i>
                            <p class="text-sm text-gray-300">Không tìm thấy liên kết thanh toán PayOS.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Bottom Navigation Bar with Prominent Back Button -->
            <div class="flex flex-col sm:flex-row items-center justify-between gap-4 pt-2 border-t border-[#d4af37]/20">
                <a href="${not empty cancelUrl ? cancelUrl : pageContext.request.contextPath}"
                   class="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-3 rounded-xl font-bold text-sm bg-gradient-to-b from-[#d4af37]/20 to-[#aa8511]/30 hover:from-[#d4af37]/40 hover:to-[#aa8511]/50 text-[#f9e596] border border-[#d4af37]/50 shadow-lg transition active:scale-95">
                    <i class="fas fa-arrow-left"></i>
                    <span>Quay Lại Trang Trước</span>
                </a>

                <c:if test="${not empty checkoutUrl}">
                    <a href="${checkoutUrl}" target="_blank"
                       class="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-5 py-3 rounded-xl font-semibold text-xs bg-blue-600/20 hover:bg-blue-600/30 text-blue-300 border border-blue-500/40 transition">
                        <span>Mở Cổng PayOS Trong Cửa Sổ Mới</span>
                        <i class="fas fa-external-link-alt text-[10px]"></i>
                    </a>
                </c:if>
            </div>

        </div>

    </main>

    <!-- FOOTER -->
    <footer class="py-4 text-center text-[11px] text-gray-500 uppercase tracking-widest border-t border-[#d4af37]/10">
        Est. 2024 &bull; H.N.D.D Bida Management System
    </footer>

</body>
</html>
