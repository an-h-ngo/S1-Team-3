package com.yoursjsu.servlet;

import com.yoursjsu.dao.CourseDAO;
import com.yoursjsu.dao.SectionDAO;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        List<String> courses = CourseDAO.getCourses(userId);
        List<String> sections = SectionDAO.getSections(userId);

        request.setAttribute("sections", sections);
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/courses.jsp").forward(request, response);
    }
    
}

