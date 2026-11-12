package org.example.daos;

import org.example.models.Locker;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LockerDAOImpl implements LockerDAO {

    private Locker mapRow(ResultSet rs) throws Exception {
        Locker l = new Locker();
        l.setId(rs.getInt("id"));
        l.setLockerNumber(rs.getString("locker_number"));
        l.setStatus(rs.getString("status"));
        
        int memberId = rs.getInt("member_id");
        if (rs.wasNull()) {
            l.setMemberId(null);
        } else {
            l.setMemberId(memberId);
        }

        l.setMemberName(rs.getNString("member_name"));
        l.setMemberPhone(rs.getString("member_phone"));
        l.setCustomerName(rs.getNString("customer_name"));

        Timestamp startTs = rs.getTimestamp("start_date");
        if (startTs != null) {
            l.setStartDate(startTs.toLocalDateTime());
        }

        Timestamp endTs = rs.getTimestamp("end_date");
        if (endTs != null) {
            l.setEndDate(endTs.toLocalDateTime());
        }

        l.setPrice(rs.getDouble("price"));
        l.setNote(rs.getNString("note"));
        return l;
    }

    @Override
    public boolean create(Locker locker) {
        String sql = "INSERT INTO Locker(locker_number, status, price, note, is_deleted) VALUES(?, 'Available', ?, ?, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, locker.getLockerNumber());
            pst.setDouble(2, locker.getPrice());
            pst.setNString(3, locker.getNote());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Locker locker) {
        String sql = "UPDATE Locker SET locker_number = ?, price = ?, note = ? WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, locker.getLockerNumber());
            pst.setDouble(2, locker.getPrice());
            pst.setNString(3, locker.getNote());
            pst.setInt(4, locker.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "UPDATE Locker SET is_deleted = 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Locker getById(int id) {
        String sql = "SELECT l.*, a.name AS member_name, a.phone AS member_phone " +
                     "FROM Locker l " +
                     "LEFT JOIN Account a ON l.member_id = a.id " +
                     "WHERE l.id = ? AND l.is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Locker> getAll() {
        List<Locker> list = new ArrayList<>();
        String sql = "SELECT l.*, a.name AS member_name, a.phone AS member_phone " +
                     "FROM Locker l " +
                     "LEFT JOIN Account a ON l.member_id = a.id " +
                     "WHERE l.is_deleted = 0 " +
                     "ORDER BY l.locker_number ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Locker> search(String keyword) {
        List<Locker> list = new ArrayList<>();
        String sql = "SELECT l.*, a.name AS member_name, a.phone AS member_phone " +
                     "FROM Locker l " +
                     "LEFT JOIN Account a ON l.member_id = a.id " +
                     "WHERE l.is_deleted = 0 AND (l.locker_number LIKE ? OR a.name LIKE ? OR a.phone LIKE ?) " +
                     "ORDER BY l.locker_number ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            pst.setString(1, kw);
            pst.setString(2, kw);
            pst.setString(3, kw);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Locker getByMemberId(int memberId) {
        String sql = "SELECT l.*, a.name AS member_name, a.phone AS member_phone " +
                     "FROM Locker l " +
                     "LEFT JOIN Account a ON l.member_id = a.id " +
                     "WHERE l.member_id = ? AND l.is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, memberId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean assignMember(int lockerId, Integer memberId, String customerName, LocalDateTime start, LocalDateTime end, double price, String note, String status) {
        String sql = "UPDATE Locker SET member_id = ?, customer_name = ?, status = ?, start_date = ?, end_date = ?, price = ?, note = ? WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            if (memberId == null) {
                pst.setNull(1, java.sql.Types.INTEGER);
            } else {
                pst.setInt(1, memberId);
            }
            pst.setNString(2, customerName);
            pst.setString(3, status);
            pst.setTimestamp(4, Timestamp.valueOf(start));
            pst.setTimestamp(5, Timestamp.valueOf(end));
            pst.setDouble(6, price);
            pst.setNString(7, note);
            pst.setInt(8, lockerId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean confirmRental(int lockerId) {
        String sql = "UPDATE Locker SET status = 'Occupied' WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, lockerId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean releaseLocker(int lockerId) {
        String sql = "UPDATE Locker SET member_id = NULL, customer_name = NULL, status = 'Available', start_date = NULL, end_date = NULL, note = NULL WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, lockerId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
