<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa Đơn - H.N.D.D Bida</title>
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
            max-width: 320px;
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
            max-width: 320px;
            background: #fff;
            color: #111;
            border-radius: 4px;
            padding: 20px 18px 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.45);
            font-size: 12px;
            line-height: 1.6;
            /* Jagged bottom edge like thermal paper */
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

        .receipt-header {
            text-align: center;
            margin-bottom: 10px;
        }
        .receipt-header .logo { font-size: 22px; margin-bottom: 2px; }
        .receipt-header .shop-name {
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
        }
        .receipt-header .shop-sub {
            font-size: 9px;
            letter-spacing: 0.12em;
            color: #555;
            text-transform: uppercase;
            margin-top: 1px;
        }
        .receipt-header .shop-addr {
            font-size: 9px;
            color: #777;
            margin-top: 3px;
        }

        .dashed { border: none; border-top: 1px dashed #aaa; margin: 10px 0; }
        .dotted  { border: none; border-top: 1px dotted  #ccc; margin: 8px 0; }

        .row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2px;
        }
        .row .label { color: #444; }
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
            margin-bottom: 4px;
        }
        table.items td { padding: 2px 0; }
        table.items .col-name  { text-align: left; }
        table.items .col-qty   { text-align: center; width: 30px; }
        table.items .col-price { text-align: right; }

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

        .footer-msg {
            text-align: center;
            font-size: 10px;
            color: #888;
            margin-top: 12px;
            letter-spacing: 0.05em;
        }
        .footer-barcode {
            text-align: center;
            font-size: 7px;
            letter-spacing: 0.03em;
            color: #bbb;
            margin-top: 6px;
        }

        /* ── PRINT STYLES ── */
        @media print {
            body {
                background: #fff !important;
                padding: 0 !important;
            }
            .screen-toolbar { display: none !important; }
            .receipt {
                max-width: 80mm;
                box-shadow: none !important;
                border-radius: 0 !important;
                margin: 0 auto;
                padding: 10px 12px 20px;
            }
            .receipt::after { display: none; }
            @page {
                size: 80mm auto;
                margin: 4mm;
            }
        }
    </style>
</head>
<body>

    <div class="screen-toolbar no-print">
        <a href="${pageContext.request.contextPath}/employee/trangchunhanvien" class="btn-back">&laquo; Bảng điều khiển</a>
        <button onclick="window.print()" class="btn-print">🖨️ In hóa đơn</button>
    </div>

    <div class="receipt">

        <!-- Header -->
        <div class="receipt-header">
            <div class="logo">🎱</div>
            <div class="shop-name">H.N.D.D BIDA</div>
            <div class="shop-sub">Premium Billiards Club</div>
            <div class="shop-addr">123 Đường Bida, TP. Hồ Chí Minh</div>
        </div>

        <hr class="dashed">

        <!-- Meta -->
        <div class="row">
            <span class="label">Mã HĐ:</span>
            <span class="value">#b${bill.bill_id}</span>
        </div>
        <div class="row">
            <span class="label">Bàn:</span>
            <span class="value">${table.name}</span>
        </div>
        <c:if test="${not empty member}">
            <div class="row">
                <span class="label">Thành viên:</span>
                <span class="value">${member.name} (${member.phone})</span>
            </div>
        </c:if>
        <div class="row">
            <span class="label">Thu ngân:</span>
            <span class="value">${cashierName}</span>
        </div>
        <div class="row">
            <span class="label">Giờ ra:</span>
            <span class="value">${billEndTimeStr}</span>
        </div>

        <hr class="dashed">

        <!-- Billiard time -->
        <div class="section-title">1. Chi tiết tiền giờ</div>
        <div class="row">
            <span class="label">Giờ vào:</span>
            <span class="value">${billStartTimeStr}</span>
        </div>
        <div class="row">
            <span class="label">Giờ ra:</span>
            <span class="value">${billEndTimeStr}</span>
        </div>
        <div class="row">
            <span class="label">Tổng thời gian:</span>
            <span class="value">
                <c:set var="h" value="${playMinutes / 60}"/>
                <c:set var="m" value="${playMinutes % 60}"/>
                <fmt:formatNumber value="${h}" maxFractionDigits="0"/>h&nbsp;<fmt:formatNumber value="${m}" maxFractionDigits="0"/>p
            </span>
        </div>
        <div class="row">
            <span class="label">Đơn giá/giờ:</span>
            <span class="value"><fmt:formatNumber value="${hourlyRate}" type="number"/>đ</span>
        </div>
        <hr class="dotted">
        <div class="row">
            <span class="label" style="font-weight:600">Tiền giờ:</span>
            <span class="value"><fmt:formatNumber value="${playFee}" type="number"/>đ</span>
        </div>

        <!-- Services -->
        <c:if test="${not empty services}">
            <hr class="dashed">
            <div class="section-title">2. Dịch vụ &amp; Đồ uống</div>
            <table class="items">
                <thead>
                    <tr>
                        <th class="col-name">Tên món</th>
                        <th class="col-qty">SL</th>
                        <th class="col-price">Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${services}">
                        <tr>
                            <td class="col-name">${item.serviceName}</td>
                            <td class="col-qty">x${item.quantity}</td>
                            <td class="col-price"><fmt:formatNumber value="${item.total}" type="number"/>đ</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <hr class="dashed">

        <!-- Sub-totals -->
        <div class="row">
            <span class="label">Tiền giờ:</span>
            <span class="value"><fmt:formatNumber value="${playFee}" type="number"/>đ</span>
        </div>
        <div class="row">
            <span class="label">Dịch vụ:</span>
            <span class="value"><fmt:formatNumber value="${serviceTotal}" type="number"/>đ</span>
        </div>
        
        <c:set var="subtotal" value="${playFee + serviceTotal}"/>
        <c:set var="discountAmount" value="${subtotal - bill.total}"/>
        <c:if test="${discountAmount > 1}">
            <c:set var="discountRate" value="${(discountAmount * 100) / subtotal}"/>
            <div class="row">
                <span class="label">Tạm tính:</span>
                <span class="value"><fmt:formatNumber value="${subtotal}" type="number"/>đ</span>
            </div>
            <div class="row" style="color: #856404">
                <span class="label">Giảm giá (<fmt:formatNumber value="${discountRate}" maxFractionDigits="0"/>%):</span>
                <span class="value">-<fmt:formatNumber value="${discountAmount}" type="number"/>đ</span>
            </div>
        </c:if>

        <!-- Grand total -->
        <div class="total-box">
            <div class="row" style="align-items:center">
                <span class="grand-label">TỔNG CỘNG</span>
                <span class="grand-value"><fmt:formatNumber value="${bill.total}" type="number"/>đ</span>
            </div>
            <c:if test="${not empty member}">
                <c:set var="pointsEarned" value="${bill.total / 1000}"/>
                <div class="row" style="margin-top:4px; font-size:9.5px; color:#10b981; font-weight:600;">
                    <span>Tích điểm lượt chơi:</span>
                    <span>+<fmt:formatNumber value="${pointsEarned}" maxFractionDigits="0"/> điểm</span>
                </div>
                <div class="row" style="margin-top:2px; font-size:9.5px; color:#666; font-weight:600;">
                    <span>Tổng điểm hiện tại:</span>
                    <span>${member.points} điểm</span>
                </div>
            </c:if>
        </div>

        <hr class="dashed">

        <div class="footer-msg">Xin cảm ơn quý khách!<br>Hẹn gặp lại lần sau 🎱</div>
        <div class="footer-barcode">*** HÓA ĐƠN NÀY CÓ GIÁ TRỊ THANH TOÁN ***</div>

    </div>

</body>
</html>
