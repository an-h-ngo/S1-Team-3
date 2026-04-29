package YourSJSU.src.main.java.com.yoursjsu.model;

public class Course {

	private String courseTitle;
	private String status;
	
	public Course(String courseTitle, String status) {
		this.courseTitle = courseTitle;
		this.status = status;
	}
	
	public String getCourseTitle() { return this.courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }
    
    public String getStatus() { return this.status; }
    public void setStatus(String status) { this.status = status; }
}
