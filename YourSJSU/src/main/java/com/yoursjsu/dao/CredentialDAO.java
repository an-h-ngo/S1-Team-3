package com.yoursjsu.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CredentialDAO {
    public String getPasswordHash(int userId) {
        String sql = "SELECT password_hash FROM credential WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Updates the credential table with the user's new password
    // Returns true if one row was changed, returns false if nothing changed
    public boolean updatePassword(int userId, String newPassword) {

        String sql =
            "UPDATE credential\n" +
            "SET    password_hash = ?\n" +
            "WHERE  user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // first ? = the new password
            // second ? = which user
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0; // returns num of rows that changed, more than 1 means it was success
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
