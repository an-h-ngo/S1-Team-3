package com.yoursjsu.model;

public class Course {

	private int sectionId;
	private String courseTitle;
	private String status;
	private String termName;
	private String meetingDays;
	private String startTime;
	private String endTime;
	private String location;
	private String instructorName;
	
	public Course(String courseTitle, String status) {
		this.courseTitle = courseTitle;
		this.status = status;
	}

    public Course(int sectionId, String courseTitle, String status, String termName,
                  String meetingDays, String startTime, String endTime, String location) {
        this(sectionId, courseTitle, status, termName, meetingDays, startTime, endTime, location, null);
    }

    public Course(int sectionId, String courseTitle, String status, String termName,
                  String meetingDays, String startTime, String endTime, String location,
                  String instructorName) {
        this.sectionId = sectionId;
        this.courseTitle = courseTitle;
        this.status = status;
        this.termName = termName;
        this.meetingDays = meetingDays;
        this.startTime = startTime;
        this.endTime = endTime;
        this.location = location;
        this.instructorName = instructorName;
    }
	
	public int getSectionId() { return this.sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }

	public String getCourseTitle() { return this.courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }
    
    public String getStatus() { return this.status; }
    public void setStatus(String status) { this.status = status; }

    public String getTermName() { return this.termName; }
    public void setTermName(String termName) { this.termName = termName; }

    public String getMeetingDays() { return this.meetingDays; }
    public void setMeetingDays(String meetingDays) { this.meetingDays = meetingDays; }

    public String getStartTime() { return this.startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return this.endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getLocation() { return this.location; }
    public void setLocation(String location) { this.location = location; }

    public String getInstructorName() { return this.instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
}
