package org.example.daos;

import org.example.models.TableType;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TableTypeDAOImpl implements TableTypeDAO {

    // --- 1. READ ALL ---
    @Override
    public List<TableType> getAll() {
        List<TableType> list = new ArrayList<>();
        String sql = "SELECT * FROM tabletype WHERE is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(new TableType(
                        rs.getInt("id"),
                        rs.getNString("name"),
                        rs.getDouble("pricePerHour")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- 2. READ BY ID ---
    @Override
    public TableType getById(int id) {
        String sql = "SELECT * FROM tabletype WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new TableType(
                            rs.getInt("id"),
                            rs.getNString("name"),
                            rs.getDouble("pricePerHour"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- 3. CREATE ---
    @Override
    public boolean create(TableType tableType) {
        String sql = "INSERT INTO tabletype(name, pricePerHour) VALUES(?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, tableType.getName());
            pst.setDouble(2, tableType.getPricePerHour());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- 4. UPDATE ---
    @Override
    public boolean update(TableType tableType) {
        String sql = "UPDATE tabletype SET name = ?, pricePerHour = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, tableType.getName());
            pst.setDouble(2, tableType.getPricePerHour());
            pst.setInt(3, tableType.getId());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- 5. DELETE ---
    @Override
    public boolean delete(int id) {
        String sql = "UPDATE tabletype SET is_deleted = 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
