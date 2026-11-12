package org.example.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = env("DB_URL", "jdbc:sqlserver://localhost:1433;databaseName=QLBida5;encrypt=true;trustServerCertificate=true;");
    private static final String USER = env("DB_USER", "sa");
    private static final String PASSWORD = env("DB_PASSWORD", "");
    private static String env(String k, String d) { String v = System.getenv(k); return v == null ? d : v; }

    private static boolean migrated = false;

    private static synchronized void checkMigration() {
        if (migrated) return;
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
             java.sql.Statement stmt = connection.createStatement()) {
            
            // 1. Category migration for Service
            boolean exists = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Service", "category")) {
                if (rs.next()) {
                    exists = true;
                }
            }
            if (!exists) {
                stmt.execute("ALTER TABLE Service ADD category NVARCHAR(100) NOT NULL DEFAULT N'Khác'");
            }

            // 1.1 Create Category table if not exists
            boolean catTableExists = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getTables(null, null, "Category", null)) {
                if (rs.next()) {
                    catTableExists = true;
                }
            }
            if (!catTableExists) {
                stmt.execute("CREATE TABLE Category (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "name NVARCHAR(100) NOT NULL UNIQUE, " +
                             "is_deleted BIT NOT NULL DEFAULT 0)");
                
                // Seed initial categories
                String[] defaultCats = {"Nước uống", "Đồ uống có cồn", "Đồ ăn", "Thuốc lá", "Khác"};
                for (String cat : defaultCats) {
                    try (java.sql.PreparedStatement pst = connection.prepareStatement("INSERT INTO Category(name) VALUES(?)")) {
                        pst.setNString(1, cat);
                        pst.executeUpdate();
                    }
                }
            }

            // 2. Add is_deleted BIT NOT NULL DEFAULT 0 to tables: TableBida, tabletype, Service, Cue, Account
            String[] tables = {"TableBida", "tabletype", "Service", "Cue", "Account"};
            for (String tbl : tables) {
                boolean hasDeleted = false;
                try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, tbl, "is_deleted")) {
                    if (rs.next()) {
                        hasDeleted = true;
                    }
                }
                if (!hasDeleted) {
                    try {
                        stmt.execute("ALTER TABLE " + tbl + " ADD is_deleted BIT NOT NULL DEFAULT 0");
                    } catch (Exception ex) {
                        // In case of case sensitivity or other issues, try uppercase/lowercase TableType
                        if ("tabletype".equals(tbl)) {
                            try {
                                stmt.execute("ALTER TABLE TableType ADD is_deleted BIT NOT NULL DEFAULT 0");
                            } catch (Exception ex2) {
                                ex2.printStackTrace();
                            }
                        } else {
                            ex.printStackTrace();
                        }
                    }
                }
            }

            // 3. Add points and discount_rate to Account table if not exists
            boolean hasPoints = false;
            boolean hasDiscountRate = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Account", null)) {
                while (rs.next()) {
                    String col = rs.getString("COLUMN_NAME");
                    if ("points".equalsIgnoreCase(col)) {
                        hasPoints = true;
                    }
                    if ("discount_rate".equalsIgnoreCase(col)) {
                        hasDiscountRate = true;
                    }
                }
            }
            if (!hasPoints) {
                stmt.execute("ALTER TABLE Account ADD points INT NOT NULL DEFAULT 0");
            }
            if (!hasDiscountRate) {
                stmt.execute("ALTER TABLE Account ADD discount_rate FLOAT NOT NULL DEFAULT 0.0");
            }

            // 4. Add member_id to Bill table if not exists
            boolean hasMemberId = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Bill", "member_id")) {
                if (rs.next()) {
                    hasMemberId = true;
                }
            }
            if (!hasMemberId) {
                stmt.execute("ALTER TABLE Bill ADD member_id INT NULL");
            }

            // 5. Create Matchmaking table if not exists
            boolean hasMatchmaking = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getTables(null, null, "Matchmaking", null)) {
                if (rs.next()) {
                    hasMatchmaking = true;
                }
            }
            if (!hasMatchmaking) {
                stmt.execute("CREATE TABLE Matchmaking (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "account_id INT NOT NULL, " +
                             "play_type NVARCHAR(100) NOT NULL, " +
                             "play_time DATETIME NOT NULL, " +
                             "note NVARCHAR(500) NULL, " +
                             "status NVARCHAR(50) NOT NULL DEFAULT 'Waiting', " +
                             "partner_id INT NULL, " +
                             "created_at DATETIME NOT NULL DEFAULT GETDATE(), " +
                             "FOREIGN KEY (account_id) REFERENCES Account(id), " +
                             "FOREIGN KEY (partner_id) REFERENCES Account(id))");
            }

            // 6. Add member_rank and playing_style to Account table if not exists
            boolean hasMemberRank = false;
            boolean hasPlayingStyle = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Account", null)) {
                while (rs.next()) {
                    String col = rs.getString("COLUMN_NAME");
                    if ("member_rank".equalsIgnoreCase(col)) {
                        hasMemberRank = true;
                    }
                    if ("playing_style".equalsIgnoreCase(col)) {
                        hasPlayingStyle = true;
                    }
                }
            }
            if (!hasMemberRank) {
                stmt.execute("ALTER TABLE Account ADD member_rank NVARCHAR(100) NULL DEFAULT N'Nghiệp dư'");
            }
            if (!hasPlayingStyle) {
                stmt.execute("ALTER TABLE Account ADD playing_style NVARCHAR(250) NULL DEFAULT N'Chưa cập nhật'");
            }

            // 7. Create Locker table if not exists
            boolean hasLocker = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getTables(null, null, "Locker", null)) {
                if (rs.next()) {
                    hasLocker = true;
                }
            }
            if (!hasLocker) {
                stmt.execute("CREATE TABLE Locker (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "locker_number NVARCHAR(100) NOT NULL UNIQUE, " +
                             "status NVARCHAR(50) NOT NULL DEFAULT 'Available', " +
                             "member_id INT NULL, " +
                             "start_date DATETIME NULL, " +
                             "end_date DATETIME NULL, " +
                             "price DECIMAL(18,2) NOT NULL DEFAULT 0.0, " +
                             "note NVARCHAR(500) NULL, " +
                             "is_deleted BIT NOT NULL DEFAULT 0, " +
                             "FOREIGN KEY (member_id) REFERENCES Account(id))");
            }

            // 7.1 Add customer_name to Locker table if not exists (for walk-in / non-member rentals)
            boolean hasCustomerName = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Locker", "customer_name")) {
                if (rs.next()) {
                    hasCustomerName = true;
                }
            }
            if (!hasCustomerName) {
                stmt.execute("ALTER TABLE Locker ADD customer_name NVARCHAR(200) NULL");
            }

            // 7.2 Add is_deleted to Booking table if not exists
            boolean hasBookingDeleted = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Booking", "is_deleted")) {
                if (rs.next()) {
                    hasBookingDeleted = true;
                }
            }
            if (!hasBookingDeleted) {
                stmt.execute("ALTER TABLE Booking ADD is_deleted BIT NOT NULL DEFAULT 0");
            }

            // 8. Create StaffCall table if not exists
            boolean hasStaffCall = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getTables(null, null, "StaffCall", null)) {
                if (rs.next()) {
                    hasStaffCall = true;
                }
            }
            if (!hasStaffCall) {
                stmt.execute("CREATE TABLE StaffCall (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "table_id INT NOT NULL, " +
                             "call_time DATETIME NOT NULL DEFAULT GETDATE(), " +
                             "status NVARCHAR(50) NOT NULL DEFAULT 'Pending', " +
                             "note NVARCHAR(500) NULL, " +
                             "FOREIGN KEY (table_id) REFERENCES TableBida(id))");
            }

            // 9. Add camera columns (ip, port, username, password) to TableBida table if not exists
            boolean hasCameraIp = false, hasCameraPort = false, hasCameraUsername = false, hasCameraPassword = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "TableBida", null)) {
                while (rs.next()) {
                    String col = rs.getString("COLUMN_NAME");
                    if ("camera_ip".equalsIgnoreCase(col)) hasCameraIp = true;
                    if ("camera_port".equalsIgnoreCase(col)) hasCameraPort = true;
                    if ("camera_username".equalsIgnoreCase(col)) hasCameraUsername = true;
                    if ("camera_password".equalsIgnoreCase(col)) hasCameraPassword = true;
                }
            }
            if (!hasCameraIp) {
                stmt.execute("ALTER TABLE TableBida ADD camera_ip NVARCHAR(100) NULL");
            }
            if (!hasCameraPort) {
                stmt.execute("ALTER TABLE TableBida ADD camera_port NVARCHAR(10) NULL");
            }
            if (!hasCameraUsername) {
                stmt.execute("ALTER TABLE TableBida ADD camera_username NVARCHAR(100) NULL");
            }
            if (!hasCameraPassword) {
                stmt.execute("ALTER TABLE TableBida ADD camera_password NVARCHAR(255) NULL");
            }

            // 10. Create MatchmakingProfile table if not exists (Ghép Kèo player registry)
            boolean hasMatchmakingProfile = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getTables(null, null, "MatchmakingProfile", null)) {
                if (rs.next()) {
                    hasMatchmakingProfile = true;
                }
            }
            if (!hasMatchmakingProfile) {
                stmt.execute("CREATE TABLE MatchmakingProfile (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "account_id INT NOT NULL UNIQUE, " +
                             "full_name NVARCHAR(150) NOT NULL, " +
                             "age INT NOT NULL, " +
                             "player_rank NVARCHAR(100) NOT NULL, " +
                             "zalo_phone NVARCHAR(30) NOT NULL, " +
                             "created_at DATETIME NOT NULL DEFAULT GETDATE(), " +
                             "FOREIGN KEY (account_id) REFERENCES Account(id))");
            }

            // 11. Add format / rank_requirement columns to Matchmaking table (Lập Kèo Mới)
            boolean hasFormat = false, hasRankRequirement = false;
            try (java.sql.ResultSet rs = connection.getMetaData().getColumns(null, null, "Matchmaking", null)) {
                while (rs.next()) {
                    String col = rs.getString("COLUMN_NAME");
                    if ("format".equalsIgnoreCase(col)) hasFormat = true;
                    if ("rank_requirement".equalsIgnoreCase(col)) hasRankRequirement = true;
                }
            }
            if (!hasFormat) {
                stmt.execute("ALTER TABLE Matchmaking ADD format NVARCHAR(50) NOT NULL DEFAULT N'Giao lưu'");
            }
            if (!hasRankRequirement) {
                stmt.execute("ALTER TABLE Matchmaking ADD rank_requirement NVARCHAR(50) NOT NULL DEFAULT N'Không giới hạn'");
            }

            migrated = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        checkMigration();
        Connection connection = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}

