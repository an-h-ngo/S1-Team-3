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
		String sql = "select E.user_id, E.status, C.course_title\r\n"
				+ "from yoursjsu.student_has_enrollment E\r\n"
				+ "JOIN yoursjsu.user U ON E.user_id = U.user_id\r\n"
				+ "JOIN yoursjsu.section S ON E.section_id = S.section_id\r\n"
				+ "JOIN yoursjsu.course C ON S.course_id = C.course_id\r\n"
				+ "WHERE U.user_id = ?;\r\n";
		try (Connection conn = DatabaseConnection.getConnection();
	        PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	
	        try (ResultSet rs = stmt.executeQuery()) {  
	            while (rs.next()) {
	            	Course course = new Course(rs.getString("course_title"), rs.getString("status"));
	                courses.add(course);
	            }
	        }
		} catch (SQLException e) {
            e.printStackTrace();
        }
	    return courses;
	}
}
