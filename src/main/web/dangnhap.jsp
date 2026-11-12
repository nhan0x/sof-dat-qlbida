<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bida Pro Management - System Login</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">

    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        classic: ['"Playfair Display"', 'serif'],
                        body: ['"Inter"', 'sans-serif'],
                    },
                    colors: {
                        felt: {
                            light: '#2a7a4d', // Xanh mặt nỉ sáng
                            dark: '#0f3622',  // Xanh mặt nỉ trong bóng tối
                        },
                        wood: {
                            light: '#6d4c41',
                            base: '#3e2723',
                            dark: '#1e110a',
                        },
                        gold: {
                            light: '#f9e596',
                            base: '#d4af37', // Vàng đồng
                            dark: '#997a15',
                        }
                    },
                    animation: {
                        'roll': 'roll 0.8s cubic-bezier(0.25, 1, 0.5, 1) forwards',
                    },
                    keyframes: {
                        roll: {
                            '0%': { transform: 'rotate(0deg) translateX(0)' },
                            '100%': { transform: 'rotate(360deg) translateX(0)' }
                        }
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        /* SVG Noise filter tạo vân vải nỉ chân thực */
        .bg-billiards-felt {
            background-color: #2a7a4d;
            background-image: radial-gradient(circle at 50% 0%, rgba(255,255,255,0.15) 0%, transparent 70%),
            url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.15'/%3E%3C/svg%3E");
        }

        .dark .bg-billiards-felt {
            background-color: #0c2617;
            background-image: radial-gradient(circle at 50% -20%, rgba(212, 175, 55, 0.15) 0%, transparent 60%),
            url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.1'/%3E%3C/svg%3E");
        }

        /* Khung viền mô phỏng thành băng bàn bida bằng gỗ */
        .wood-frame {
            background: linear-gradient(135deg, #4e342e 0%, #3e2723 50%, #26140e 100%);
            box-shadow:
                    0 25px 50px -12px rgba(0, 0, 0, 0.8),
                    inset 0 0 0 2px rgba(255,255,255,0.05),
                    inset 0 0 15px rgba(0,0,0,0.9);
        }

        /* Mặt trong của form (lõm xuống) */
        .inner-felt {
            background-color: rgba(20, 60, 35, 0.95);
            box-shadow: inset 0 5px 20px rgba(0,0,0,0.5);
            border: 1px solid rgba(212, 175, 55, 0.2);
        }
        .dark .inner-felt {
            background-color: rgba(6, 20, 12, 0.95);
            box-shadow: inset 0 5px 30px rgba(0,0,0,0.8);
            border: 1px solid rgba(212, 175, 55, 0.1);
        }

        /* Chữ viền vàng kim */
        .gold-text-emboss {
            background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));
        }

        /* Input Autofill fix */
        input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px #1c452c inset !important;
            -webkit-text-fill-color: #e5e7eb !important;
            transition: background-color 5000s ease-in-out 0s;
        }
        .dark input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px #0a1f13 inset !important;
            -webkit-text-fill-color: #d4af37 !important;
        }
    </style>
</head>

<body class="bg-billiards-felt min-h-screen flex flex-col items-center justify-center relative transition-colors duration-700 overflow-x-hidden">

<div class="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-white/10 dark:bg-gold-base/5 rounded-full blur-[100px] pointer-events-none z-0 transition-all duration-700"></div>

<button id="theme-toggle" class="absolute top-6 right-6 z-50 flex items-center gap-2 px-5 py-2.5 rounded-full border border-gold-dark/40 bg-wood-base text-gold-light hover:bg-wood-dark transition-all shadow-lg group">
    <span id="theme-icon" class="text-lg">🏮</span>
    <span id="theme-text" class="font-classic text-sm tracking-wider uppercase group-hover:text-white transition-colors">Không gian</span>
</button>

