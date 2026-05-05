package com.yoursjsu.servlet;

import com.yoursjsu.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/select-role")
public class RoleSelectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!(user.getIsStudent() && user.getIsFaculty())) {
            RoleUtil.redirectByRole(user, request, response);
            return;
        }
        request.getRequestDispatcher("/select-role.jsp").forward(request, response);
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
        if (!CsrfUtil.isValid(request)) {
            request.setAttribute("error", "Your session expired. Please try again.");
            request.getRequestDispatcher("/select-role.jsp").forward(request, response);
            return;
        }
        String role = request.getParameter("role");
        if (RoleUtil.STUDENT.equals(role) && user.getIsStudent()) {
            session.setAttribute("activeRole", RoleUtil.STUDENT);
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return;
        }
        if (RoleUtil.FACULTY.equals(role) && user.getIsFaculty()) {
            session.setAttribute("activeRole", RoleUtil.FACULTY);
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard");
            return;
        }
        request.setAttribute("error", "That role is not available for your account.");
        request.getRequestDispatcher("/select-role.jsp").forward(request, response);
    }
}
