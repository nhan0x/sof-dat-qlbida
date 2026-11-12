<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa Đơn - H.N.D.D Management</title>
</head>
<body class="bg-billiards with-sidebar min-h-screen">
<%@ include file="sidebar.jsp" %>

<!-- TOP NAV -->
<nav class="bida-topnav">
    <h1 style="font-size:18px; color:#f9e596; font-weight:700; font-family:'Playfair Display',serif;">
        Hóa Đơn
    </h1>
    <div style="display:flex; align-items:center; gap:14px;">
        <div style="text-align:right;">
            <div style="font-size:13.5px; font-weight:600; color:#f9e596;">${sessionScope.account.name}</div>
            <div style="font-size:11px; color:rgba(212,175,55,0.6); text-transform:uppercase; letter-spacing:1px;">Administrator</div>
        </div>
        <div class="gold-avatar-ring">
            <div class="gold-avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.name}">${sessionScope.account.name.substring(0,1).toUpperCase()}</c:when>
                    <c:otherwise>A</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<div style="max-width:1400px; margin:0 auto; padding:28px;">

    <!-- Page header -->
    <div style="margin-bottom:24px;">
        <h2 class="gold-text" style="font-family:'Playfair Display',serif; font-size:26px; font-weight:700;">
            Hóa Đơn Cửa Hàng
        </h2>
        <p style="font-size:13.5px; color:rgba(212,175,55,0.5); margin-top:4px;">
            Toàn bộ hóa đơn kèm ngày giờ mở bàn / thanh toán và nhân viên đã thao tác (người bấm).
        </p>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <div class="bida-alert alert-success">
            <i class="fas fa-circle-check"></i> ${sessionScope.message}
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="bida-alert alert-danger">
            <i class="fas fa-circle-exclamation"></i> ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- FILTER -->
    <div class="bida-card" style="padding:20px 24px; margin-bottom:22px;">
        <form method="get" action="${pageContext.request.contextPath}/admin/quanlihoadon"
              style="display:flex; flex-wrap:wrap; align-items:flex-end; gap:14px;">
            <div>
                <label class="modal-label" for="fromDate">Từ ngày</label>
                <input class="modal-input" style="width:170px;" type="date" id="fromDate" name="fromDate" value="${fromDate}">
            </div>
            <div>
                <label class="modal-label" for="toDate">Đến ngày</label>
                <input class="modal-input" style="width:170px;" type="date" id="toDate" name="toDate" value="${toDate}">
            </div>
            <div>
                <label class="modal-label" for="staffId">Người bấm (nhân viên)</label>
                <select class="modal-input" style="width:200px;" id="staffId" name="staffId">
                    <option value="">Tất cả</option>
                    <c:forEach var="s" items="${staffList}">
                        <option value="${s.id}" ${filterStaffId == s.id ? 'selected' : ''}>${s.name} (${s.role})</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="modal-label" for="tableId">Bàn</label>
                <select class="modal-input" style="width:160px;" id="tableId" name="tableId">
                    <option value="">Tất cả</option>
                    <c:forEach var="t" items="${tables}">
                        <option value="${t.id}" ${filterTableId == t.id ? 'selected' : ''}>${t.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="modal-label" for="status">Trạng thái</label>
                <select class="modal-input" style="width:170px;" id="status" name="status">
                    <option value="">Tất cả</option>
                    <option value="Paid" ${filterStatus == 'Paid' ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="Unpaid" ${filterStatus == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
                </select>
            </div>
            <button type="submit" class="btn-gold"><i class="fas fa-filter"></i> Lọc Hóa Đơn</button>
            <a href="${pageContext.request.contextPath}/admin/quanlihoadon" class="btn-modal-cancel" style="text-decoration:none;">
                <i class="fas fa-rotate-left"></i> Đặt lại
            </a>
        </form>
    </div>

    <!-- STATS -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:18px; margin-bottom:22px;">
        <div class="bida-card" style="padding:20px;">
            <div style="font-size:24px; font-weight:800; color:#f9e596;">${totalCount}</div>
            <div style="font-size:12.5px; color:rgba(212,175,55,0.6); margin-top:4px;">Tổng hóa đơn</div>
        </div>
        <div class="bida-card" style="padding:20px;">
            <div style="font-size:24px; font-weight:800; color:#86efac;">
                <fmt:formatNumber value="${totalPaid}" pattern="#,###"/>đ
            </div>
            <div style="font-size:12.5px; color:rgba(212,175,55,0.6); margin-top:4px;">Doanh thu đã thu</div>
        </div>
        <div class="bida-card" style="padding:20px;">
            <div style="font-size:24px; font-weight:800; color:#93c5fd;">${paidCount}</div>
            <div style="font-size:12.5px; color:rgba(212,175,55,0.6); margin-top:4px;">Hóa đơn đã thanh toán</div>
        </div>
        <div class="bida-card" style="padding:20px;">
            <div style="font-size:24px; font-weight:800; color:#fde047;">${unpaidCount}</div>
            <div style="font-size:12.5px; color:rgba(212,175,55,0.6); margin-top:4px;">Đang mở / chưa thanh toán</div>
        </div>
        <div class="bida-card" style="padding:20px;">
            <div style="font-size:24px; font-weight:800; color:#d4af37;">
                <fmt:formatNumber value="${avgPerBill}" pattern="#,###"/>đ
            </div>
            <div style="font-size:12.5px; color:rgba(212,175,55,0.6); margin-top:4px;">Trung bình / hóa đơn</div>
        </div>
    </div>

    <!-- TABLE -->
    <div class="bida-card" style="overflow:hidden;">
        <div style="display:flex; align-items:center; justify-content:space-between; padding:18px 22px; border-bottom:1px solid rgba(212,175,55,0.12); flex-wrap:wrap; gap:12px;">
            <h3 style="font-family:'Playfair Display',serif; font-size:17px; color:#f9e596;">
                <i class="fas fa-file-invoice-dollar" style="color:#d4af37;"></i> Danh Sách Hóa Đơn
            </h3>
            <div class="bida-search">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Tìm theo bàn, nhân viên, mã HĐ..." onkeyup="filterTable()">
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty billRows}">
                <div style="overflow-x:auto;">
                    <table class="bida-table" id="tableMain">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Bàn</th>
                                <th>Người Bấm</th>
                                <th>Giờ Mở Bàn</th>
                                <th>Giờ Thanh Toán</th>
                                <th>Tổng Tiền</th>
                                <th>Trạng Thái</th>
                                <th style="text-align:center;">Chi Tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${billRows}">
                                <tr>
                                    <td style="font-family:monospace; color:#d4af37;">#${item.billId}</td>
                                    <td style="color:#86efac; font-weight:600;">${item.tableName}</td>
                                    <td>
                                        ${item.staffName}
                                        <c:if test="${not empty item.staffRole}">
                                            <span style="font-size:11px; color:rgba(212,175,55,0.55);">(${item.staffRole})</span>
                                        </c:if>
                                    </td>
                                    <td style="font-family:monospace; font-size:12.5px;">${item.timeStart}</td>
                                    <td style="font-family:monospace; font-size:12.5px;">${empty item.timeEnd ? '--' : item.timeEnd}</td>
                                    <td style="color:#f9e596; font-weight:700;">
                                        <fmt:formatNumber value="${item.total}" pattern="#,###"/>đ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'Paid'}">
                                                <span class="badge badge-green"><span class="badge-dot"></span> Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-yellow"><span class="badge-dot"></span> Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <div style="display:flex; align-items:center; justify-content:center; gap:8px;">
                                        <a class="btn-icon btn-view" title="Xem chi tiết"
                                           href="${pageContext.request.contextPath}/admin/quanlihoadon?billId=${item.billId}">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a class="btn-icon btn-del" title="Xóa hóa đơn"
                                           href="${pageContext.request.contextPath}/admin/quanlihoadon?action=delete&billId=${item.billId}"
                                           onclick="return confirm('Xác nhận xóa hóa đơn #${item.billId}?')">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bida-empty">
                    <div class="empty-icon">🧾</div>
                    <h4>Không có hóa đơn nào</h4>
                    <p>Không tìm thấy hóa đơn phù hợp với bộ lọc đã chọn.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function filterTable() {
        const query = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('#tableMain tbody tr').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
        });
    }
</script>

</body>
</html>
