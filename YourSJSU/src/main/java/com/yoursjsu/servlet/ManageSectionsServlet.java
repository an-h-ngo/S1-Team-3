package com.yoursjsu.servlet;
import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.dao.SectionAdminDAO;
import com.yoursjsu.model.SectionResult;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@WebServlet("/manage-sections")
public class ManageSectionsServlet extends HttpServlet {

    private SectionAdminDAO dao = new SectionAdminDAO();
    // borrow getAllTerms() from course-search DAO
    private CourseSearchDAO courseSearchDAO = new CourseSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (RoleUtil.requireFaculty(request, response) == null) return;

        request.setAttribute("courses",  dao.getAllCoursesForDropdown());
        request.setAttribute("faculty",  dao.getAllFacultyForDropdown());
        request.setAttribute("terms",    courseSearchDAO.getAllTerms());
        request.setAttribute("sections", dao.getAllSections());
        request.getRequestDispatcher("/manage-sections.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (RoleUtil.requireFaculty(request, response) == null) return;

        if (!CsrfUtil.isValid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        String result;

        if ("add".equals(action)) {
            result = handleAdd(request);
        } else if ("remove".equals(action)) {
            result = handleRemove(request);
        } else {
            result = "unknown";
        }

        response.sendRedirect(request.getContextPath() + "/manage-sections?result=" + result);
    }

    // Parse form, validate, and insert section
    private String handleAdd(HttpServletRequest request) {
        try {
            int courseId        = Integer.parseInt(request.getParameter("courseId"));
            int termId          = Integer.parseInt(request.getParameter("termId"));
            String facultyStr   = nullIfBlank(request.getParameter("facultyId"));
            if (facultyStr == null) {
                return "bad-input";
            }
            Integer facultyId   = Integer.parseInt(facultyStr);
            String meetingDays  = nullIfBlank(request.getParameter("meetingDays"));
            String startTime    = nullIfBlank(request.getParameter("startTime"));
            String endTime      = nullIfBlank(request.getParameter("endTime"));
            String location     = nullIfBlank(request.getParameter("location"));
            String modality     = nullIfBlank(request.getParameter("modality"));
            int capacity        = Integer.parseInt(request.getParameter("capacity"));
            int waitlistCap     = Integer.parseInt(request.getParameter("waitlistCapacity"));

            if (meetingDays == null || startTime == null || endTime == null || location == null
                    || modality == null || capacity < 1 || waitlistCap < 0) {
                return "bad-input";
            }

            boolean ok = dao.addSection(courseId, termId, facultyId,
                                        meetingDays, startTime, endTime,
                                        location, modality, capacity, waitlistCap);
            return ok ? "added" : "fail";
        } catch (NumberFormatException e) {
            return "bad-input";
        }
    }

    // Parse section ID, delete if there are no students
    private String handleRemove(HttpServletRequest request) {
        try {
            int sectionId = Integer.parseInt(request.getParameter("sectionId"));
            return dao.removeSection(sectionId);   // returns "ok", "has-students", "fail"
        } catch (NumberFormatException e) {
            return "bad-input";
        }
    }

    private String nullIfBlank(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}
