package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yoursjsu.model.SectionResult;

public class SectionDAO {

	public static List<String> getSections(int userId){
		
		List<String> sections = new ArrayList<>();
		String sql = "SELECT user_id, course_title FROM section S\r\n"
				+ "JOIN course C ON S.course_id = C.course_id\r\n"
				+ "JOIN student_has_enrollment SHE ON S.section_id = SHE.section_id\r\n"
				+ "WHERE term_id = 1 AND user_id = ?";
		try (Connection conn = DatabaseConnection.getConnection();
	        PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	
	        try (ResultSet rs = stmt.executeQuery()) {  
	            while (rs.next()) {
	                sections.add(rs.getString("course_title"));
	            }
	        }
		} catch (SQLException e) {
            e.printStackTrace();
        }
	    return sections;
	}
	
	public SectionResult findById(int sectionId) {
	    String sql = "SELECT s.section_id, d.department_code, c.course_number, c.course_title, \r\n"
	    		+ "t.term_name, s.meeting_days, s.start_time, s.end_time, s.location, s.modality, \r\n"
	    		+ "s.capacity, s.waitlist_capacity, s.course_id, s.term_id, s.faculty_id \r\n"
	    		+ "FROM section s\r\n"
	    		+ "JOIN course c ON s.course_id = c.course_id \r\n"
	    		+ "JOIN term t ON s.term_id = t.term_id \r\n"
	    		+ "JOIN department d ON c.department_id = d.department_id\r\n"
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
	                r.setTermName(rs.getString("term_name"));
	                r.setMeetingDays(rs.getString("meeting_days"));
	                r.setStartTime(rs.getString("start_time"));
	                r.setEndTime(rs.getString("end_time"));
	                r.setLocation(rs.getString("location"));
	                r.setModality(rs.getString("modality"));
	                r.setCapacity(rs.getInt("capacity"));
	                r.setWaitlistCapacity(rs.getInt("waitlist_capacity"));
	                r.setCourseId(rs.getInt("course_id"));
	                r.setTermId(rs.getInt("term_id"));
	                r.setFacultyId(rs.getInt("faculty_id"));
	                
	                System.out.print(r.getSectionId());
	                return r;
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return null;
	}

	public boolean updateSection(int sectionId, int courseId, int termId, int facultyId,
	        String meetingDays, String startTime, String endTime,
	        String location, String modality, int capacity, int waitlistCapacity) {
	    String sql = "UPDATE section SET course_id=?, term_id=?, faculty_id=?, meeting_days=?, "
	               + "start_time=?, end_time=?, location=?, modality=?, capacity=?, waitlist_capacity=? "
	               + "WHERE section_id=?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, courseId);
	        stmt.setInt(2, termId);
	        stmt.setInt(3, facultyId);
	        stmt.setString(4, meetingDays);
	        stmt.setString(5, startTime);
	        stmt.setString(6, endTime);
	        stmt.setString(7, location);
	        stmt.setString(8, modality);
	        stmt.setInt(9, capacity);
	        stmt.setInt(10, waitlistCapacity);
	        stmt.setInt(11, sectionId);
	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public List<String[]> getAllCourses() {
	    List<String[]> courses = new ArrayList<>();
	    String sql = "SELECT C.course_id, CONCAT(D.department_name, ' ', C.course_number, ' - ', C.course_title) \r\n"
	    		+ "FROM course C, department D\r\n"
	    		+ "ORDER BY D.department_code, C.course_number";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {
	        while (rs.next()) {
	            courses.add(new String[]{ rs.getString(1), rs.getString(2) });
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return courses;
	}

	public List<String[]> getAllTerms() {
	    List<String[]> terms = new ArrayList<>();
	    String sql = "SELECT term_id, term_name FROM term ORDER BY term_id DESC";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {
	        while (rs.next()) {
	            terms.add(new String[]{ rs.getString(1), rs.getString(2) });
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return terms;
	}

	public List<String[]> getAllFaculty() {
	    List<String[]> faculty = new ArrayList<>();
	    String sql = "SELECT f.user_id, CONCAT(u.first_name, ' ', u.last_name) \r\n"
	    		+ "FROM faculty f JOIN user u ON f.user_id = u.user_id \r\n"
	    		+ "ORDER BY u.last_name";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {
	        while (rs.next()) {
	            faculty.add(new String[]{ rs.getString(1), rs.getString(2) });
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return faculty;
	}
}
