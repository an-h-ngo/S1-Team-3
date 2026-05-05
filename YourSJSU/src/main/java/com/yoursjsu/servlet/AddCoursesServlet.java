package com.yoursjsu.servlet;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.model.SectionResult;

@WebServlet("/add-classes")
public class AddCoursesServlet extends HttpServlet{
	private CourseSearchDAO courseSearchDAO = new CourseSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // checks session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // loads terms (kept for the JSP's term dropdown if it has one)
        List<String[]> terms = courseSearchDAO.getAllTerms();
        request.setAttribute("terms", terms);

        String keyword = request.getParameter("keyword");
        String departmentCode = request.getParameter("departmentCode");
        String courseNumber = request.getParameter("courseNumber");
        String instructorName = request.getParameter("instructorName");
        String termIdStr = request.getParameter("termId");

        boolean isSearch = (keyword != null || departmentCode != null
                || courseNumber != null || instructorName != null || termIdStr != null);

        if (isSearch) {
            request.setAttribute("keyword", keyword);
            request.setAttribute("departmentCode", departmentCode);
            request.setAttribute("courseNumber", courseNumber);
            request.setAttribute("instructorName", instructorName);
            request.setAttribute("termId", termIdStr);

            // checks to make sure there is some filter
            boolean hasAny = (keyword != null && !keyword.trim().isEmpty())
                    || (departmentCode != null && !departmentCode.trim().isEmpty())
                    || (courseNumber != null && !courseNumber.trim().isEmpty())
                    || (instructorName != null && !instructorName.trim().isEmpty())
                    || (termIdStr != null && !termIdStr.trim().isEmpty());

            if (!hasAny) {
                request.setAttribute("error", "Please enter at least one search criterion.");
            } else {
                // if the user typed a courseNumber but no keyword, route the courseNumber into the keyword box so the search still works
                String effectiveKeyword = keyword;
                if ((effectiveKeyword == null || effectiveKeyword.trim().isEmpty())
                        && courseNumber != null && !courseNumber.trim().isEmpty()) {
                    effectiveKeyword = courseNumber;
                }

                List<SectionResult> results = courseSearchDAO.searchSections(
                        effectiveKeyword, departmentCode);
                request.setAttribute("results", results);
                request.setAttribute("searched", true);
            }
        }

        request.getRequestDispatcher("/add-classes.jsp").forward(request, response);
    }
}
