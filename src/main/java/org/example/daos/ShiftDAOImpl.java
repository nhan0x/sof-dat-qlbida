package org.example.daos;

import org.example.models.Shift;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ShiftDAOImpl implements ShiftDAO {

    public ShiftDAOImpl() {
        createTableIfNeeded();
    }

    private void createTableIfNeeded() {
        String sql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Shift' AND xtype='U')\n" +
                "BEGIN\n" +
                "    CREATE TABLE Shift (\n" +
                "        id INT IDENTITY(1,1) PRIMARY KEY,\n" +
                "        account_id INT NOT NULL,\n" +
                "        time_start DATETIME NOT NULL,\n" +
                "        time_end DATETIME,\n" +
                "        initial_balance FLOAT NOT NULL,\n" +
                "        total_revenue FLOAT DEFAULT 0,\n" +
                "        status NVARCHAR(20) DEFAULT 'Open',\n" +
                "        FOREIGN KEY (account_id) REFERENCES Account(id)\n" +
                "    )\n" +
                "END";
        String addClosingBalance =
                "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shift') AND name = 'closing_balance')\n" +
                "    ALTER TABLE Shift ADD closing_balance FLOAT NULL";
        String addNote =
                "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shift') AND name = 'note')\n" +
                "    ALTER TABLE Shift ADD note NVARCHAR(500) NULL";
        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement()) {
            st.execute(sql);
            st.execute(addClosingBalance);
            st.execute(addNote);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Shift mapRow(ResultSet rs) throws Exception {
        Shift shift = new Shift();
        shift.setId(rs.getInt("id"));
        shift.setAccountId(rs.getInt("account_id"));
        
        Timestamp startTs = rs.getTimestamp("time_start");
        if (startTs != null) {
            shift.setTimeStart(startTs.toLocalDateTime());
        }

        Timestamp endTs = rs.getTimestamp("time_end");
        if (endTs != null) {
            shift.setTimeEnd(endTs.toLocalDateTime());
        }

        shift.setInitialBalance(rs.getDouble("initial_balance"));
        shift.setTotalRevenue(rs.getDouble("total_revenue"));
        shift.setClosingBalance(rs.getDouble("closing_balance"));
        try {
            shift.setNote(rs.getString("note"));
        } catch (Exception e) {
            shift.setNote(null);
        }
        shift.setStatus(rs.getString("status"));
        return shift;
    }

    @Override
    public Shift getActiveShiftByAccountId(int accountId) {
        String sql = "SELECT * FROM Shift WHERE account_id = ? AND status = 'Open'";
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
    public boolean openShift(Shift shift) {
        String sql = "INSERT INTO Shift(account_id, time_start, initial_balance, total_revenue, status) VALUES(?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, shift.getAccountId());
            pst.setTimestamp(2, shift.getTimeStart() != null ? Timestamp.valueOf(shift.getTimeStart()) : null);
            pst.setDouble(3, shift.getInitialBalance());
            pst.setDouble(4, shift.getTotalRevenue());
            pst.setString(5, shift.getStatus());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean closeShift(int shiftId, double totalRevenue, double closingBalance) {
        return closeShift(shiftId, -1, totalRevenue, closingBalance, null);
    }

    @Override
    public boolean closeShift(int shiftId, double initialBalance, double totalRevenue, double closingBalance, String note) {
        String sql;
        if (initialBalance >= 0) {
            sql = "UPDATE Shift SET time_end = ?, initial_balance = ?, total_revenue = ?, closing_balance = ?, note = ?, status = 'Closed' WHERE id = ?";
        } else {
            sql = "UPDATE Shift SET time_end = ?, total_revenue = ?, closing_balance = ?, note = ?, status = 'Closed' WHERE id = ?";
        }
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            int idx = 1;
            pst.setTimestamp(idx++, Timestamp.valueOf(java.time.LocalDateTime.now()));
            if (initialBalance >= 0) {
                pst.setDouble(idx++, initialBalance);
            }
            pst.setDouble(idx++, totalRevenue);
            pst.setDouble(idx++, closingBalance);
            pst.setString(idx++, note);
            pst.setInt(idx++, shiftId);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Shift> getAllShifts() {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shift ORDER BY time_start DESC";
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
    public Shift getShiftById(int id) {
        String sql = "SELECT * FROM Shift WHERE id = ?";
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
}
