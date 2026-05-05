<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Select role</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260505-ui3">
</head>
<body class="dashboard-page">
    <main class="change-password-content">
        <div class="login-container">
            <div class="login-header">
                <h1>Select role</h1>
                <%
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                %>
                    <p>Continue as student or faculty, <%= user.getFirstName() %>.</p>
                <% } %>
            </div>
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <% } %>
            <form method="post" action="${pageContext.request.contextPath}/select-role" class="login-form">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <button type="submit" name="role" value="student" class="btn-login">Continue as Student</button>
                <button type="submit" name="role" value="faculty" class="btn-login">Continue as Faculty</button>
            </form>
        </div>
    </main>
</body>
</html>
