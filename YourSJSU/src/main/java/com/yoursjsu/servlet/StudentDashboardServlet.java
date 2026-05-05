package com.yoursjsu.servlet;
import com.yoursjsu.dao.DashboardDAO;
import com.yoursjsu.model.Course;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/student-dashboard")
public class StudentDashboardServlet extends HttpServlet {
    private DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        String[] studentStatus = dashboardDAO.getStudentStatus(user.getUserId());
        List<Course> enrollments = dashboardDAO.getCurrentEnrollments(user.getUserId());
        List<Course> waitlists = dashboardDAO.getActiveWaitlists(user.getUserId());

        request.setAttribute("holdStatus", studentStatus[0]);
        request.setAttribute("registrationStatus", studentStatus[1]);
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("waitlists", waitlists);

        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }
}
