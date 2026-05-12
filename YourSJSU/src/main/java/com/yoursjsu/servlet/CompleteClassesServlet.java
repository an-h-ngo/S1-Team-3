package com.yoursjsu.servlet;

import com.yoursjsu.dao.GradeCompletionDAO;
import com.yoursjsu.model.Course;
import com.yoursjsu.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/complete-classes")
public class CompleteClassesServlet extends HttpServlet {
    private final GradeCompletionDAO dao = new GradeCompletionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User faculty = RoleUtil.requireFaculty(request, response);
        if (faculty == null) {
            return;
        }

        List<Course> sections = dao.getFacultySections(faculty.getUserId());
        request.setAttribute("sections", sections);
        request.setAttribute("success", request.getParameter("success"));
        request.setAttribute("error", request.getParameter("error"));

        Integer selectedSectionId = parseInt(request.getParameter("sectionId"));
        if (selectedSectionId != null && !hasSection(sections, selectedSectionId)) {
            selectedSectionId = null;
        }
        if (selectedSectionId == null && !sections.isEmpty()) {
            selectedSectionId = sections.get(0).getSectionId();
        }

        if (selectedSectionId != null) {
            request.setAttribute("selectedSectionId", String.valueOf(selectedSectionId));
            request.setAttribute("students", dao.getEnrolledStudents(faculty.getUserId(), selectedSectionId));
        }

        request.getRequestDispatcher("/complete-classes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User faculty = RoleUtil.requireFaculty(request, response);
        if (faculty == null) {
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Integer sectionId = parseInt(request.getParameter("sectionId"));
        Integer studentId = parseInt(request.getParameter("studentId"));
        String grade = request.getParameter("grade");
        if (sectionId == null || studentId == null || grade == null || grade.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/complete-classes?error=bad-input");
            return;
        }

        boolean ok = dao.completeEnrollment(faculty.getUserId(), sectionId, studentId, grade.trim());
        response.sendRedirect(request.getContextPath() + "/complete-classes?sectionId=" + sectionId
                + (ok ? "&success=completed" : "&error=fail"));
    }

    private Integer parseInt(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean hasSection(List<Course> sections, int sectionId) {
        for (Course section : sections) {
            if (section.getSectionId() == sectionId) {
                return true;
            }
        }
        return false;
    }
}
