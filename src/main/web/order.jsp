<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>${table.name} - Gọi Phục Vụ | H.N.D.D Bida</title>
    <meta name="description" content="Gọi nhân viên, order đồ uống, yêu cầu thanh toán tại ${table.name}">
    <meta name="theme-color" content="#0c2617">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-dark:      #0c2617;
            --bg-card:      #071a0e;
            --bg-card2:     #122a1a;
            --gold:         #d4af37;
            --gold-light:   #f9e596;
            --gold-dark:    #7d6310;
            --wood:         #1e110a;
            --text-main:    #e5e7eb;
            --text-muted:   #6b7280;
            --emerald:      #10b981;
            --amber:        #f59e0b;
            --red:          #ef4444;
            --blue:         #3b82f6;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-dark);
            background-image:
                radial-gradient(ellipse at top left,  rgba(212,175,55,0.07) 0%, transparent 55%),
                radial-gradient(ellipse at bottom right, rgba(16,185,129,0.07) 0%, transparent 55%);
            min-height: 100vh;
            color: var(--text-main);
        }

        /* ─── HEADER ─── */
        .app-header {
            background: linear-gradient(180deg, #2c1a10 0%, #1a0e06 100%);
            border-bottom: 1px solid rgba(212,175,55,0.2);
            padding: 14px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        .brand-logo { font-size: 26px; }
        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 18px;
            font-weight: 700;
            background: linear-gradient(to bottom, #f9e596, #d4af37, #997a15);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .brand-sub { font-size: 10px; color: rgba(212,175,55,0.5); letter-spacing: 0.15em; text-transform: uppercase; }
        .table-badge {
            background: rgba(212,175,55,0.15);
            border: 1px solid rgba(212,175,55,0.4);
            border-radius: 20px;
            padding: 6px 14px;
            font-family: 'Playfair Display', serif;
            font-size: 15px;
            font-weight: 700;
            color: var(--gold-light);
        }

        /* ─── MAIN CONTENT ─── */
        .content { padding: 20px; max-width: 480px; margin: 0 auto; }

        /* ─── TOAST ─── */
        .toast {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 18px; border-radius: 16px; margin-bottom: 16px;
            font-size: 14px; font-weight: 500;
            animation: slideDown 0.35s ease;
        }
        @keyframes slideDown { from { opacity:0; transform: translateY(-10px) } to { opacity:1; transform: translateY(0) } }
        .toast-success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.35); color: #6ee7b7; }
        .toast-error   { background: rgba(239,68,68,0.15);   border: 1px solid rgba(239,68,68,0.35);   color: #fca5a5; }

        /* ─── MODE SELECTOR (Tab bar) ─── */
        .mode-tabs {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-bottom: 22px;
        }
        .mode-tab {
            background: var(--bg-card);
            border: 2px solid rgba(212,175,55,0.12);
            border-radius: 16px;
            padding: 14px 6px;
            cursor: pointer;
            text-align: center;
            transition: all 0.25s ease;
            display: flex; flex-direction: column; align-items: center; gap: 6px;
        }
        .mode-tab:hover { border-color: rgba(212,175,55,0.35); }
        .mode-tab.active {
            background: rgba(212,175,55,0.12);
            border-color: var(--gold);
            box-shadow: 0 0 20px rgba(212,175,55,0.1);
        }
        .mode-tab .tab-icon { font-size: 26px; }
        .mode-tab .tab-label { font-size: 11px; font-weight: 700; color: var(--gold-light); line-height: 1.3; }
        .mode-tab.active .tab-label { color: var(--gold-light); }

        /* ─── SECTION CARD ─── */
        .section-card {
            background: var(--bg-card);
            border: 1px solid rgba(212,175,55,0.1);
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 16px;
            display: none;
        }
        .section-card.visible { display: block; }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 16px; font-weight: 700; color: #fff;
            margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .section-desc {
            font-size: 13px; color: var(--text-muted); line-height: 1.6;
            margin-bottom: 18px;
        }

        /* ─── SERVICE LIST ─── */
        .cat-scroll {
            display: flex; gap: 8px; overflow-x: auto; padding-bottom: 6px; margin-bottom: 14px;
            scrollbar-width: none;
        }
        .cat-scroll::-webkit-scrollbar { display: none; }
        .cat-chip {
            flex-shrink: 0; padding: 5px 14px; border-radius: 20px;
            font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em;
            cursor: pointer; transition: all 0.2s; border: 1px solid rgba(212,175,55,0.2);
            background: var(--bg-card2); color: var(--text-muted);
            white-space: nowrap;
        }
        .cat-chip.active { background: rgba(212,175,55,0.15); border-color: var(--gold); color: var(--gold-light); }

        .svc-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; max-height: 300px; overflow-y: auto; padding-right: 2px; }
        .svc-item {
            background: var(--bg-card2); border: 1.5px solid rgba(212,175,55,0.1);
            border-radius: 14px; padding: 12px 10px;
            cursor: pointer; transition: all 0.2s; position: relative;
        }
        .svc-item:hover { border-color: rgba(212,175,55,0.3); }
        .svc-item.selected { background: rgba(212,175,55,0.12); border-color: var(--gold); }
        .svc-item .svc-name { font-size: 12.5px; font-weight: 600; color: #fff; line-height: 1.35; margin-bottom: 4px; }
        .svc-item .svc-price { font-size: 12px; font-weight: 700; color: var(--gold-light); }
        .svc-item .svc-cat { font-size: 10px; color: var(--text-muted); margin-top: 2px; }
        .svc-item .check-mark {
            position: absolute; top: 8px; right: 8px;
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--gold); color: var(--wood);
            font-size: 10px; font-weight: 900;
            display: none; align-items: center; justify-content: center;
        }
        .svc-item.selected .check-mark { display: flex; }

        .selected-count {
            font-size: 12px; color: var(--gold-light); font-weight: 600;
            margin-top: 10px; display: none;
        }

        /* ─── NOTE FIELD ─── */
        .note-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: rgba(212,175,55,0.75); margin-bottom: 8px; display: block; }
        textarea.note-input {
            width: 100%; background: rgba(0,0,0,0.3); border: 1px solid rgba(212,175,55,0.2);
            border-radius: 14px; padding: 12px 14px; color: var(--gold-light);
            font-family: 'Inter', sans-serif; font-size: 13px; resize: none;
            outline: none; transition: border-color 0.2s;
        }
        textarea.note-input::placeholder { color: var(--text-muted); }
        textarea.note-input:focus { border-color: rgba(212,175,55,0.5); }

        /* ─── SUBMIT BUTTON ─── */
        .submit-btn {
            width: 100%; padding: 17px; border-radius: 18px;
            font-family: 'Playfair Display', serif;
            font-size: 17px; font-weight: 700; letter-spacing: 0.05em;
            cursor: pointer; transition: all 0.25s; border: none;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            margin-top: 20px;
        }
        .btn-call    { background: linear-gradient(180deg,#d4af37,#aa8511); color: var(--wood); box-shadow: 0 5px 20px rgba(212,175,55,0.3); }
        .btn-call:hover  { background: linear-gradient(180deg,#f9e596,#d4af37); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(212,175,55,0.4); }
        .btn-order   { background: linear-gradient(180deg,#10b981,#059669); color: #fff; box-shadow: 0 5px 20px rgba(16,185,129,0.3); }
        .btn-order:hover { background: linear-gradient(180deg,#34d399,#10b981); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(16,185,129,0.35); }
        .btn-pay     { background: linear-gradient(180deg,#3b82f6,#1d4ed8); color: #fff; box-shadow: 0 5px 20px rgba(59,130,246,0.3); }
        .btn-pay:hover  { background: linear-gradient(180deg,#60a5fa,#3b82f6); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(59,130,246,0.35); }
        .submit-btn:active { transform: translateY(0); }

        /* ─── FOOTER ─── */
        .app-footer { text-align: center; font-size: 11.5px; color: var(--text-muted); padding: 24px 20px 40px; line-height: 1.8; }
        .app-footer strong { color: var(--gold); }

        /* ─── SCROLLBAR ─── */
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(212,175,55,0.2); border-radius: 4px; }
    </style>
</head>

<body>

<!-- HEADER -->
<header class="app-header">
    <div style="display:flex; align-items:center; gap:10px;">
        <span class="brand-logo">🎱</span>
        <div>
            <div class="brand-name">H.N.D.D Bida</div>
            <div class="brand-sub">Premium Club</div>
        </div>
    </div>
    <div class="table-badge">${table.name}</div>
</header>

<!-- MAIN CONTENT -->
<div class="content">

    <!-- TOAST MESSAGES -->
    <c:if test="${not empty param.success}">
        <div class="toast toast-success" id="mainToast">
            <span style="font-size:22px">✅</span>
            <div>
                <div style="font-weight:700; margin-bottom:2px;">Gửi yêu cầu thành công!</div>
                <div style="font-size:12px; color:#9ca3af;">Nhân viên sẽ đến phục vụ bạn trong chốc lát.</div>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast toast-error" id="mainToast">
            <span style="font-size:22px">❌</span>
            <div>
                <div style="font-weight:700; margin-bottom:2px;">Có lỗi xảy ra!</div>
                <div style="font-size:12px; color:#9ca3af;">Vui lòng thử lại hoặc gọi trực tiếp nhân viên.</div>
            </div>
        </div>
    </c:if>

    <!-- 3 MODE TABS -->
    <div class="mode-tabs">
        <div class="mode-tab active" id="tab-call" onclick="switchMode('call')">
            <div class="tab-icon">🔔</div>
            <div class="tab-label">Gọi<br>Nhân Viên</div>
        </div>
        <div class="mode-tab" id="tab-order" onclick="switchMode('order')">
            <div class="tab-icon">🧃</div>
            <div class="tab-label">Order<br>Đồ Uống</div>
        </div>
        <div class="mode-tab" id="tab-pay" onclick="switchMode('pay')">
            <div class="tab-icon">💳</div>
            <div class="tab-label">Yêu Cầu<br>Thanh Toán</div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/order" method="post">
        <input type="hidden" name="tableId" value="${table.id}">
        <input type="hidden" name="callType" id="callTypeHidden" value="call">

        <!-- ── PANEL 1: GỌI NHÂN VIÊN ── -->
        <div class="section-card visible" id="panel-call">
            <div class="section-title">🔔 Gọi Nhân Viên</div>
            <div class="section-desc">
                Nhân viên sẽ đến bàn của bạn trong vài phút. Bạn có thể để lại ghi chú để chúng tôi phục vụ tốt hơn.
            </div>
            <label class="note-label">Lý do / Ghi chú (tùy chọn)</label>
            <textarea class="note-input" name="note_call" rows="3"
                      placeholder="Ví dụ: Cần thêm phấn bida, Muốn đổi bàn, ..."></textarea>
            <button type="submit" class="submit-btn btn-call" onclick="setCallType('call')">
                <i class="fas fa-bell"></i> Gọi Nhân Viên Ngay
            </button>
        </div>

        <!-- ── PANEL 2: ORDER ĐỒ UỐNG ── -->
        <div class="section-card" id="panel-order">
            <div class="section-title">🧃 Chọn Đồ Uống / Dịch Vụ</div>

            <c:choose>
                <c:when test="${not empty serviceList}">
                    <!-- Category filter -->
                    <div class="cat-scroll" id="catScroll">
                        <div class="cat-chip active" onclick="filterCat('ALL', this)">Tất cả</div>
                        <c:set var="seen" value=""/>
                        <c:forEach var="s" items="${serviceList}">
                            <c:if test="${not empty s.category and !seen.contains(s.category)}">
                                <div class="cat-chip" onclick="filterCat('${s.category}', this)">${s.category}</div>
                                <c:set var="seen" value="${seen}|${s.category}"/>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Service grid -->
                    <div class="svc-grid" id="svcGrid">
                        <c:forEach var="svc" items="${serviceList}">
                            <div class="svc-item" data-cat="${svc.category}" data-id="${svc.id}"
                                 onclick="toggleSvc(this, ${svc.id})">
                                <div class="check-mark">✓</div>
                                <div class="svc-name">${svc.name}</div>
                                <div class="svc-price"><fmt:formatNumber value="${svc.price}" type="number"/>đ</div>
                                <div class="svc-cat">${svc.category}</div>
                                <input type="checkbox" name="serviceIds" value="${svc.id}" style="display:none" class="svc-cb">
                            </div>
                        </c:forEach>
                    </div>
                    <div class="selected-count" id="svcCountEl">0 món đã chọn</div>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding:30px; color:var(--text-muted);">
                        <div style="font-size:36px; margin-bottom:10px;">🫙</div>
                        <div style="font-size:13px;">Chưa có thực đơn được cài đặt.</div>
                    </div>
                </c:otherwise>
            </c:choose>

            <div style="margin-top:16px;">
                <label class="note-label">Ghi chú thêm (tùy chọn)</label>
                <textarea class="note-input" name="note_order" rows="2"
                          placeholder="Ví dụ: Cần đá viên, ít đường..."></textarea>
            </div>
            <button type="submit" class="submit-btn btn-order" onclick="setCallType('order')">
                <i class="fas fa-shopping-cart"></i> Gửi Order Ngay
            </button>
        </div>

        <!-- ── PANEL 3: THANH TOÁN ── -->
        <div class="section-card" id="panel-pay">
            <div class="section-title">💳 Yêu Cầu Thanh Toán</div>
            <div class="section-desc">
                Nhân viên sẽ mang hóa đơn đến bàn của bạn ngay. Bạn có thể chọn phương thức thanh toán khi nhân viên đến.
            </div>
            <label class="note-label">Phương thức thanh toán mong muốn</label>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:16px;">
                <label style="display:flex; align-items:center; gap:8px; padding:12px; background:var(--bg-card2); border:1.5px solid rgba(212,175,55,0.15); border-radius:14px; cursor:pointer; font-size:13px; color:var(--text-main);">
                    <input type="radio" name="payment_method" value="Tiền mặt" checked style="accent-color:var(--gold);">
                    💵 Tiền mặt
                </label>
                <label style="display:flex; align-items:center; gap:8px; padding:12px; background:var(--bg-card2); border:1.5px solid rgba(212,175,55,0.15); border-radius:14px; cursor:pointer; font-size:13px; color:var(--text-main);">
                    <input type="radio" name="payment_method" value="Chuyển khoản" style="accent-color:var(--gold);">
                    📱 Chuyển khoản
                </label>
            </div>
            <label class="note-label">Ghi chú thêm</label>
            <textarea class="note-input" name="note_pay" rows="2"
                      placeholder="Ví dụ: Xuất hóa đơn VAT, Tách hóa đơn..."></textarea>
            <button type="submit" class="submit-btn btn-pay" onclick="setCallType('pay')">
                <i class="fas fa-credit-card"></i> Yêu Cầu Thanh Toán
            </button>
        </div>

    </form>
</div>

<!-- FOOTER -->
<div class="app-footer">
    Cảm ơn bạn đã đến với <strong>H.N.D.D Bida</strong> 🎱<br>
    Nhân viên sẽ phục vụ bạn trong <strong>vài phút</strong>.<br>
    Chúc bạn có những ván bida tuyệt vời!
</div>

<script>
    // ── Mode Switching ──
    function switchMode(mode) {
        ['call','order','pay'].forEach(m => {
            document.getElementById('tab-'   + m).classList.remove('active');
            document.getElementById('panel-' + m).classList.remove('visible');
        });
        document.getElementById('tab-'   + mode).classList.add('active');
        document.getElementById('panel-' + mode).classList.add('visible');
    }

    // ── Set hidden callType before submit ──
    function setCallType(type) {
        // Merge note fields into single 'note' param by renaming
        const callTypes = { call: 'note_call', order: 'note_order', pay: 'note_pay' };
        const activeNote = document.querySelector('textarea[name="' + callTypes[type] + '"]');
        if (activeNote) activeNote.name = 'note'; // rename to 'note' so servlet reads it

        // Include payment method in note for pay type
        if (type === 'pay') {
            const method = document.querySelector('input[name="payment_method"]:checked');
            const noteEl = document.querySelector('textarea[name="note"]');
            if (method && noteEl) {
                const existing = noteEl.value.trim();
                noteEl.value = '[' + method.value + '] ' + (existing ? existing : '');
            }
        }

        document.getElementById('callTypeHidden').value = type;
    }

    // ── Service Toggle ──
    const selectedSvcs = new Set();

    function toggleSvc(el, id) {
        const cb = el.querySelector('.svc-cb');
        if (selectedSvcs.has(id)) {
            selectedSvcs.delete(id);
            el.classList.remove('selected');
            cb.checked = false;
        } else {
            selectedSvcs.add(id);
            el.classList.add('selected');
            cb.checked = true;
        }
        const countEl = document.getElementById('svcCountEl');
        if (countEl) {
            countEl.textContent = selectedSvcs.size + ' món đã chọn';
            countEl.style.display = selectedSvcs.size > 0 ? 'block' : 'none';
        }
    }

    // ── Category Filter ──
    function filterCat(cat, btnEl) {
        document.querySelectorAll('.cat-chip').forEach(c => c.classList.remove('active'));
        if (btnEl) btnEl.classList.add('active');
        document.querySelectorAll('.svc-item').forEach(item => {
            item.style.display = (cat === 'ALL' || item.dataset.cat === cat) ? '' : 'none';
        });
    }

    // ── Auto-dismiss toast ──
    window.addEventListener('DOMContentLoaded', () => {
        const toast = document.getElementById('mainToast');
        if (toast) {
            setTimeout(() => {
                toast.style.transition = 'opacity 0.5s';
                toast.style.opacity = '0';
                setTimeout(() => toast.remove(), 500);
            }, 5000);
        }
    });
</script>
</body>
</html>
