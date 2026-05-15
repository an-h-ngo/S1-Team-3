package com.yoursjsu.servlet;

import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.model.SectionResult;
import com.yoursjsu.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/course-information")
public class CourseInfoServlet extends HttpServlet {

    private CourseSearchDAO courseSearchDAO;

    @Override
    public void init() throws ServletException {
        courseSearchDAO = new CourseSearchDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String sectionIdParam = request.getParameter("sectionId");
        if (sectionIdParam == null || sectionIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return;
        }

        int sectionId;
        try {
            sectionId = Integer.parseInt(sectionIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return;
        }

       
        SectionResult section = courseSearchDAO.getSectionById(sectionId);

        String enrollStatus = courseSearchDAO.getEnrollmentStatus(user.getUserId(), sectionId);
        if (enrollStatus == null || enrollStatus.isBlank()) {
            enrollStatus = "Not Enrolled";
        }

        request.setAttribute("section",      section);
        request.setAttribute("enrollStatus", enrollStatus);
        request.setAttribute("sectionId",    String.valueOf(sectionId));

        request.getRequestDispatcher("/course-information.jsp")
               .forward(request, response);
    }
}
