<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Course" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Student Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260505-ui3">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    List<Course> enrollments = (List<Course>) request.getAttribute("enrollments");
    List<Course> waitlists = (List<Course>) request.getAttribute("waitlists");
    String holdStatusRaw = String.valueOf(request.getAttribute("holdStatus") != null ? request.getAttribute("holdStatus") : "").trim();
    String registrationStatusRaw = String.valueOf(request.getAttribute("registrationStatus") != null ? request.getAttribute("registrationStatus") : "").trim();
    boolean hasNoHold = holdStatusRaw.length() == 0 || "none".equalsIgnoreCase(holdStatusRaw) || "no".equalsIgnoreCase(holdStatusRaw) || holdStatusRaw.toLowerCase().contains("no hold");
    String holdStatus = hasNoHold ? "No active holds" : holdStatusRaw;
    String registrationStatus = registrationStatusRaw.length() == 0 ? "Unavailable" : registrationStatusRaw;
    int enrollmentCount = enrollments != null ? enrollments.size() : 0;
    int waitlistCount = waitlists != null ? waitlists.size() : 0;
    boolean hasBlockingHold = !hasNoHold;
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand">
                <div class="seal">SJ</div>
                <div>
                    <h1>YourSJSU</h1>
                    <span>Student Portal</span>
                </div>
            </div>
            <nav class="portal-nav">
                <a class="active" href="${pageContext.request.contextPath}/student-dashboard">Overview</a>
                <a href="${pageContext.request.contextPath}/search-courses">Course Search</a>
                <a href="${pageContext.request.contextPath}/schedule">Term Schedule <span class="nav-badge"><%= enrollmentCount %></span></a>
                <a href="${pageContext.request.contextPath}/transcript">Transcript</a>
                <a href="${pageContext.request.contextPath}/financial-summary">Finances</a>
                <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role">Switch Role</a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= user != null ? user.getFirstName() + " " + user.getLastName() : "Student" %></strong>
                        <span><%= user != null ? "ID " + user.getSjsuId() : "YourSJSU" %></span>
                    </div>
                </summary>
                <div class="account-menu">
                    <a href="${pageContext.request.contextPath}/change-password">Change password</a>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <button type="submit" class="signout-action">Sign out</button>
                    </form>
                </div>
            </details>
        </aside>

        <main class="portal-main">
            <header class="topbar">
                <div class="title-block">
                    <p>San Jose State University</p>
                    <h1>Registration dashboard</h1>
                </div>
            </header>

            <section class="metric-grid">
                <article class="metric-card">
                    <span class="label">Enrolled courses</span>
                    <div class="value"><%= enrollmentCount %></div>
                    <small>Current active enrollments</small>
                </article>
                <article class="metric-card">
                    <span class="label">Waitlisted</span>
                    <div class="value"><%= waitlistCount %></div>
                    <small>Pending seat availability</small>
                </article>
                <article class="metric-card">
                    <span class="label">Hold status</span>
                    <div class="value"><%= hasBlockingHold ? "Hold" : "Clear" %></div>
                    <small><%= holdStatus %></small>
                </article>
                <article class="metric-card">
                    <span class="label">Registration</span>
                    <div class="value"><%= registrationStatus %></div>
                    <small>Updated from student records</small>
                </article>
            </section>

            <section class="grid overview-grid" style="margin-top:16px">
                <article class="card">
                    <span class="eyebrow">Today's priority</span>
                    <div class="accent-line"></div>
                    <h2><%= hasBlockingHold ? "Resolve your hold before enrolling." : "You are ready to continue registration." %></h2>
                    <div class="list">
                        <div class="row">
                            <div>
                                <h4>Academic hold review</h4>
                                <p><%= holdStatus %></p>
                            </div>
                            <span class="pill <%= hasBlockingHold ? "red" : "green" %>"><%= hasBlockingHold ? "Blocking" : "Clear" %></span>
                        </div>
                        <div class="row">
                            <div>
                                <h4>Registration window</h4>
                                <p><%= registrationStatus %></p>
                            </div>
                            <span class="pill gold">Review</span>
                        </div>
                        <div class="row">
                            <div>
                                <h4>Course planning</h4>
                                <p>Search open classes or review your current term schedule.</p>
                            </div>
                            <a class="btn" href="${pageContext.request.contextPath}/search-courses">Search</a>
                        </div>
                    </div>
                </article>

                <article class="card flat">
                    <h2>Current enrollments</h2>
                    <div class="list">
                        <% if (enrollments != null && !enrollments.isEmpty()) {
                            for (Course c : enrollments) { %>
                                <div class="row">
                                    <div>
                                        <h4><%= c.getCourseTitle() %></h4>
                                        <p><%= c.getTermName() %> - <%= c.getMeetingDays() %> <%= c.getStartTime() %> - <%= c.getEndTime() %> - <%= c.getLocation() %></p>
                                    </div>
                                    <span class="pill green">Enrolled</span>
                                </div>
                        <%  }
                        } else { %>
                            <p class="no-results">No active enrollments.</p>
                        <% } %>
                    </div>
                </article>
            </section>

            <section class="grid two-column" style="margin-top:16px">
                <article class="card">
                    <h2>Active waitlists</h2>
                    <div class="list">
                        <% if (waitlists != null && !waitlists.isEmpty()) {
                            for (Course c : waitlists) { %>
                                <div class="row">
                                    <div>
                                        <h4><%= c.getCourseTitle() %></h4>
                                        <p><%= c.getTermName() %> - <%= c.getMeetingDays() %> <%= c.getStartTime() %> - <%= c.getEndTime() %> - <%= c.getLocation() %></p>
                                    </div>
                                    <span class="pill gold">Waitlist</span>
                                </div>
                        <%  }
                        } else { %>
                            <p class="no-results">No active waitlists.</p>
                        <% } %>
                    </div>
                </article>

                <article class="card">
                    <h2>Quick actions</h2>
                    <div class="dashboard-actions">
                        <a href="${pageContext.request.contextPath}/search-courses" class="btn-action">Search Courses</a>
                        <a href="${pageContext.request.contextPath}/schedule" class="btn-action">Review Schedule</a>
                        <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                            <a href="${pageContext.request.contextPath}/select-role" class="btn-action">Switch Role</a>
                        <% } %>
                    </div>
                </article>
            </section>
        </main>
    </div>
</body>
</html>
