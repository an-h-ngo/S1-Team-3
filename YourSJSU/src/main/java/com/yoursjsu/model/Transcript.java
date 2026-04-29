package YourSJSU.src.main.java.com.yoursjsu.model;

import java.util.ArrayList;
import java.util.List;

public class Transcript {

	private int userId;
	private List<ClassStatus> classStatusList = new ArrayList<ClassStatus>();
	
	public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public List<ClassStatus> getClassStatusList() { return this.classStatusList; }
    public void setClassStatusList(List<ClassStatus> classStatusList) { this.classStatusList = classStatusList; }
    
    public void addClassStatus(ClassStatus classStatus) {
    	this.classStatusList.add(classStatus);
    }
}
