package org.example.daos;

import org.example.models.Bill;
import java.time.LocalDateTime;
import java.util.List;

public interface BillDAO {
    boolean createBill(Bill bill);
    Bill getUnpaidBillByTableId(int tableId);
    boolean updateBill(Bill bill);
    Bill getBillById(int id);
    List<Bill> getPaidBillsByShift(LocalDateTime start, LocalDateTime end);

    /**
     * Tìm hóa đơn theo nhiều tiêu chí lọc. Mọi tham số đều có thể null (bỏ qua tiêu chí đó).
     *
     * @param from      thời điểm mở bàn từ (time_start >= from)
     * @param to        thời điểm mở bàn đến (time_start < to)
     * @param accountId chỉ lấy hóa đơn do nhân viên/tài khoản này thao tác
     * @param tableId   chỉ lấy hóa đơn của bàn này
     * @param status    'Paid' / 'Unpaid'
     */
    List<Bill> searchBills(LocalDateTime from, LocalDateTime to, Integer accountId, Integer tableId, String status);

    boolean deleteBill(int billId);
}


