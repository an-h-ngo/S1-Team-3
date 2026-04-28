package com.yoursjsu.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CredentialDAO {

    // Looks up password on file for the user, credential table has one row per user, filter by user_id and get password column
    public String getPasswordHash(int userId) {

        String sql =
            "SELECT password_hash\n" +
            "FROM   credential\n" +
            "WHERE  user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Fill in the ? with this user's id.
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
    // This is called when the user runs the change-password form
    // Returns true if one row was changed, returns false if nothing changed
    public boolean updatePassword(int userId, String newPassword) {

        String sql =
            "UPDATE credential\n" +
            "SET    password_hash = ?\n" +
            "WHERE  user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // First ? = the new password
            // Second ? = which user
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0; // returns num of rows that changed, more than 1 means it was success
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
