package org.example.daos;

import org.example.models.TableBida;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TableBidaDAOImpl implements TableBidaDAO {

    // --- 1. READ ALL ---
    @Override
    public List<TableBida> getAll() {
        List<TableBida> list = new ArrayList<>();
        String sql = "SELECT t.*, tt.name AS typeName, tt.pricePerHour FROM TableBida t " +
                "LEFT JOIN tabletype tt ON t.tableTypeId = tt.id WHERE t.is_deleted = 0";
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

    // --- 2. READ BY ID ---
    @Override
    public TableBida getById(int id) {
        String sql = "SELECT t.*, tt.name AS typeName, tt.pricePerHour FROM TableBida t " +
                "LEFT JOIN tabletype tt ON t.tableTypeId = tt.id WHERE t.id = ? AND t.is_deleted = 0";
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

    private TableBida mapRow(ResultSet rs) throws java.sql.SQLException {
        TableBida table = new TableBida(
                rs.getInt("id"),
                rs.getNString("name"),
                rs.getNString("status"),
                rs.getInt("tableTypeId"));
        table.setTableTypeName(rs.getNString("typeName"));
        table.setPricePerHour(rs.getDouble("pricePerHour"));
        table.setCameraIp(rs.getNString("camera_ip"));
        table.setCameraPort(rs.getNString("camera_port"));
        table.setCameraUsername(rs.getNString("camera_username"));
        table.setCameraPassword(rs.getNString("camera_password"));
        return table;
    }

    // --- 3. CREATE ---
    @Override
    public boolean create(TableBida table) {
        String sql = "INSERT INTO TableBida(name, status, tableTypeId, camera_ip, camera_port, camera_username, camera_password) VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, table.getName());
            pst.setNString(2, table.getStatus());
            pst.setInt(3, table.getTableTypeId());
            pst.setNString(4, table.getCameraIp());
            pst.setNString(5, table.getCameraPort());
            pst.setNString(6, table.getCameraUsername());
            pst.setNString(7, table.getCameraPassword());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- 4. UPDATE ---
    @Override
    public boolean update(TableBida table) {
        String sql = "UPDATE TableBida SET name = ?, status = ?, tableTypeId = ?, camera_ip = ?, camera_port = ?, camera_username = ?, camera_password = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, table.getName());
            pst.setNString(2, table.getStatus());
            pst.setInt(3, table.getTableTypeId());
            pst.setNString(4, table.getCameraIp());
            pst.setNString(5, table.getCameraPort());
            pst.setNString(6, table.getCameraUsername());
            pst.setNString(7, table.getCameraPassword());
            pst.setInt(8, table.getId());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- 5. DELETE ---
    @Override
    public boolean delete(int id) {
        String sql = "UPDATE TableBida SET is_deleted = 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Khi xóa hết bàn, reset lại bộ đếm id để bàn tạo mới tiếp theo bắt đầu từ 1
    private void resetIdentityIfEmpty(Connection con) {
        String countSql = "SELECT COUNT(*) FROM TableBida";
        try (PreparedStatement countPst = con.prepareStatement(countSql);
             ResultSet rs = countPst.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                try (PreparedStatement reseedPst = con.prepareStatement(
                        "DBCC CHECKIDENT ('TableBida', RESEED, 0)")) {
                    reseedPst.execute();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
