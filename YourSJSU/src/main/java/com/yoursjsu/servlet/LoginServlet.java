package com.yoursjsu.servlet;
import com.yoursjsu.dao.CredentialDAO;
import com.yoursjsu.dao.UserDAO;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private CredentialDAO credentialDAO = new CredentialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Skip login page if logged in already
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, request, response);
            return;
        }
        // If they just changed their password, show a success message
        String success = request.getParameter("success");
        if ("passwordChanged".equals(success)) {
            request.setAttribute("success", "Password changed successfully. Please log in with your new password.");
        }
        // Otherwise, show the login form
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the user inputs
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        // Check if both fields are filled in
        if (identifier == null || identifier.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if user exists
        identifier = identifier.trim();
        User user = userDAO.findBySjsuIdOrEmail(identifier);
        if (user == null) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if account is active
        if (!"active".equals(user.getStatus())) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if password matches database column password
        String hash = credentialDAO.getPasswordHash(user.getUserId());
        if (hash == null || !hash.equals(password)) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // If steps are successful, log them in
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(60 * 60); // log them out after 1 hour of inactivity

        // OSend to dashboard
        redirectByRole(user, request, response);
    }

    private void redirectByRole(User user, HttpServletRequest request,
                                HttpServletResponse response) throws IOException {
        if (user.getIsStudent()) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard"); // send to student dashboard if user is a student
        } else if (user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard"); // send to staff dashboard if user is a faculty
        } else {
            // Send to login if neither student or faculty
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
