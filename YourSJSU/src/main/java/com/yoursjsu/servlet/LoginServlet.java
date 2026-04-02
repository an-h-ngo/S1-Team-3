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
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, request, response);
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        identifier = identifier.trim();
        User user = userDAO.findBySjsuIdOrEmail(identifier);

        if (user == null) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!"active".equals(user.getStatus())) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String hash = credentialDAO.getPasswordHash(user.getUserId());
        if (hash == null) {
            request.setAttribute("error", "Invalid credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(60 * 60); // 1 hour timeout

        redirectByRole(user, request, response);
    }

    private void redirectByRole(User user, HttpServletRequest request,
                                HttpServletResponse response) throws IOException {
        if (user.getIsStudent()) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
        } else if (user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}