package com.yoursjsu.dao;

import com.yoursjsu.model.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {
    public String[] getFacultyInfo(int userId) {
        String sql = "SELECT f.staff_title, d.department_name "
                + "FROM faculty f "
                + "LEFT JOIN department_faculty df ON f.user_id = df.user_id "
                + "LEFT JOIN department d ON df.department_id = d.department_id "
                + "WHERE f.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new String[]{rs.getString("staff_title"), rs.getString("department_name")};
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new String[]{"unknown", "unknown"};
    }

    public List<Course> getTeachingSections(int userId) {
        List<Course> sections = new ArrayList<>();
        String sql = "SELECT s.section_id, c.course_title, t.term_name, s.meeting_days, "
                + "s.start_time, s.end_time, s.location, "
                + "COALESCE(e.enrolled_count, 0) AS enrolled_count "
                + "FROM section s "
                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS enrolled_count "
                + "FROM student_has_enrollment WHERE status = 'enrolled' GROUP BY section_id) e "
                + "ON s.section_id = e.section_id "
                + "WHERE s.faculty_id = ? "
                + "ORDER BY t.term_id DESC, c.course_title";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(rs.getInt("section_id"), rs.getString("course_title"),
                            rs.getString("enrolled_count") + " enrolled", rs.getString("term_name"),
                            rs.getString("meeting_days"), rs.getString("start_time"),
                            rs.getString("end_time"), rs.getString("location"));
                    sections.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sections;
    }
}
