package com.yoursjsu.dao;

import com.yoursjsu.model.Course;
import com.yoursjsu.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradeCompletionDAO {
    public List<Course> getFacultySections(int facultyId) {
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
                + "ORDER BY CAST(SUBSTRING_INDEX(t.term_name, ' ', -1) AS UNSIGNED) DESC, "
                + "CASE SUBSTRING_INDEX(t.term_name, ' ', 1) "
                + "WHEN 'Fall' THEN 3 WHEN 'Summer' THEN 2 WHEN 'Spring' THEN 1 ELSE 0 END DESC, "
                + "c.course_title";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, facultyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sections.add(new Course(rs.getInt("section_id"), rs.getString("course_title"),
                            rs.getString("enrolled_count") + " enrolled", rs.getString("term_name"),
                            rs.getString("meeting_days"), rs.getString("start_time"),
                            rs.getString("end_time"), rs.getString("location")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sections;
    }

    public List<User> getEnrolledStudents(int facultyId, int sectionId) {
        List<User> students = new ArrayList<>();
        String sql = "SELECT u.user_id, u.sjsu_id, u.email, u.first_name, u.last_name, u.status "
                + "FROM student_has_enrollment e "
                + "JOIN section s ON e.section_id = s.section_id "
                + "JOIN `user` u ON e.user_id = u.user_id "
                + "WHERE s.faculty_id = ? AND e.section_id = ? AND e.status = 'enrolled' "
                + "ORDER BY u.last_name, u.first_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, facultyId);
            stmt.setInt(2, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setSjsuId(rs.getString("sjsu_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setStatus(rs.getString("status"));
                    students.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean completeEnrollment(int facultyId, int sectionId, int studentId, String grade) {
        if (!isValidGrade(grade)) {
            return false;
        }
        String sql = "UPDATE student_has_enrollment e "
                + "JOIN section s ON e.section_id = s.section_id "
                + "SET e.status = 'completed', e.letter_grade = ? "
                + "WHERE s.faculty_id = ? AND e.section_id = ? AND e.user_id = ? AND e.status = 'enrolled'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, grade);
            stmt.setInt(2, facultyId);
            stmt.setInt(3, sectionId);
            stmt.setInt(4, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isValidGrade(String grade) {
        if (grade == null) return false;
        switch (grade) {
            case "A+": case "A": case "A-":
            case "B+": case "B": case "B-":
            case "C+": case "C": case "C-":
            case "D+": case "D": case "D-":
            case "F": case "W": case "I": case "IP":
                return true;
            default:
                return false;
        }
    }
}
