package com.yoursjsu.servlet;
import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.model.SectionResult;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/search-courses")
public class CourseSearchServlet extends HttpServlet {

    private CourseSearchDAO courseSearchDAO = new CourseSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Reads the search boxes for course name and department num
        String keyword = request.getParameter("keyword");
        String departmentCode = request.getParameter("departmentCode");

        // Any searches submitted by user
        boolean isSearch = (keyword != null || departmentCode != null);

        if (isSearch) {
            // Pass the values back to the JSP so the form stays filled in
            request.setAttribute("keyword", keyword);
            request.setAttribute("departmentCode", departmentCode);

            // Check if anything is typed
            boolean hasAny = (keyword != null && !keyword.trim().isEmpty())
                    || (departmentCode != null && !departmentCode.trim().isEmpty());

            if (!hasAny) {
                request.setAttribute("error", "Please enter a search term.");
            } else {
                // Run the search and stash the results for the JSP
                List<SectionResult> results = courseSearchDAO.searchSections(keyword, departmentCode);
                request.setAttribute("results", results);
                request.setAttribute("searched", true);
            }
        }

        // render page
        request.getRequestDispatcher("/search-courses.jsp").forward(request, response);
    }
}
