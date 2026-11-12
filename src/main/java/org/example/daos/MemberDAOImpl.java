package org.example.daos;

import org.example.models.Member;
import org.example.utils.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MemberDAOImpl implements MemberDAO {

    @Override
    public List<Member> getAll() {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT id, username, name, phone, email, points, discount_rate FROM Account WHERE role = N'Khách hàng' AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(new Member(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getNString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getInt("points"),
                        rs.getDouble("discount_rate")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Member getById(int id) {
        String sql = "SELECT id, username, name, phone, email, points, discount_rate FROM Account WHERE id = ? AND role = N'Khách hàng' AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Member(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getNString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getInt("points"),
                            rs.getDouble("discount_rate")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Member getByPhone(String phone) {
        String sql = "SELECT id, username, name, phone, email, points, discount_rate FROM Account WHERE phone = ? AND role = N'Khách hàng' AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, phone);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Member(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getNString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getInt("points"),
                            rs.getDouble("discount_rate")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean create(Member member, String plainPassword) {
        String pwd = (plainPassword == null || plainPassword.trim().isEmpty()) ? "123456" : plainPassword;
        String hashedPassword = BCrypt.hashpw(pwd, BCrypt.gensalt(12));
        
        String sql = "INSERT INTO Account(username, password, role, name, phone, email, points, discount_rate, is_deleted) VALUES(?, ?, N'Khách hàng', ?, ?, ?, ?, ?, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, member.getUsername());
            pst.setString(2, hashedPassword);
            pst.setNString(3, member.getName());
            pst.setString(4, member.getPhone());
            pst.setString(5, member.getEmail());
            pst.setInt(6, member.getPoints());
            pst.setDouble(7, member.getDiscountRate());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Member member) {
        String sql = "UPDATE Account SET name = ?, phone = ?, email = ?, points = ?, discount_rate = ? WHERE id = ? AND role = N'Khách hàng'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, member.getName());
            pst.setString(2, member.getPhone());
            pst.setString(3, member.getEmail());
            pst.setInt(4, member.getPoints());
            pst.setDouble(5, member.getDiscountRate());
            pst.setInt(6, member.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "UPDATE Account SET is_deleted = 1 WHERE id = ? AND role = N'Khách hàng'";
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
    public boolean addPoints(int id, int pointsToAdd) {
        String sqlAdd = "UPDATE Account SET points = points + ? WHERE id = ? AND role = N'Khách hàng'";
        String sqlGet = "SELECT points FROM Account WHERE id = ? AND role = N'Khách hàng'";
        String sqlUpdateRate = "UPDATE Account SET discount_rate = ? WHERE id = ? AND role = N'Khách hàng'";
        
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement pstAdd = con.prepareStatement(sqlAdd);
                 PreparedStatement pstGet = con.prepareStatement(sqlGet);
                 PreparedStatement pstUpdate = con.prepareStatement(sqlUpdateRate)) {
                 
                // 1. Add points
                pstAdd.setInt(1, pointsToAdd);
                pstAdd.setInt(2, id);
                pstAdd.executeUpdate();
                
                // 2. Get updated point total
                pstGet.setInt(1, id);
                int points = 0;
                try (ResultSet rs = pstGet.executeQuery()) {
                    if (rs.next()) {
                        points = rs.getInt("points");
                    }
                }
                
                // 3. Determine new discount rate based on points
                double newRate = 0.0;
                if (points >= 2000) {
                    newRate = 20.0;
                } else if (points >= 1000) {
                    newRate = 15.0;
                } else if (points >= 500) {
                    newRate = 10.0;
                } else if (points >= 300) {
                    newRate = 5.0;
                }
                
                // 4. Update the member's discount rate
                pstUpdate.setDouble(1, newRate);
                pstUpdate.setInt(2, id);
                pstUpdate.executeUpdate();
                
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Member> search(String keyword) {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT id, username, name, phone, email, points, discount_rate FROM Account " +
                     "WHERE role = N'Khách hàng' AND is_deleted = 0 " +
                     "AND (name LIKE ? OR phone LIKE ? OR email LIKE ? OR username LIKE ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            pst.setString(1, kw);
            pst.setString(2, kw);
            pst.setString(3, kw);
            pst.setString(4, kw);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(new Member(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getNString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getInt("points"),
                            rs.getDouble("discount_rate")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
