package com.yoursjsu.servlet;

import com.yoursjsu.dao.CourseDAO;
import com.yoursjsu.dao.ScheduleDAO;
import com.yoursjsu.dao.SectionDAO;
import com.yoursjsu.model.Course;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/schedule")
public class ScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        int userId = user.getUserId();
        List<Course> courses = ScheduleDAO.getCourses(userId);
        List<String> sections = SectionDAO.getSections(userId);

        request.setAttribute("sections", sections);
        request.setAttribute("courses", courses);
        request.setAttribute("success", request.getParameter("success"));
        request.setAttribute("error", request.getParameter("error"));
        request.getRequestDispatcher("/schedule.jsp").forward(request, response);
    }
    
}
