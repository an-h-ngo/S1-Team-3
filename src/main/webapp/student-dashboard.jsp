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
	    <div class="nav-link" onclick="goTo('/courses')">
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
 	</nav>

	<script>
		function goTo(path) {
		    window.location.href = "<%= request.getContextPath() %>" + path;
		}
	</script>
	
    <main class="dashboard-content">
        <h1>Student Dashboard</h1>
        <% if (user != null) { %>
            <p class="dashboard-subtitle">Welcome, <%= user.getFirstName() %>. You are logged in as a student.</p>
        <% } %>

        <div class="dashboard-actions">
            <a href="${pageContext.request.contextPath}/search-courses" class="btn-action">Search Courses</a>
        </div>
    </main>
</body>
</html>