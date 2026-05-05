<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Student Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
		<div class="nav-center">Student Dashboard</div>
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
        <% if (user != null) { %>
            <p class="dashboard-subtitle">Welcome, <%= user.getFirstName() %>. You are logged in as a student.</p>
        <% } %>
        <div class="dashboard-actions">
    <a href="${pageContext.request.contextPath}/search-courses" class="btn-action">
        <div class="icon icon-search">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                 stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="6.5" cy="6.5" r="4"/>
                <line x1="10" y1="10" x2="14" y2="14"/>
            </svg>
        </div>
        Search Courses
    </a>
    <a href="${pageContext.request.contextPath}/search-courses" class="btn-action">
        <div class="icon icon-add">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                 stroke-width="1.5" stroke-linecap="round">
                <rect x="2" y="2" width="12" height="12" rx="2"/>
                <line x1="8" y1="5" x2="8" y2="11"/>
                <line x1="5" y1="8" x2="11" y2="8"/>
            </svg>
        </div>
        Add Classes
    </a>
    <a href="${pageContext.request.contextPath}/drop-course" class="btn-action">
        <div class="icon icon-drop">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                 stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 5h10"/>
                <path d="M5 5v8a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1V5"/>
                <path d="M6 5V3.5A1.5 1.5 0 0 1 7.5 2h1A1.5 1.5 0 0 1 10 3.5V5"/>
            </svg>
        </div>
        Drop a Course
    </a>
    <a href="${pageContext.request.contextPath}/financial-summary" class="btn-action">
        <div class="icon icon-pw">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                 stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="8" cy="8" r="6"/>
                <path d="M8 5v6"/>
                <path d="M6 7h3a1 1 0 0 1 0 2H7a1 1 0 0 0 0 2h3"/>
            </svg>
        </div>
        Financial Summary
    </a>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-action">
        <div class="icon icon-pw">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                 stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="7" width="10" height="7" rx="1.5"/>
                <path d="M5 7V5a3 3 0 0 1 6 0v2"/>
                <circle cx="8" cy="10.5" r="1"/>
            </svg>
        </div>
        Change Password
    </a>
</div>
    </main>
</body>
</html>
