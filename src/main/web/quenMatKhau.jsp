<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - H.N.D.D Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap');

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(rgba(12, 53, 35, 0.85), rgba(10, 35, 25, 0.95)),
                    url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
                background-size: cover;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                color: #ffffff;
                padding: 20px;
            }

            .container {
                background-color: #ffffff;
                width: 100%;
                max-width: 420px;
                padding: 35px 40px;
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            }

            .header-section {
                text-align: center;
                margin-bottom: 25px;
            }

            .logo-main {
                font-size: 32px;
                font-weight: 900;
                font-style: italic;
                letter-spacing: 1px;
                color: #fbbf24;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
                margin-bottom: 2px;
            }

            .logo-sub {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 4px;
                color: #fde68a;
                margin-bottom: 15px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 6px;
            }

            .input-wrapper {
                position: relative;
            }

            .input-wrapper i {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                font-size: 15px;
            }

            .input-wrapper input {
                width: 100%;
                background-color: rgba(6, 78, 59, 0.05);
                border: 1px solid #d1d5db;
                color: #1f2937;
                font-size: 14px;
                font-weight: 500;
                padding: 12px 15px 12px 45px;
                border-radius: 14px;
                outline: none;
                transition: all 0.25s ease;
            }

            .input-wrapper input:focus {
                border-color: #059669;
                background-color: #ffffff;
                box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.15);
            }

            .btn-submit {
                width: 100%;
                background-color: #059669;
                color: #ffffff;
                border: none;
                padding: 14px;
                font-size: 14px;
                font-weight: 700;
                border-radius: 14px;
                cursor: pointer;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.2s ease;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
                margin-bottom: 15px;
            }

            .btn-submit:hover {
                background-color: #047857;
                transform: translateY(-1px);
                box-shadow: 0 6px 15px rgba(5, 150, 105, 0.4);
            }

            .error-message {
                text-align: center;
                margin-bottom: 15px;
                color: #ef4444;
                font-size: 13px;
                min-height: 18px;
            }

            .footer-text {
                text-align: center;
                font-size: 13px;
                color: #6b7280;
                font-weight: 500;
            }

            .footer-text a {
                color: #059669;
                text-decoration: none;
                font-weight: 700;
            }

            .footer-text a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="header-section">
            <div class="logo-main">🎱 H.N.D.D</div>
            <div class="logo-sub">Management</div>
            <p style="color: #cbd5e1; font-size: 14px; margin-top: 5px;">Khôi phục mật khẩu của bạn</p>
        </div>

        <div class="container">
            <h3 style="color: #1f2937; text-align: center; font-size: 18px; font-weight: 700; margin-bottom: 20px;">Lấy
                Lại Mật Khẩu</h3>

            <p style="color: #6b7280; font-size: 13px; text-align: center; margin-bottom: 20px;">
                Vui lòng nhập Email đã đăng ký. Chúng tôi sẽ gửi mã OTP để bạn đặt lại mật khẩu.
            </p>

            <form action="quenMatKhau" method="post">
                <div class="form-group">
                    <label>Email Đăng Ký</label>
                    <div class="input-wrapper">
                        <i class="fa-regular fa-envelope"></i>
                        <input type="email" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <div class="error-message">${loi}</div>

                <button type="submit" class="btn-submit">
                    GỬI MÃ XÁC THỰC <i class="fa-solid fa-paper-plane" style="font-size: 12px;"></i>
                </button>
            </form>

            <div class="footer-text">
                <a href="dangnhap"><i class="fa-solid fa-arrow-left"></i> Quay lại Đăng nhập</a>
            </div>
        </div>

        <p style="text-align: center; margin-top: 25px; font-size: 12px; color: #6b7280; font-weight: 500;">
            &copy; 2026 Bida Pro. All Rights Reserved.
        </p>
    </body>

    </html>