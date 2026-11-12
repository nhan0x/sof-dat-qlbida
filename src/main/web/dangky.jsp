<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Đăng Ký Tài Khoản</title>
    <%@ include file="common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen flex flex-col items-center justify-center relative transition-colors duration-700 overflow-x-hidden p-4">

    <!-- Ambient Light Glow -->
    <div class="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-white/10 dark:bg-gold-base/5 rounded-full blur-[100px] pointer-events-none z-0"></div>

    <div class="w-full max-w-[460px] flex flex-col items-center relative z-10 py-6">

        <!-- Header Brand -->
        <div class="text-center mb-6 w-full group cursor-default">
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

        <!-- Signup Card wood frame -->
        <div class="w-full wood-frame rounded-2xl p-3 shadow-[0_20px_40px_rgba(0,0,0,0.6)] relative">
            <!-- Bolts -->
            <div class="absolute top-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute top-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute bottom-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
            <div class="absolute bottom-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>

            <form action="${pageContext.request.contextPath}/dangky" method="post" class="inner-felt rounded-xl p-6 relative overflow-hidden">
                <%
                    String roleVal = "Khách hàng";
                    String rParam = request.getParameter("role");
                    String rAttr = (String) request.getAttribute("role");
                    if ("Nhân viên".equals(rParam) || "Nhân viên".equals(rAttr)) {
                        roleVal = "Nhân viên";
                    }
                %>
                <input type="hidden" name="role" value="<%= roleVal %>">

                <h2 class="text-center font-classic text-lg text-white dark:text-gold-light mb-6 border-b border-gold-dark/30 pb-4">
                    <%= "Nhân viên".equals(roleVal) ? "Đăng Ký Tài Khoản Nhân Viên" : "Đăng ký tài khoản mới" %>
                </h2>

                <div class="space-y-4">
                    <!-- Họ và Tên -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Họ và Tên</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-regular fa-user"></i>
                            </span>
                            <input type="text" name="name" required placeholder="Nhập họ và tên..."
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>

                    <!-- Tài khoản -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Tài khoản đăng nhập</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-solid fa-user-tag"></i>
                            </span>
                            <input type="text" name="username" required placeholder="Tên đăng nhập..." pattern="^\S+$" title="Tài khoản không được chứa khoảng trắng hoặc để trống"
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Địa chỉ Email</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-regular fa-envelope"></i>
                            </span>
                            <input type="email" name="email" required placeholder="email@example.com"
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>

                    <!-- Số điện thoại -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Số điện thoại</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-solid fa-mobile-screen"></i>
                            </span>
                            <input type="text" name="phone" required placeholder="Nhập số điện thoại..."
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>

                    <!-- Mật khẩu -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Mật khẩu</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input type="password" name="password" required placeholder="Tối thiểu 6 ký tự..." pattern="^\S{6,}$" title="Mật khẩu phải từ 6 ký tự trở lên và không được chứa khoảng trắng"
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>

                    <!-- Xác nhận mật khẩu -->
                    <div>
                        <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-1.5 uppercase">Xác nhận mật khẩu</label>
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input type="password" name="confirm_password" required placeholder="Nhập lại mật khẩu..." pattern="^\S{6,}$" title="Mật khẩu phải từ 6 ký tự trở lên và không được chứa khoảng trắng"
                                   class="w-full pl-11 pr-4 py-2.5 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition placeholder-gray-500 shadow-inner" />
                        </div>
                    </div>
                </div>

                <!-- Error Messages -->
                <div class="text-center text-sm my-4 min-h-[20px]">
                    <i class="font-body text-red-400 font-medium drop-shadow-[0_1px_2px_rgba(0,0,0,0.8)] not-italic">${loi}</i>
                </div>

                <button type="submit" class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold text-base py-3 px-4 rounded-lg shadow-lg transition active:translate-y-0.5 uppercase tracking-wider border border-[#8a6a09]">
                    Đăng Ký Ngay
                </button>

                <div class="mt-6 pt-4 border-t border-gold-dark/20 text-center flex flex-col gap-2 font-body text-sm">
                    <a href="${pageContext.request.contextPath}/dangnhap" class="text-gray-300 hover:text-gold-light transition flex items-center justify-center gap-2 group">
                        <span class="w-1.5 h-1.5 rounded-full bg-gold-dark group-hover:bg-gold-light transition"></span>
                        Đã có tài khoản? Đăng nhập ngay
                    </a>
                </div>
            </form>
        </div>

        <div class="mt-6 text-center text-xs font-classic text-gray-300/50 uppercase tracking-widest">
            &copy; 2026 Bida Pro. All Rights Reserved.
        </div>
    </div>

</body>
</html>