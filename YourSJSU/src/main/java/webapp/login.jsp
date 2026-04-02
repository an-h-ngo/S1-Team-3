<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Sign In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-page">
    <div class="login-container">
        <div class="login-header">
            <h1>YourSJSU</h1>
            <p>San Jose State University Portal</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">

            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <div class="form-group">
                <label for="identifier">SJSU ID or Email</label>
                <input type="text" id="identifier" name="identifier"
                       placeholder="e.g. 012345678 or name@sjsu.edu" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="login-footer">
            <p>CS 157A &mdash; Team 3</p>
        </div>
    </div>
</body>
</html>
