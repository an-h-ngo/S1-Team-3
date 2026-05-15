package com.yoursjsu.dao;
import com.yoursjsu.model.SectionResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseSearchDAO {
    // Returns all terms newest-first by academic term name, not insertion order.
    public List<String[]> getAllTerms() {
        List<String[]> terms = new ArrayList<>();
        String sql = "SELECT term_id, term_name " +
                "FROM term " +
                "ORDER BY CAST(SUBSTRING_INDEX(term_name, ' ', -1) AS UNSIGNED) DESC, " +
                "CASE SUBSTRING_INDEX(term_name, ' ', 1) " +
                "WHEN 'Fall' THEN 3 " +
                "WHEN 'Summer' THEN 2 " +
                "WHEN 'Spring' THEN 1 " +
                "ELSE 0 END DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                terms.add(new String[] {
                        String.valueOf(rs.getInt("term_id")),
                        rs.getString("term_name")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public SectionResult getSectionById(int sectionId) {
        String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, "
                + "t.term_name, CONCAT(u.first_name, ' ', u.last_name) AS instructor_name, "
                + "s.meeting_days, s.start_time, s.end_time, "
                + "s.location, s.modality, s.capacity, s.waitlist_capacity, "
                + "COALESCE(e.enrolled_count, 0) AS enrolled_count, "
                + "COALESCE(w.waitlist_count, 0) AS waitlist_count "
 
                + "FROM section s "
 
                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN department d ON c.department_id = d.department_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "JOIN `user` u ON s.faculty_id = u.user_id "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS enrolled_count "
                + "           FROM student_has_enrollment WHERE status = 'enrolled' GROUP BY section_id) e "
                + "ON s.section_id = e.section_id "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS waitlist_count "
                + "           FROM student_waitlist WHERE status = 'waiting' GROUP BY section_id) w "
                + "ON s.section_id = w.section_id "
 
                + "WHERE s.section_id = ?";
 
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
 
            stmt.setInt(1, sectionId);
 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
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
                    r.setWaitlistCapacity(rs.getInt("waitlist_capacity"));
                    r.setEnrolledCount(rs.getInt("enrolled_count"));
                    r.setWaitlistCount(rs.getInt("waitlist_count"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String getEnrollmentStatus(int userId, int sectionId) {
        
        String enrolledSql =
                "SELECT 1 FROM student_has_enrollment "
                + "WHERE user_id = ? AND section_id = ? AND status = 'enrolled' "
                + "LIMIT 1";
 
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(enrolledSql)) {
 
            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);
 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return "Enrolled";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
 
        
        String waitlistSql =
                "SELECT 1 FROM student_waitlist "
                + "WHERE user_id = ? AND section_id = ? AND status = 'waiting' "
                + "LIMIT 1";
 
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(waitlistSql)) {
 
            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);
 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return "Waitlisted";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
 
        return "Not Enrolled";
    }
    
    public List<SectionResult> searchSections(String keyword, String departmentCode,
                                              String courseNumber, String instructorName,
                                              String termId) {
        List<SectionResult> results = new ArrayList<>();

        // The keyword check uses OR so it matches against course title OR course number
        String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, "
                + "t.term_name, CONCAT(u.first_name, ' ', u.last_name) AS instructor_name, "
                + "s.meeting_days, s.start_time, s.end_time, "
                + "s.location, s.modality, s.capacity, s.waitlist_capacity, "
                + "COALESCE(e.enrolled_count, 0) AS enrolled_count, "
                + "COALESCE(w.waitlist_count, 0) AS waitlist_count "

                + "FROM section s "

                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN department d ON c.department_id = d.department_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "JOIN `user` u ON s.faculty_id = u.user_id "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS enrolled_count "
                + "FROM student_has_enrollment WHERE status = 'enrolled' GROUP BY section_id) e "
                + "ON s.section_id = e.section_id "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS waitlist_count "
                + "FROM student_waitlist WHERE status = 'waiting' GROUP BY section_id) w "
                + "ON s.section_id = w.section_id "

                + "WHERE (c.course_title LIKE ? OR c.course_number LIKE ?) "
                + "  AND d.department_code LIKE ? "
                + "  AND c.course_number LIKE ? "
                + "  AND CONCAT(u.first_name, ' ', u.last_name) LIKE ? "
                + "  AND (? IS NULL OR s.term_id = ?) "

                + "ORDER BY d.department_code, c.course_number";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Blank input matches everything
            String keywordParam;
            if (keyword == null || keyword.trim().isEmpty()) {
                keywordParam = "%";
            } else {
                keywordParam = "%" + keyword.trim() + "%";
            }

            String deptParam;
            if (departmentCode == null || departmentCode.trim().isEmpty()) {
                deptParam = "%";
            } else {
                deptParam = departmentCode.trim().toUpperCase();
            }

            String courseNumberParam;
            if (courseNumber == null || courseNumber.trim().isEmpty()) {
                courseNumberParam = "%";
            } else {
                courseNumberParam = "%" + courseNumber.trim() + "%";
            }

            String instructorParam;
            if (instructorName == null || instructorName.trim().isEmpty()) {
                instructorParam = "%";
            } else {
                instructorParam = "%" + instructorName.trim() + "%";
            }

            Integer parsedTermId = null;
            if (termId != null && !termId.trim().isEmpty()) {
                try {
                    parsedTermId = Integer.parseInt(termId.trim());
                } catch (NumberFormatException e) {
                    parsedTermId = -1;
                }
            }

            // Plug user inputs into SQL ? marks, once for course title search and another for course number search
            stmt.setString(1, keywordParam);
            stmt.setString(2, keywordParam);
            stmt.setString(3, deptParam);
            stmt.setString(4, courseNumberParam);
            stmt.setString(5, instructorParam);
            if (parsedTermId == null) {
                stmt.setNull(6, java.sql.Types.INTEGER);
                stmt.setNull(7, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(6, parsedTermId);
                stmt.setInt(7, parsedTermId);
            }

            // run the query and copy each row into SectionResult
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
                    r.setWaitlistCapacity(rs.getInt("waitlist_capacity"));
                    r.setEnrolledCount(rs.getInt("enrolled_count"));
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
