<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Course" %>
<%@ page import="java.util.List" %>
<%!
    private String h(Object value) {
        if (value == null) return "";
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Complete Classes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User currentUser = (User) session.getAttribute("user");
    List<Course> sections = (List<Course>) request.getAttribute("sections");
    List<User> students = (List<User>) request.getAttribute("students");
    String selectedSectionId = (String) request.getAttribute("selectedSectionId");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String userInitials = currentUser != null && currentUser.getFirstName() != null && currentUser.getLastName() != null && currentUser.getFirstName().length() > 0 && currentUser.getLastName().length() > 0
            ? (currentUser.getFirstName().substring(0, 1) + currentUser.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Faculty Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/faculty-dashboard" aria-label="Faculty Dashboard"><span class="nav-icon nav-icon-faculty" aria-hidden="true"></span><span class="nav-label">Faculty Dashboard</span></a>
                <a href="${pageContext.request.contextPath}/manage-students" aria-label="Manage Students"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Manage Students</span></a>
                <a href="${pageContext.request.contextPath}/manage-sections" aria-label="Manage Sections"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Manage Sections</span></a>
                <a class="active" href="${pageContext.request.contextPath}/complete-classes" aria-label="Complete Classes"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Complete Classes</span></a>
                <% if (currentUser != null && currentUser.getIsStudent() && currentUser.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role" aria-label="Switch Role"><span class="nav-icon nav-icon-switch" aria-hidden="true"></span><span class="nav-label">Switch Role</span></a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= h(currentUser != null ? currentUser.getFirstName() + " " + currentUser.getLastName() : "Faculty") %></strong>
                        <span><%= h(currentUser != null ? "ID " + currentUser.getSjsuId() : "YourSJSU") %></span>
                    </div>
                </summary>
                <div class="account-menu">
                    <a href="${pageContext.request.contextPath}/change-password">Change password</a>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <button type="submit" class="signout-action">Sign out</button>
                    </form>
                </div>
            </details>
        </aside>

        <main class="portal-main">
            <header class="topbar">
                <div class="title-block">
                    <p>Grade completion</p>
                    <h1>Complete classes</h1>
                </div>
            </header>

            <% if ("completed".equals(success)) { %>
                <div class="success-message">Student enrollment completed.</div>
            <% } %>
            <% if (error != null) { %>
                <div class="error-message"><%= "bad-input".equals(error) ? "Please select a student, section, and grade." : "Unable to complete enrollment." %></div>
            <% } %>

            <section class="financial-section">
                <h2>Select Section</h2>
                <% if (sections == null || sections.isEmpty()) { %>
                    <p class="no-results">No assigned sections found.</p>
                <% } else { %>
                    <form method="get" action="${pageContext.request.contextPath}/complete-classes" class="term-filter-form" style="grid-template-columns:minmax(260px, 1fr) auto;">
                        <label for="sectionId" class="eyebrow">Assigned section</label>
                        <select id="sectionId" name="sectionId" onchange="this.form.submit()">
                            <% for (Course section : sections) {
                                String selected = String.valueOf(section.getSectionId()).equals(selectedSectionId) ? "selected" : "";
                            %>
                                <option value="<%= section.getSectionId() %>" <%= selected %>><%= h(section.getCourseTitle()) %> - <%= h(section.getTermName()) %></option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn-search">View Students</button>
                    </form>
                <% } %>
            </section>

            <section class="financial-section">
                <h2>Enrolled Students</h2>
                <% if (students == null || students.isEmpty()) { %>
                    <p class="no-results">No active enrolled students in this section.</p>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="results-table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>SJSU ID</th>
                                    <th>Email</th>
                                    <th>Grade</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User student : students) {
                                    String formId = "completeForm" + student.getUserId();
                                %>
                                    <tr>
                                        <td><strong><%= h(student.getLastName()) %>, <%= h(student.getFirstName()) %></strong></td>
                                        <td><%= h(student.getSjsuId()) %></td>
                                        <td><%= h(student.getEmail()) %></td>
                                        <td>
                                            <select name="grade" form="<%= formId %>" required>
                                                <option value="">Select grade</option>
                                                <option value="A+">A+</option><option value="A">A</option><option value="A-">A-</option>
                                                <option value="B+">B+</option><option value="B">B</option><option value="B-">B-</option>
                                                <option value="C+">C+</option><option value="C">C</option><option value="C-">C-</option>
                                                <option value="D+">D+</option><option value="D">D</option><option value="D-">D-</option>
                                                <option value="F">F</option><option value="W">W</option><option value="I">I</option><option value="IP">IP</option>
                                            </select>
                                        </td>
                                        <td>
                                            <form id="<%= formId %>" method="post" action="${pageContext.request.contextPath}/complete-classes" style="margin:0;">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <input type="hidden" name="sectionId" value="<%= h(selectedSectionId) %>">
                                                <input type="hidden" name="studentId" value="<%= student.getUserId() %>">
                                                <button type="submit" class="btn-search">Complete</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>
