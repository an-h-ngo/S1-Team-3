<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Search Courses</title>
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

    <main class="search-content">
        <h1>Search Courses</h1>

        <form method="get" action="${pageContext.request.contextPath}/search-courses" class="search-form">
            <div class="search-row">
                <input type="text" name="keyword" placeholder="Course title keyword"
                       value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                <input type="text" name="courseNumber" placeholder="Course number (e.g. 157A)"
                       value="<%= request.getAttribute("courseNumber") != null ? request.getAttribute("courseNumber") : "" %>">
                <input type="text" name="instructorName" placeholder="Instructor name"
                       value="<%= request.getAttribute("instructorName") != null ? request.getAttribute("instructorName") : "" %>">
            </div>
            <div class="search-row">
                <input type="text" name="departmentCode" placeholder="Department code (e.g. CS)"
                       value="<%= request.getAttribute("departmentCode") != null ? request.getAttribute("departmentCode") : "" %>">
                <select name="termId">
                    <option value="">All Terms</option>
                    <%
                        List<String[]> terms = (List<String[]>) request.getAttribute("terms");
                        String selectedTerm = (String) request.getAttribute("termId");
                        if (terms != null) {
                            for (String[] term : terms) {
                                String sel = term[0].equals(selectedTerm) ? "selected" : "";
                    %>
                        <option value="<%= term[0] %>" <%= sel %>><%= term[1] %></option>
                    <%
                            }
                        }
                    %>
                </select>
                <button type="submit" class="btn-search">Search</button>
            </div>
        </form>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <% } %>

        <%
            List<SectionResult> results = (List<SectionResult>) request.getAttribute("results");
            Boolean searched = (Boolean) request.getAttribute("searched");
            if (results != null && !results.isEmpty()) {
        %>
        <div class="table-wrapper">
            <table class="results-table">
                <thead>
                    <tr>
                        <th>Course</th>
                        <th>Title</th>
                        <th>Units</th>
                        <th>Term</th>
                        <th>Instructor</th>
                        <th>Days/Time</th>
                        <th>Location</th>
                        <th>Mode</th>
                        <th>Seats</th>
                        <th>Waitlist</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SectionResult r : results) {
                        int seatsAvail = r.getCapacity() - r.getEnrolledCount();
                        int wlAvail = r.getWaitlistCapacity() - r.getWaitlistCount();
                        String status;
                        String statusClass;
                        if (seatsAvail > 0) {
                            status = "Open";
                            statusClass = "status-open";
                        } else if (wlAvail > 0) {
                            status = "Waitlist";
                            statusClass = "status-waitlist";
                        } else {
                            status = "Closed";
                            statusClass = "status-closed";
                        }
                    %>
                    <tr>
                        <td><%= r.getDepartmentCode() %> <%= r.getCourseNumber() %></td>
                        <td><%= r.getCourseTitle() %></td>
                        <td><%= r.getUnits() %></td>
                        <td><%= r.getTermName() %></td>
                        <td><%= r.getInstructorName() %></td>
                        <td><%= r.getMeetingDays() %> <%= r.getStartTime() %> - <%= r.getEndTime() %></td>
                        <td><%= r.getLocation() %></td>
                        <td><%= r.getModality() %></td>
                        <td><%= seatsAvail %> / <%= r.getCapacity() %></td>
                        <td><%= wlAvail %> / <%= r.getWaitlistCapacity() %></td>
                        <td><span class="<%= statusClass %>"><%= status %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else if (searched != null && searched) { %>
            <p class="no-results">No courses found matching your criteria.</p>
        <% } %>
    </main>
</body>
</html>