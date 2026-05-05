<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Add Courses</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260505-ui3">
</head>
<body class="dashboard-page">

    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-center">Courses</div>
        <div class="nav-right">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
                <span class="nav-user"><%= user.getFirstName() %> <%= user.getLastName() %></span>
            <% } %>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-logout-form">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>
    <nav class="nav-bar1">
        <div class="nav-link" onclick="goTo('/student-dashboard')">
            Student Dashboard
        </div>
        <div class="nav-link" onclick="goTo('/search-courses')">
            Courses
        </div>
        <div class="nav-link" onclick="goTo('/schedule')">
            Term Schedule
        </div>
        <div class="nav-link" onclick="goTo('/transcript')">
            Transcript
        </div>
        <div class="nav-link" onclick="goTo('/financial-summary')">
            Financial Summary
        </div>
        <div class="nav-link" onclick="goTo('/change-password')">
            Reset Password
        </div>
    </nav>

    <script>
        function goTo(path) {
            window.location.href = "<%= request.getContextPath() %>" + path;
        }
    </script>

    <main class="dashboard-content">

        <section class="card">
            <h2>Search Courses</h2>
            <%
                List<String> sections = (List<String>) request.getAttribute("sections");
            %>
        </section>


    </main>
</body>
</html>
