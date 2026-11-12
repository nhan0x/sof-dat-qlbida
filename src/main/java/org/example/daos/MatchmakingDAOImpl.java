package org.example.daos;

import org.example.models.Matchmaking;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class MatchmakingDAOImpl implements MatchmakingDAO {

    private static final String SELECT_BASE =
            "SELECT m.*, " +
            "a1.name AS host_name, mp1.zalo_phone AS host_zalo, " +
            "a2.name AS partner_name, mp2.zalo_phone AS partner_zalo " +
            "FROM Matchmaking m " +
            "JOIN Account a1 ON m.account_id = a1.id " +
            "LEFT JOIN MatchmakingProfile mp1 ON mp1.account_id = a1.id " +
            "LEFT JOIN Account a2 ON m.partner_id = a2.id " +
            "LEFT JOIN MatchmakingProfile mp2 ON mp2.account_id = a2.id ";

    private Matchmaking mapRow(ResultSet rs) throws Exception {
        Matchmaking m = new Matchmaking();
        m.setId(rs.getInt("id"));
        m.setAccountId(rs.getInt("account_id"));
        m.setHostName(rs.getNString("host_name"));
        m.setHostZalo(rs.getString("host_zalo"));
        m.setTableType(rs.getNString("play_type"));
        m.setFormat(rs.getNString("format"));
        m.setRankRequirement(rs.getNString("rank_requirement"));

        Timestamp playTimeTs = rs.getTimestamp("play_time");
        if (playTimeTs != null) {
            m.setPlayTime(playTimeTs.toLocalDateTime());
        }

        m.setNote(rs.getNString("note"));
        m.setStatus(rs.getString("status"));

        int partnerId = rs.getInt("partner_id");
        if (rs.wasNull()) {
            m.setPartnerId(null);
        } else {
            m.setPartnerId(partnerId);
        }

        m.setPartnerName(rs.getNString("partner_name"));
        m.setPartnerZalo(rs.getString("partner_zalo"));

        Timestamp createdAtTs = rs.getTimestamp("created_at");
        if (createdAtTs != null) {
            m.setCreatedAt(createdAtTs.toLocalDateTime());
        }

        return m;
    }

    @Override
    public boolean create(Matchmaking match) {
        String sql = "INSERT INTO Matchmaking(account_id, play_type, format, rank_requirement, play_time, note, status) " +
                     "VALUES(?, ?, ?, ?, ?, ?, 'Waiting')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, match.getAccountId());
            pst.setNString(2, match.getTableType());
            pst.setNString(3, match.getFormat());
            pst.setNString(4, match.getRankRequirement());
            pst.setTimestamp(5, Timestamp.valueOf(match.getPlayTime()));
            pst.setNString(6, match.getNote());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Matchmaking> getAllWaiting() {
        List<Matchmaking> list = new ArrayList<>();
        String sql = SELECT_BASE +
                "WHERE m.status = 'Waiting' AND m.play_time >= DATEADD(hour, -2, GETDATE()) " +
                "ORDER BY m.play_time ASC";
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
    public List<Matchmaking> getByAccountId(int accountId) {
        List<Matchmaking> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE m.account_id = ? ORDER BY m.created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, accountId);
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
    public List<Matchmaking> getByPartnerId(int partnerId) {
        List<Matchmaking> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE m.partner_id = ? ORDER BY m.play_time ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, partnerId);
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
    public Matchmaking getById(int id) {
        String sql = SELECT_BASE + "WHERE m.id = ?";
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
    public boolean joinMatch(int matchId, int partnerId) {
        String sql = "UPDATE Matchmaking SET partner_id = ?, status = 'Matched' WHERE id = ? AND status = 'Waiting'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, partnerId);
            pst.setInt(2, matchId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean cancelMatch(int matchId) {
        String sql = "UPDATE Matchmaking SET status = 'Cancelled' WHERE id = ? AND status = 'Waiting'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, matchId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
