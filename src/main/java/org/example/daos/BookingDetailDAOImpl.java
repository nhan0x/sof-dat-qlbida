package org.example.daos;

import org.example.models.BookingDetail;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingDetailDAOImpl implements BookingDetailDAO {

    @Override
    public List<BookingDetail> getByBookingId(int bookingId) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetail WHERE bookingId = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, bookingId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(new BookingDetail(
                            rs.getInt("id"),
                            rs.getInt("bookingId"),
                            rs.getInt("serviceId"),
                            rs.getInt("quantity")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean create(BookingDetail detail) {
        String sql = "INSERT INTO BookingDetail(bookingId, serviceId, quantity) VALUES(?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, detail.getBookingId());
            pst.setInt(2, detail.getServiceId());
            pst.setInt(3, detail.getQuantity());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteByBookingId(int bookingId) {
        String sql = "DELETE FROM BookingDetail WHERE bookingId = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, bookingId);
            return pst.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
