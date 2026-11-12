package org.example.daos;

import org.example.models.BillDetails;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BilldetailsDAOImpl implements BillDetailsDAO {

    private BillDetails mapRow(ResultSet rs) throws Exception {
        return new BillDetails(
                rs.getInt("id"),
                rs.getInt("bill_id"),
                rs.getInt("service_id"),
                rs.getInt("quantity"),
                rs.getDouble("price")
        );
    }

    @Override
    public List<BillDetails> getDetailsByBillId(int billId) {
        List<BillDetails> list = new ArrayList<>();
        String sql = "SELECT * FROM BillDetail WHERE bill_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, billId);
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
    public boolean addDetail(BillDetails detail) {
        String sql = "INSERT INTO BillDetail(bill_id, service_id, quantity, price) VALUES(?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, detail.getBillId());
            pst.setInt(2, detail.getService_id());
            pst.setInt(3, detail.getQuantity());
            pst.setDouble(4, detail.getPrice());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateDetail(BillDetails detail) {
        String sql = "UPDATE BillDetail SET bill_id = ?, service_id = ?, quantity = ?, price = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, detail.getBillId());
            pst.setInt(2, detail.getService_id());
            pst.setInt(3, detail.getQuantity());
            pst.setDouble(4, detail.getPrice());
            pst.setInt(5, detail.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteDetail(int id) {
        String sql = "DELETE FROM BillDetail WHERE id = ?";
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
    public BillDetails getDetailByBillAndService(int billId, int serviceId) {
        String sql = "SELECT * FROM BillDetail WHERE bill_id = ? AND service_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, billId);
            pst.setInt(2, serviceId);
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
}