<div class="w-full max-w-[440px] flex flex-col items-center relative z-10 px-4">

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

    <div class="w-full wood-frame rounded-2xl p-3 shadow-[0_20px_40px_rgba(0,0,0,0.6)] relative">

        <div class="absolute top-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
        <div class="absolute top-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
        <div class="absolute bottom-4 left-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>
        <div class="absolute bottom-4 right-4 w-2 h-2 rounded-full bg-black/80 shadow-[inset_0_1px_1px_rgba(255,255,255,0.2)]"></div>

        <form action="${pageContext.request.contextPath}/dangnhap" method="post" class="inner-felt rounded-xl p-8 relative overflow-hidden">

            <h2 class="text-center font-classic text-xl text-white dark:text-gold-light mb-6 border-b border-gold-dark/30 pb-4">
                Xác Thực Thành Viên
            </h2>

            <% if (request.getAttribute("thongbao") != null) { %>
            <div class="mb-6 p-3 bg-green-900/40 border border-green-500/50 text-green-200 text-center text-sm font-medium rounded-lg shadow-inner">
                <%= request.getAttribute("thongbao") %>
            </div>
            <% } %>

            <div class="mb-5">
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">
                    Tài khoản
                </label>
                <div class="relative group">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path></svg>
                        </span>
                    <input type="text" name="username" required placeholder="Nhập tên tài khoản..."
                           class="w-full pl-11 pr-4 py-3 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition-all placeholder-gray-400/50 shadow-inner" />
                </div>
            </div>

            <div class="mb-5">
                <label class="block text-xs font-classic tracking-widest text-gold-base/90 mb-2 uppercase">
                    Mật mã
                </label>
                <div class="relative group">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gold-base/50 group-focus-within:text-gold-base transition-colors">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path></svg>
                        </span>
                    <input type="password" name="password" id="password" required placeholder="Nhập mật khẩu..."
                           class="w-full pl-11 pr-10 py-3 bg-black/20 dark:bg-black/40 border border-gold-dark/30 rounded-lg focus:outline-none focus:ring-1 focus:ring-gold-base focus:border-gold-base font-body text-sm text-gray-100 dark:text-gold-light transition-all placeholder-gray-400/50 shadow-inner" />
                    <span id="togglePassword" class="absolute inset-y-0 right-0 flex items-center pr-3 text-gold-base/50 cursor-pointer hover:text-gold-light transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                        </span>
                </div>
            </div>

            <div class="flex items-center justify-between text-sm mb-7 font-body">
                <label class="flex items-center gap-2 cursor-pointer group">
                    <div class="relative flex items-center">
                        <input type="checkbox" class="peer sr-only">
                        <div class="w-4 h-4 border border-gold-dark/50 rounded bg-black/30 peer-checked:bg-gold-base peer-checked:border-gold-base transition-all flex items-center justify-center shadow-inner">
                            <svg class="w-3 h-3 text-wood-dark opacity-0 peer-checked:opacity-100" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg>
                        </div>
                    </div>
                    <span class="text-gray-300 group-hover:text-gold-light transition-colors">Ghi nhớ mật khẩu</span>
                </label>
                <a href="quenMatKhau" class="text-gold-base/80 hover:text-gold-light hover:underline underline-offset-4 decoration-gold-light/50 transition-all italic">Quên mật mã?</a>
            </div>

            <div class="text-center text-sm mb-5 min-h-[20px]">
                <i class="font-body text-red-400 font-medium drop-shadow-[0_1px_2px_rgba(0,0,0,0.8)] not-italic">${loi}</i>
            </div>

            <button type="submit" class="w-full bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-classic font-bold text-lg py-3 px-4 rounded-lg shadow-[0_5px_15px_rgba(0,0,0,0.4),inset_0_1px_1px_rgba(255,255,255,0.5)] transition-all active:translate-y-1 active:shadow-[0_2px_5px_rgba(0,0,0,0.4),inset_0_2px_4px_rgba(0,0,0,0.3)] uppercase tracking-widest border border-[#8a6a09]">
                Đăng Nhập
            </button>

            <div class="mt-8 pt-6 border-t border-gold-dark/20 text-center flex flex-col gap-3 font-body text-sm">
                <a href="${pageContext.request.contextPath}/dangky" class="text-gray-300 hover:text-gold-light transition-colors flex items-center justify-center gap-2 group">
                    <span class="w-1.5 h-1.5 rounded-full bg-gold-dark group-hover:bg-gold-light transition-colors"></span>
                    Đăng ký tài khoản mới
                </a>
            </div>
        </form>
    </div>

    <div class="mt-8 text-center text-xs font-classic text-gray-300/50 uppercase tracking-widest">
        Est. 2024 &bull; H.N.D.D Management System
    </div>
</div>

<script>
    // Xử lý ẩn/hiện mật khẩu
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');

    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        if(type === 'password') {
            this.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>';
        } else {
            this.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path></svg>';
        }
    });

    // Xử lý Dark/Light Mode (Đổi ánh sáng bàn)
    const themeToggleBtn = document.getElementById('theme-toggle');
    const themeIcon = document.getElementById('theme-icon');
    const themeText = document.getElementById('theme-text');
    const htmlElement = document.documentElement;

    function updateThemeUI(isDark) {
        if(isDark) {
            themeIcon.textContent = '🌙';
            themeText.textContent = 'Giảm đèn';
        } else {
            themeIcon.textContent = '💡';
            themeText.textContent = 'Bật đèn';
        }
    }

    // Mặc định nạp trạng thái từ LocalStorage
    if (localStorage.getItem('theme') === 'light') {
        htmlElement.classList.remove('dark');
        updateThemeUI(false);
    } else {
        htmlElement.classList.add('dark');
        updateThemeUI(true);
    }

    // Bắt sự kiện click chuyển đổi
    themeToggleBtn.addEventListener('click', () => {
        htmlElement.classList.toggle('dark');
        const isDark = htmlElement.classList.contains('dark');
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
        updateThemeUI(isDark);
    });
</script>
</body>
</html>