package org.example.daos;

import org.example.models.Bill;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillDAOImpl implements BillDAO {

    private Bill mapRow(ResultSet rs) throws Exception {
        Bill bill = new Bill();
        bill.setBill_id(rs.getInt("id"));
        bill.setTable_id(rs.getInt("table_id"));
        
        int accountId = rs.getInt("account_id");
        if (rs.wasNull()) {
            bill.setAccount_id(null);
        } else {
            bill.setAccount_id(accountId);
        }

        int voucherId = rs.getInt("voucher_id");
        if (rs.wasNull()) {
            bill.setVoucher_id(null);
        } else {
            bill.setVoucher_id(voucherId);
        }

        int memberId = rs.getInt("member_id");
        if (rs.wasNull()) {
            bill.setMemberId(null);
        } else {
            bill.setMemberId(memberId);
        }

        Timestamp startTs = rs.getTimestamp("time_start");
        if (startTs != null) {
            bill.setTime_start(startTs.toLocalDateTime());
        }

        Timestamp endTs = rs.getTimestamp("time_end");
        if (endTs != null) {
            bill.setTime_end(endTs.toLocalDateTime());
        }

        bill.setTotal(rs.getDouble("total"));
        bill.setStatus(rs.getString("status"));
        return bill;
    }

    @Override
    public boolean createBill(Bill bill) {
        String sql = "INSERT INTO Bill(table_id, account_id, voucher_id, member_id, time_start, time_end, total, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, bill.getTable_id());
            if (bill.getAccount_id() == null) {
                pst.setNull(2, java.sql.Types.INTEGER);
            } else {
                pst.setInt(2, bill.getAccount_id());
            }
            if (bill.getVoucher_id() == null) {
                pst.setNull(3, java.sql.Types.INTEGER);
            } else {
                pst.setInt(3, bill.getVoucher_id());
            }
            if (bill.getMemberId() == null) {
                pst.setNull(4, java.sql.Types.INTEGER);
            } else {
                pst.setInt(4, bill.getMemberId());
            }
            pst.setTimestamp(5, bill.getTime_start() != null ? Timestamp.valueOf(bill.getTime_start()) : null);
            pst.setTimestamp(6, bill.getTime_end() != null ? Timestamp.valueOf(bill.getTime_end()) : null);
            pst.setDouble(7, bill.getTotal());
            pst.setString(8, bill.getStatus());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Bill getUnpaidBillByTableId(int tableId) {
        String sql = "SELECT * FROM Bill WHERE table_id = ? AND status = 'Unpaid'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, tableId);
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
    public boolean updateBill(Bill bill) {
        String sql = "UPDATE Bill SET table_id = ?, account_id = ?, voucher_id = ?, member_id = ?, time_start = ?, time_end = ?, total = ?, status = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, bill.getTable_id());
            if (bill.getAccount_id() == null) {
                pst.setNull(2, java.sql.Types.INTEGER);
            } else {
                pst.setInt(2, bill.getAccount_id());
            }
            if (bill.getVoucher_id() == null) {
                pst.setNull(3, java.sql.Types.INTEGER);
            } else {
                pst.setInt(3, bill.getVoucher_id());
            }
            if (bill.getMemberId() == null) {
                pst.setNull(4, java.sql.Types.INTEGER);
            } else {
                pst.setInt(4, bill.getMemberId());
            }
            pst.setTimestamp(5, bill.getTime_start() != null ? Timestamp.valueOf(bill.getTime_start()) : null);
            pst.setTimestamp(6, bill.getTime_end() != null ? Timestamp.valueOf(bill.getTime_end()) : null);
            pst.setDouble(7, bill.getTotal());
            pst.setString(8, bill.getStatus());
            pst.setInt(9, bill.getBill_id());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Bill getBillById(int id) {
        String sql = "SELECT * FROM Bill WHERE id = ?";
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
    public List<Bill> searchBills(LocalDateTime from, LocalDateTime to, Integer accountId, Integer tableId, String status) {
        List<Bill> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Bill WHERE 1 = 1");
        List<Object> params = new ArrayList<>();

        if (from != null) {
            sql.append(" AND time_start >= ?");
            params.add(Timestamp.valueOf(from));
        }
        if (to != null) {
            sql.append(" AND time_start < ?");
            params.add(Timestamp.valueOf(to));
        }
        if (accountId != null) {
            sql.append(" AND account_id = ?");
            params.add(accountId);
        }
        if (tableId != null) {
            sql.append(" AND table_id = ?");
            params.add(tableId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }
        sql.append(" ORDER BY id DESC");

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pst.setObject(i + 1, params.get(i));
            }
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
    public List<Bill> getPaidBillsByShift(LocalDateTime start, LocalDateTime end) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM Bill WHERE status = 'Paid' AND time_end >= ? AND time_end <= ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setTimestamp(1, Timestamp.valueOf(start));
            pst.setTimestamp(2, Timestamp.valueOf(end));
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
    public boolean deleteBill(int billId) {
        String sqlDetail = "DELETE FROM BillDetail WHERE bill_id = ?";
        String sqlBill = "DELETE FROM Bill WHERE id = ?";
        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement pst1 = con.prepareStatement(sqlDetail)) {
                pst1.setInt(1, billId);
                pst1.executeUpdate();
            }
            try (PreparedStatement pst2 = con.prepareStatement(sqlBill)) {
                pst2.setInt(1, billId);
                return pst2.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
