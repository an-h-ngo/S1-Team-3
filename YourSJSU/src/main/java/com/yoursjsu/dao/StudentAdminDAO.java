package com.yoursjsu.dao;
import com.yoursjsu.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentAdminDAO {

    // Returns all users in system + their overdue charges
    public List<UserWithHolds> getAllUsersWithHoldCounts() {
        List<UserWithHolds> rows = new ArrayList<>();

        // subquery counts overdue charges per user. COALESCE makes sure we
        // get 0 instead of null for users with no charges at all.
        String sql = "SELECT u.user_id, u.sjsu_id, u.email, u.first_name, u.last_name, u.status, "
                   + "       COALESCE((SELECT COUNT(*) FROM charge ch "
                   + "                  WHERE ch.user_id = u.user_id "
                   + "                    AND ch.status = 'overdue'), 0) AS hold_count "
                   + "FROM   `user` u "
                   + "ORDER BY u.last_name, u.first_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setSjsuId(rs.getString("sjsu_id"));
                user.setEmail(rs.getString("email"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setStatus(rs.getString("status"));

                UserWithHolds row = new UserWithHolds();
                row.user = user;
                row.holdCount = rs.getInt("hold_count");
                rows.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }

    // set users status to active or inactive, faculty can grant or deny access to portal
    // returns true if one row is updated
    public boolean setUserStatus(int userId, String newStatus) {
        // Only allow the two valid values — anything else is rejected.
        if (!"active".equals(newStatus) && !"inactive".equals(newStatus)) {
            return false;
        }

        String sql = "UPDATE `user` SET status = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // removes hold on student, marks all charges as paid
    // returns num of rows changed
    public int liftAllHolds(int userId) {
        String sql = "UPDATE charge "
                   + "SET    status = 'paid' "
                   + "WHERE  user_id = ? "
                   + "  AND  status = 'overdue'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // place hold by marking recent payment as overdue
    // return true if a row is changed
    public boolean placeHold(int userId) {
        String sql = "UPDATE charge "
                   + "SET    status = 'overdue' "
                   + "WHERE  charge_id = (SELECT charge_id FROM ( "
                   + "                       SELECT charge_id FROM charge "
                   + "                       WHERE user_id = ? AND status = 'paid' "
                   + "                       ORDER BY posted_at DESC LIMIT 1 "
                   + "                   ) AS x)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static class UserWithHolds {
        public User user;
        public int holdCount;

        public User getUser() { return user; }
        public int getHoldCount() { return holdCount; }
    }
}
