package org.example.daos;

import org.example.models.Booking;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAOImpl implements BookingDAO {

    private Booking extractBooking(ResultSet rs) throws Exception {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setAccountId(rs.getInt("account_id"));
        b.setTable_id(rs.getInt("table_id"));

        Timestamp bt = rs.getTimestamp("booking_time");
        if (bt != null)
            b.setBookingTime(bt.toLocalDateTime());

        Timestamp pt = rs.getTimestamp("play_time");
        if (pt != null)
            b.setPlayTime(pt.toLocalDateTime());

        b.setStatus(rs.getString("status"));
        b.setDuration(rs.getInt("duration"));
        b.setPaymentType(rs.getString("payment_type"));
        return b;
    }

    @Override
    public List<Booking> getAll() {
        List<Booking> list = new ArrayList<>();
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Booking WHERE is_deleted = 0 ORDER BY booking_time DESC";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(extractBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Booking> getBookingsByAccountId(int accountId) {
        List<Booking> list = new ArrayList<>();
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Booking WHERE account_id = ? AND is_deleted = 0 ORDER BY booking_time DESC";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, accountId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(extractBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Booking getById(int id) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Booking WHERE id = ? AND is_deleted = 0";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return extractBooking(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean create(Booking booking) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "INSERT INTO Booking(account_id, table_id, booking_time, play_time, status, duration, payment_type) VALUES(?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, booking.getAccountId());
            pst.setInt(2, booking.getTable_id());
            pst.setTimestamp(3, booking.getBookingTime() != null ? Timestamp.valueOf(booking.getBookingTime()) : null);
            pst.setTimestamp(4, booking.getPlayTime() != null ? Timestamp.valueOf(booking.getPlayTime()) : null);
            pst.setString(5, booking.getStatus());
            pst.setInt(6, booking.getDuration());
            pst.setString(7, booking.getPaymentType());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int createAndGetId(Booking booking) {
        String sql = "INSERT INTO Booking(account_id, table_id, booking_time, play_time, status, duration, payment_type) VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            pst.setInt(1, booking.getAccountId());
            pst.setInt(2, booking.getTable_id());
            pst.setTimestamp(3, booking.getBookingTime() != null ? Timestamp.valueOf(booking.getBookingTime()) : null);
            pst.setTimestamp(4, booking.getPlayTime() != null ? Timestamp.valueOf(booking.getPlayTime()) : null);
            pst.setString(5, booking.getStatus());
            pst.setInt(6, booking.getDuration());
            pst.setString(7, booking.getPaymentType());
            if (pst.executeUpdate() == 1) {
                try (ResultSet keys = pst.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public boolean updateStatus(int id, String status) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "UPDATE Booking SET status = ? WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, status);
            pst.setInt(2, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "UPDATE Booking SET is_deleted = 1 WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra xem bàn đã có booking nào trùng khoảng thời gian chưa.
     * Logic: hai khoảng [A_start, A_end) và [B_start, B_end) chồng nhau khi:
     *   A_start < B_end AND A_end > B_start
     * Chỉ xét các booking status != 'Đã Hủy'.
     */
    @Override
    public boolean isTableBooked(int tableId, LocalDateTime playTime, int duration, int excludeBookingId) {
        // endTime của booking mới muốn đặt
        LocalDateTime endTime = playTime.plusHours(duration);
        String sql = "SELECT COUNT(*) FROM Booking " +
                     "WHERE table_id = ? " +
                     "AND is_deleted = 0 " +
                     "AND status != N'Đã Hủy' " +
                     "AND status != N'Chờ Thanh Toán' " +
                     "AND play_time < ? " +
                     "AND DATEADD(hour, duration, play_time) > ? " +
                     (excludeBookingId > 0 ? "AND id != ? " : "");
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, tableId);
            pst.setTimestamp(2, Timestamp.valueOf(endTime));   // play_time < endTime_moi
            pst.setTimestamp(3, Timestamp.valueOf(playTime));  // DATEADD(...) > playTime_moi
            if (excludeBookingId > 0) {
                pst.setInt(4, excludeBookingId);
            }
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Booking> getBookingsByPlayDate(java.time.LocalDate date) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking " +
                     "WHERE is_deleted = 0 " +
                     "AND status != N'Đã Hủy' " +
                     "AND status != N'Chờ Thanh Toán' " +
                     "AND play_time >= ? AND play_time < ? " +
                     "ORDER BY play_time ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setTimestamp(1, Timestamp.valueOf(date.atStartOfDay()));
            pst.setTimestamp(2, Timestamp.valueOf(date.plusDays(1).atStartOfDay()));
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Booking> getUpcomingBookings(int tableId, LocalDateTime from, LocalDateTime to) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking " +
                     "WHERE table_id = ? " +
                     "AND is_deleted = 0 " +
                     "AND status != N'Đã Hủy' " +
                     "AND status != N'Chờ Thanh Toán' " +
                     "AND DATEADD(hour, duration, play_time) > ? AND play_time < ? " +
                     "ORDER BY play_time ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, tableId);
            pst.setTimestamp(2, Timestamp.valueOf(from));
            pst.setTimestamp(3, Timestamp.valueOf(to));
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Booking getScheduledBookingCovering(int tableId, LocalDateTime moment) {
        String sql = "SELECT TOP 1 * FROM Booking " +
                     "WHERE table_id = ? " +
                     "AND is_deleted = 0 " +
                     "AND status != N'Đã Hủy' " +
                     "AND status != N'Chờ Thanh Toán' " +
                     "AND duration > 0 " +
                     // cho phép lệch tối đa 1 giờ giữa giờ đặt và giờ nhân viên mở bàn thực tế
                     "AND play_time <= DATEADD(hour, 1, ?) " +
                     "AND DATEADD(hour, duration, play_time) > ? " +
                     "ORDER BY play_time DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, tableId);
            pst.setTimestamp(2, Timestamp.valueOf(moment));
            pst.setTimestamp(3, Timestamp.valueOf(moment));
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return extractBooking(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
