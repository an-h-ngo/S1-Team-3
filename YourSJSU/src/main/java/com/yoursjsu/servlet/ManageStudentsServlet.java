package com.yoursjsu.servlet;
import com.yoursjsu.dao.StudentAdminDAO;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

// faculty page, for placing financial holds and granting or denying access to a students account
@WebServlet("/manage-students")
public class ManageStudentsServlet extends HttpServlet {

    private StudentAdminDAO dao = new StudentAdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Login + faculty check
        if (!isFacultyLoggedIn(request, response)) return;

        // Pull the full list of users with their overdue-charge counts
        List<StudentAdminDAO.UserWithHolds> rows = dao.getAllUsersWithHoldCounts();
        request.setAttribute("rows", rows);

        request.getRequestDispatcher("/manage-students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isFacultyLoggedIn(request, response)) return;

        // reads action parameter and the targeted user
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-students");
            return;
        }

        // use the right DAO method
        String resultParam;
        if ("activate".equals(action)) {
            resultParam = dao.setUserStatus(userId, "active") ? "activated" : "fail";
        } else if ("deactivate".equals(action)) {
            resultParam = dao.setUserStatus(userId, "inactive") ? "deactivated" : "fail";
        } else if ("lift-holds".equals(action)) {
            int n = dao.liftAllHolds(userId);
            resultParam = (n > 0 ? "lifted-" + n : "no-holds");
        } else if ("place-hold".equals(action)) {
            resultParam = dao.placeHold(userId) ? "placed" : "fail";
        } else {
            resultParam = "unknown";
        }

        response.sendRedirect(request.getContextPath() + "/manage-students?result=" + resultParam);
    }

    // returns true if the request is from a logged-in faculty user.
    // otherwise redireect to login and return false
    private boolean isFacultyLoggedIn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return false;
        }
        return true;
    }
}
