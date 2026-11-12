package org.example.daos;

import org.example.daos.AccountDAO;
import org.example.models.Account;
import org.example.utils.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAOImpl implements AccountDAO {

    @Override
    public Boolean dangKy(String username, String password, String name, String phone, String email, String role) {
        try {
            String sql = "INsert into Account(username, password, role, name, phone, email)\n" +
                    "  VALUES(?, ?, ?, ?, ?, ?)";

            Connection con = DBUtil.getConnection();
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, role);
            pst.setNString(4, name);
            pst.setString(5, phone);
            pst.setString(6, email);

            if (pst.executeUpdate() == 1) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean daTonTaiUserName(String username) {
        try {
            String sql = "SELECT * FROM Account WHERE username = ?";

            Connection con = DBUtil.getConnection();
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean daTonTaiEmail(String email) {
        try {
            String sql = "SELECT * FROM Account WHERE email = ?";

            Connection con = DBUtil.getConnection();
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Account dangNhap(String username, String password) {
        try {
            String sql = "SELECT * FROM Account WHERE username = ? AND is_deleted = 0";

            Connection con = DBUtil.getConnection();
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setId(rs.getInt("id"));
                acc.setUsername(rs.getString("username"));
                acc.setEmail(rs.getString("email"));
                acc.setPassword(rs.getString("password"));
                acc.setPhone(rs.getString("phone"));
                acc.setRole(rs.getString("role"));
                acc.setName(rs.getString("name"));
                acc.setMemberRank(rs.getString("member_rank"));
                acc.setPlayingStyle(rs.getString("playing_style"));
                acc.setPoints(rs.getInt("points"));
                acc.setDiscountRate(rs.getDouble("discount_rate"));

                Boolean mkDung = BCrypt.checkpw(password, acc.getPassword());
                if (mkDung) {
                    return acc;
                } else {
                    return null;
                }

            } else {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public java.util.List<Account> getAllAccounts() {
        java.util.List<Account> list = new java.util.ArrayList<>();
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Account WHERE is_deleted = 0";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(new Account(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("member_rank"),
                        rs.getString("playing_style")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Account getAccountById(int id) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Account WHERE id = ? AND is_deleted = 0";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Account acc = new Account(rs.getInt("id"), rs.getString("username"), rs.getString("password"),
                        rs.getString("role"), rs.getString("name"), rs.getString("phone"), rs.getString("email"),
                        rs.getString("member_rank"), rs.getString("playing_style"));
                acc.setPoints(rs.getInt("points"));
                acc.setDiscountRate(rs.getDouble("discount_rate"));
                return acc;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean createAccount(Account acc) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "INSERT INTO Account(username, password, role, name, phone, email) VALUES(?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, acc.getUsername());
            pst.setString(2, acc.getPassword());
            pst.setString(3, acc.getRole());
            pst.setString(4, acc.getName());
            pst.setString(5, acc.getPhone());
            pst.setString(6, acc.getEmail());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateAccount(Account acc) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "UPDATE Account SET role = ?, name = ?, phone = ?, email = ? WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, acc.getRole());
            pst.setString(2, acc.getName());
            pst.setString(3, acc.getPhone());
            pst.setString(4, acc.getEmail());
            pst.setInt(5, acc.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteAccount(int id) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "UPDATE Account SET is_deleted = 1 WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public java.util.List<Account> searchAccounts(String keyword) {
        java.util.List<Account> list = new java.util.ArrayList<>();
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Account WHERE is_deleted = 0 AND (username LIKE ? OR name LIKE ? OR phone LIKE ? OR email LIKE ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            pst.setString(4, searchPattern);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(new Account(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("member_rank"),
                        rs.getString("playing_style")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean resetPassword(String email, String newPasswordHashed) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "UPDATE Account SET password = ? WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, newPasswordHashed);
            pst.setString(2, email);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Account getAccountByEmail(String email) {
        try {
            Connection con = DBUtil.getConnection();
            String sql = "SELECT * FROM Account WHERE email = ? AND is_deleted = 0";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setId(rs.getInt("id"));
                acc.setUsername(rs.getString("username"));
                acc.setEmail(rs.getString("email"));
                acc.setPassword(rs.getString("password"));
                acc.setPhone(rs.getString("phone"));
                acc.setRole(rs.getString("role"));
                acc.setName(rs.getString("name"));
                acc.setMemberRank(rs.getString("member_rank"));
                acc.setPlayingStyle(rs.getString("playing_style"));
                return acc;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updatePersonalInfo(Account acc) {
        String sql = "UPDATE Account SET name = ?, phone = ?, email = ?, member_rank = ?, playing_style = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, acc.getName());
            pst.setString(2, acc.getPhone());
            pst.setString(3, acc.getEmail());
            pst.setNString(4, acc.getMemberRank());
            pst.setNString(5, acc.getPlayingStyle());
            pst.setInt(6, acc.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateMatchmakingProfile(int accountId, String rank, String style, String phone, String email) {
        String sql = "UPDATE Account SET member_rank = ?, playing_style = ?, phone = ?, email = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setNString(1, rank);
            pst.setNString(2, style);
            pst.setString(3, phone);
            pst.setString(4, email);
            pst.setInt(5, accountId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}