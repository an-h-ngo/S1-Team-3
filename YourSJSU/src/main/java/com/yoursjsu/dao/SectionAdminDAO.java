package com.yoursjsu.dao;
import com.yoursjsu.model.SectionResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class SectionAdminDAO {

	// Returns all courses in the catalog
    public List<String[]> getAllCoursesForDropdown() {
        List<String[]> courses = new ArrayList<>();
        String sql = "SELECT c.course_id, d.department_code, c.course_number, c.course_title "
                   + "FROM course c "
                   + "JOIN department d ON c.department_id = d.department_id "
                   + "ORDER BY d.department_code, c.course_number";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String label = rs.getString("department_code") + " "
                             + rs.getString("course_number") + " - "
                             + rs.getString("course_title");
                courses.add(new String[] { String.valueOf(rs.getInt("course_id")), label });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    // Returns every faculty member
    public List<String[]> getAllFacultyForDropdown() {
        List<String[]> faculty = new ArrayList<>();
        String sql = "SELECT u.user_id, u.first_name, u.last_name "
                   + "FROM `user` u "
                   + "JOIN faculty f ON u.user_id = f.user_id "
                   + "ORDER BY u.last_name, u.first_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String label = rs.getString("first_name") + " " + rs.getString("last_name");
                faculty.add(new String[] { String.valueOf(rs.getInt("user_id")), label });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return faculty;
    }

    // Returns all existing sections
    // Joins course/department/term info for the management table
    public List<SectionResult> getAllSections() {
        List<SectionResult> results = new ArrayList<>();
        String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, "
                   + "       t.term_name, s.meeting_days, s.start_time, s.end_time, "
                   + "       s.location, s.modality, s.capacity "
                   + "FROM section s "
                   + "JOIN course c ON s.course_id = c.course_id "
                   + "JOIN department d ON c.department_id = d.department_id "
                   + "JOIN term t ON s.term_id = t.term_id "
                   + "ORDER BY t.term_id DESC, d.department_code, c.course_number";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                SectionResult r = new SectionResult();
                r.setSectionId(rs.getInt("section_id"));
                r.setDepartmentCode(rs.getString("department_code"));
                r.setCourseNumber(rs.getString("course_number"));
                r.setCourseTitle(rs.getString("course_title"));
                r.setUnits(rs.getInt("units"));
                r.setTermName(rs.getString("term_name"));
                r.setMeetingDays(rs.getString("meeting_days"));
                r.setStartTime(rs.getString("start_time"));
                r.setEndTime(rs.getString("end_time"));
                r.setLocation(rs.getString("location"));
                r.setModality(rs.getString("modality"));
                r.setCapacity(rs.getInt("capacity"));
                results.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    // Inserts a new section into the section table
    // facultyID is optional, it will pass null if there is no instructor assigned
    // Returns true if one row is inserted
    public boolean addSection(int courseId, int termId, Integer facultyId,
                              String meetingDays, String startTime, String endTime,
                              String location, String modality,
                              int capacity, int waitlistCapacity) {

        String sql = "INSERT INTO section (course_id, term_id, faculty_id, meeting_days, "
                   + "                     start_time, end_time, location, modality, "
                   + "                     capacity, waitlist_capacity) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            stmt.setInt(2, termId);
            if (facultyId != null) {
                stmt.setInt(3, facultyId);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setString(4, meetingDays);
            stmt.setString(5, startTime);
            stmt.setString(6, endTime);
            stmt.setString(7, location);
            stmt.setString(8, modality);
            stmt.setInt(9, capacity);
            stmt.setInt(10, waitlistCapacity);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // If students are enrolled or waitlisted then the DELETE would fail, so check the count first and refuse if any exist
    // Returns "ok" if section is deleted
    // Returns "has-students" if it refused because enrollments/waitlists are in place
    // Returns "fail" if the section doesn't exist
    public String removeSection(int sectionId) {
        String countSql = "SELECT (SELECT COUNT(*) FROM student_has_enrollment WHERE section_id = ?) "
                        + "     + (SELECT COUNT(*) FROM student_waitlist        WHERE section_id = ?) "
                        + "AS total";
        String deleteSql = "DELETE FROM section WHERE section_id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            // First check if any enrollments or waitlist entries reference this section
            try (PreparedStatement check = conn.prepareStatement(countSql)) {
                check.setInt(1, sectionId);
                check.setInt(2, sectionId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next() && rs.getInt("total") > 0) {
                        return "has-students";
                    }
                }
            }

            // Safe to delete
            try (PreparedStatement del = conn.prepareStatement(deleteSql)) {
                del.setInt(1, sectionId);
                return del.executeUpdate() > 0 ? "ok" : "fail";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "fail";
    }
}
