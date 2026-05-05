package com.yoursjsu.dao;
import com.yoursjsu.model.SectionResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {

    public List<SectionResult> getEnrolledSections(int userId) {
        List<SectionResult> results = new ArrayList<>();

        String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, "
                   + "       t.term_name, s.meeting_days, s.start_time, s.end_time, "
                   + "       s.location, s.modality, s.capacity "
                   + "FROM student_has_enrollment e "
                   + "JOIN section s    ON e.section_id    = s.section_id "
                   + "JOIN course c     ON s.course_id     = c.course_id "
                   + "JOIN department d ON c.department_id = d.department_id "
                   + "JOIN term t       ON s.term_id       = t.term_id "
                   + "WHERE e.user_id = ? "
                   + "  AND e.status = 'enrolled' "
                   + "ORDER BY t.term_id DESC, d.department_code, c.course_number";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    public boolean dropCourse(int userId, int sectionId) {
        String sql = "UPDATE student_has_enrollment "
                   + "SET    status = 'dropped' "
                   + "WHERE  user_id = ? "
                   + "  AND  section_id = ? "
                   + "  AND  status = 'enrolled'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
