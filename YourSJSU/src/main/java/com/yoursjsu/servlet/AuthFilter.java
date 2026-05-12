package com.yoursjsu.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import com.yoursjsu.dao.SessionDAO;
import com.yoursjsu.model.User;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {
    private static final Map<String, String> JSP_ROUTES = new HashMap<>();
    private final SessionDAO sessionDAO = new SessionDAO();

    static {
        JSP_ROUTES.put("/student-dashboard.jsp", "/student-dashboard");
        JSP_ROUTES.put("/faculty-dashboard.jsp", "/faculty-dashboard");
        JSP_ROUTES.put("/select-role.jsp", "/select-role");
        JSP_ROUTES.put("/change-password.jsp", "/change-password");
        JSP_ROUTES.put("/search-courses.jsp", "/search-courses");
        JSP_ROUTES.put("/add-classes.jsp", "/add-classes");
        JSP_ROUTES.put("/drop-course.jsp", "/drop-course");
        JSP_ROUTES.put("/courses.jsp", "/courses");
        JSP_ROUTES.put("/schedule.jsp", "/schedule");
        JSP_ROUTES.put("/transcript.jsp", "/transcript");
        JSP_ROUTES.put("/financial-summary.jsp", "/financial-summary");
        JSP_ROUTES.put("/complete-classes.jsp", "/complete-classes");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        addSecurityHeaders(response);

        HttpSession session = request.getSession(false);
        session = validateDbSession(request, response, session);
        if (session != null) {
            request.setAttribute(CsrfUtil.SESSION_ATTRIBUTE, CsrfUtil.getToken(session));
        }

        String path = request.getServletPath();
        String route = JSP_ROUTES.get(path);
        if (route != null) {
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            response.sendRedirect(request.getContextPath() + route);
            return;
        }

        if (isProtectedPath(path)) {
            addNoCacheHeaders(response);
        }

        chain.doFilter(request, response);
    }

    private HttpSession validateDbSession(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        if (session == null || session.getAttribute("user") == null) {
            return session;
        }
        User user = (User) session.getAttribute("user");
        String token = (String) session.getAttribute("dbSessionToken");
        if (token == null || !sessionDAO.validateAndExtend(token, user.getUserId())) {
            session.invalidate();
            return null;
        }
        return session;
    }

    private boolean isProtectedPath(String path) {
        return !isPublicPath(path) && !isStaticAsset(path);
    }

    private boolean isPublicPath(String path) {
        return "".equals(path)
                || "/".equals(path)
                || "/index.jsp".equals(path)
                || "/login".equals(path)
                || "/login.jsp".equals(path);
    }

    private boolean isStaticAsset(String path) {
        return path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/fonts/");
    }

    private void addSecurityHeaders(HttpServletResponse response) {
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("Referrer-Policy", "same-origin");
    }

    private void addNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
