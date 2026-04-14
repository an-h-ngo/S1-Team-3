<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Change Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-right">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
                <span class="nav-user"><%= user.getFirstName() %> <%= user.getLastName() %></span>
            <% } %>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-logout-form">
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>

    <main class="change-password-content">
        <div class="login-container">
            <div class="login-header">
                <h1>Change Password</h1>
                <p>Update your account credentials</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/change-password" class="login-form">
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
    </main>
</body>
</html>