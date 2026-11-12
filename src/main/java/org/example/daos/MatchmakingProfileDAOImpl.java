package org.example.daos;

import org.example.models.MatchmakingProfile;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class MatchmakingProfileDAOImpl implements MatchmakingProfileDAO {

    private MatchmakingProfile mapRow(ResultSet rs) throws java.sql.SQLException {
        MatchmakingProfile p = new MatchmakingProfile();
        p.setId(rs.getInt("id"));
        p.setAccountId(rs.getInt("account_id"));
        p.setFullName(rs.getNString("full_name"));
        p.setAge(rs.getInt("age"));
        p.setRank(rs.getNString("player_rank"));
        p.setZaloPhone(rs.getString("zalo_phone"));
        Timestamp createdAtTs = rs.getTimestamp("created_at");
        if (createdAtTs != null) {
            p.setCreatedAt(createdAtTs.toLocalDateTime());
        }
        return p;
    }

    @Override
    public List<MatchmakingProfile> getAll() {
        List<MatchmakingProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM MatchmakingProfile ORDER BY created_at DESC";
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
    public MatchmakingProfile getById(int id) {
        String sql = "SELECT * FROM MatchmakingProfile WHERE id = ?";
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
    public MatchmakingProfile getByAccountId(int accountId) {
        String sql = "SELECT * FROM MatchmakingProfile WHERE account_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, accountId);
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
    public boolean upsert(MatchmakingProfile profile) {
        MatchmakingProfile existing = getByAccountId(profile.getAccountId());
        if (existing != null) {
            String sql = "UPDATE MatchmakingProfile SET full_name = ?, age = ?, player_rank = ?, zalo_phone = ? WHERE account_id = ?";
            try (Connection con = DBUtil.getConnection();
                 PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setNString(1, profile.getFullName());
                pst.setInt(2, profile.getAge());
                pst.setNString(3, profile.getRank());
                pst.setString(4, profile.getZaloPhone());
                pst.setInt(5, profile.getAccountId());
                return pst.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO MatchmakingProfile(account_id, full_name, age, player_rank, zalo_phone) VALUES(?, ?, ?, ?, ?)";
            try (Connection con = DBUtil.getConnection();
                 PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, profile.getAccountId());
                pst.setNString(2, profile.getFullName());
                pst.setInt(3, profile.getAge());
                pst.setNString(4, profile.getRank());
                pst.setString(5, profile.getZaloPhone());
                return pst.executeUpdate() == 1;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
