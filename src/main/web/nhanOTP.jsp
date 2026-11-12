<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Xác Nhận OTP</title>
    <%@ include file="common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen flex flex-col items-center justify-center relative transition-colors duration-700 overflow-x-hidden p-4">

    <!-- Ambient Glow Light -->
    <div class="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-white/10 dark:bg-gold-base/5 rounded-full blur-[100px] pointer-events-none z-0"></div>

    <div class="w-full max-w-[440px] flex flex-col items-center relative z-10">

        <!-- Brand Header -->
        <div class="text-center mb-8 w-full group cursor-default">
            <div class="flex justify-center items-center gap-3 text-5xl font-classic font-bold tracking-wider mb-2 text-white">
                <span class="inline-block text-4xl drop-shadow-xl group-hover:animate-roll">🎱</span>
                <span class="gold-text-emboss">H.N.D.D</span>
            </div>
            <div class="font-classic text-sm tracking-[0.25em] text-gold-base/80 uppercase flex items-center justify-center gap-4 mt-1">
                <span class="w-8 h-[1px] bg-gold-dark/50"></span>
                Premium Billiards
                <span class="w-8 h-[1px] bg-gold-dark/50"></span>
            </div>
        </div>

        <!-- Wood frame card wrapper -->
        <div class="w-full wood-frame rounded-2xl p-3 shadow-[0_20px_40px_rgba(0,0,0,0.6)] relative animate-float">
            <!-- Bolts -->
            <div class="absolute top-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute top-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute bottom-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute bottom-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>

            <form id="otp-form" action="${pageContext.request.contextPath}/xacNhanOTP" method="post" class="inner-felt rounded-xl p-8 relative overflow-hidden">
                
                <h2 class="text-center font-classic text-lg text-white dark:text-gold-light mb-2">
                    Xác Thực OTP
                </h2>
                <p class="text-center text-xs text-gray-400 mb-8 border-b border-gold-dark/30 pb-4">
                    Nhập mã OTP gồm 6 chữ số được gửi đến Email của bạn để hoàn tất quy trình.
                </p>

                <!-- OTP inputs container -->
                <div class="flex justify-between gap-2 mb-8">
                    <input type="text" name="otp1" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                    <input type="text" name="otp2" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                    <input type="text" name="otp3" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                    <input type="text" name="otp4" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                    <input type="text" name="otp5" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                    <input type="text" name="otp6" maxlength="1" inputmode="numeric" required
                           class="otp-input w-12 h-14 text-center text-xl font-bold bg-black/40 border border-gold-dark/30 rounded-xl focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-gray-100 dark:text-gold-light transition shadow-inner">
                </div>

                <!-- Error Messages -->
                <div class="text-center text-sm mb-6 min-h-[20px]">
                    <i class="font-body text-red-400 font-medium drop-shadow-[0_1px_2px_rgba(0,0,0,0.8)] not-italic">${loi}</i>
                </div>

                <button type="submit" class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold text-base py-3.5 px-4 rounded-lg shadow-lg transition active:translate-y-0.5 uppercase tracking-wider border border-[#8a6a09]">
                    Xác nhận OTP
                </button>

                <div class="mt-8 pt-6 border-t border-gold-dark/20 text-center flex flex-col gap-3 font-body text-sm">
                    <a href="${pageContext.request.contextPath}/dangnhap" class="text-gray-300 hover:text-gold-light transition flex items-center justify-center gap-2 group">
                        <i class="fa-solid fa-chevron-left text-[10px]"></i> Quay lại đăng nhập
                    </a>
                </div>
            </form>
        </div>

        <div class="mt-8 text-center text-xs font-classic text-gray-300/50 uppercase tracking-widest">
            Est. 2024 &bull; H.N.D.D Management System
        </div>
    </div>

    <!-- OTP Autofocus and Nav Scripts -->
    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const form = document.getElementById('otp-form');

        inputs.forEach((input, index) => {
            // Focus first input on load
            if (index === 0) input.focus();

            // Handle typing
            input.addEventListener('input', (e) => {
                const value = e.target.value;
                // Only allow numbers
                if (!/^\d*$/.test(value)) {
                    e.target.value = value.replace(/[^\d]/g, '');
                    return;
                }

                if (value.length > 0) {
                    if (index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                }
            });

            // Handle backspace and navigation
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace') {
                    if (input.value === '') {
                        if (index > 0) {
                            inputs[index - 1].focus();
                        }
                    }
                } else if (e.key === 'ArrowLeft') {
                    if (index > 0) inputs[index - 1].focus();
                } else if (e.key === 'ArrowRight') {
                    if (index < inputs.length - 1) inputs[index + 1].focus();
                }
            });

            // Handle paste
            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasteData = e.clipboardData.getData('text').replace(/[^\d]/g, '').slice(0, 6).split('');
                if (pasteData.length > 0) {
                    pasteData.forEach((char, i) => {
                        if (inputs[i]) {
                            inputs[i].value = char;
                        }
                    });
                    const lastIndex = Math.min(pasteData.length, inputs.length - 1);
                    inputs[lastIndex].focus();
                }
            });
        });
    </script>
</body>
</html>