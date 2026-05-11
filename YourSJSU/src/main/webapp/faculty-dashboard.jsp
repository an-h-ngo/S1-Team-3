<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Course" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Faculty Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260505-ui3">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    List<Course> teachingSections = (List<Course>) request.getAttribute("teachingSections");
    int teachingCount = teachingSections != null ? teachingSections.size() : 0;
    String staffTitle = request.getAttribute("staffTitle") != null ? String.valueOf(request.getAttribute("staffTitle")) : "Not on file";
    String departmentName = request.getAttribute("departmentName") != null ? String.valueOf(request.getAttribute("departmentName")) : "Not on file";
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div><h1>YourSJSU</h1><span>Faculty Portal</span></div></div>
            <nav class="portal-nav">
                <a class="active" href="${pageContext.request.contextPath}/faculty-dashboard">Faculty Dashboard</a>
                <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role">Switch Role</a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= user != null ? user.getFirstName() + " " + user.getLastName() : "Faculty" %></strong>
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
                    <p>Instruction</p>
                    <h1>Faculty dashboard</h1>
                </div>
            </header>

            <section class="metric-grid">
                <article class="metric-card"><span class="label">Teaching sections</span><div class="value"><%= teachingCount %></div><small>Assigned class sections</small></article>
                <article class="metric-card"><span class="label">Title</span><div class="value"><%= staffTitle %></div><small>Faculty profile</small></article>
                <article class="metric-card"><span class="label">Department</span><div class="value"><%= departmentName %></div><small>Academic department</small></article>
                <article class="metric-card"><span class="label">Account</span><div class="value">Active</div><small>Signed in as faculty</small></article>
            </section>

            <section class="grid two-column" style="margin-top:16px">
                <article class="card">
                    <h2>Faculty profile</h2>
                    <div class="list">
                        <div class="row"><div><h4>Title</h4><p><%= staffTitle %></p></div><span class="pill">Faculty</span></div>
                        <div class="row"><div><h4>Department</h4><p><%= departmentName %></p></div><span class="pill green">Active</span></div>
                    </div>
                </article>

                <article class="card">
                    <h2>Quick actions</h2>
                    <div class="dashboard-actions">
                        <a href="${pageContext.request.contextPath}/manage-students" class="btn-action">Manage Students</a>
                        <a href="${pageContext.request.contextPath}/manage-sections" class="btn-action">Manage Sections</a>
                        <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                            <a href="${pageContext.request.contextPath}/select-role" class="btn-action">Switch Role</a>
                        <% } %>
                    </div>
                </article>
            </section>

            <section class="card" style="margin-top:16px">
                <h2>Teaching sections</h2>
                <div class="list">
                    <% if (teachingSections != null && !teachingSections.isEmpty()) {
                        for (Course c : teachingSections) { %>
                            <div class="row">
                                <div>
                                    <h4><%= c.getCourseTitle() %> - <%= c.getTermName() %></h4>
                                    <p><%= c.getMeetingDays() %> <%= c.getStartTime() %> - <%= c.getEndTime() %> - <%= c.getLocation() %></p>
                                </div>
                                <span class="pill green"><%= c.getStatus() %></span>
                            </div>
                    <%  }
                    } else { %>
                        <p class="no-results">No assigned sections found.</p>
                    <% } %>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
