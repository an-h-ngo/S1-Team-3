package src.main.java.com.yoursjsu.model;

public class SectionResult {
    private int sectionId;
    private String departmentCode;
    private String courseNumber;
    private String courseTitle;
    private int units;
    private String termName;
    private String instructorName;
    private String meetingDays;
    private String startTime;
    private String endTime;
    private String location;
    private String modality;
    private int capacity;
    private int enrolledCount;
    private int waitlistCapacity;
    private int waitlistCount;

    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }

    public String getDepartmentCode() { return departmentCode; }
    public void setDepartmentCode(String departmentCode) { this.departmentCode = departmentCode; }

    public String getCourseNumber() { return courseNumber; }
    public void setCourseNumber(String courseNumber) { this.courseNumber = courseNumber; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }

    public int getUnits() { return units; }
    public void setUnits(int units) { this.units = units; }

    public String getTermName() { return termName; }
    public void setTermName(String termName) { this.termName = termName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public String getMeetingDays() { return meetingDays; }
    public void setMeetingDays(String meetingDays) { this.meetingDays = meetingDays; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(int enrolledCount) { this.enrolledCount = enrolledCount; }

    public int getWaitlistCapacity() { return waitlistCapacity; }
    public void setWaitlistCapacity(int waitlistCapacity) { this.waitlistCapacity = waitlistCapacity; }

    public int getWaitlistCount() { return waitlistCount; }
    public void setWaitlistCount(int waitlistCount) { this.waitlistCount = waitlistCount; }
}
