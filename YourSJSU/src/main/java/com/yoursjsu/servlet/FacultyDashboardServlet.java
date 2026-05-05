package com.yoursjsu.servlet;
import com.yoursjsu.dao.FacultyDAO;
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

@WebServlet("/faculty-dashboard")
public class FacultyDashboardServlet extends HttpServlet {
    private FacultyDAO facultyDAO = new FacultyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = RoleUtil.requireFaculty(request, response);
        if (user == null) {
            return;
        }
        String[] facultyInfo = facultyDAO.getFacultyInfo(user.getUserId());
        List<Course> teachingSections = facultyDAO.getTeachingSections(user.getUserId());

        request.setAttribute("staffTitle", facultyInfo[0]);
        request.setAttribute("departmentName", facultyInfo[1]);
        request.setAttribute("teachingSections", teachingSections);

        request.getRequestDispatcher("/faculty-dashboard.jsp").forward(request, response);
    }
}
