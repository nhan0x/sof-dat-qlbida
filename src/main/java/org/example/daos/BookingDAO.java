package org.example.daos;

import org.example.models.Booking;
import java.time.LocalDateTime;
import java.util.List;

public interface BookingDAO {
    List<Booking> getAll();

    List<Booking> getBookingsByAccountId(int accountId);

    Booking getById(int id);

    boolean create(Booking booking);

    // Tạo booking và trả về id vừa tạo (-1 nếu lỗi) để có thể lưu các dịch vụ đặt trước kèm theo
    int createAndGetId(Booking booking);

    boolean updateStatus(int id, String status);

    boolean delete(int id);

    /**
     * Kiểm tra xem bàn có bị đặt trùng khoảng thời gian [playTime, playTime+duration) không.
     * Chỉ xét các booking có status khác "Đã Hủy".
     *
     * @param tableId   ID bàn cần kiểm tra
     * @param playTime  Thời điểm bắt đầu muốn đặt
     * @param duration  Số giờ chơi
     * @param excludeBookingId  Nếu > 0, bỏ qua booking này (dùng khi chỉnh sửa)
     * @return true nếu bàn ĐÃ bị đặt trong khoảng thời gian đó
     */
    boolean isTableBooked(int tableId, LocalDateTime playTime, int duration, int excludeBookingId);

    /**
     * Tìm lịch đặt trước (chưa hủy) của bàn có khoảng chơi [play_time, play_time + duration)
     * bao trùm thời điểm truyền vào. Dùng để biết phiên chơi hiện tại của bàn có phải
     * xuất phát từ lịch đặt trước (đã biết trước thời lượng) hay là khách vãng lai.
     *
     * @return Booking tương ứng, hoặc null nếu không có
     */
    Booking getScheduledBookingCovering(int tableId, LocalDateTime moment);

    /**
     * Lấy toàn bộ lịch đặt bàn (chưa hủy) có giờ chơi nằm trong ngày chỉ định,
     * sắp xếp theo giờ chơi tăng dần.
     */
    List<Booking> getBookingsByPlayDate(java.time.LocalDate date);

    /**
     * Lấy các lịch đặt trước (chưa hủy) của một bàn có giờ chơi trong khoảng [from, to),
     * sắp xếp theo giờ chơi tăng dần. Dùng để cảnh báo nhân viên trước khi mở bàn.
     */
    List<Booking> getUpcomingBookings(int tableId, LocalDateTime from, LocalDateTime to);
}
