package org.example.utils;

import org.example.daos.BillDAO;
import org.example.daos.BookingDAO;
import org.example.daos.TableBidaDAO;
import org.example.models.Bill;
import org.example.models.Booking;
import org.example.models.TableBida;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Quy tắc xác định một bàn có "trống" để khách đặt trước hay không.
 *
 * Bàn được coi là trống tại khung giờ [playTime, playTime + duration) khi:
 *  1. Không trùng với bất kỳ lịch đặt trước nào chưa hủy (lịch đặt trước đã biết thời lượng
 *     nên chỉ cần kiểm tra chồng lấn khoảng thời gian).
 *  2. Nếu bàn đang có khách chơi mà phiên chơi đó KHÔNG thuộc lịch đặt trước (khách vãng lai,
 *     không biết chơi tới khi nào) thì khách chỉ được đặt từ thời điểm bắt đầu chơi
 *     cộng thêm {@link #WALKIN_GAP_HOURS} giờ trở đi.
 *     Ví dụ: bàn 1 bắt đầu chơi lúc 5h ⇒ chỉ đặt được từ 8h.
 *  3. Nếu phiên chơi hiện tại thuộc lịch đặt trước (đã biết thời lượng) thì áp dụng đúng
 *     thời lượng đó, không cộng thêm 3 giờ.
 *     Ví dụ: bàn đặt từ 5h thời lượng 4 tiếng ⇒ không đặt được lúc 8h, phải từ 9h.
 */
public final class TableAvailability {

    /** Số giờ tối thiểu phải cách thời điểm bắt đầu chơi của khách vãng lai. */
    public static final int WALKIN_GAP_HOURS = 3;

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

    private final BookingDAO bookingDAO;
    private final TableBidaDAO tableDAO;
    private final BillDAO billDAO;

    public TableAvailability(BookingDAO bookingDAO, TableBidaDAO tableDAO, BillDAO billDAO) {
        this.bookingDAO = bookingDAO;
        this.tableDAO = tableDAO;
        this.billDAO = billDAO;
    }

    public static boolean isInUse(TableBida table) {
        if (table == null || table.getStatus() == null) return false;
        String st = table.getStatus().trim();
        return "Đang sử dụng".equalsIgnoreCase(st) || "In Use".equalsIgnoreCase(st);
    }

    /**
     * @return null nếu bàn đặt được; ngược lại trả về lý do để hiển thị cho khách.
     */
    public String getUnavailableReason(int tableId, LocalDateTime playTime, int duration) {
        return getUnavailableReason(tableId, playTime, duration, 0);
    }

    public String getUnavailableReason(int tableId, LocalDateTime playTime, int duration, int excludeBookingId) {
        // 1. Trùng với lịch đặt trước đã có
        if (bookingDAO.isTableBooked(tableId, playTime, duration, excludeBookingId)) {
            return "Bàn này đã được đặt trong khung giờ bạn chọn. Vui lòng chọn giờ khác hoặc bàn khác.";
        }

        // 2. Bàn đang có khách vãng lai chơi
        LocalDateTime freeFrom = getWalkInFreeFrom(tableId);
        if (freeFrom != null && playTime.isBefore(freeFrom)) {
            return "Bàn này đang có khách chơi. Bạn chỉ có thể đặt bàn này từ "
                    + freeFrom.format(DTF) + " trở đi.";
        }
        return null;
    }

    public boolean isAvailable(int tableId, LocalDateTime playTime, int duration) {
        return getUnavailableReason(tableId, playTime, duration) == null;
    }

    /**
     * Thời điểm sớm nhất có thể đặt bàn do phiên chơi vãng lai đang diễn ra (giờ bắt đầu + 3h),
     * hoặc null nếu bàn không bận hoặc phiên chơi hiện tại đã thuộc lịch đặt trước.
     */
    public LocalDateTime getWalkInFreeFrom(int tableId) {
        TableBida table = tableDAO.getById(tableId);
        if (!isInUse(table)) return null;

        LocalDateTime startTime = null;
        Bill bill = billDAO.getUnpaidBillByTableId(tableId);
        if (bill != null && bill.getTime_start() != null) {
            startTime = bill.getTime_start();
        }
        // Không có hóa đơn mở → coi như bàn vừa bắt đầu chơi
        if (startTime == null) startTime = LocalDateTime.now();

        // Phiên chơi này thuộc lịch đặt trước đã biết thời lượng → không áp dụng quy tắc +3h,
        // khoảng bận đã được kiểm tra qua isTableBooked ở trên.
        Booking scheduled = bookingDAO.getScheduledBookingCovering(tableId, startTime);
        if (scheduled != null) return null;

        return startTime.plusHours(WALKIN_GAP_HOURS);
    }
}
