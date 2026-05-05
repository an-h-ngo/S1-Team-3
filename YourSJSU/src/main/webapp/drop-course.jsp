<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Drop a Course</title>
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
        <div class="nav-link" onclick="goTo('/student-dashboard')">Student Dashboard</div>
        <div class="nav-link" onclick="goTo('/courses')">Courses</div>
        <div class="nav-link" onclick="goTo('/schedule')">Term Schedule</div>
        <div class="nav-link" onclick="goTo('/transcript')">Transcript</div>
        <div class="nav-link" onclick="goTo('/financial-summary')">Financial Summary</div>
    </nav>

    <script>
        function goTo(path) {
            window.location.href = "<%= request.getContextPath() %>" + path;
        }
        function confirmDrop(courseLabel) {
            return confirm("Are you sure you want to drop " + courseLabel + "?");
        }
    </script>

    <main class="search-content">
        <h1>Drop a Course</h1>

        <%
            String dropped = request.getParameter("dropped");
            if ("1".equals(dropped)) {
        %>
            <div class="success-message">Course successfully dropped.</div>
        <% } else if ("0".equals(dropped)) { %>
            <div class="error-message">Could not drop that course (you may not be enrolled in it).</div>
        <% } %>

        <%
            List<SectionResult> enrolled = (List<SectionResult>) request.getAttribute("enrolled");
            if (enrolled == null || enrolled.isEmpty()) {
        %>
            <p class="no-results">You are not currently enrolled in any courses.</p>
        <% } else { %>
            <div class="table-wrapper">
                <table class="results-table">
                    <thead>
                        <tr>
                            <th>Course</th>
                            <th>Title</th>
                            <th>Units</th>
                            <th>Term</th>
                            <th>Days/Time</th>
                            <th>Location</th>
                            <th>Mode</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (SectionResult r : enrolled) {
                            String label = r.getDepartmentCode() + " " + r.getCourseNumber() + " - " + r.getCourseTitle();
                        %>
                        <tr>
                            <td><%= r.getDepartmentCode() %> <%= r.getCourseNumber() %></td>
                            <td><%= r.getCourseTitle() %></td>
                            <td><%= r.getUnits() %></td>
                            <td><%= r.getTermName() %></td>
                            <td><%= r.getMeetingDays() %> <%= r.getStartTime() %> - <%= r.getEndTime() %></td>
                            <td><%= r.getLocation() %></td>
                            <td><%= r.getModality() %></td>
                            <td>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/drop-course"
                                      onsubmit="return confirmDrop('<%= label.replace("'", "") %>');"
                                      style="margin:0">
                                    <input type="hidden" name="sectionId" value="<%= r.getSectionId() %>">
                                    <button type="submit" class="btn-drop">Drop</button>
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
