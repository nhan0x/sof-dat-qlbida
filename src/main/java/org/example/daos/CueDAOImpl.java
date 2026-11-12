package org.example.daos;

import org.example.models.Cue;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CueDAOImpl implements CueDAO {

    // --- 1. CREATE ---
    @Override
    public Boolean create(String name, String brand, float pricePerHour, String status, String description) {
        String sql = "INSERT INTO Cue(name, brand, price_per_hour, status, description) VALUES(?, ?, ?, ?, ?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setNString(1, name);
            pst.setNString(2, brand);
            pst.setFloat(3, pricePerHour);
            pst.setNString(4, status);
            pst.setNString(5, description);

            return pst.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 2. READ ALL ---
    @Override
    public List<Cue> getAll() {
        List<Cue> cueList = new ArrayList<>();
        String sql = "SELECT * FROM Cue WHERE is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Cue cue = new Cue(
                        rs.getInt("id"), // Giả định bảng có cột khóa chính là id
                        rs.getNString("name"),
                        rs.getNString("brand"),
                        rs.getFloat("price_per_hour"),
                        rs.getNString("status"),
                        rs.getNString("description")
                );
                cueList.add(cue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cueList;
    }

    // --- 3. READ BY ID ---
    @Override
    public Cue getById(int id) {
        String sql = "SELECT * FROM Cue WHERE id = ? AND is_deleted = 0";
        Cue cue = null;

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, id);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    cue = new Cue(
                            rs.getInt("id"),
                            rs.getNString("name"),
                            rs.getNString("brand"),
                            rs.getFloat("price_per_hour"),
                            rs.getNString("status"),
                            rs.getNString("description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cue;
    }

    // --- 4. UPDATE ---
    @Override
    public Boolean update(int id, String name, String brand, float pricePerHour, String status, String description) {
        String sql = "UPDATE Cue SET name = ?, brand = ?, price_per_hour = ?, status = ?, description = ? WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setNString(1, name);
            pst.setNString(2, brand);
            pst.setFloat(3, pricePerHour);
            pst.setNString(4, status);
            pst.setNString(5, description);
            pst.setInt(6, id);

            return pst.executeUpdate() > 0; // Trả về true nếu có ít nhất 1 dòng được cập nhật

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 5. DELETE ---
    @Override
    public Boolean delete(int id) {
        String sql = "UPDATE Cue SET is_deleted = 1 WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, id);

            return pst.executeUpdate() > 0; // Trả về true nếu xóa thành công

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}