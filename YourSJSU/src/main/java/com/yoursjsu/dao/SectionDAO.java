package YourSJSU.src.main.java.com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
}
