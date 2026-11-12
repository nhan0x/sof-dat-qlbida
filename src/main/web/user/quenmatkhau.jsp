<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bida Pro Management - Quên mật khẩu</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            /* Lớp nền mờ ảo phía sau giống như ảnh mẫu */
            background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.9)),
            url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
            background-size: cover;
        }
    </style>
</head>
<body class="flex flex-col min-h-screen items-center justify-between p-6 text-white">

<div></div>

<div class="w-full max-w-md flex flex-col items-center">

    <div class="text-center mb-8">
        <div class="flex justify-center items-center gap-1 text-3xl font-black italic tracking-wider text-amber-400 drop-shadow-md">
            <span>🎱</span> H.N.D.D
        </div>
        <div class="text-xs font-bold tracking-widest text-amber-200/80 uppercase mt-1">
            Management
        </div>
        <p class="text-sm text-gray-300 mt-6 font-medium">
            Khôi phục mật khẩu tài khoản Bida
        </p>
    </div>

    <form action="/quenmatkhau" method="post" class="w-full bg-white text-gray-800 rounded-2xl p-8 shadow-2xl border border-emerald-800/20">

        <p class="text-xs text-gray-500 mb-6 text-center leading-relaxed">
            Vui lòng nhập email đăng ký tài khoản của bạn. Chúng tôi sẽ gửi hướng dẫn khôi phục mật khẩu qua email này.
        </p>

        <div class="mb-6">
            <label class="block text-sm font-semibold text-gray-700 mb-2">
                Địa chỉ Email
            </label>
            <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                        ✉️
                    </span>
                <input type="email" name="email" required
                       placeholder="example@domain.com"
                       class="w-full pl-10 pr-4 py-3 bg-emerald-950/10 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-600 focus:border-transparent font-medium transition-all" />
            </div>
        </div>

        <!-- Nơi hiển thị thông báo lỗi hoặc thành công nếu có -->
        <div class="text-center text-sm mb-4">
            <i style="color: #ef4444; font-style: normal; font-weight: 500;">${loi}</i>
            <i style="color: #10b981; font-style: normal; font-weight: 500;">${thongbao}</i>
        </div>

        <button type="submit"
                class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3.5 px-4 rounded-xl shadow-lg shadow-emerald-700/30 transition-all active:scale-[0.99] uppercase tracking-wider text-sm cursor-pointer mb-4">
            Gửi yêu cầu khôi phục
        </button>

        <div class="text-center">
            <a href="/dangnhap" class="text-xs font-semibold text-emerald-600 hover:text-emerald-800 hover:underline transition-all">
                ← Quay lại đăng nhập
            </a>
        </div>
    </form>
</div>

<div></div>

</body>
</html>