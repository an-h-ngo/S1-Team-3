<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Change Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    String activeRole = (String) session.getAttribute("activeRole");
    boolean facultyRole = "faculty".equals(activeRole);
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span><%= facultyRole ? "Faculty Portal" : "Student Portal" %></span></div></div>
            <nav class="portal-nav">
                <% if (facultyRole) { %>
                    <a href="${pageContext.request.contextPath}/faculty-dashboard" aria-label="Faculty Dashboard"><span class="nav-icon nav-icon-faculty" aria-hidden="true"></span><span class="nav-label">Faculty Dashboard</span></a>
                    <a href="${pageContext.request.contextPath}/manage-students" aria-label="Manage Students"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Manage Students</span></a>
                    <a href="${pageContext.request.contextPath}/manage-sections" aria-label="Manage Sections"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Manage Sections</span></a>
                    <a href="${pageContext.request.contextPath}/complete-classes" aria-label="Complete Classes"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Complete Classes</span></a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/student-dashboard" aria-label="Overview"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Overview</span></a>
                    <a href="${pageContext.request.contextPath}/search-courses" aria-label="Course Search"><span class="nav-icon nav-icon-search" aria-hidden="true"></span><span class="nav-label">Course Search</span></a>
                    <a href="${pageContext.request.contextPath}/schedule" aria-label="Term Schedule"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Term Schedule</span></a>
                    <a href="${pageContext.request.contextPath}/transcript" aria-label="Transcript"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Transcript</span></a>
                    <a href="${pageContext.request.contextPath}/financial-summary" aria-label="Finances"><span class="nav-icon nav-icon-finances" aria-hidden="true"></span><span class="nav-label">Finances</span></a>
                <% } %>
                <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role" aria-label="Switch Role"><span class="nav-icon nav-icon-switch" aria-hidden="true"></span><span class="nav-label">Switch Role</span></a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= user != null ? user.getFirstName() + " " + user.getLastName() : "User" %></strong>
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
                    <p>Account security</p>
                    <h1>Change password</h1>
                </div>
            </header>

            <div class="change-password-content">
                <div class="login-container">
                    <div class="login-header">
                        <div class="seal" style="margin:0 auto 14px">SJ</div>
                        <h1>Change password</h1>
                        <p>Update your account credentials</p>
                    </div>

                    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
                        <div class="error-message"><%= error %></div>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/change-password" class="login-form">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <button type="submit" class="btn-login">Change Password</button>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
