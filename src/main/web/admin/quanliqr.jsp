<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Mã QR Bàn - H.N.D.D Bida</title>
    <%@ include file="sidebar.jsp" %>

    <!-- QR Code Library (no external server needed, pure JS) -->
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>

    <style>
        @media print {
            .bida-sidebar, .bida-topnav, .no-print { display: none !important; }
            .with-sidebar { padding-left: 0 !important; }
            body { background: white !important; }
            .print-card {
                break-inside: avoid;
                border: 2px solid #333 !important;
                box-shadow: none !important;
                background: white !important;
            }
            .print-card .qr-label { color: black !important; }
            .print-area {
                display: grid !important;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }
        }

        .qr-card {
            background: linear-gradient(145deg, rgba(20,55,35,0.92) 0%, rgba(6,18,12,0.98) 100%);
            border: 1px solid rgba(212,175,55,0.15);
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.25s ease;
            box-shadow: 0 8px 25px rgba(0,0,0,0.35);
        }
        .qr-card:hover {
            border-color: rgba(212,175,55,0.35);
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.4);
        }

        .qr-box {
            background: white;
            border-radius: 12px;
            padding: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .qr-status-available { background: rgba(34,197,94,0.1); color: #86efac; border: 1px solid rgba(34,197,94,0.25); }
        .qr-status-occupied  { background: rgba(234,179,8,0.1);  color: #fde047; border: 1px solid rgba(234,179,8,0.25);  }
        .qr-status-other     { background: rgba(100,116,139,0.15); color: #94a3b8; border: 1px solid rgba(100,116,139,0.25); }

        .download-btn {
            background: rgba(212,175,55,0.1);
            border: 1px solid rgba(212,175,55,0.25);
            color: #d4af37;
            transition: all 0.2s;
        }
        .download-btn:hover { background: rgba(212,175,55,0.2); }

        .print-single-btn {
            background: rgba(59,130,246,0.1);
            border: 1px solid rgba(59,130,246,0.25);
            color: #93c5fd;
            transition: all 0.2s;
        }
        .print-single-btn:hover { background: rgba(59,130,246,0.2); }

        /* Modal print preview */
        .print-modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.7); backdrop-filter: blur(8px);
            z-index: 1000; align-items: center; justify-content: center;
        }
        .print-modal-overlay.active { display: flex; }

        .qr-preview-box {
            background: white;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            max-width: 320px;
            width: 100%;
        }
        .qr-preview-box .table-label {
            font-family: 'Playfair Display', serif;
            font-size: 28px; font-weight: 700; color: #1e110a;
            margin-bottom: 4px;
        }
        .qr-preview-box .table-sub {
            font-size: 12px; color: #555; margin-bottom: 16px;
            letter-spacing: 0.05em;
        }
        .qr-preview-box .club-name {
            font-family: 'Playfair Display', serif;
            font-size: 16px; font-weight: 700; color: #1e110a;
            margin-top: 14px;
        }
        .qr-preview-box .club-sub {
            font-size: 10px; color: #777;
            letter-spacing: 0.1em; text-transform: uppercase;
        }
    </style>
</head>

<body>
<%-- Top Navigation Bar --%>
<div class="bida-topnav no-print">
    <div class="flex items-center gap-3">
        <span class="text-2xl">🎱</span>
        <div>
            <h2 class="text-base font-bold text-[#f9e596] font-classic">Quản Lý Mã QR Bàn</h2>
            <p class="text-xs text-[#d4af37]/50">Mỗi bàn có mã QR riêng — Khách quét để gọi phục vụ & order đồ</p>
        </div>
    </div>

    <div class="flex items-center gap-3">
        <!-- Print All button -->
        <button onclick="printAllQR()" 
                class="btn-gold no-print">
            <i class="fas fa-print"></i> In Tất Cả QR
        </button>
        <!-- Download All button -->
        <button onclick="downloadAllQR()" 
                class="btn-gold no-print" style="background: linear-gradient(180deg,#3b82f6,#1d4ed8); border-color:#1e40af; color:white;">
            <i class="fas fa-download"></i> Tải Tất Cả
        </button>
    </div>
</div>

<div style="padding: 32px 32px 32px 32px;">

    <!-- Info Banner -->
    <div class="bida-card p-4 mb-6 flex items-start gap-4 no-print">
        <div class="text-3xl mt-1">📱</div>
        <div>
            <h3 class="font-bold text-[#f9e596] font-classic mb-1">Hướng Dẫn Sử Dụng Mã QR</h3>
            <p class="text-sm text-gray-400">
                In mã QR và đặt tại mỗi bàn bida. Khi khách quét mã bằng camera điện thoại, họ sẽ được chuyển đến 
                trang <strong class="text-[#d4af37]">gọi nhân viên</strong> hoặc <strong class="text-[#d4af37]">order đồ uống</strong> dành riêng cho bàn đó.
                Yêu cầu sẽ hiển thị ngay trên màn hình nhân viên với <strong class="text-emerald-400">thông báo âm thanh</strong>.
            </p>
        </div>
    </div>

    <!-- Stats row -->
    <div class="grid grid-cols-3 gap-4 mb-8 no-print">
        <div class="bida-card p-4 text-center">
            <div class="text-3xl font-classic font-bold text-[#f9e596]">${tableList.size()}</div>
            <div class="text-xs text-gray-400 mt-1 uppercase tracking-wider">Tổng số bàn</div>
        </div>
        <div class="bida-card p-4 text-center">
            <div class="text-3xl font-classic font-bold text-emerald-300">
                <c:set var="freeCount" value="0"/>
                <c:forEach var="t" items="${tableList}">
                    <c:if test="${t.status == 'Trống'}"><c:set var="freeCount" value="${freeCount + 1}"/></c:if>
                </c:forEach>
                ${freeCount}
            </div>
            <div class="text-xs text-gray-400 mt-1 uppercase tracking-wider">Bàn trống</div>
        </div>
        <div class="bida-card p-4 text-center">
            <div class="text-3xl font-classic font-bold text-amber-400">
                ${tableList.size() - freeCount}
            </div>
            <div class="text-xs text-gray-400 mt-1 uppercase tracking-wider">Đang có khách</div>
        </div>
    </div>

    <!-- QR Grid -->
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-5 print-area" id="qrGrid">
        <c:forEach var="table" items="${tableList}">
            <div class="qr-card print-card flex flex-col" id="card-${table.id}">
                <!-- Table header -->
                <div class="p-4 border-b border-[rgba(212,175,55,0.1)]">
                    <div class="flex items-center justify-between mb-1">
                        <span class="font-classic font-bold text-white text-lg">${table.name}</span>
                        <span class="text-[10px] font-bold uppercase px-2 py-0.5 rounded-full 
                            ${table.status == 'Trống' ? 'qr-status-available' : (table.status == 'Đang sử dụng' ? 'qr-status-occupied' : 'qr-status-other')}">
                            ${table.status}
                        </span>
                    </div>
                    <div class="text-[11px] text-gray-500">${table.tableTypeName}</div>
                </div>

                <!-- QR Code -->
                <div class="flex-1 flex flex-col items-center justify-center p-4 gap-3">
                    <div class="qr-box" id="qr-${table.id}">
                        <%-- QR generated by JS below --%>
                    </div>
                    <div class="text-[10px] text-gray-400 text-center leading-relaxed">
                        Quét để gọi phục vụ<br>hoặc order đồ uống
                    </div>
                </div>

                <!-- Actions -->
                <div class="p-3 border-t border-[rgba(212,175,55,0.08)] flex gap-2 no-print">
                    <button onclick="openPrintPreview(${table.id}, '${table.name}', '${table.tableTypeName}')"
                            class="print-single-btn flex-1 py-2 rounded-lg text-xs font-semibold flex items-center justify-center gap-1">
                        <i class="fas fa-print text-[11px]"></i> In
                    </button>
                    <button onclick="downloadQR(${table.id}, '${table.name}')"
                            class="download-btn flex-1 py-2 rounded-lg text-xs font-semibold flex items-center justify-center gap-1">
                        <i class="fas fa-download text-[11px]"></i> Tải
                    </button>
                    <a href="${pageContext.request.contextPath}/order?table=${table.id}" target="_blank"
                       class="flex-1 py-2 rounded-lg text-xs font-semibold flex items-center justify-center gap-1
                              bg-emerald-900/30 border border-emerald-500/25 text-emerald-300 hover:bg-emerald-900/50 transition">
                        <i class="fas fa-external-link-alt text-[11px]"></i> Xem
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty tableList}">
        <div class="bida-empty">
            <div class="empty-icon">🎱</div>
            <h4>Chưa có bàn bida nào</h4>
            <p>Vui lòng thêm bàn bida trước khi tạo mã QR.</p>
        </div>
    </c:if>

</div>

<!-- Print Preview Modal -->
<div class="print-modal-overlay" id="printModal">
    <div style="background: #0c2617; border: 1px solid rgba(212,175,55,0.3); border-radius: 20px; padding: 24px; max-width: 400px; width: 90%;">
        <div class="modal-header">
            <h3><i class="fas fa-print"></i> In Mã QR Bàn</h3>
            <button onclick="closePrintModal()" class="modal-close">✕</button>
        </div>
        <div class="modal-body flex flex-col items-center gap-4">
            <!-- Preview card to be printed -->
            <div class="qr-preview-box" id="printPreview">
                <div class="table-label" id="previewTableName">Bàn 01</div>
                <div class="table-sub" id="previewTableType">H.N.D.D Premium Billiards</div>
                <div id="previewQR"></div>
                <div class="club-name">🎱 H.N.D.D Bida</div>
                <div class="club-sub">Quét để gọi phục vụ & order đồ</div>
            </div>
            <p class="text-xs text-gray-400 text-center">
                Bấm <strong class="text-[#d4af37]">In ngay</strong> để mở hộp thoại in, hoặc <strong class="text-blue-400">Tải về</strong> dưới dạng PNG.
            </p>
        </div>
        <div class="modal-footer">
            <button onclick="closePrintModal()" class="btn-modal-cancel"><i class="fas fa-times"></i> Đóng</button>
            <button onclick="downloadFromModal()" class="btn-modal-cancel" style="color:#93c5fd; border-color:rgba(59,130,246,0.3);">
                <i class="fas fa-download"></i> Tải PNG
            </button>
            <button onclick="printFromModal()" class="btn-modal-submit"><i class="fas fa-print"></i> In Ngay</button>
        </div>
    </div>
</div>

<script>
    // ── Base URL for QR generation ──
    const BASE_URL = window.location.origin + '${pageContext.request.contextPath}';

    // ── Generate all QR codes ──
    document.addEventListener('DOMContentLoaded', () => {
        <c:forEach var="table" items="${tableList}">
        generateQR(document.getElementById('qr-${table.id}'), '${table.id}', 120);
        </c:forEach>
    });

    function generateQR(el, tableId, size) {
        const url = BASE_URL + '/order?table=' + tableId;
        new QRCode(el, {
            text: url,
            width: size || 120,
            height: size || 120,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });
    }

    // ── Print Preview Modal ──
    let currentPrintTableId = null;

    function openPrintPreview(tableId, tableName, tableType) {
        currentPrintTableId = tableId;
        document.getElementById('previewTableName').textContent = tableName;
        document.getElementById('previewTableType').textContent = tableType || 'H.N.D.D Premium Billiards';

        // Clear and regenerate QR in preview
        const previewQR = document.getElementById('previewQR');
        previewQR.innerHTML = '';
        const url = BASE_URL + '/order?table=' + tableId;
        new QRCode(previewQR, {
            text: url,
            width: 200, height: 200,
            colorDark: '#1e110a',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });

        document.getElementById('printModal').classList.add('active');
    }

    function closePrintModal() {
        document.getElementById('printModal').classList.remove('active');
    }

    function printFromModal() {
        const previewEl = document.getElementById('printPreview');
        const win = window.open('', '_blank');
        win.document.write(`
            <!DOCTYPE html><html><head>
            <meta charset="UTF-8">
            <title>Mã QR - ${previewEl.querySelector('.table-label').textContent}</title>
            <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
            <style>
                body { margin: 0; padding: 40px; display: flex; justify-content: center; font-family: 'Inter', sans-serif; }
                .card { border: 2px solid #1e110a; border-radius: 16px; padding: 30px; text-align: center; max-width: 280px; width: 100%; }
                .table-label { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; color: #1e110a; margin-bottom: 4px; }
                .table-sub { font-size: 11px; color: #555; margin-bottom: 16px; }
                .club-name { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 700; color: #1e110a; margin-top: 14px; }
                .club-sub { font-size: 10px; color: #777; letter-spacing: 0.1em; text-transform: uppercase; }
            </style>
            </head><body>
            <div class="card">${previewEl.innerHTML}</div>
            </body></html>
        `);
        win.document.close();
        setTimeout(() => { win.print(); win.close(); }, 500);
    }

    function downloadFromModal() {
        if (currentPrintTableId !== null) {
            downloadQR(currentPrintTableId, document.getElementById('previewTableName').textContent);
        }
    }

    // ── Download single QR as PNG ──
    function downloadQR(tableId, tableName) {
        const qrEl = document.getElementById('qr-' + tableId);
        const canvas = qrEl.querySelector('canvas');
        if (!canvas) {
            alert('Không tìm thấy QR Code. Vui lòng đợi trang tải xong.');
            return;
        }
        // Create a composite canvas with label
        const padding = 20;
        const labelH = 50;
        const c2 = document.createElement('canvas');
        c2.width  = canvas.width + padding * 2;
        c2.height = canvas.height + padding * 2 + labelH;
        const ctx = c2.getContext('2d');

        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, c2.width, c2.height);

        // Draw QR
        ctx.drawImage(canvas, padding, padding);

        // Draw label
        ctx.fillStyle = '#1e110a';
        ctx.font = 'bold 18px serif';
        ctx.textAlign = 'center';
        ctx.fillText(tableName, c2.width / 2, canvas.height + padding + 28);

        ctx.font = '11px sans-serif';
        ctx.fillStyle = '#666';
        ctx.fillText('H.N.D.D Bida — Quét để order', c2.width / 2, canvas.height + padding + 46);

        // Download
        const link = document.createElement('a');
        link.download = 'QR_' + tableName.replace(/\s/g, '_') + '.png';
        link.href = c2.toDataURL('image/png');
        link.click();
    }

    // ── Print ALL QR codes ──
    function printAllQR() {
        window.print();
    }

    // ── Download ALL QR codes as individual files ──
    async function downloadAllQR() {
        const cards = document.querySelectorAll('[id^="qr-"]');
        for (const qrEl of cards) {
            const tableId = qrEl.id.replace('qr-', '');
            const card = document.getElementById('card-' + tableId);
            const tableName = card.querySelector('.font-classic.font-bold').textContent.trim();
            downloadQR(tableId, tableName);
            await new Promise(r => setTimeout(r, 400)); // small delay between downloads
        }
    }
</script>
</body>
</html>
