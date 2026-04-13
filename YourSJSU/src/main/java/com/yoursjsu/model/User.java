package com.yoursjsu.model;

public class User {
    private int userId;
    private String sjsuId;
    private String email;
    private String firstName;
    private String lastName;
    private String status;
    private boolean isStudent;
    private boolean isFaculty;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSjsuId() { return sjsuId; }
    public void setSjsuId(String sjsuId) { this.sjsuId = sjsuId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean getIsStudent() { return isStudent; }
    public void setIsStudent(boolean student) { isStudent = student; }

    public boolean getIsFaculty() { return isFaculty; }
    public void setIsFaculty(boolean faculty) { isFaculty = faculty; }
}