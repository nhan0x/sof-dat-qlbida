package org.example.daos;

import org.example.models.Category;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getNString("name"),
                        rs.getBoolean("is_deleted")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Category getById(int id) {
        String sql = "SELECT * FROM Category WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("id"),
                            rs.getNString("name"),
                            rs.getBoolean("is_deleted")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Category getByName(String name) {
        String sql = "SELECT * FROM Category WHERE name = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, name);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("id"),
                            rs.getNString("name"),
                            rs.getBoolean("is_deleted")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Category getAnyByName(String name) {
        String sql = "SELECT * FROM Category WHERE name = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, name);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("id"),
                            rs.getNString("name"),
                            rs.getBoolean("is_deleted")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean create(Category category) {
        String sql = "INSERT INTO Category(name) VALUES(?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, category.getName());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Category category) {
        Category old = getById(category.getId());
        if (old == null) return false;

        String sql = "UPDATE Category SET name = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Update Category table
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setNString(1, category.getName());
                    pst.setInt(2, category.getId());
                    int updated = pst.executeUpdate();
                    if (updated <= 0) {
                        con.rollback();
                        return false;
                    }
                }
                
                // Update matching Service records to the new category name
                String updateServiceSql = "UPDATE Service SET category = ? WHERE category = ? AND is_deleted = 0";
                try (PreparedStatement pstService = con.prepareStatement(updateServiceSql)) {
                    pstService.setNString(1, category.getName());
                    pstService.setNString(2, old.getName());
                    pstService.executeUpdate();
                }

                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        Category old = getById(id);
        if (old == null) return false;

        String sql = "UPDATE Category SET is_deleted = 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Update Category table
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setInt(1, id);
                    int updated = pst.executeUpdate();
                    if (updated <= 0) {
                        con.rollback();
                        return false;
                    }
                }
                
                // Update matching Service records to default category "Khác"
                String updateServiceSql = "UPDATE Service SET category = N'Khác' WHERE category = ? AND is_deleted = 0";
                try (PreparedStatement pstService = con.prepareStatement(updateServiceSql)) {
                    pstService.setNString(1, old.getName());
                    pstService.executeUpdate();
                }

                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
