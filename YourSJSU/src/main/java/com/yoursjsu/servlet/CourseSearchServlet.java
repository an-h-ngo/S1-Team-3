package com.yoursjsu.servlet;

import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.model.SectionResult;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search-courses")
public class CourseSearchServlet extends HttpServlet {

    private CourseSearchDAO courseSearchDAO = new CourseSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (RoleUtil.requireStudent(request, response) == null) {
            return;
        }

        List<String[]> terms = courseSearchDAO.getAllTerms();
        request.setAttribute("terms", terms);
        request.setAttribute("success", request.getParameter("success"));
        request.setAttribute("error", request.getParameter("error"));
        request.setAttribute("returnQuery", buildReturnQuery(request));

        String keyword = request.getParameter("keyword");
        String departmentCode = request.getParameter("departmentCode");
        String courseNumber = request.getParameter("courseNumber");
        String instructorName = request.getParameter("instructorName");
        String termId = request.getParameter("termId");

        boolean isSearch = (keyword != null || departmentCode != null || courseNumber != null
                || instructorName != null || termId != null);

        if (isSearch) {
            request.setAttribute("keyword", keyword);
            request.setAttribute("departmentCode", departmentCode);
            request.setAttribute("courseNumber", courseNumber);
            request.setAttribute("instructorName", instructorName);
            request.setAttribute("termId", termId);

            boolean hasAny = (keyword != null && !keyword.trim().isEmpty())
                    || (departmentCode != null && !departmentCode.trim().isEmpty())
                    || (courseNumber != null && !courseNumber.trim().isEmpty())
                    || (instructorName != null && !instructorName.trim().isEmpty())
                    || (termId != null && !termId.trim().isEmpty());

            if (!hasAny) {
                request.setAttribute("error", "Please enter a search term.");
            } else {
                List<SectionResult> results = courseSearchDAO.searchSections(keyword, departmentCode,
                        courseNumber, instructorName, termId);
                request.setAttribute("results", results);
                request.setAttribute("searched", true);
            }
        }

        request.getRequestDispatcher("/search-courses.jsp").forward(request, response);
    }

    private String buildReturnQuery(HttpServletRequest request) {
        StringBuilder query = new StringBuilder();
        addParam(query, "keyword", request.getParameter("keyword"));
        addParam(query, "departmentCode", request.getParameter("departmentCode"));
        addParam(query, "courseNumber", request.getParameter("courseNumber"));
        addParam(query, "instructorName", request.getParameter("instructorName"));
        addParam(query, "termId", request.getParameter("termId"));
        return query.toString();
    }

    private void addParam(StringBuilder query, String name, String value) {
        if (value == null || value.trim().isEmpty()) {
            return;
        }
        try {
            if (query.length() > 0) {
                query.append("&");
            }
            query.append(name).append("=")
                    .append(java.net.URLEncoder.encode(value, "UTF-8"));
        } catch (java.io.UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }
}
