package com.yoursjsu.servlet;
import com.yoursjsu.dao.EnrollmentDAO;
import com.yoursjsu.model.SectionResult;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/drop-course")
public class DropCourseServlet extends HttpServlet {

    private EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // userh as to be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Pull the list of currently enrolled sections
        List<SectionResult> enrolled = enrollmentDAO.getEnrolledSections(user.getUserId());
        request.setAttribute("enrolled", enrolled);

        request.getRequestDispatcher("/drop-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // check for log in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Parse the section ID the student wants to drop
        String sectionIdStr = request.getParameter("sectionId");
        if (sectionIdStr == null || sectionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/drop-course");
            return;
        }

        int sectionId;
        try {
            sectionId = Integer.parseInt(sectionIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/drop-course");
            return;
        }

        // Try to drop the course. The DAO's UPDATE only succeeds if the user if enrolled in that setion
        boolean dropped = enrollmentDAO.dropCourse(user.getUserId(), sectionId);

        // dropped = 1 = success
        // dropped = 0 = nothing changed
        response.sendRedirect(request.getContextPath() + "/drop-course?dropped=" + (dropped ? "1" : "0"));
    }
}
