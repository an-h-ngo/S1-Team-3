package com.yoursjsu.servlet;
import com.yoursjsu.dao.CredentialDAO;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private CredentialDAO credentialDAO = new CredentialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // make sure all fields
        if (currentPassword == null || currentPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // make sure new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Verifies current password
        String storedPassword = credentialDAO.getPasswordHash(user.getUserId());
        if (storedPassword == null || !storedPassword.equals(currentPassword)) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // update the password
        boolean updated = credentialDAO.updatePassword(user.getUserId(), newPassword);
        if (!updated) {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Invalidate session so sends to login
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login?success=passwordChanged");
    }
}
