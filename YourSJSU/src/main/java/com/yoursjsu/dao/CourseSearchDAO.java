package com.yoursjsu.dao;
import com.yoursjsu.model.SectionResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseSearchDAO {
    // Returns all the terms in the database in descending order
    public List<String[]> getAllTerms() {
        List<String[]> terms = new ArrayList<>();
        String sql = "SELECT term_id, term_name " +
                "FROM term " +
                "ORDER BY term_id DESC";

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

    public List<SectionResult> searchSections(String keyword, String departmentCode) {
        List<SectionResult> results = new ArrayList<>();

        // The keyword check uses OR so it matches against course title OR course number
        String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, c.units, "
                + "t.term_name, s.meeting_days, s.start_time, s.end_time, "
                + "s.location, s.modality, s.capacity "

                + "FROM section s "

                + "JOIN course c ON s.course_id = c.course_id "
                + "JOIN department d ON c.department_id = d.department_id "
                + "JOIN term t ON s.term_id = t.term_id "

                + "WHERE (c.course_title LIKE ? OR c.course_number LIKE ?) "
                + "  AND d.department_code LIKE ? "

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

            // Plug user inputs into SQL ? marks, once for course title search and another for course number search
            stmt.setString(1, keywordParam);
            stmt.setString(2, keywordParam);
            stmt.setString(3, deptParam);

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
}
