package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SessionDAO {
    public boolean createSession(String sessionToken, int userId) {
        String sql = "INSERT INTO `session` (session_token, user_id, status, created_at, expires_at) "
                + "VALUES (?, ?, 'active', NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR)) "
                + "ON DUPLICATE KEY UPDATE user_id = VALUES(user_id), status = 'active', "
                + "created_at = NOW(), expires_at = DATE_ADD(NOW(), INTERVAL 1 HOUR)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionToken);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean validateAndExtend(String sessionToken, int userId) {
        String sql = "UPDATE `session` "
                + "SET expires_at = DATE_ADD(NOW(), INTERVAL 1 HOUR) "
                + "WHERE session_token = ? AND user_id = ? AND status = 'active' AND expires_at > NOW()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionToken);
            stmt.setInt(2, userId);
            boolean valid = stmt.executeUpdate() > 0;
            if (!valid) {
                expireSession(sessionToken);
            }
            return valid;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void invalidateSession(String sessionToken) {
        updateStatus(sessionToken, "invalidated");
    }

    public void expireOldSessions() {
        String sql = "UPDATE `session` SET status = 'expired' "
                + "WHERE status = 'active' AND expires_at <= NOW()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void expireSession(String sessionToken) {
        if (sessionToken == null) {
            return;
        }
        String sql = "UPDATE `session` SET status = 'expired' "
                + "WHERE session_token = ? AND status = 'active' AND expires_at <= NOW()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionToken);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateStatus(String sessionToken, String status) {
        if (sessionToken == null) {
            return;
        }
        String sql = "UPDATE `session` SET status = ? WHERE session_token = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, sessionToken);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
