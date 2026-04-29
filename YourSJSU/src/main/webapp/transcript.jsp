<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Transcript" %>
<%@ page import="com.yoursjsu.model.ClassStatus" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Transcript</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>
    <nav class="nav-bar1">
    Reset Password, Financial Summary, and Course Search
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
        <div class="nav-link" onclick="goTo('/password-reset')">
            Reset Password
        </div>
        
    </nav>

    <script>
        function goTo(path) {
            window.location.href = "<%= request.getContextPath() %>" + path;
        }
    </script>

    <main class="dashboard-content">
		<!-- Student Info -->
        <section class="card">
		    <h2>Student Information</h2>
		    <% if (user != null) { %>
		    <div style="display: flex; justify-content: center;">
		        <table class="transcript-table" style="width: auto; min-width: 300px;">
		            <tr>
		                <td><strong>Name:</strong></td>
		                <td><%= user.getFirstName() %> <%= user.getLastName() %></td>
		            </tr>
		            <tr>
		                <td><strong>Student ID:</strong></td>
		                <td><%= user.getSjsuId() %></td>
		            </tr>
		            <tr>
		                <td><strong>Email:</strong></td>
		                <td><%= user.getEmail() %></td>
		            </tr>
		        </table>
		    </div>
		    <% } %>
		</section>

        <!-- Transcript Table -->
        <section class="card">
            <h2>Academic Transcript</h2>

            <%
                Transcript transcript = (Transcript)request.getAttribute("transcript");
            %>

            <% if (transcript != null) { %>
            <table class="transcript-table">
                <thead>
                    <tr>
                        
                        <th>Course Name</th>
                        <th>Units</th>
                        <th>Grade</th>
                        <th>Term</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        double totalPoints = 0;
                        int totalUnits = 0;

                        for (ClassStatus row : transcript.getClassStatusList()) {
                            String grade = row.getLetterGrade();
                            int units = row.getUnits();
                            if (grade != null){
								totalUnits += units;
                            } else {
                            	grade = "In Progress";
                            }
							
                            // calculate grade points
                            double gradePoint = 0;

                    %>
                    <tr>

                        <td><%= row.getCourseTitle() %></td>
                        <td><%= units %></td>
                        <td><%= grade %></td>
                        <td><%= row.getTermId() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <!-- GPA Summary -->
            <div class="gpa-summary">
                <%
                    double gpa = totalUnits > 0 ? totalPoints / totalUnits : 0.0;
                %>
                <p><strong>Total Units Completed:</strong> <%= totalUnits %></p>
                <p><strong>Cumulative GPA:</strong> <%= String.format("%.2f", gpa) %></p>
            </div>

            <% } else { %>
                <p>No transcript records found.</p>
            <% } %>
        </section>
		

    </main>
</body>
</html>