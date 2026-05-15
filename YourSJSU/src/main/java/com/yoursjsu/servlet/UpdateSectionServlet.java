package com.yoursjsu.servlet;
import com.yoursjsu.dao.SectionDAO;
import com.yoursjsu.model.SectionResult;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/update-section")
public class UpdateSectionServlet extends HttpServlet {

    private SectionDAO sectionDAO = new SectionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sectionIdStr = request.getParameter("sectionId");
        
        if (sectionIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/manage-sections");
            return;
        }

        int sectionId = Integer.parseInt(sectionIdStr);
        SectionResult section = sectionDAO.findById(sectionId);

        if (section == null) {
            response.sendRedirect(request.getContextPath() + "/manage-sections");
            return;
        }

   
        request.setAttribute("section", section);
        request.setAttribute("courses", sectionDAO.getAllCourses());
        request.setAttribute("terms", sectionDAO.getAllTerms());
        request.setAttribute("faculty", sectionDAO.getAllFaculty());
        request.getRequestDispatcher("/update-section.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int sectionId        = Integer.parseInt(request.getParameter("sectionId"));
            int courseId         = Integer.parseInt(request.getParameter("courseId"));
            int termId           = Integer.parseInt(request.getParameter("termId"));
            int facultyId        = Integer.parseInt(request.getParameter("facultyId"));
            String meetingDays   = request.getParameter("meetingDays");

            String startTime 	 = concatTime(request, "startHour", "startMinute", "startAmPm");;
            String endTime 		 = concatTime(request, "endHour", "endMinute", "endAmPm");
            
            String location      = request.getParameter("location");
            String modality      = request.getParameter("modality");
            int capacity         = Integer.parseInt(request.getParameter("capacity"));
            int waitlistCapacity = Integer.parseInt(request.getParameter("waitlistCapacity"));

            boolean ok = sectionDAO.updateSection(sectionId, courseId, termId, facultyId,
                    meetingDays, startTime, endTime, location, modality, capacity, waitlistCapacity);

            if (ok) {
                response.sendRedirect(request.getContextPath() + "/manage-sections?result=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/update-section?sectionId=" + sectionId + "&result=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-sections?result=bad-input");
        }
    }
    
    
    private String concatTime(HttpServletRequest request, String hourParameter, String minParameter, String amPmParameter) {
    	int hour = Integer.parseInt(request.getParameter(hourParameter));
        int min  = Integer.parseInt(request.getParameter(minParameter));
        String amPm = request.getParameter(amPmParameter);
        if ("AM".equals(amPm) && hour == 12) hour = 0;
        if ("PM".equals(amPm) && hour != 12) hour += 12;
    	return String.format("%02d:%02d", hour, min);
    }
}

