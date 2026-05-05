package com.yoursjsu.servlet;

import com.yoursjsu.dao.RegistrationDAO;
import com.yoursjsu.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/drop-course")
public class DropCourseServlet extends HttpServlet {
    private RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/schedule?error=" + url("Your session expired. Please try again."));
            return;
        }

        Integer sectionId = parseSectionId(request);
        if (sectionId == null) {
            response.sendRedirect(request.getContextPath() + "/schedule?error=Invalid section selected.");
            return;
        }

        RegistrationDAO.DropResult result = registrationDAO.drop(user.getUserId(), sectionId);
        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/schedule?success=" + url(result.getSuccessMessage()));
        } else {
            response.sendRedirect(request.getContextPath() + "/schedule?error=" + url(result.getError()));
        }
    }

    private Integer parseSectionId(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("sectionId"));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String url(String value) throws IOException {
        return java.net.URLEncoder.encode(value, "UTF-8");
    }
}
