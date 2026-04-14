package src.main.java.com.yoursjsu.servlet;
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

        // checks session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // loads terms
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
                Integer termId = null;
                if (termIdStr != null && !termIdStr.trim().isEmpty()) {
                    try {
                        termId = Integer.parseInt(termIdStr.trim());
                    } catch (NumberFormatException e) {
                        // ignores invalid id
                    }
                }

                List<SectionResult> results = courseSearchDAO.searchSections(
                        keyword, departmentCode, courseNumber, instructorName, termId);
                request.setAttribute("results", results);
                request.setAttribute("searched", true);
            }
        }

        request.getRequestDispatcher("/search-courses.jsp").forward(request, response);
    }
}