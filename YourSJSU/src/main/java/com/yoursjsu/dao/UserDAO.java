package com.yoursjsu.dao;
import com.yoursjsu.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findBySjsuIdOrEmail(String identifier) {

        String sql =
            "SELECT u.user_id, u.sjsu_id, u.email, u.first_name, u.last_name, u.status,\n" +
            "(SELECT COUNT(*) FROM student s WHERE s.user_id = u.user_id) AS is_student,\n" + // Check if the user exists as student
            "(SELECT COUNT(*) FROM faculty f WHERE f.user_id = u.user_id) AS is_faculty\n" + // Check if user exists as staff
            "FROM `user` u\n" +
            "WHERE u.sjsu_id = ? OR u.email = ?"; // can login with SJSU ID or email

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, identifier); // compared to both email and SJSU columns
            stmt.setString(2, identifier);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Copy each column from the row into a user object
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setSjsuId(rs.getString("sjsu_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setStatus(rs.getString("status"));
                    // The COUNT subqueries returned 1 if the user exist and 0 if not
                    user.setIsStudent(rs.getInt("is_student") > 0);
                    user.setIsFaculty(rs.getInt("is_faculty") > 0);
                    return user;
                }
            }
        } catch (SQLException e) {
            // return null so the login shows "Invalid credentials" error if there is an exeption
            e.printStackTrace();
        }
        return null;
    }
}
