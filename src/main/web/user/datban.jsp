<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D - Đặt Bàn Bida</title>
    <%@ include file="../common/head.jsp" %>
    <style>
        /* =========================================
           BASE & TYPOGRAPHY
        ========================================= */
        * { box-sizing: border-box; }

        body { overflow-x: hidden; }

        /* =========================================
           NAVBAR
        ========================================= */
        .top-nav {
            position: sticky;
            top: 0;
            z-index: 50;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 16px;
            background: linear-gradient(180deg,#4e342e,#2c1810);
            border-bottom: 1px solid rgba(212,175,55,0.25);
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        @media (min-width: 640px) {
            .top-nav { height: 64px; padding: 0 24px; }
        }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-brand-title { font-size: 18px; font-weight: 700; }
        @media (min-width: 640px) { .nav-brand-title { font-size: 20px; } }
        .nav-actions { display: flex; align-items: center; gap: 6px; }
        @media (min-width: 640px) { .nav-actions { gap: 12px; } }
        .nav-link {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 12px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            color: rgba(234,179,8,0.7);
            text-decoration: none;
            transition: background .2s, color .2s;
        }
        .nav-link:hover { background: rgba(161,98,7,0.2); color: #fde68a; }
        .nav-link span { display: none; }
        @media (min-width: 480px) { .nav-link span { display: inline; } }
        .avatar-ring {
            background: linear-gradient(135deg,#d4af37,#997a15);
            padding: 2px; border-radius: 50%;
        }
        .avatar-inner {
            background: #1a4a2e; border-radius: 50%;
            width: 30px; height: 30px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 12px; color: #d4af37;
        }
        @media (min-width: 640px) { .avatar-inner { width: 34px; height: 34px; font-size: 13px; } }
        .nav-user { display: none; }
        @media (min-width: 640px) { .nav-user { display: block; text-align: right; } }

        /* =========================================
           PAGE WRAPPER
        ========================================= */
        .page-wrap {
            min-height: calc(100vh - 56px);
            padding: 20px 12px 40px;
            max-width: 1400px;
            margin: 0 auto;
        }
        @media (min-width: 640px) { .page-wrap { padding: 28px 20px 48px; } }
        @media (min-width: 1024px) { .page-wrap { padding: 36px 32px 60px; } }

        /* =========================================
           PAGE TITLE
        ========================================= */
        .page-title { text-align: center; margin-bottom: 20px; }
        .page-title h1 { font-size: 24px; font-weight: 700; color: #fff; margin: 0 0 4px; }
        @media (min-width: 640px) { .page-title h1 { font-size: 30px; } }
        .title-divider {
            width: 50px; height: 1px;
            background: linear-gradient(90deg,transparent,#d4af37,transparent);
            margin: 10px auto;
        }
        .page-title p { font-size: 13px; color: #9ca3af; margin: 0; }
        @media (min-width: 640px) { .page-title p { font-size: 14px; } }

        /* =========================================
           TOAST
        ========================================= */
        .toast {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 16px;
            border-radius: 16px;
            font-size: 13px;
            margin-bottom: 16px;
            animation: slideDown .3s ease;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .toast-error   { background: rgba(239,68,68,.12);  border: 1px solid rgba(239,68,68,.35);  color: #f87171; }
        .toast-success { background: rgba(34,197,94,.12);  border: 1px solid rgba(34,197,94,.35);  color: #86efac; }
        .toast-close {
            margin-left: auto; flex-shrink: 0;
            background: none; border: none; cursor: pointer; padding: 2px 6px;
            font-size: 15px; border-radius: 6px;
            opacity: .7; transition: opacity .2s;
        }
        .toast-close:hover { opacity: 1; }

        /* =========================================
           FILTER BAR
        ========================================= */
        .filter-bar {
            background: linear-gradient(135deg, rgba(30,15,8,0.97), rgba(18,10,4,0.99));
            border: 1px solid rgba(212,175,55,0.22);
            border-radius: 20px;
            padding: 16px 16px 14px;
            box-shadow: 0 8px 32px rgba(0,0,0,.5), inset 0 1px 0 rgba(212,175,55,.08);
            margin-bottom: 20px;
        }
        @media (min-width: 640px) { .filter-bar { padding: 20px 22px 18px; margin-bottom: 24px; } }

        .filter-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        @media (min-width: 640px) { .filter-grid { grid-template-columns: 1fr 1fr 1fr; gap: 12px; } }
        @media (min-width: 900px) { .filter-grid { grid-template-columns: 1fr 1fr 1fr auto; align-items: end; gap: 14px; } }

        .filter-field { display: flex; flex-direction: column; }
        .filter-field.full-on-mobile { grid-column: 1 / -1; }
        @media (min-width: 640px) { .filter-field.full-on-mobile { grid-column: auto; } }

        .f-label {
            font-size: 10px;
            letter-spacing: .15em;
            text-transform: uppercase;
            color: rgba(212,175,55,0.8);
            font-weight: 600;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .f-input {
            background: rgba(0,0,0,0.42);
            border: 1px solid rgba(212,175,55,0.2);
            color: #f9e596;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 14px;
            transition: border-color .2s, box-shadow .2s;
            outline: none;
            color-scheme: dark;
            width: 100%;
            -webkit-appearance: none;
            appearance: none;
        }
        .f-input:focus {
            border-color: rgba(212,175,55,0.6);
            box-shadow: 0 0 0 3px rgba(212,175,55,.1);
        }
        .f-select-wrap { position: relative; }
        .f-select-wrap .chevron {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            color: rgba(212,175,55,0.5); font-size: 11px;
            pointer-events: none;
        }

        .filter-btn {
            background: linear-gradient(180deg,#d4af37,#aa8511);
            color: #1e110a;
            border: 1px solid #8a6a09;
            border-radius: 12px;
            padding: 11px 20px;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: .06em;
            text-transform: uppercase;
            cursor: pointer;
            transition: background .2s, transform .1s, box-shadow .2s;
            width: 100%;
            box-shadow: 0 4px 14px rgba(0,0,0,.35);
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        @media (min-width: 900px) { .filter-btn { width: auto; white-space: nowrap; padding: 11px 24px; } }
        .filter-btn:hover { background: linear-gradient(180deg,#f9e596,#d4af37); box-shadow: 0 6px 20px rgba(212,175,55,.25); }
        .filter-btn:active { transform: translateY(1px); }

        .filter-notice {
            margin-top: 12px;
            display: flex; align-items: flex-start; gap: 10px;
            padding: 10px 14px;
            border-radius: 12px;
            background: rgba(212,175,55,.05);
            border: 1px solid rgba(212,175,55,.12);
        }
        .filter-notice p { font-size: 12px; color: rgba(253,230,138,.7); margin: 0; line-height: 1.6; }

        /* =========================================
           RESULT INFO BAR
        ========================================= */
        .result-bar {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 16px;
        }
        @media (min-width: 640px) {
            .result-bar { flex-direction: row; align-items: center; justify-content: space-between; }
        }
        .result-text { font-size: 13px; color: #9ca3af; }
        .result-text .hl { color: #facc15; font-weight: 600; }
        .legend { display: flex; flex-wrap: wrap; gap: 12px; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #d1d5db; }
        .legend-dot {
            width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0;
        }

        /* =========================================
           TABLE GRID
        ========================================= */
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }
        @media (min-width: 480px)  { .tables-grid { gap: 12px; } }
        @media (min-width: 640px)  { .tables-grid { grid-template-columns: repeat(3, 1fr); gap: 14px; } }
        @media (min-width: 900px)  { .tables-grid { grid-template-columns: repeat(4, 1fr); gap: 16px; } }
        @media (min-width: 1200px) { .tables-grid { grid-template-columns: repeat(5, 1fr); gap: 18px; } }

        /* =========================================
           TABLE CARD
        ========================================= */
        .t-card {
            border-radius: 18px;
            padding: 3px;
            position: relative;
            transition: transform .22s, box-shadow .22s;
            cursor: default;
        }
        .t-card.bookable { cursor: pointer; }
        .t-card.bookable:active { transform: scale(0.97); }
        @media (hover: hover) {
            .t-card.bookable:hover { transform: scale(1.04); box-shadow: 0 14px 36px rgba(0,0,0,.6); }
            .t-card.bookable:hover .t-inner { border-color: rgba(212,175,55,.55); }
        }

        .t-frame-available { background: linear-gradient(145deg,#2d5a1e,#1a3a10); }
        .t-frame-booked    { background: linear-gradient(145deg,#5a4a1e,#3a2e10); }
        .t-frame-neutral   { background: linear-gradient(145deg,#282828,#181818); }

        .t-inner {
            border-radius: 15px;
            padding: 16px 12px 14px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(212,175,55,.07);
            background: linear-gradient(145deg, rgba(0,0,0,.52), rgba(0,0,0,.3));
            transition: border-color .22s;
            position: relative;
            overflow: hidden;
            min-height: 160px;
        }
        @media (min-width: 640px) {
            .t-inner { padding: 20px 14px 18px; gap: 9px; min-height: 190px; }
        }

        /* Status dot */
        .s-dot-wrap { position: absolute; top: 10px; right: 10px; }
        .s-dot {
            display: block; width: 9px; height: 9px;
            border-radius: 50%;
            position: relative;
        }
        .s-dot::before {
            content: ''; position: absolute; inset: 0;
            border-radius: 50%;
            animation: ping 1.3s ease-out infinite;
            opacity: .65;
        }
        .s-dot-green          { background: #10b981; }
        .s-dot-green::before  { background: #10b981; }
        .s-dot-amber          { background: #f59e0b; }
        .s-dot-amber::before  { background: #f59e0b; }
        .s-dot-gray           { background: #6b7280; }
        .s-dot-gray::before   { background: #6b7280; animation: none; }
        @keyframes ping { 75%, 100% { transform: scale(2.2); opacity: 0; } }

        /* Ball icon */
        .t-ball {
            width: 52px; height: 52px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px;
            background: rgba(0,0,0,.25);
            border: 1px solid rgba(212,175,55,.09);
            flex-shrink: 0;
        }
        @media (min-width: 640px) { .t-ball { width: 60px; height: 60px; font-size: 30px; } }

        .t-name {
            font-weight: 700;
            font-size: 14px;
            color: #fff;
            text-align: center;
            width: 100%;
            border-bottom: 1px solid rgba(212,175,55,.15);
            padding-bottom: 7px;
            line-height: 1.3;
        }
        @media (min-width: 640px) { .t-name { font-size: 15px; } }

        .t-info { text-align: center; width: 100%; }
        .t-info-row { font-size: 11px; color: #9ca3af; margin: 0 0 2px; }
        @media (min-width: 640px) { .t-info-row { font-size: 12px; } }
        .t-info-val { color: #facc15; font-weight: 600; }
        .t-info-val.price { color: #fde68a; }

        /* Badge */
        .t-badge {
            font-size: 9px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .1em;
            padding: 3px 10px; border-radius: 20px;
            flex-shrink: 0;
        }
        @media (min-width: 640px) { .t-badge { font-size: 10px; padding: 4px 12px; } }
        .badge-avail  { background: rgba(16,185,129,.15); color:#34d399; border: 1px solid rgba(16,185,129,.3); }
        .badge-booked { background: rgba(245,158,11,.15);  color:#fbbf24; border: 1px solid rgba(245,158,11,.3); }
        .badge-neutral{ background: rgba(107,114,128,.14); color:#9ca3af; border: 1px solid rgba(107,114,128,.25); }

        /* Unavailable dim */
        .t-dim {
            position: absolute; inset: 0; border-radius: 15px;
            background: rgba(0,0,0,.18);
            pointer-events: none;
        }

        /* =========================================
           EMPTY STATE
        ========================================= */
        .empty-state {
            text-align: center; padding: 60px 20px;
        }
        .empty-state .icon { font-size: 48px; margin-bottom: 14px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #fff; margin: 0 0 6px; }
        .empty-state p  { font-size: 13px; color: #6b7280; margin: 0; }

        /* =========================================
           MODAL
        ========================================= */
        .modal-bd {
            position: fixed; inset: 0;
            background: rgba(0,0,0,.82);
            backdrop-filter: blur(7px);
            z-index: 999;
            display: flex; align-items: flex-end; justify-content: center;
            padding: 0;
            transition: opacity .2s;
        }
        @media (min-width: 540px) {
            .modal-bd { align-items: center; padding: 16px; }
        }

        .modal-box {
            background: linear-gradient(145deg,#1a0e06,#120a04);
            border: 1px solid rgba(212,175,55,.3);
            border-radius: 24px 24px 0 0;
            padding: 3px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 -8px 50px rgba(0,0,0,.7);
            animation: slideUp .25s ease;
        }
        @media (min-width: 540px) {
            .modal-box {
                border-radius: 24px;
                box-shadow: 0 30px 80px rgba(0,0,0,.8);
                animation: popIn .22s ease;
            }
        }
        @keyframes slideUp  { from { transform: translateY(100%); } to { transform: translateY(0); } }
        @keyframes popIn    { from { opacity: 0; transform: scale(.94); } to { opacity: 1; transform: scale(1); } }

        .modal-inner {
            background: linear-gradient(145deg,#1a3a25,#0d2016);
            border-radius: 21px 21px 0 0;
            padding: 24px 20px;
        }
        @media (min-width: 540px) {
            .modal-inner { border-radius: 21px; padding: 28px 28px; }
        }

        /* Drag handle (mobile only) */
        .modal-handle {
            width: 40px; height: 4px;
            background: rgba(212,175,55,.3);
            border-radius: 2px;
            margin: 0 auto 18px;
        }
        @media (min-width: 540px) { .modal-handle { display: none; } }

        .modal-title { font-size: 20px; font-weight: 700; text-align: center; color: #fff; margin: 0 0 4px; }
        @media (min-width: 540px) { .modal-title { font-size: 22px; } }
        .modal-div { width: 48px; height: 1px; background: linear-gradient(90deg,transparent,#d4af37,transparent); margin: 8px auto 18px; }

        .modal-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 16px;
            background: rgba(0,0,0,.3);
            border: 1px solid rgba(212,175,55,.12);
            border-radius: 14px;
            padding: 14px;
            margin-bottom: 16px;
        }
        .mi-label { font-size: 10px; text-transform: uppercase; letter-spacing: .12em; color: #9ca3af; display: block; margin-bottom: 2px; }
        .mi-val   { font-size: 14px; font-weight: 600; color: #e5e7eb; }
        .mi-val.gold { color: #facc15; }

        .modal-note { font-size: 11px; color: #6b7280; text-align: center; margin: 0 0 18px; line-height: 1.6; }
        .modal-note strong { color: #facc15; }

        .modal-actions { display: flex; gap: 10px; }
        .btn-cancel {
            flex: 1; padding: 13px;
            border-radius: 13px;
            border: 1px solid rgba(212,175,55,.18);
            background: rgba(0,0,0,.4);
            color: #9ca3af;
            font-size: 14px; font-weight: 600;
            cursor: pointer; transition: color .2s, background .2s;
        }
        .btn-cancel:hover { background: rgba(0,0,0,.6); color: #fff; }
        .btn-confirm {
            flex: 2; padding: 13px;
            border-radius: 13px;
            border: 1px solid #8a6a09;
            background: linear-gradient(180deg,#d4af37,#aa8511);
            color: #1e110a;
            font-size: 14px; font-weight: 700;
            letter-spacing: .05em; text-transform: uppercase;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(0,0,0,.4);
            transition: background .2s;
        }
        .btn-confirm:hover { background: linear-gradient(180deg,#f9e596,#d4af37); }
        .btn-confirm:active { transform: scale(.98); }

        /* =========================================
           FOOTER
        ========================================= */
        .page-footer {
            text-align: center; margin-top: 40px;
            font-size: 11px; letter-spacing: .18em; text-transform: uppercase;
            color: rgba(156,163,175,.35);
        }
    </style>
</head>
<body class="bg-billiards-felt min-h-screen">

<!-- =========================================
     NAVBAR
========================================= -->
<nav class="top-nav">
    <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp" class="nav-brand">
        <span style="font-size:22px;">🎱</span>
        <div>
            <span class="font-classic nav-brand-title gold-text-emboss">H.N.D.D</span>
            <div style="font-size:9px;letter-spacing:.18em;color:rgba(161,98,7,.7);text-transform:uppercase;display:none;" class="sm-show">Premium Billiards</div>
        </div>
    </a>

    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/user/trangchunguoidung.jsp" class="nav-link">
            <i class="fas fa-house" style="font-size:13px;"></i>
            <span>Trang Chủ</span>
        </a>
        <a href="${pageContext.request.contextPath}/lichsudatban" class="nav-link">
            <i class="fas fa-clock-rotate-left" style="font-size:13px;"></i>
            <span>Lịch Sử</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/ghepkeo" class="nav-link">
            <i class="fas fa-people-arrows" style="font-size:13px;color:#a78bfa;"></i>
            <span style="color:#c4b5fd;">Ghép Kèo</span>
        </a>
        <div class="nav-user">
            <div style="font-size:13px;font-weight:600;color:#fde68a;">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name}</c:when>
                    <c:otherwise>Khách Hàng</c:otherwise>
                </c:choose>
            </div>
            <div style="font-size:9px;color:rgba(161,98,7,.65);text-transform:uppercase;letter-spacing:.15em;">VIP Member</div>
        </div>
        <div class="avatar-ring">
            <div class="avatar-inner">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                    <c:otherwise>K</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- =========================================
     PAGE CONTENT
========================================= -->
<div class="page-wrap">

    <!-- Title -->
    <div class="page-title">
        <div style="font-size:10px;letter-spacing:.24em;color:rgba(161,98,7,.6);text-transform:uppercase;margin-bottom:4px;" class="font-classic">H.N.D.D Billiards</div>
        <h1 class="font-classic">Đặt Bàn Trước</h1>
        <div class="title-divider"></div>
        <p class="font-body">Chọn ngày, giờ &amp; thời lượng — rồi nhấn vào bàn muốn đặt</p>
    </div>

    <!-- Toast messages -->
    <c:if test="${not empty sessionScope.booking_error}">
        <div id="toastError" class="toast toast-error">
            <i class="fas fa-circle-exclamation" style="flex-shrink:0;"></i>
            <span>${sessionScope.booking_error}</span>
            <button class="toast-close" onclick="this.parentElement.remove()" style="color:#f87171;">✕</button>
        </div>
        <c:remove var="booking_error" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.booking_success}">
        <div id="toastSuccess" class="toast toast-success">
            <i class="fas fa-circle-check" style="flex-shrink:0;"></i>
            <span>${sessionScope.booking_success}</span>
            <button class="toast-close" onclick="this.parentElement.remove()" style="color:#86efac;">✕</button>
        </div>
        <c:remove var="booking_success" scope="session"/>
    </c:if>

    <!-- =========================================
         FILTER BAR
    ========================================= -->
    <div class="filter-bar">
        <form method="get" action="${pageContext.request.contextPath}/datban" id="filterForm">
            <div class="filter-grid">

                <!-- Ngày đặt -->
                <div class="filter-field">
                    <label class="f-label" for="bookingDate">
                        <i class="fas fa-calendar-alt"></i> Ngày Đặt
                    </label>
                    <input type="date" name="bookingDate" id="bookingDate"
                           class="f-input" value="${filterDate}" required>
                </div>

                <!-- Giờ bắt đầu -->
                <div class="filter-field">
                    <label class="f-label" for="bookingTime">
                        <i class="fas fa-clock"></i> Giờ Bắt Đầu
                    </label>
                    <input type="time" name="bookingTime" id="bookingTime"
                           class="f-input" value="${filterTime}" required>
                </div>

                <!-- Thời lượng -->
                <div class="filter-field">
                    <label class="f-label" for="duration">
                        <i class="fas fa-hourglass-half"></i> Thời Lượng
                    </label>
                    <div class="f-select-wrap">
                        <select name="duration" id="duration" class="f-input" style="padding-right:32px;" required>
                            <c:forEach var="h" begin="1" end="8">
                                <option value="${h}" <c:if test="${filterDuration == h}">selected</c:if>>${h} Giờ</option>
                            </c:forEach>
                        </select>
                        <i class="fas fa-chevron-down chevron"></i>
                    </div>
                </div>

                <!-- Button -->
                <div class="filter-field full-on-mobile" style="justify-content:flex-end;">
                    <label class="f-label" style="visibility:hidden;display:none;" aria-hidden="true">.</label>
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-magnifying-glass"></i>
                        <span>Xem Bàn Trống</span>
                    </button>
                </div>

            </div>
        </form>

        <!-- Notice -->
        <div class="filter-notice">
            <i class="fas fa-circle-info" style="color:#eab308;margin-top:1px;flex-shrink:0;font-size:13px;"></i>
            <p class="font-body">
                Vui lòng đến nhận bàn <strong style="color:#facc15;">đúng giờ đã đặt</strong>.
                Nếu quá <strong style="color:#facc15;">15 phút</strong>, hệ thống sẽ tự động hủy đơn.
            </p>
        </div>
    </div>

    <!-- =========================================
         RESULT INFO & LEGEND
    ========================================= -->
    <div class="result-bar">
        <div>
            <c:choose>
                <c:when test="${not empty slotStatusMap}">
                    <p class="result-text">
                        Kết quả: <span class="hl">${filterDate}</span>
                        lúc <span class="hl">${filterTime}</span>,
                        <span class="hl">${filterDuration} giờ</span>
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="result-text">Nhập bộ lọc để xem tình trạng bàn theo thời gian cụ thể</p>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${not empty slotStatusMap}">
            <div class="legend">
                <div class="legend-item">
                    <span class="legend-dot" style="background:#10b981;box-shadow:0 0 7px rgba(16,185,129,.5);"></span>
                    Trống – có thể đặt
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background:#f59e0b;box-shadow:0 0 7px rgba(245,158,11,.5);"></span>
                    Đã đặt trước
                </div>
            </div>
        </c:if>
    </div>

    <!-- =========================================
         TABLE GRID
    ========================================= -->
    <div class="tables-grid">
        <c:forEach var="table" items="${tables}">
            <c:set var="slotSt"    value="${slotStatusMap[table.id]}"/>
            <c:set var="hasFilter" value="${not empty slotStatusMap}"/>

            <c:choose>
                <c:when test="${hasFilter and slotSt == 'available'}">
                    <c:set var="frameClass" value="t-frame-available"/>
                    <c:set var="bookable"   value="bookable"/>
                    <c:set var="dotClass"   value="s-dot-green"/>
                    <c:set var="badgeClass" value="badge-avail"/>
                    <c:set var="badgeText"  value="Trống"/>
                    <c:set var="ballEmoji"  value="🎱"/>
                    <c:set var="canClick"   value="true"/>
                </c:when>
                <c:when test="${hasFilter and slotSt == 'booked'}">
                    <c:set var="frameClass" value="t-frame-booked"/>
                    <c:set var="bookable"   value=""/>
                    <c:set var="dotClass"   value="s-dot-amber"/>
                    <c:set var="badgeClass" value="badge-booked"/>
                    <c:set var="badgeText"  value="Đã Đặt"/>
                    <c:set var="ballEmoji"  value="🚫"/>
                    <c:set var="canClick"   value="false"/>
                </c:when>
                <c:otherwise>
                    <c:set var="frameClass" value="t-frame-neutral"/>
                    <c:set var="bookable"   value=""/>
                    <c:set var="dotClass"   value="s-dot-gray"/>
                    <c:set var="badgeClass" value="badge-neutral"/>
                    <c:set var="badgeText"  value="Chọn giờ trước"/>
                    <c:set var="ballEmoji"  value="🎱"/>
                    <c:set var="canClick"   value="false"/>
                </c:otherwise>
            </c:choose>

            <c:set var="freeFrom" value="${freeFromMap[table.id]}"/>
            <c:choose>
                <c:when test="${hasFilter and slotSt == 'booked' and not empty freeFrom}">
                    <c:set var="badgeText" value="Đang chơi"/>
                </c:when>
                <c:when test="${not hasFilter and not empty freeFrom}">
                    <c:set var="dotClass"   value="s-dot-amber"/>
                    <c:set var="badgeClass" value="badge-booked"/>
                    <c:set var="badgeText"  value="Đang chơi"/>
                </c:when>
            </c:choose>

            <div class="t-card ${frameClass} ${bookable}"
                 <c:if test="${canClick == 'true'}">
                     onclick="openModal(${table.id}, '${table.name}', '${table.tableTypeName}', ${table.pricePerHour})"
                 </c:if>
                 role="${canClick == 'true' ? 'button' : 'presentation'}"
                 tabindex="${canClick == 'true' ? '0' : '-1'}"
                 aria-label="${table.name}">
                <div class="t-inner">

                    <!-- Status dot -->
                    <div class="s-dot-wrap">
                        <span class="s-dot ${dotClass}"></span>
                    </div>

                    <!-- Ball / emoji -->
                    <div class="t-ball">${ballEmoji}</div>

                    <!-- Name -->
                    <div class="t-name font-classic">${table.name}</div>

                    <!-- Info -->
                    <div class="t-info">
                        <p class="t-info-row">Loại: <span class="t-info-val">${table.tableTypeName}</span></p>
                        <p class="t-info-row">Giá: <span class="t-info-val price"><fmt:formatNumber value="${table.pricePerHour}" type="number"/>đ/h</span></p>
                    </div>

                    <!-- Thông báo bàn đang có khách vãng lai chơi -->
                    <c:if test="${not empty freeFrom}">
                        <p class="t-info-row" style="color:#fbbf24;font-size:11px;margin-top:2px;">
                            Đặt được từ <span class="t-info-val">${freeFrom}</span>
                        </p>
                    </c:if>

                    <!-- Badge -->
                    <span class="t-badge ${badgeClass}">${badgeText}</span>

                    <!-- Dim overlay for unavailable -->
                    <c:if test="${canClick == 'false' and hasFilter}">
                        <div class="t-dim"></div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Empty state -->
    <c:if test="${empty tables}">
        <div class="empty-state">
            <div class="icon">🎱</div>
            <h3 class="font-classic">Chưa có bàn nào</h3>
            <p class="font-body">Hệ thống chưa có bàn bida. Vui lòng liên hệ nhân viên.</p>
        </div>
    </c:if>

    <div class="page-footer font-classic">Est. 2024 &bull; H.N.D.D Management System</div>
</div>

<!-- =========================================
     BOOKING CONFIRMATION MODAL
========================================= -->
<div id="bookingModal" class="modal-bd" style="display:none;" onclick="handleBdClick(event)">
    <div class="modal-box" onclick="event.stopPropagation()">
        <div class="modal-inner">
            <!-- Drag handle -->
            <div class="modal-handle"></div>

            <!-- Header -->
            <div style="text-align:center;margin-bottom:4px;">
                <div style="font-size:36px;margin-bottom:8px;">🎱</div>
                <h2 class="modal-title font-classic">Xác Nhận Đặt Bàn</h2>
                <div class="modal-div"></div>
            </div>

            <!-- Info grid -->
            <div class="modal-info-grid">
                <div>
                    <span class="mi-label">Bàn</span>
                    <span id="mi-name" class="mi-val gold"></span>
                </div>
                <div>
                    <span class="mi-label">Loại bàn</span>
                    <span id="mi-type" class="mi-val"></span>
                </div>
                <div>
                    <span class="mi-label">Ngày đặt</span>
                    <span id="mi-date" class="mi-val"></span>
                </div>
                <div>
                    <span class="mi-label">Giờ bắt đầu</span>
                    <span id="mi-time" class="mi-val"></span>
                </div>
                <div>
                    <span class="mi-label">Thời lượng</span>
                    <span id="mi-dur" class="mi-val"></span>
                </div>
                <div>
                    <span class="mi-label">Tổng tiền dự tính</span>
                    <span id="mi-total" class="mi-val gold"></span>
                </div>
            </div>

            <p class="modal-note font-body">
                Nhấn <strong>Tiếp Tục</strong> để chuyển sang trang chọn dịch vụ &amp; hình thức thanh toán.
            </p>

            <!-- Actions -->
            <form method="post" action="${pageContext.request.contextPath}/datban" id="modalForm">
                <input type="hidden" name="action" value="calculate">
                <input type="hidden" name="tableId"     id="mi-tableId">
                <input type="hidden" name="bookingDate" id="mi-bookDate">
                <input type="hidden" name="bookingTime" id="mi-bookTime">
                <input type="hidden" name="duration"    id="mi-bookDur">

                <div class="modal-actions">
                    <button type="button" class="btn-cancel font-body" onclick="closeModal()">
                        <i class="fas fa-xmark"></i> Hủy
                    </button>
                    <button type="submit" class="btn-confirm font-classic">
                        <i class="fas fa-arrow-right"></i> Tiếp Tục
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    /* ===== Set today as default date ===== */
    (function() {
        const d = document.getElementById('bookingDate');
        if (d && !d.value) {
            const now = new Date();
            d.value = now.getFullYear() + '-'
                    + String(now.getMonth()+1).padStart(2,'0') + '-'
                    + String(now.getDate()).padStart(2,'0');
        }
    })();

    /* ===== Auto-dismiss toasts ===== */
    setTimeout(() => {
        ['toastError','toastSuccess'].forEach(id => {
            const el = document.getElementById(id);
            if (el) { el.style.opacity = '0'; el.style.transition = 'opacity .5s'; setTimeout(()=>el.remove(),500); }
        });
    }, 5500);

    /* ===== Keyboard: Enter on bookable card ===== */
    document.addEventListener('keydown', e => {
        if (e.key === 'Enter' && e.target.classList.contains('bookable')) e.target.click();
        if (e.key === 'Escape') closeModal();
    });

    /* ===== Modal open ===== */
    function openModal(tableId, tableName, tableType, price) {
        const date = document.getElementById('bookingDate').value;
        const time = document.getElementById('bookingTime').value;
        const dur  = document.getElementById('duration').value;

        if (!date || !time || !dur) {
            alert('Vui lòng nhập đầy đủ Ngày, Giờ và Thời lượng trước khi chọn bàn!');
            document.getElementById('bookingDate').focus();
            return;
        }
        const dt = new Date(date + 'T' + time);
        if (dt <= new Date()) {
            alert('Thời gian đặt bàn phải là thời gian trong tương lai!');
            return;
        }

        document.getElementById('mi-name').textContent  = tableName;
        document.getElementById('mi-type').textContent  = tableType;
        document.getElementById('mi-date').textContent  = fmtDate(date);
        document.getElementById('mi-time').textContent  = time;
        document.getElementById('mi-dur').textContent   = dur + ' giờ';
        document.getElementById('mi-total').textContent = fmtMoney(price * parseInt(dur)) + 'đ';

        document.getElementById('mi-tableId').value  = tableId;
        document.getElementById('mi-bookDate').value = date;
        document.getElementById('mi-bookTime').value = time;
        document.getElementById('mi-bookDur').value  = dur;

        const modal = document.getElementById('bookingModal');
        modal.style.display = 'flex';
        requestAnimationFrame(() => { modal.style.opacity = '1'; });
    }

    function closeModal() {
        document.getElementById('bookingModal').style.display = 'none';
    }
    function handleBdClick(e) {
        if (e.target === document.getElementById('bookingModal')) closeModal();
    }

    function fmtDate(s) {
        if (!s) return '';
        const [y,m,d] = s.split('-');
        return d+'/'+m+'/'+y;
    }
    function fmtMoney(n) {
        return Math.round(n).toLocaleString('vi-VN');
    }
</script>
</body>
</html>