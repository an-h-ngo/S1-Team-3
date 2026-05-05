package com.yoursjsu.servlet;
import com.yoursjsu.dao.CredentialDAO;
import com.yoursjsu.dao.SessionDAO;
import com.yoursjsu.dao.UserDAO;
import com.yoursjsu.model.User;
import com.yoursjsu.util.PasswordUtil;
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
    private SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Skip login page if logged in already
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            RoleUtil.redirectByRole(user, request, response);
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

        String storedPassword = credentialDAO.getPasswordHash(user.getUserId());
        if (!PasswordUtil.verifyPassword(password, storedPassword)) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (PasswordUtil.needsBcryptMigration(storedPassword)) {
            boolean migrated = credentialDAO.updatePasswordHash(user.getUserId(), PasswordUtil.hashPassword(password));
            if (!migrated) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
        }

        HttpSession existingSession = request.getSession(false);
        if (existingSession != null) {
            existingSession.invalidate();
        }

        // If steps are successful, log them in
        sessionDAO.expireOldSessions();
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.removeAttribute("activeRole");
        session.setMaxInactiveInterval(60 * 60); // log them out after 1 hour of inactivity
        CsrfUtil.getToken(session);
        if (!sessionDAO.createSession(session.getId(), user.getUserId())) {
            session.invalidate();
            request.setAttribute("error", "Unable to start a secure session. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        session.setAttribute("dbSessionToken", session.getId());

        // OSend to dashboard
        RoleUtil.redirectByRole(user, request, response);
    }
}
