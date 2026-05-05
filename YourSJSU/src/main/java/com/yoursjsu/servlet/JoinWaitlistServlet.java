package com.yoursjsu.servlet;

import com.yoursjsu.dao.RegistrationDAO;
import com.yoursjsu.model.User;
import java.io.IOException;
import java.net.URLDecoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/join-waitlist")
public class JoinWaitlistServlet extends HttpServlet {
    private RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/search-courses?error=" + url("Your session expired. Please try again."));
            return;
        }

        Integer sectionId = parseSectionId(request);
        if (sectionId == null) {
            response.sendRedirect(request.getContextPath() + "/search-courses?error=" + url("Invalid section selected."));
            return;
        }

        String error = registrationDAO.joinWaitlist(user.getUserId(), sectionId);
        if (error == null) {
            response.sendRedirect(searchRedirect(request, "success", "Waitlist request confirmed."));
        } else {
            response.sendRedirect(searchRedirect(request, "error", error));
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

    private String searchRedirect(HttpServletRequest request, String key, String message) throws IOException {
        String returnQuery = request.getParameter("returnQuery");
        StringBuilder target = new StringBuilder(request.getContextPath()).append("/search-courses");
        String safeReturnQuery = safeReturnQuery(returnQuery);
        if (!safeReturnQuery.isEmpty()) {
            target.append("?").append(safeReturnQuery).append("&");
        } else {
            target.append("?");
        }
        return target.append(key).append("=").append(url(message)).toString();
    }

    private String safeReturnQuery(String returnQuery) throws IOException {
        if (returnQuery == null || returnQuery.trim().isEmpty()) {
            return "";
        }
        StringBuilder safe = new StringBuilder();
        for (String pair : returnQuery.split("&")) {
            int equalsIndex = pair.indexOf('=');
            if (equalsIndex <= 0) {
                continue;
            }
            String key;
            String value;
            try {
                key = URLDecoder.decode(pair.substring(0, equalsIndex), "UTF-8");
                value = URLDecoder.decode(pair.substring(equalsIndex + 1), "UTF-8");
            } catch (IllegalArgumentException e) {
                continue;
            }
            if (isAllowedSearchParameter(key)) {
                if (safe.length() > 0) {
                    safe.append("&");
                }
                safe.append(url(key)).append("=").append(url(value));
            }
        }
        return safe.toString();
    }

    private boolean isAllowedSearchParameter(String key) {
        return "keyword".equals(key)
                || "courseNumber".equals(key)
                || "instructorName".equals(key)
                || "departmentCode".equals(key)
                || "termId".equals(key);
    }
}
