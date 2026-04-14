package src.main.java.com.yoursjsu.dao;
import com.yoursjsu.model.SectionResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseSearchDAO {

    public List<String[]> getAllTerms() {
        List<String[]> terms = new ArrayList<>();
        String sql = "SELECT term_id, term_name" +
                "FROM term" +
                "ORDER BY term_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                terms.add(new String[]{
                    String.valueOf(rs.getInt("term_id")),
                    rs.getString("term_name")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public List<SectionResult> searchSections(String keyword, String departmentCode,
            String courseNumber, String instructorName, Integer termId) {

        List<SectionResult> results = new ArrayList<>();

        // Checks for at least one filter
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasDept = departmentCode != null && !departmentCode.trim().isEmpty();
        boolean hasCourseNum = courseNumber != null && !courseNumber.trim().isEmpty();
        boolean hasInstructor = instructorName != null && !instructorName.trim().isEmpty();
        boolean hasTerm = termId != null;

        if (!hasKeyword && !hasDept && !hasCourseNum && !hasInstructor && !hasTerm) {
            return results;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, ");
        sql.append("t.term_name, CONCAT(u.first_name, ' ', u.last_name) AS instructor_name, ");
        sql.append("s.meeting_days, s.start_time, s.end_time, s.location, s.modality, ");
        sql.append("s.capacity, s.waitlist_capacity, ");
        sql.append("COALESCE(e.enrolled_count, 0) AS enrolled_count, ");
        sql.append("COALESCE(w.waitlist_count, 0) AS waitlist_count ");
        sql.append("FROM section s ");
        sql.append("JOIN course c ON s.course_id = c.course_id ");
        sql.append("JOIN department d ON c.department_id = d.department_id ");
        sql.append("JOIN term t ON s.term_id = t.term_id ");
        sql.append("LEFT JOIN `user` u ON s.faculty_id = u.user_id ");
        sql.append("LEFT JOIN (");
        sql.append("  SELECT section_id, COUNT(*) AS enrolled_count ");
        sql.append("  FROM student_has_enrollment WHERE status = 'enrolled' ");
        sql.append("  GROUP BY section_id");
        sql.append(") e ON s.section_id = e.section_id ");
        sql.append("LEFT JOIN (");
        sql.append("  SELECT section_id, COUNT(*) AS waitlist_count ");
        sql.append("  FROM student_waitlist WHERE status = 'waiting' ");
        sql.append("  GROUP BY section_id");
        sql.append(") w ON s.section_id = w.section_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (hasKeyword) {
            sql.append("AND c.course_title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (hasDept) {
            sql.append("AND d.department_code = ? ");
            params.add(departmentCode.trim().toUpperCase());
        }
        if (hasCourseNum) {
            sql.append("AND c.course_number = ? ");
            params.add(courseNumber.trim());
        }
        if (hasInstructor) {
            sql.append("AND CONCAT(u.first_name, ' ', u.last_name) LIKE ? ");
            params.add("%" + instructorName.trim() + "%");
        }
        if (hasTerm) {
            sql.append("AND s.term_id = ? ");
            params.add(termId);
        }

        sql.append("ORDER BY d.department_code, c.course_number, s.section_id");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else {
                    stmt.setString(i + 1, (String) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SectionResult r = new SectionResult();
                    r.setSectionId(rs.getInt("section_id"));
                    r.setDepartmentCode(rs.getString("department_code"));
                    r.setCourseNumber(rs.getString("course_number"));
                    r.setCourseTitle(rs.getString("course_title"));
                    r.setUnits(rs.getInt("units"));
                    r.setTermName(rs.getString("term_name"));
                    r.setInstructorName(rs.getString("instructor_name"));
                    r.setMeetingDays(rs.getString("meeting_days"));
                    r.setStartTime(rs.getString("start_time"));
                    r.setEndTime(rs.getString("end_time"));
                    r.setLocation(rs.getString("location"));
                    r.setModality(rs.getString("modality"));
                    r.setCapacity(rs.getInt("capacity"));
                    r.setEnrolledCount(rs.getInt("enrolled_count"));
                    r.setWaitlistCapacity(rs.getInt("waitlist_capacity"));
                    r.setWaitlistCount(rs.getInt("waitlist_count"));
                    results.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
}