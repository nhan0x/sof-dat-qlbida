<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    request.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa Đơn Thuê Tủ - H.N.D.D Bida</title>
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
        .receipt-header .shop-name { font-size: 15px; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; }
        .receipt-header .shop-sub { font-size: 9px; letter-spacing: 0.12em; color: #555; text-transform: uppercase; margin-top: 1px; }
        .receipt-header .shop-addr { font-size: 9px; color: #777; margin-top: 3px; }

        .dashed { border: none; border-top: 1px dashed #aaa; margin: 10px 0; }
        .dotted  { border: none; border-top: 1px dotted  #ccc; margin: 8px 0; }

        .row { display: flex; justify-content: space-between; margin-bottom: 2px; }
        .row .label { color: #444; }
        .row .value { font-weight: 600; text-align: right; }

        .section-title { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: #333; margin-bottom: 6px; }

        .total-box {
            background: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 8px 10px;
            margin-top: 10px;
        }
        .total-box .grand-label { font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
        .total-box .grand-value { font-size: 18px; font-weight: 700; text-align: right; }

        .footer-msg { text-align: center; font-size: 10px; color: #888; margin-top: 12px; letter-spacing: 0.05em; }
        .footer-barcode { text-align: center; font-size: 7px; letter-spacing: 0.03em; color: #bbb; margin-top: 6px; }

        /* ── PRINT STYLES ── */
        @media print {
            body { background: #fff !important; padding: 0 !important; }
            .screen-toolbar { display: none !important; }
            .receipt {
                max-width: 80mm;
                box-shadow: none !important;
                border-radius: 0 !important;
                margin: 0 auto;
                padding: 10px 12px 20px;
            }
            .receipt::after { display: none; }
            @page { size: 80mm auto; margin: 4mm; }
        }
    </style>
</head>
<body>

    <div class="screen-toolbar no-print">
        <a href="${pageContext.request.contextPath}/admin/quanlilocker" class="btn-back">&laquo; Quản lý tủ</a>
        <button onclick="window.print()" class="btn-print">🖨️ In hóa đơn</button>
    </div>

    <div class="receipt">

        <!-- Header -->
        <div class="receipt-header">
            <div class="logo">🔑</div>
            <div class="shop-name">H.N.D.D BIDA</div>
            <div class="shop-sub">Hóa Đơn Thuê Tủ Đựng Cơ</div>
            <div class="shop-addr">123 Đường Bida, TP. Hồ Chí Minh</div>
        </div>

        <hr class="dashed">

        <!-- Meta -->
        <div class="row">
            <span class="label">Mã Tủ:</span>
            <span class="value">Tủ ${locker.lockerNumber}</span>
        </div>
        <c:choose>
            <c:when test="${not empty locker.memberName}">
                <div class="row">
                    <span class="label">Thành viên:</span>
                    <span class="value">${locker.memberName}</span>
                </div>
                <div class="row">
                    <span class="label">SĐT:</span>
                    <span class="value">${locker.memberPhone}</span>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <span class="label">Khách hàng:</span>
                    <span class="value">${locker.customerName}</span>
                </div>
            </c:otherwise>
        </c:choose>
        <div class="row">
            <span class="label">Ngày lập:</span>
            <span class="value"><%= DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy").format(java.time.LocalDateTime.now()) %></span>
        </div>

        <hr class="dashed">

        <!-- Rental period -->
        <div class="section-title">Thời Gian Thuê</div>
        <div class="row">
            <span class="label">Bắt đầu:</span>
            <span class="value">${locker.startDate.format(dateFormatter)}</span>
        </div>
        <div class="row">
            <span class="label">Kết thúc:</span>
            <span class="value">${locker.endDate.format(dateFormatter)}</span>
        </div>

        <hr class="dashed">

        <!-- Payment -->
        <div class="row">
            <span class="label">Hình thức TT:</span>
            <span class="value">
                <c:choose>
                    <c:when test="${fn:startsWith(locker.note, '[CK]')}">🏦 Chuyển khoản</c:when>
                    <c:otherwise>💵 Tiền mặt</c:otherwise>
                </c:choose>
            </span>
        </div>
        <c:if test="${fn:startsWith(locker.note, '[TM]') || fn:startsWith(locker.note, '[CK]')}">
            <c:set var="displayNote" value="${fn:length(locker.note) > 4 ? fn:substring(locker.note, 4, fn:length(locker.note)) : ''}"/>
        </c:if>
        <c:if test="${not empty displayNote}">
            <div class="row">
                <span class="label">Ghi chú:</span>
                <span class="value">${displayNote}</span>
            </div>
        </c:if>

        <!-- Grand total -->
        <div class="total-box">
            <div class="row" style="align-items:center">
                <span class="grand-label">TỔNG CỘNG</span>
                <span class="grand-value"><fmt:formatNumber value="${locker.price}" type="number"/>đ</span>
            </div>
        </div>

        <hr class="dashed">

        <div class="footer-msg">Xin cảm ơn quý khách!<br>Vui lòng giữ hóa đơn để đối chiếu 🔑</div>
        <div class="footer-barcode">*** HÓA ĐƠN NÀY CÓ GIÁ TRỊ THANH TOÁN ***</div>

    </div>

</body>
</html>
