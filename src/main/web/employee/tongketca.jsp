<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Tổng Kết Ca - H.N.D.D Bida</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600;700&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: #1a1a2e;
            font-family: 'IBM Plex Mono', 'Courier New', monospace;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 24px 16px;
            min-height: 100vh;
        }

        .screen-toolbar {
            width: 100%;
            max-width: 360px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .btn-back {
            background: #2d2d44;
            color: #c9a84c;
            border: 1px solid #4a3f1a;
            padding: 7px 14px;
            border-radius: 6px;
            font-size: 11px;
            font-family: inherit;
            text-decoration: none;
            font-weight: 600;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-back:hover { background: #3a3a5c; }

        .btn-print {
            background: linear-gradient(to bottom, #d4af37, #aa8511);
            color: #1a1200;
            border: 1px solid #8a6a09;
            padding: 7px 16px;
            border-radius: 6px;
            font-size: 11px;
            font-family: inherit;
            font-weight: 700;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-print:hover { opacity: 0.85; }

        /* ── RECEIPT ── */
        .receipt {
            width: 100%;
            max-width: 360px;
            background: #fff;
            color: #111;
            border-radius: 4px;
            padding: 20px 18px 28px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.45);
            font-size: 12px;
            line-height: 1.6;
            position: relative;
        }
        .receipt::after {
            content: '';
            display: block;
            position: absolute;
            bottom: -8px;
            left: 0;
            right: 0;
            height: 8px;
            background:
                linear-gradient(135deg, #fff 33.33%, transparent 33.33%) 0 0,
                linear-gradient(-135deg, #fff 33.33%, transparent 33.33%) 0 0;
            background-size: 8px 8px;
            background-color: #1a1a2e;
        }

        .receipt-header { text-align: center; margin-bottom: 10px; }
        .receipt-header .logo { font-size: 22px; margin-bottom: 2px; }
        .receipt-header .shop-name {
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
        }
        .receipt-header .doc-type {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            background: #111;
            color: #fff;
            display: inline-block;
            padding: 2px 10px;
            border-radius: 2px;
            margin-top: 5px;
        }
        .receipt-header .shop-sub {
            font-size: 9px;
            letter-spacing: 0.12em;
            color: #555;
            text-transform: uppercase;
            margin-top: 3px;
        }

        .dashed { border: none; border-top: 1px dashed #aaa; margin: 10px 0; }
        .dotted  { border: none; border-top: 1px dotted  #ccc; margin: 8px 0; }

        .row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3px;
            gap: 6px;
        }
        .row .label { color: #444; flex-shrink: 0; }
        .row .value { font-weight: 600; text-align: right; }

        .section-title {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: #333;
            margin-bottom: 6px;
        }

        table.items {
            width: 100%;
            border-collapse: collapse;
            font-size: 11px;
        }
        table.items th {
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #555;
            border-bottom: 1px dashed #aaa;
            padding-bottom: 4px;
        }
        table.items td { padding: 2px 0; }
        table.items .col-id    { text-align: left; width: 50px; }
        table.items .col-table { text-align: left; }
        table.items .col-time  { text-align: left; font-size: 10px; color: #555; }
        table.items .col-total { text-align: right; font-weight: 600; }

        .total-box {
            background: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 8px 10px;
            margin-top: 10px;
        }
        .total-box .grand-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }
        .total-box .grand-value {
            font-size: 18px;
            font-weight: 700;
            text-align: right;
        }
        .total-box .sub-row {
            font-size: 10px;
            color: #555;
            display: flex;
            justify-content: space-between;
            margin-bottom: 2px;
        }

        .sig-row {
            display: flex;
            justify-content: space-between;
            font-size: 10px;
            color: #444;
            margin-top: 14px;
        }
        .sig-row .sig-block { text-align: center; }
        .sig-row .sig-block .sig-label { font-size: 9px; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 28px; }
        .sig-row .sig-block .sig-line { border-top: 1px solid #999; width: 100px; }

        .footer-msg {
            text-align: center;
            font-size: 10px;
            color: #888;
            margin-top: 12px;
            letter-spacing: 0.04em;
        }
        .footer-barcode {
            text-align: center;
            font-size: 7px;
            letter-spacing: 0.03em;
            color: #bbb;
            margin-top: 5px;
        }

        /* ── PRINT ── */
        @media print {
            body { background: #fff !important; padding: 0 !important; }
            .screen-toolbar { display: none !important; }
            .receipt {
                max-width: 90mm;
                box-shadow: none !important;
                border-radius: 0 !important;
                margin: 0 auto;
                padding: 10px 12px 24px;
            }
            .receipt::after { display: none; }
            @page {
                size: 90mm auto;
                margin: 4mm;
            }
        }
    </style>
</head>
<body>

    <div class="screen-toolbar">
        <c:choose>
            <c:when test="${loggedOut}">
                <a href="${pageContext.request.contextPath}/dangnhap" class="btn-back">&laquo; Về trang đăng nhập</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/employee/trangchunhanvien" class="btn-back">&laquo; Bảng điều khiển</a>
            </c:otherwise>
        </c:choose>
        <button onclick="window.print()" class="btn-print">🖨️ In Báo Cáo</button>
    </div>

    <c:if test="${loggedOut}">
        <div style="max-width:360px;margin:0 auto 14px;padding:12px 14px;border-radius:10px;
                    background:#fff8e1;border:1px solid #e0c060;color:#7a5c00;font-size:12px;text-align:center;">
            Bạn đã đóng ca và được <strong>đăng xuất khỏi hệ thống</strong>.
            Vui lòng in/lưu báo cáo này trước khi rời trang.
        </div>
    </c:if>

    <div class="receipt">

        <!-- Header -->
        <div class="receipt-header">
            <div class="logo">📋</div>
            <div class="shop-name">H.N.D.D BIDA</div>
            <div class="doc-type">Báo Cáo Tổng Kết Ca</div>
            <div class="shop-sub">H.N.D.D Bida Club</div>
        </div>

        <hr class="dashed">

        <!-- Shift info -->
        <div class="row">
            <span class="label">Nhân viên:</span>
            <span class="value">${employee.name}</span>
        </div>
        <div class="row">
            <span class="label">Trạng thái:</span>
            <span class="value">ĐÃ ĐÓNG CA</span>
        </div>
        <div class="row">
            <span class="label">Giờ bắt đầu:</span>
            <span class="value">${shiftTimeStartStr}</span>
        </div>
        <div class="row">
            <span class="label">Giờ kết thúc:</span>
            <span class="value">${shiftTimeEndStr}</span>
        </div>

        <hr class="dashed">

        <!-- Revenue summary -->
        <div class="section-title">Thông số két tiền &amp; Kiểm kê</div>
        <div class="row">
            <span class="label">Tiền mặt đầu ca:</span>
            <span class="value"><fmt:formatNumber value="${shift.initialBalance}" type="number"/>đ</span>
        </div>
        <div class="row">
            <span class="label">Doanh thu phát sinh:</span>
            <span class="value">+<fmt:formatNumber value="${computedRevenue}" type="number"/>đ</span>
        </div>
        <hr class="dotted">
        <div class="total-box">
            <div class="sub-row">
                <span>Tiền mặt đầu ca</span>
                <span><fmt:formatNumber value="${shift.initialBalance}" type="number"/>đ</span>
            </div>
            <div class="sub-row">
                <span>Doanh thu ca</span>
                <span>+<fmt:formatNumber value="${computedRevenue}" type="number"/>đ</span>
            </div>
            <hr class="dotted" style="margin:6px 0">
            <div class="row" style="align-items:center; margin-bottom:0">
                <span class="grand-label">TỔNG KỲ VỌNG</span>
                <span class="grand-value"><fmt:formatNumber value="${grandTotalAmount}" type="number"/>đ</span>
            </div>
        </div>

        <hr class="dotted">
        <div class="row">
            <span class="label">Tiền đếm thực tế cuối ca:</span>
            <span class="value" style="font-size:13px;"><fmt:formatNumber value="${shift.closingBalance}" type="number"/>đ</span>
        </div>
        <div class="row" style="align-items:center; margin-top:4px;">
            <span class="label">Kết quả đối soát:</span>
            <span class="value">
                <c:choose>
                    <c:when test="${cashDifference > 0}">
                        <span style="color:#047857; background:#d1fae5; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700;">
                            +<fmt:formatNumber value="${cashDifference}" type="number"/>đ (THỪA/DƯ KÉT)
                        </span>
                    </c:when>
                    <c:when test="${cashDifference < 0}">
                        <span style="color:#b91c1c; background:#fee2e2; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700;">
                            <fmt:formatNumber value="${cashDifference}" type="number"/>đ (THIẾU KÉT)
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span style="color:#065f46; background:#ecfdf5; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700;">
                            0đ (KHỚP KÉT 100%)
                        </span>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>

        <c:if test="${not empty shift.note}">
            <div style="margin-top:10px; padding:8px 10px; background:#f9fafb; border:1px solid #e5e7eb; border-radius:4px; font-size:11px;">
                <div style="font-weight:700; font-size:9px; color:#6b7280; text-transform:uppercase; margin-bottom:2px;">Ghi chú bàn giao &amp; Giải trình:</div>
                <div style="color:#1f2937; white-space:pre-wrap;">${shift.note}</div>
            </div>
        </c:if>

        <hr class="dashed">

        <!-- Bill list -->
        <div class="section-title">Danh sách hóa đơn</div>
        <c:choose>
            <c:when test="${not empty shiftBills}">
                <table class="items">
                    <thead>
                        <tr>
                            <th class="col-id">Mã HĐ</th>
                            <th class="col-table">Bàn</th>
                            <th class="col-time">Giờ TT</th>
                            <th class="col-total">Tổng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="bill" items="${shiftBills}">
                            <tr>
                                <td class="col-id">#b${bill.bill_id}</td>
                                <td class="col-table">${bill.table_id}</td>
                                <td class="col-time">${bill.timeEndStr}</td>
                                <td class="col-total"><fmt:formatNumber value="${bill.total}" type="number"/>đ</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align:center; color:#999; font-size:11px; padding: 8px 0; font-style:italic;">
                    Ca làm việc không có giao dịch nào.
                </div>
            </c:otherwise>
        </c:choose>

        <hr class="dashed">

        <!-- Signatures -->
        <div class="sig-row">
            <div class="sig-block">
                <div class="sig-label">Nhân viên ký tên</div>
                <div class="sig-line"></div>
            </div>
            <div class="sig-block">
                <div class="sig-label">Quản lý ký tên</div>
                <div class="sig-line"></div>
            </div>
        </div>

        <div class="footer-msg">H.N.D.D Bida — Báo cáo được in tự động</div>
        <div class="footer-barcode">*** TÀI LIỆU NỘI BỘ — KHÔNG PHÁT HÀNH NGOÀI ***</div>

    </div>

</body>
</html>
