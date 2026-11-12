<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Cơ Mới</title>
    <style>
        /* Đặt lại mặc định */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        /* Khung Form */
        .form-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            animation: fadeIn 0.5s ease-in-out;
        }

        .form-title {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 24px;
            font-weight: 600;
        }

        /* Các nhóm input */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }

        .form-control:focus {
            border-color: #4a90e2;
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
            outline: none;
        }

        /* Nút Submit */
        .btn-submit {
            width: 100%;
            padding: 14px;
            background-color: #4a90e2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.1s ease;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background-color: #357abd;
        }

        .btn-submit:active {
            transform: scale(0.98);
        }

        /* Thông báo lỗi */
        .error-message {
            display: block;
            text-align: center;
            color: #e74c3c;
            margin-top: 15px;
            font-size: 14px;
            font-weight: 500;
            min-height: 20px;
        }

        /* Hiệu ứng xuất hiện mượt mà */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h2 class="form-title">Thêm Cơ Bida Mới</h2>

        <form action="/themCo" method="post">
            <div class="form-group">
                <label for="name">Tên cơ</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Nhập tên cơ..." required>
            </div>

            <div class="form-group">
                <label for="brand">Thương hiệu</label>
                <input type="text" id="brand" name="brand" class="form-control" placeholder="Ví dụ: Predator, Mezz..." required>
            </div>

            <div class="form-group">
                <label for="price">Giá bán (VNĐ)</label>
                <input type="number" id="price" name="price" class="form-control" placeholder="Nhập giá tiền..." required>
            </div>

            <div class="form-group">
                <label for="status">Tình trạng</label>
                <input type="text" id="status" name="status" class="form-control" placeholder="Mới 100%, 99%..." required>
            </div>

            <div class="form-group">
                <label for="description">Mô tả chi tiết</label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Nhập mô tả thêm..." required>
            </div>

            <button type="submit" class="btn-submit">Thêm Cơ</button>

            <span class="error-message">${loi}</span>
        </form>
    </div>

</body>
</html>