package com.yoursjsu.dao;

import com.yoursjsu.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public User findBySjsuIdOrEmail(String identifier) {
        String sql = "SELECT u.user_id, u.sjsu_id, u.email, u.first_name, u.last_name, u.status, "
                   + "(SELECT COUNT(*) FROM student s WHERE s.user_id = u.user_id) AS is_student, "
                   + "(SELECT COUNT(*) FROM faculty f WHERE f.user_id = u.user_id) AS is_faculty "
                   + "FROM `user` u WHERE u.sjsu_id = ? OR u.email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, identifier);
            stmt.setString(2, identifier);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setSjsuId(rs.getString("sjsu_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setStatus(rs.getString("status"));
                    user.setIsStudent(rs.getInt("is_student") > 0);
                    user.setIsFaculty(rs.getInt("is_faculty") > 0);
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}