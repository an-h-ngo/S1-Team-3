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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-right">
            <%
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span class="nav-user"><%= currentUser.getFirstName() %> <%= currentUser.getLastName() %></span>
            <% } %>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-logout-form">
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>

    <main class="search-content">
        <h1>Manage Students</h1>
        <p class="dashboard-subtitle" style="text-align:left;margin-bottom:18px;">
            Faculty tools for granting/denying access (FR-D4) and lifting/placing financial holds (FR-D3).
        </p>

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
                            <th>Access (FR-D4)</th>
                            <th>Holds (FR-D3)</th>
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
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="<%= isActive ? "deactivate" : "activate" %>">
                                    <button type="submit" class="btn-search" style="font-size:12px;padding:6px 10px;">
                                        <%= isActive ? "Deactivate" : "Activate" %>
                                    </button>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/manage-students" style="margin:0;display:inline;">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="lift-holds">
                                    <button type="submit" class="btn-search" style="font-size:12px;padding:6px 10px;background:#2e7d32;">
                                        Lift Holds
                                    </button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/manage-students" style="margin:0;display:inline;">
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
</body>
</html>
