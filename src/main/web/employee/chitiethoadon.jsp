<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H.N.D.D Bida - Chi Tiết Hóa Đơn #${billDetail.billId}</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body class="bg-billiards-felt min-h-screen text-gray-100">

<div class="max-w-3xl mx-auto px-4 py-10">

    <div class="flex items-center justify-between mb-6">
        <div>
            <div class="font-classic text-xs tracking-[0.25em] text-gold-base/60 uppercase mb-1">Hóa đơn</div>
            <h1 class="font-classic text-2xl font-bold text-white">Chi Tiết Hóa Đơn #${billDetail.billId}</h1>
        </div>
        <a href="${pageContext.request.contextPath}${isAdminView ? '/admin/quanlihoadon' : '/employee/lichsuhoadon'}"
           class="bg-wood-base hover:bg-wood-dark border border-gold-dark/40 text-gold-light px-4 py-2 rounded-lg text-xs font-semibold uppercase tracking-wider transition shadow-md">
            <i class="fas fa-arrow-left mr-1"></i> Quay lại
        </a>
    </div>

    <div class="wood-frame rounded-2xl p-1 shadow-2xl">
        <div class="inner-felt rounded-xl p-6 flex flex-col gap-5">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm">
                <div class="bg-black/25 border border-gold-dark/20 rounded-xl px-4 py-3">
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Bàn</div>
                    <div class="text-emerald-300 font-semibold">${billDetail.tableName}</div>
                </div>
                <div class="bg-black/25 border border-gold-dark/20 rounded-xl px-4 py-3">
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Người thực hiện (người bấm)</div>
                    <div class="text-white font-semibold">
                        ${billDetail.staffName}
                        <c:if test="${not empty billDetail.staffRole}">
                            <span class="text-xs text-gold-base/80 font-normal">(${billDetail.staffRole})</span>
                        </c:if>
                    </div>
                </div>
                <div class="bg-black/25 border border-gold-dark/20 rounded-xl px-4 py-3">
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Giờ mở bàn</div>
                    <div class="font-mono text-gray-200">${billDetail.timeStart}</div>
                </div>
                <div class="bg-black/25 border border-gold-dark/20 rounded-xl px-4 py-3">
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Giờ thanh toán</div>
                    <div class="font-mono text-gray-200">${empty billDetail.timeEnd ? '--' : billDetail.timeEnd}</div>
                </div>
            </div>

            <div>
                <h3 class="font-classic text-sm font-bold text-gold-base/90 uppercase tracking-widest mb-3">
                    <i class="fas fa-utensils mr-1.5"></i>Dịch vụ đã gọi
                </h3>
                <c:choose>
                    <c:when test="${not empty billDetail.services}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gold-dark/10 text-sm">
                                <thead>
                                    <tr class="text-left text-xs uppercase tracking-wider text-gold-base border-b border-gold-dark/20">
                                        <th class="py-2 px-3">Dịch vụ</th>
                                        <th class="py-2 px-3">SL</th>
                                        <th class="py-2 px-3">Đơn giá</th>
                                        <th class="py-2 px-3 text-right">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gold-dark/10">
                                    <c:forEach var="s" items="${billDetail.services}">
                                        <tr>
                                            <td class="py-2.5 px-3 text-gray-200">${s.name}</td>
                                            <td class="py-2.5 px-3 text-gray-300">${s.quantity}</td>
                                            <td class="py-2.5 px-3 text-gray-300"><fmt:formatNumber value="${s.price}" pattern="#,###"/>đ</td>
                                            <td class="py-2.5 px-3 text-right text-gold-light">
                                                <fmt:formatNumber value="${s.total}" pattern="#,###"/>đ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="flex justify-between text-sm mt-3 pt-3 border-t border-gold-dark/20">
                            <span class="text-gray-400">Tổng tiền dịch vụ</span>
                            <span class="text-gold-light font-semibold">
                                <fmt:formatNumber value="${billDetail.serviceTotal}" pattern="#,###"/>đ
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-sm text-gray-500 italic">Hóa đơn này không có dịch vụ kèm theo.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="flex items-center justify-between bg-black/30 border border-gold-dark/25 rounded-xl px-5 py-4">
                <div>
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Trạng thái</div>
                    <c:choose>
                      <c:when test="${billDetail.status == 'Paid'}">
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-900/50 text-emerald-300 border border-emerald-500/30">Đã thanh toán</span>
                      </c:when>
                      <c:otherwise>
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-900/50 text-amber-300 border border-amber-500/30">Chưa thanh toán</span>
                      </c:otherwise>
                    </c:choose>
                </div>
                <div class="text-right">
                    <div class="text-[10px] uppercase tracking-wider text-gray-400 mb-1">Tổng hóa đơn</div>
                    <div class="text-2xl font-bold text-gold-light">
                        <fmt:formatNumber value="${billDetail.total}" pattern="#,###"/>đ
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
