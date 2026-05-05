package com.yoursjsu.dao;

import com.yoursjsu.model.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {
    public String[] getStudentStatus(int userId) {
        String sql = "SELECT hold_status, registration_status FROM student WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new String[]{rs.getString("hold_status"), rs.getString("registration_status")};
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new String[]{"unknown", "unknown"};
    }

    public List<Course> getCurrentEnrollments(int userId) {
        String sql = "SELECT e.section_id, c.course_title, e.status, t.term_name, "
                + "s.meeting_days, s.start_time, s.end_time, s.location "
                + "FROM student_has_enrollment e "
                + "JOIN section s ON e.section_id = s.section_id "
                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "WHERE e.user_id = ? AND e.status = 'enrolled' "
                + "ORDER BY t.term_id DESC, c.course_title";
        return getCourses(userId, sql);
    }

    public List<Course> getActiveWaitlists(int userId) {
        String sql = "SELECT w.section_id, c.course_title, w.status, t.term_name, "
                + "s.meeting_days, s.start_time, s.end_time, s.location "
                + "FROM student_waitlist w "
                + "JOIN section s ON w.section_id = s.section_id "
                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "WHERE w.user_id = ? AND w.status = 'waiting' "
                + "ORDER BY w.requested_at";
        return getCourses(userId, sql);
    }

    private List<Course> getCourses(int userId, String sql) {
        List<Course> courses = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(new Course(rs.getInt("section_id"), rs.getString("course_title"),
                            rs.getString("status"), rs.getString("term_name"),
                            rs.getString("meeting_days"), rs.getString("start_time"),
                            rs.getString("end_time"), rs.getString("location")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
}
