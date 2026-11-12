<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem Camera<c:if test="${not empty camTable}"> - ${camTable.name}</c:if> - H.N.D.D Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-card: rgba(255, 255, 255, 0.95);
            --bg-input: #f7f9fa;
            --border-color: #e2e8f0;
            --border-focus: #0c764a;
            --text-primary: #1e293b;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --accent-primary: #0c764a;
            --accent-gradient: linear-gradient(135deg, #0c764a 0%, #0a603c 100%);
            --success: #10b981;
            --success-bg: rgba(16, 185, 129, 0.15);
            --danger: #ef4444;
            --danger-bg: rgba(239, 68, 68, 0.15);
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 14px rgba(0,0,0,0.15);
            --shadow-lg: 0 15px 30px rgba(0,0,0,0.2);
            --radius-sm: 8px; --radius-md: 12px; --radius-lg: 16px; --radius-xl: 20px;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: linear-gradient(rgba(10, 50, 30, 0.85), rgba(10, 35, 25, 0.95)),
                url('https://images.unsplash.com/photo-1544329010-121655104f68?q=80&w=1920') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-primary); min-height: 100vh; line-height: 1.6;
        }

        /* NAVBAR */
        .navbar {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(20px);
            border-bottom: 2px solid #fff; padding: 0 32px; height: 68px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-left { display: flex; align-items: center; gap: 16px; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 8px;
            color: var(--accent-primary); text-decoration: none; font-size: 13px; font-weight: 600;
            border: 1px solid var(--border-color); padding: 8px 14px; border-radius: var(--radius-sm);
            transition: all 0.2s;
        }
        .btn-back:hover { background: var(--accent-primary); color: white; }
        .navbar-user { display: flex; align-items: center; gap: 16px; }
        .navbar-user .user-info { text-align: right; }
        .navbar-user .user-name { font-size: 14px; font-weight: 600; color: var(--text-primary); }
        .navbar-user .user-role { font-size: 11px; color: var(--accent-primary); text-transform: uppercase; letter-spacing: 1px; font-weight: 600; }
        .navbar-user .avatar {
            width: 40px; height: 40px; border-radius: 50%; background: var(--accent-gradient);
            display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 16px; color: white;
        }
        .btn-logout {
            background: rgba(239,68,68,0.15); color: var(--danger); border: 1px solid rgba(239,68,68,0.3);
            padding: 8px 16px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all 0.3s; text-decoration: none;
        }
        .btn-logout:hover { background: var(--danger); color: white; transform: translateY(-1px); }

        /* MAIN */
        .main-content { max-width: 1000px; margin: 0 auto; padding: 32px; }

        .page-header { margin-bottom: 24px; }
        .page-header .page-title { font-size: 28px; font-weight: 800; color: white; }
        .page-header .page-subtitle { font-size: 14px; color: rgba(255,255,255,0.7); margin-top: 4px; }

        .alert { padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; }
        .alert-danger { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.3); }

        .card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 28px; box-shadow: var(--shadow-sm); }

        .auth-controls, .controls { display: flex; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
        input.form-control {
            padding: 12px 14px; border: 1px solid var(--border-color); border-radius: var(--radius-sm);
            background: var(--bg-input); color: var(--text-primary); flex-grow: 1; font-size: 14px; font-family: inherit;
        }
        input.form-control:focus { outline: none; border-color: var(--border-focus); box-shadow: 0 0 0 3px rgba(12,118,74,0.15); }

        .btn { padding: 12px 22px; border-radius: var(--radius-sm); font-size: 14px; font-weight: 700; font-family: inherit; cursor: pointer; transition: all 0.3s; border: none; display: inline-flex; align-items: center; gap: 8px; }
        .btn-primary { background: var(--accent-gradient); color: white; box-shadow: 0 4px 12px rgba(12,118,74,0.25); }
        .btn-primary:hover { transform: translateY(-1px); }
        .btn-stop { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.25); }
        .btn-stop:hover { background: var(--danger); color: white; }

        .video-container {
            width: 100%; aspect-ratio: 16/9; background: #000; border-radius: var(--radius-md);
            overflow: hidden; display: flex; justify-content: center; align-items: center;
            border: 2px dashed var(--border-color); position: relative; margin-top: 8px;
        }
        #camera-stream { width: 100%; height: 100%; object-fit: contain; display: none; }
        .placeholder { color: var(--text-muted); font-size: 1.1rem; text-align: center; padding: 20px; }
        .placeholder i { font-size: 40px; display: block; margin-bottom: 12px; opacity: 0.5; }

        .table-info { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; font-size: 14px; color: var(--text-secondary); }
        .table-info strong { color: var(--text-primary); font-size: 16px; }

        @media (max-width: 768px) {
            .main-content { padding: 16px; }
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

    <!-- NAVBAR -->
    <nav class="navbar" style="padding-left: 32px;">
        <div class="navbar-left">
            <a href="${pageContext.request.contextPath}/admin/camera" class="btn-back">
                <i class="fas fa-arrow-left"></i> Danh Sách Camera
            </a>
        </div>
        <div class="navbar-user">
            <div class="user-info">
                <div class="user-name">${sessionScope.account.name}</div>
                <div class="user-role">Administrator</div>
            </div>
            <div class="avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">
                        ${sessionScope.account.name.substring(0,1).toUpperCase()}
                    </c:when>
                    <c:otherwise>A</c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/dangnhap?action=logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </nav>

    <!-- MAIN -->
    <div class="main-content">
        <div class="page-header">
            <h1 class="page-title">Giám Sát Camera</h1>
            <p class="page-subtitle">Xem trực tiếp hình ảnh camera gắn tại bàn bida</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty camTable}">
            <div class="card">
                <div class="table-info">
                    <i class="fas fa-table-cells" style="color: var(--accent-primary)"></i>
                    Bàn: <strong>${camTable.name}</strong>
                    <span id="save-status" style="margin-left: auto; font-size: 12.5px; font-weight: 600; opacity: 0; transition: opacity 0.3s;"></span>
                </div>

                <div class="auth-controls">
                    <input type="text" id="username" class="form-control" placeholder="Tài khoản (Bỏ trống nếu không cài)"
                           value="${fn:escapeXml(camTable.cameraUsername)}" />
                    <input type="password" id="password" class="form-control" placeholder="Mật khẩu (Bỏ trống nếu không cài)"
                           value="${fn:escapeXml(camTable.cameraPassword)}" />
                </div>

                <div class="controls">
                    <input type="text" id="ip-address" class="form-control" placeholder="Nhập IP (VD: 192.168.1.100)"
                           value="${fn:escapeXml(camTable.cameraIp)}" />
                    <input type="text" id="port" class="form-control" placeholder="Port"
                           value="${not empty camTable.cameraPort ? fn:escapeXml(camTable.cameraPort) : '8080'}" style="max-width: 100px;" />
                    <select id="connect-mode" class="form-control" style="max-width: 180px;">
                        <option value="proxy" selected>Proxy Server (Sửa CORS)</option>
                        <option value="direct">Kết nối trực tiếp IP</option>
                    </select>
                    <button type="button" class="btn btn-primary" onclick="connectCamera()">
                        <i class="fas fa-play"></i> Kết nối
                    </button>
                    <button type="button" class="btn btn-stop" onclick="stopCamera()">
                        <i class="fas fa-stop"></i> Ngắt kết nối
                    </button>
                </div>

                <div class="video-container">
                    <div class="placeholder" id="placeholder-text">
                        <i class="fas fa-video-slash"></i>
                        Chưa kết nối đến Camera...
                    </div>
                    <img id="camera-stream" alt="Live Stream Camera" />
                </div>
            </div>
        </c:if>
    </div>

    <script>
        function connectCamera() {
            const ip = document.getElementById('ip-address').value.trim();
            const port = document.getElementById('port').value.trim();
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const mode = document.getElementById('connect-mode') ? document.getElementById('connect-mode').value : 'proxy';
            const streamImg = document.getElementById('camera-stream');
            const placeholder = document.getElementById('placeholder-text');

            if (!ip || !port) {
                alert('Vui lòng nhập đầy đủ địa chỉ IP và Port!');
                return;
            }

            let streamUrl = '';
            if (mode === 'proxy' || username || password) {
                // Xử lý qua Backend Proxy: Khắc phục triệt để CORS và trình duyệt chặn http://user:pass@ip:port
                streamUrl = '${pageContext.request.contextPath}/admin/camera-stream?' +
                    'ip=' + encodeURIComponent(ip) +
                    '&port=' + encodeURIComponent(port) +
                    '&username=' + encodeURIComponent(username) +
                    '&password=' + encodeURIComponent(password) +
                    '&path=/video&t=' + new Date().getTime();
            } else {
                // Kết nối trực tiếp (đã bỏ crossorigin="anonymous" để trình duyệt không kiểm tra CORS header)
                streamUrl = 'http://' + ip + ':' + port + '/video?t=' + new Date().getTime();
            }

            streamImg.onerror = function() {
                if (mode === 'direct') {
                    console.warn('Kết nối trực tiếp thất bại, tự động thử lại qua Backend Proxy...');
                    const proxyUrl = '${pageContext.request.contextPath}/admin/camera-stream?' +
                        'ip=' + encodeURIComponent(ip) +
                        '&port=' + encodeURIComponent(port) +
                        '&username=' + encodeURIComponent(username) +
                        '&password=' + encodeURIComponent(password) +
                        '&path=/video&t=' + new Date().getTime();
                    streamImg.onerror = function() {
                        alert('Không thể kết nối tới Camera. Vui lòng kiểm tra lại địa chỉ IP, Port hoặc trạng thái thiết bị!');
                        stopCamera();
                    };
                    streamImg.src = proxyUrl;
                } else {
                    alert('Không thể kết nối tới Camera qua Proxy Server. Vui lòng kiểm tra địa chỉ IP/Port của Camera!');
                    stopCamera();
                }
            };

            streamImg.onload = function() {
                streamImg.style.display = 'block';
                placeholder.style.display = 'none';
            };

            streamImg.src = streamUrl;
            streamImg.style.display = 'block';
            placeholder.style.display = 'none';
        }

        function stopCamera() {
            const streamImg = document.getElementById('camera-stream');
            const placeholder = document.getElementById('placeholder-text');

            streamImg.onerror = null;
            streamImg.onload = null;
            streamImg.src = '';
            streamImg.style.display = 'none';
            placeholder.style.display = 'block';
        }

        document.addEventListener('DOMContentLoaded', function () {
            const ip = document.getElementById('ip-address');
            if (ip && ip.value.trim()) {
                connectCamera();
            }
        });

        // ===== TỰ ĐỘNG LƯU KHI NHẬP XONG (BLUR) =====
        <c:if test="${not empty camTable}">
        const CAMERA_TABLE_ID = ${camTable.id};
        const CAMERA_SAVE_URL = '${pageContext.request.contextPath}/admin/camera';
        let saveStatusTimer = null;

        function showSaveStatus(text, isError) {
            const el = document.getElementById('save-status');
            if (!el) return;
            clearTimeout(saveStatusTimer);
            el.textContent = text;
            el.style.color = isError ? 'var(--danger)' : 'var(--success)';
            el.style.opacity = '1';
            saveStatusTimer = setTimeout(() => { el.style.opacity = '0'; }, 2500);
        }

        function saveCameraConfig() {
            const body = new URLSearchParams();
            body.append('action', 'save');
            body.append('id', CAMERA_TABLE_ID);
            body.append('cameraIp', document.getElementById('ip-address').value.trim());
            body.append('cameraPort', document.getElementById('port').value.trim());
            body.append('cameraUsername', document.getElementById('username').value.trim());
            body.append('cameraPassword', document.getElementById('password').value.trim());

            fetch(CAMERA_SAVE_URL, { method: 'POST', body: body })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showSaveStatus('✓ Đã lưu thông tin camera', false);
                    } else {
                        showSaveStatus('✗ Lưu thất bại', true);
                    }
                })
                .catch(() => showSaveStatus('✗ Không thể kết nối máy chủ', true));
        }

        ['ip-address', 'port', 'username', 'password'].forEach(function (id) {
            const el = document.getElementById(id);
            if (el) el.addEventListener('blur', saveCameraConfig);
        });
        </c:if>
    </script>

</body>
</html>
