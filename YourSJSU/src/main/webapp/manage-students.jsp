<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.dao.StudentAdminDAO.UserWithHolds" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Manage Students</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User currentUser = (User) session.getAttribute("user");
    String userInitials = currentUser != null && currentUser.getFirstName() != null && currentUser.getLastName() != null && currentUser.getFirstName().length() > 0 && currentUser.getLastName().length() > 0
            ? (currentUser.getFirstName().substring(0, 1) + currentUser.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Faculty Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/faculty-dashboard" aria-label="Faculty Dashboard"><span class="nav-icon nav-icon-faculty" aria-hidden="true"></span><span class="nav-label">Faculty Dashboard</span></a>
                <a class="active" href="${pageContext.request.contextPath}/manage-students" aria-label="Manage Students"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Manage Students</span></a>
                <a href="${pageContext.request.contextPath}/manage-sections" aria-label="Manage Sections"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Manage Sections</span></a>
                <a href="${pageContext.request.contextPath}/complete-classes" aria-label="Complete Classes"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Complete Classes</span></a>
                <% if (currentUser != null && currentUser.getIsStudent() && currentUser.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role" aria-label="Switch Role"><span class="nav-icon nav-icon-switch" aria-hidden="true"></span><span class="nav-label">Switch Role</span></a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= currentUser != null ? currentUser.getFirstName() + " " + currentUser.getLastName() : "Faculty" %></strong>
                        <span><%= currentUser != null ? "ID " + currentUser.getSjsuId() : "YourSJSU" %></span>
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
                    <p>Student administration</p>
                    <h1>Manage students</h1>
                </div>
            </header>

        <%
            String result = request.getParameter("result");
            if (result != null) {
                String msg;
                String msgClass;
                if ("activated".equals(result))   { msg = "Account activated.";       msgClass = "success-message"; }
                else if ("deactivated".equals(result)) { msg = "Account deactivated."; msgClass = "success-message"; }
                else if ("placed".equals(result))      { msg = "Hold placed.";        msgClass = "success-message"; }
                else if ("no-holds".equals(result))    { msg = "Nothing to do — student has no holds."; msgClass = "error-message"; }
                else if (result != null && result.startsWith("lifted-")) {
                    msg = "Lifted " + result.substring(7) + " hold(s).";
                    msgClass = "success-message";
                }
                else { msg = "Action failed."; msgClass = "error-message"; }
        %>
            <div class="<%= msgClass %>"><%= msg %></div>
        <% } %>

        <%
            List<UserWithHolds> rows = (List<UserWithHolds>) request.getAttribute("rows");
            if (rows == null || rows.isEmpty()) {
        %>
            <p class="no-results">No students found.</p>
        <% } else { %>
            <div class="table-wrapper">
                <table class="results-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>SJSU ID</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Holds</th>
                            <th>Access</th>
                            <th>Holds</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (UserWithHolds row : rows) {
                            User u = row.getUser();
                            String statusClass = "active".equals(u.getStatus()) ? "status-paid" : "status-overdue";
                            boolean isActive = "active".equals(u.getStatus());
                        %>
                        <tr>
                            <td><%= u.getLastName() %>, <%= u.getFirstName() %></td>
                            <td><%= u.getSjsuId() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><span class="<%= statusClass %>"><%= u.getStatus().toUpperCase() %></span></td>
                            <td>
                                <% if (row.getHoldCount() == 0) { %>
                                    <span class="status-paid">0</span>
                                <% } else { %>
                                    <span class="status-overdue"><%= row.getHoldCount() %></span>
                                <% } %>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/manage-students" style="margin:0;display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="<%= isActive ? "deactivate" : "activate" %>">
                                    <button type="submit" class="btn-search" style="font-size:12px;padding:6px 10px;">
                                        <%= isActive ? "Deactivate" : "Activate" %>
                                    </button>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/manage-students" style="margin:0;display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="lift-holds">
                                    <button type="submit" class="btn-search" style="font-size:12px;padding:6px 10px;background:#2e7d32;">
                                        Lift Holds
                                    </button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/manage-students" style="margin:0;display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="place-hold">
                                    <button type="submit" class="btn-search" style="font-size:12px;padding:6px 10px;background:#b71c1c;">
                                        Place Hold
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
        </main>
    </div>
</body>
</html>
