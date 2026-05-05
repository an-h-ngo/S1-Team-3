package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yoursjsu.model.ClassStatus;
import com.yoursjsu.model.Transcript;

public class TranscriptDAO {
	public static Transcript getSections(int userId){
		
		Transcript transcript = new Transcript();
		String sql = "select e.user_id, e.status, c.course_title, c.units, e.letter_grade, s.term_id, t.term_name\r\n"
				+ "FROM yoursjsu.student_has_enrollment e\r\n"
				+ "JOIN yoursjsu.section s ON e.section_id = s.section_id\r\n"
				+ "JOIN yoursjsu.course c ON s.course_id = c.course_id\r\n"
				+ "JOIN yoursjsu.term t ON s.term_id = t.term_id\r\n"
				+ "WHERE e.user_id = ? AND e.status = 'completed'";
		try (Connection conn = DatabaseConnection.getConnection();
	        PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	
	        try (ResultSet rs = stmt.executeQuery()) { 
	        	transcript.setUserId(userId);
	            while (rs.next()) {
	            	ClassStatus classStatus = new ClassStatus(rs.getString("status"), rs.getString("course_title"), 
	                		rs.getInt("units"), rs.getString("letter_grade"), rs.getInt("term_id"), rs.getString("term_name"));
	                transcript.addClassStatus(classStatus);
	            }
	            
	        }
		} catch (SQLException e) {
            e.printStackTrace();
        }
	    return transcript;
	}
}
