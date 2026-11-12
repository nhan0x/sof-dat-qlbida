<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Cơ Mới (Add Cue)</title>
            <style>
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                body {
                    /* Hình nền màu xanh bida */
                    background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.95)),
                                url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
                    background-size: cover;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                    padding: 20px;
                }

                .form-container {
                    background: rgba(255, 255, 255, 0.95);
                    padding: 40px;
                    border-radius: 12px;
                    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
                    width: 100%;
                    max-width: 450px;
                    border: 2px solid #fff;
                }

                .header-logo {
                    text-align: center;
                    margin-bottom: 20px;
                }

                .header-logo img {
                    max-width: 150px;
                    margin-bottom: 10px;
                }

                h2 {
                    text-align: center;
                    margin-bottom: 30px;
                    color: #333;
                    font-size: 22px;
                    font-weight: 700;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    color: #555;
                    font-size: 14px;
                    font-weight: 600;
                }

                .input-group {
                    position: relative;
                }

                .input-group input,
                .input-group select,
                .input-group textarea {
                    width: 100%;
                    padding: 12px 15px;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    font-size: 15px;
                    transition: all 0.3s ease;
                    background-color: #f7f9fa;
                }

                .input-group input:focus,
                .input-group select:focus,
                .input-group textarea:focus {
                    outline: none;
                    border-color: #0c764a;
                    box-shadow: 0 0 0 3px rgba(12, 118, 74, 0.2);
                    background-color: #fff;
                }

                .btn-submit {
                    width: 100%;
                    padding: 14px;
                    background: #0c764a;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: bold;
                    cursor: pointer;
                    margin-top: 10px;
                    transition: background 0.3s;
                    text-transform: uppercase;
                }

                .btn-submit:hover {
                    background: #0a603c;
                }

                .back-link {
                    display: block;
                    text-align: center;
                    margin-top: 20px;
                    text-decoration: none;
                    color: #0c764a;
                    font-weight: 600;
                    font-size: 14px;
                }

                .back-link:hover {
                    text-decoration: underline;
                }

                .alert {
                    padding: 10px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    text-align: center;
                    font-weight: bold;
                }

                .alert-success {
                    background: #d4edda;
                    color: #155724;
                }

                .alert-danger {
                    background: #f8d7da;
                    color: #721c24;
                }
            </style>
        </head>

        <body>
            <div class="form-container">
                <div class="header-logo">
                    <h2>BIDA PRO <br><span style="font-size: 14px; font-weight: normal; color: #666;">MANAGEMENT</span>
                    </h2>
                </div>

                <h2>Thêm Cơ Mới</h2>

                <% String message=(String) request.getAttribute("message"); String error=(String)
                    request.getAttribute("error"); if (message !=null) { %>
                    <div class="alert alert-success">
                        <%= message %>
                    </div>
                    <% } else if (error !=null) { %>
                        <div class="alert alert-danger">
                            <%= error %>
                        </div>
                        <% } %>

                            <form action="/admin/themCo" method="POST">
                                <div class="form-group">
                                    <label for="name">Tên Cơ (Name):</label>
                                    <div class="input-group">
                                        <input type="text" id="name" name="name" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="brand">Thương Hiệu (Brand):</label>
                                    <div class="input-group">
                                        <input type="text" id="brand" name="brand" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="pricePerHour">Giá Thuê / Giờ:</label>
                                    <div class="input-group">
                                        <input type="number" step="0.01" min="0.01" id="pricePerHour" name="pricePerHour" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="status">Trạng Thái (Status):</label>
                                    <div class="input-group">
                                        <select id="status" name="status" required>
                                            <option value="Available">Available (Có sẵn)</option>
                                            <option value="In Use">In Use (Đang sử dụng)</option>
                                            <option value="Maintenance">Maintenance (Bảo trì)</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="description">Mô Tả (Description):</label>
                                    <div class="input-group">
                                        <textarea id="description" name="description" rows="3"></textarea>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit">Thêm Cơ</button>
                                <a href="index.jsp" class="back-link">← Quay Lại</a>
                            </form>
            </div>
        </body>

        </html>