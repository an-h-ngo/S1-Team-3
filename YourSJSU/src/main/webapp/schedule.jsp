<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Course" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Schedule</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260505-ui3">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    int enrolledCount = 0;
    int completedCount = 0;
    if (courses != null) {
        for (Course c : courses) {
            if ("enrolled".equals(c.getStatus())) enrolledCount++;
            if ("completed".equals(c.getStatus())) completedCount++;
        }
    }
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div id="confirmModal" class="modal-overlay" style="display:none">
        <div class="modal-box">
            <p>Drop this class from your schedule?</p>
            <div class="modal-buttons">
                <button class="btn-confirm" type="button" onclick="confirmRemove()">Yes, Drop Class</button>
                <button class="btn-cancel" type="button" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>

    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div><h1>YourSJSU</h1><span>Student Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/student-dashboard">Overview</a>
                <a href="${pageContext.request.contextPath}/search-courses">Course Search</a>
                <a class="active" href="${pageContext.request.contextPath}/schedule">Term Schedule <span class="nav-badge"><%= enrolledCount %></span></a>
                <a href="${pageContext.request.contextPath}/transcript">Transcript</a>
                <a href="${pageContext.request.contextPath}/financial-summary">Finances</a>
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
                    <p>Registration</p>
                    <h1>Term schedule</h1>
                </div>
            </header>

            <% String error = (String) request.getAttribute("error"); if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>
            <% String success = (String) request.getAttribute("success"); if (success != null) { %>
                <div class="success-message"><%= success %></div>
            <% } %>

            <section class="metric-grid">
                <article class="metric-card"><span class="label">Enrolled</span><div class="value"><%= enrolledCount %></div><small>Current term classes</small></article>
                <article class="metric-card"><span class="label">Completed</span><div class="value"><%= completedCount %></div><small>Past completed classes</small></article>
                <article class="metric-card"><span class="label">Available actions</span><div class="value"><%= enrolledCount %></div><small>Classes can be dropped from the schedule list</small></article>
                <article class="metric-card"><span class="label">Course search</span><div class="value"><%= enrolledCount + completedCount %></div><small>Total courses shown on this page</small></article>
            </section>

            <section class="grid two-column" style="margin-top:16px">
                <article class="card">
                    <h2>Current schedule</h2>
                    <div class="list">
                        <% if (courses != null && enrolledCount > 0) {
                            for (Course c : courses) {
                                if ("enrolled".equals(c.getStatus())) { %>
                                    <div class="row">
                                        <div>
                                            <h4><%= c.getCourseTitle() %> - <%= c.getTermName() %></h4>
                                            <p><%= c.getMeetingDays() %> <%= c.getStartTime() %> - <%= c.getEndTime() %> - <%= c.getLocation() %></p>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/drop-course" onsubmit="return removeCourse(this)">
                                            <input type="hidden" name="sectionId" value="<%= c.getSectionId() %>">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <button type="submit" class="remove-btn">Drop</button>
                                        </form>
                                    </div>
                        <%      }
                            }
                        } else { %>
                            <p class="no-results">No active enrolled courses.</p>
                        <% } %>
                    </div>
                </article>

                <article class="card">
                    <h2>Weekly plan</h2>
                    <div class="schedule-grid" aria-label="Weekly schedule overview">
                        <div class="head">Time</div><div class="head">Mon</div><div class="head">Tue</div><div class="head">Wed</div><div class="head">Thu</div><div class="head">Fri</div>
                        <div class="time">Classes</div>
                        <div class="schedule-slot"><%= enrolledCount %> enrolled</div>
                        <div></div><div></div><div></div><div></div>
                    </div>
                    <p>Detailed meeting information is shown in the enrollment cart.</p>
                </article>
            </section>

            <section class="card" style="margin-top:16px">
                <h2>Courses taken</h2>
                <div class="list">
                    <% if (courses != null && completedCount > 0) {
                        for (Course c : courses) {
                            if ("completed".equals(c.getStatus())) { %>
                                <div class="row">
                                    <div><h4><%= c.getCourseTitle() %></h4><p><%= c.getTermName() %></p></div>
                                    <span class="pill green">Complete</span>
                                </div>
                    <%      }
                        }
                    } else { %>
                        <p class="no-results">No completed courses found.</p>
                    <% } %>
                </div>
            </section>
        </main>
    </div>

    <script>
        let currentForm = null;

        function removeCourse(form) {
            currentForm = form;
            document.getElementById('confirmModal').style.display = 'flex';
            return false;
        }

        function confirmRemove() {
            if (currentForm) {
                currentForm.submit();
            }
        }

        function closeModal() {
            document.getElementById('confirmModal').style.display = 'none';
            currentForm = null;
        }
    </script>
</body>
</html>
