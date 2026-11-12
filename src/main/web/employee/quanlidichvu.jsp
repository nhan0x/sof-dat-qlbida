<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Dịch Vụ - H.N.D.D Bida</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen text-gray-100 flex flex-col items-center p-6">

    <!-- Back button -->
    <!-- Back button -->
    <div class="w-full max-w-[900px] flex justify-between items-center mb-4">
        <a href="${pageContext.request.contextPath}/employee/trangchunhanvien"
           class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
            &lt;&lt; Bảng điều khiển
        </a>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.message}">
        <div class="w-full max-w-[900px] bg-green-950/50 border border-green-500/50 text-green-200 p-4 rounded-xl shadow-lg flex items-center justify-between mb-4" id="successAlert">
            <span class="text-sm font-medium">✨ ${sessionScope.message}</span>
            <button onclick="document.getElementById('successAlert').remove()" class="text-green-200 hover:text-white">✕</button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="w-full max-w-[900px] bg-red-950/50 border border-red-500/50 text-red-200 p-4 rounded-xl shadow-lg flex items-center justify-between mb-4" id="errorAlert">
            <span class="text-sm font-medium">🚨 ${sessionScope.error}</span>
            <button onclick="document.getElementById('errorAlert').remove()" class="text-red-200 hover:text-white">✕</button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Main Card -->
    <div class="w-full max-w-[900px] wood-frame rounded-2xl p-1 shadow-2xl relative">
        <div class="absolute top-3 left-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
        <div class="absolute top-3 right-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
        <div class="absolute bottom-3 left-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>
        <div class="absolute bottom-3 right-3 w-1.5 h-1.5 rounded-full bg-black/80"></div>

        <div class="inner-felt rounded-xl p-8">

            <!-- Header -->
            <div class="text-center border-b border-gold-dark/30 pb-6 mb-6">
                <span class="text-4xl block mb-2">🛎️</span>
                <h2 class="font-classic text-2xl font-bold tracking-wider gold-text-emboss">DANH SÁCH DỊCH VỤ</h2>
                <p class="text-xs text-gold-base/80 uppercase font-classic tracking-widest mt-1">Đồ uống &amp; món ăn của quán (Chỉ xem / Gọi món)</p>
            </div>

            <!-- Table Notification Banner -->
            <c:if test="${not empty selectedTable}">
                <div class="mb-6 p-4 rounded-xl flex items-center justify-between bg-blue-950/40 border border-blue-500/30">
                    <div class="flex items-center gap-3">
                        <span class="text-lg">🎯</span>
                        <span class="text-sm font-semibold text-blue-200">
                            Đang gọi món cho: <strong class="text-white">${selectedTable.name}</strong>
                        </span>
                    </div>
                    <a href="${pageContext.request.contextPath}/employee/trangchunhanvien" class="text-xs text-blue-300 hover:text-white underline font-medium">Hoàn thành</a>
                </div>
            </c:if>

            <!-- Category Tabs -->
            <div class="flex flex-wrap gap-2 mb-6 items-center">
                <div class="flex flex-wrap gap-2 flex-1 bg-black/25 p-2 rounded-xl border border-gold-dark/20 overflow-x-auto">
                    <button type="button" class="category-tab px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wider transition bg-gradient-to-b from-[#d4af37] to-[#aa8511] text-wood-dark border border-[#8a6a09] shadow-sm" data-category="Tất cả" onclick="filterByCategory('Tất cả')">
                        Tất cả
                    </button>
                    <c:forEach var="cat" items="${categoryList}">
                        <button type="button" class="category-tab px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition text-gold-light/70 hover:bg-gold-dark/10 hover:text-white" data-category="${cat.name}" onclick="filterByCategory('${cat.name}')">
                            ${cat.name}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- Service Table -->
            <div class="overflow-x-auto bg-black/10 border border-gold-dark/10 rounded-xl p-3">
                <c:choose>
                    <c:when test="${not empty serviceList}">
                        <table class="w-full text-sm text-left" id="tableMain">
                            <thead>
                                <tr class="text-gray-400 text-xs uppercase border-b border-gold-dark/10">
                                    <th class="pb-2">STT</th>
                                    <th class="pb-2">Tên Dịch Vụ</th>
                                    <th class="pb-2">Danh Mục</th>
                                    <th class="pb-2 text-right">Giá (VNĐ)</th>
                                    <th class="pb-2 text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${serviceList}">
                                    <tr class="border-b border-gold-dark/5 hover:bg-white/5" data-category="${item.category != null ? item.category : 'Khác'}">
                                        <td class="row-stt py-3 font-semibold text-gold-base/70"></td>
                                        <td class="py-3 font-semibold text-white">${item.name}</td>
                                        <td class="py-3 text-xs text-gold-light/90">
                                            <span class="px-2 py-1 rounded bg-gold-dark/10 border border-gold-dark/20">${item.category != null ? item.category : 'Khác'}</span>
                                        </td>
                                        <td class="py-3 text-right text-gold-light font-mono">
                                            <fmt:formatNumber value="${item.price}" type="number"/>đ
                                        </td>
                                        <td class="py-3 text-center text-xs">
                                            <c:choose>
                                                <c:when test="${not empty selectedTable}">
                                                    <form action="${pageContext.request.contextPath}/employee/trangchunhanvien" method="post" class="flex items-center gap-2 justify-center">
                                                        <input type="hidden" name="action" value="addService">
                                                        <input type="hidden" name="tableId" value="${selectedTable.id}">
                                                        <input type="hidden" name="serviceId" value="${item.id}">
                                                        <input type="number" name="quantity" min="1" value="1" required
                                                               class="w-14 px-1.5 py-1 bg-black/40 border border-gold-dark/30 rounded text-center text-xs text-white focus:outline-none focus:border-gold-base shadow-inner">
                                                        <button type="submit" class="bg-gradient-to-b from-[#d4af37] to-[#aa8511] hover:from-[#f9e596] hover:to-[#d4af37] text-wood-dark font-bold px-3 py-1 rounded text-xs transition border border-[#8a6a09] uppercase tracking-wider font-classic">
                                                            Gọi món
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-xs text-gold-base/50 italic">Chỉ xem</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-10 text-xs text-gray-500 font-mono italic">Chưa có dịch vụ nào. Nhấn "Thêm Dịch Vụ" để bắt đầu.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        let currentCategory = 'Tất cả';

        function filterByCategory(category) {
            currentCategory = category;
            document.querySelectorAll('.category-tab').forEach(tab => {
                if (tab.getAttribute('data-category') === category) {
                    tab.className = "category-tab px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wider transition bg-gradient-to-b from-[#d4af37] to-[#aa8511] text-wood-dark border border-[#8a6a09] shadow-sm";
                } else {
                    tab.className = "category-tab px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition text-gold-light/70 hover:bg-gold-dark/10 hover:text-white";
                }
            });
            filterTable();
        }

        function filterTable() {
            let stt = 1;
            document.querySelectorAll('#tableMain tbody tr').forEach(row => {
                const rowCategory = row.getAttribute('data-category') || 'Khác';
                const matchesCategory = (currentCategory === 'Tất cả' || rowCategory === currentCategory);
                if (matchesCategory) {
                    row.style.display = '';
                    const sttCell = row.querySelector('.row-stt');
                    if (sttCell) sttCell.textContent = stt++;
                } else {
                    row.style.display = 'none';
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            filterByCategory('Tất cả');
        });
    </script>
</body>
</html>
