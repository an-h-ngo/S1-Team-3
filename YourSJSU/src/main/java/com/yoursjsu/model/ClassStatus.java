package com.yoursjsu.model;

public class ClassStatus {
	private String status;
	private String courseTitle;
	private int units;
	private String letterGrade;
	private int term_id;
	private String termName;
	
	public ClassStatus(String status, String courseTitle, int units, String letterGrade, int term_id) {
		this.status = status;
		this.courseTitle = courseTitle;
		this.units = units;
		this.letterGrade = letterGrade;
		this.term_id = term_id;
	}

    public ClassStatus(String status, String courseTitle, int units, String letterGrade, int term_id, String termName) {
        this(status, courseTitle, units, letterGrade, term_id);
        this.termName = termName;
    }
	
	public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }
    
    public int getUnits() { return units; }
    public void setUnits(int units) { this.units = units; }
    
    public String getLetterGrade() { return letterGrade; }
    public void setLetterGrade(String letterGrade) { this.letterGrade = letterGrade; }
    
    public int getTermId() { return this.term_id; }
    public void setTermId(int term_id) { this.term_id = term_id; }

    public String getTermName() { return termName; }
    public void setTermName(String termName) { this.termName = termName; }
}
