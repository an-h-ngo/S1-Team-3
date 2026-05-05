package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.yoursjsu.model.User;

public class CourseDAO {
	
	public static List<String> getCourses(int userId){
		
		List<String> courses = new ArrayList<>();
		String sql = "SELECT user_id, course_title FROM course NATURAL JOIN user WHERE user_id = ?";
		try (Connection conn = DatabaseConnection.getConnection();
	        PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	
	        try (ResultSet rs = stmt.executeQuery()) {  
	            while (rs.next()) {
	                courses.add(rs.getString("course_title"));
	            }
	        }
		} catch (SQLException e) {
            e.printStackTrace();
        }
	    return courses;
	}
}
