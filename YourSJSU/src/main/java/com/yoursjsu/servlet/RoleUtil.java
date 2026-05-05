package com.yoursjsu.servlet;

import com.yoursjsu.model.User;
import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class RoleUtil {
    public static final String STUDENT = "student";
    public static final String FACULTY = "faculty";

    public static User requireStudent(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireLogin(request, response);
        if (user == null) {
            return null;
        }
        HttpSession session = request.getSession(false);
        String role = ensureActiveRole(session, user, request, response);
        if (role == null) {
            return null;
        }
        if (!user.getIsStudent() || !STUDENT.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard");
            return null;
        }
        return user;
    }

    public static User requireFaculty(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireLogin(request, response);
        if (user == null) {
            return null;
        }
        HttpSession session = request.getSession(false);
        String role = ensureActiveRole(session, user, request, response);
        if (role == null) {
            return null;
        }
        if (!user.getIsFaculty() || !FACULTY.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return null;
        }
        return user;
    }

    public static User requireAnyRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireLogin(request, response);
        if (user == null) {
            return null;
        }
        HttpSession session = request.getSession(false);
        return ensureActiveRole(session, user, request, response) == null ? null : user;
    }

    public static void redirectByRole(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);
        String activeRole = (String) session.getAttribute("activeRole");
        if (STUDENT.equals(activeRole) && user.getIsStudent()) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
            return;
        }
        if (FACULTY.equals(activeRole) && user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard");
            return;
        }
        if (user.getIsStudent() && user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/select-role");
        } else if (user.getIsStudent()) {
            session.setAttribute("activeRole", STUDENT);
            response.sendRedirect(request.getContextPath() + "/student-dashboard");
        } else if (user.getIsFaculty()) {
            session.setAttribute("activeRole", FACULTY);
            response.sendRedirect(request.getContextPath() + "/faculty-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private static User requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }

    private static String ensureActiveRole(HttpSession session, User user, HttpServletRequest request,
                                           HttpServletResponse response) throws IOException {
        String role = (String) session.getAttribute("activeRole");
        if (role != null) {
            return role;
        }
        if (user.getIsStudent() && user.getIsFaculty()) {
            response.sendRedirect(request.getContextPath() + "/select-role");
            return null;
        }
        if (user.getIsStudent()) {
            session.setAttribute("activeRole", STUDENT);
            return STUDENT;
        }
        if (user.getIsFaculty()) {
            session.setAttribute("activeRole", FACULTY);
            return FACULTY;
        }
        response.sendRedirect(request.getContextPath() + "/login");
        return null;
    }
}
