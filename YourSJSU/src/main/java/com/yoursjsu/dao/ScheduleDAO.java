package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.yoursjsu.model.Course;
import com.yoursjsu.model.User;

public class ScheduleDAO {
	
	public static List<Course> getCourses(int userId){
		
		List<Course> courses = new ArrayList<>();
		String sql = "select E.user_id, E.status, E.section_id, C.course_title, T.term_name, "
				+ "S.meeting_days, S.start_time, S.end_time, S.location\r\n"
				+ "from yoursjsu.student_has_enrollment E\r\n"
				+ "JOIN yoursjsu.user U ON E.user_id = U.user_id\r\n"
				+ "JOIN yoursjsu.section S ON E.section_id = S.section_id\r\n"
				+ "JOIN yoursjsu.course C ON S.course_id = C.course_id\r\n"
				+ "JOIN yoursjsu.term T ON S.term_id = T.term_id\r\n"
				+ "WHERE U.user_id = ?;\r\n";
		try (Connection conn = DatabaseConnection.getConnection();
	        PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	
	        try (ResultSet rs = stmt.executeQuery()) {  
	            while (rs.next()) {
	            	Course course = new Course(rs.getInt("section_id"), rs.getString("course_title"),
	            			rs.getString("status"), rs.getString("term_name"),
	            			rs.getString("meeting_days"), rs.getString("start_time"),
	            			rs.getString("end_time"), rs.getString("location"));
	                courses.add(course);
	            }
	        }
		} catch (SQLException e) {
            e.printStackTrace();
        }
	    return courses;
	}
}
