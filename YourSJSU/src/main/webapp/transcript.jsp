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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    Transcript transcript = (Transcript) request.getAttribute("transcript");
    double totalPoints = 0;
    int totalUnits = 0;
    if (transcript != null && !transcript.getClassStatusList().isEmpty()) {
        for (ClassStatus row : transcript.getClassStatusList()) {
            String grade = row.getLetterGrade();
            int units = row.getUnits();
            if (grade != null) {
                totalUnits += units;
                switch (grade) {
                    case "A": case "A-": case "A+": totalPoints += 4.0 * units; break;
                    case "B": case "B-": case "B+": totalPoints += 3.0 * units; break;
                    case "C": case "C-": case "C+": totalPoints += 2.0 * units; break;
                    case "D": case "D-": case "D+": totalPoints += 1.0 * units; break;
                    default: break;
                }
            }
        }
    }
    double gpa = totalUnits > 0 ? totalPoints / totalUnits : 0.0;
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Student Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/student-dashboard" aria-label="Overview"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Overview</span></a>
                <a href="${pageContext.request.contextPath}/search-courses" aria-label="Course Search"><span class="nav-icon nav-icon-search" aria-hidden="true"></span><span class="nav-label">Course Search</span></a>
                <a href="${pageContext.request.contextPath}/schedule" aria-label="Term Schedule"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Term Schedule</span></a>
                <a class="active" href="${pageContext.request.contextPath}/transcript" aria-label="Transcript"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Transcript</span> <span class="nav-badge"><%= String.format("%.2f", gpa) %></span></a>
                <a href="${pageContext.request.contextPath}/financial-summary" aria-label="Finances"><span class="nav-icon nav-icon-finances" aria-hidden="true"></span><span class="nav-label">Finances</span></a>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= user != null ? user.getFirstName() + " " + user.getLastName() : "Student" %></strong>
                        <span><%= user != null ? "ID " + user.getSjsuId() : "YourSJSU" %></span>
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
                    <p>Academic records</p>
                    <h1>Transcript</h1>
                </div>
            </header>

            <section class="metric-grid">
                <article class="metric-card"><span class="label">Cumulative GPA</span><div class="value"><%= String.format("%.2f", gpa) %></div><small>Calculated from graded units</small></article>
                <article class="metric-card"><span class="label">Completed units</span><div class="value"><%= totalUnits %></div><small>Units with posted grades</small></article>
                <article class="metric-card"><span class="label">Student ID</span><div class="value"><%= user != null ? user.getSjsuId() : "Not on file" %></div><small>Academic record identifier</small></article>
                <article class="metric-card"><span class="label">Status</span><div class="value">Active</div><small>Current student profile</small></article>
            </section>

            <section class="grid two-column" style="margin-top:16px">
                <article class="card">
                    <h2>Student information</h2>
                    <% if (user != null) { %>
                        <div class="list">
                            <div class="row"><div><h4>Name</h4><p><%= user.getFirstName() %> <%= user.getLastName() %></p></div><span class="pill green">Verified</span></div>
                            <div class="row"><div><h4>Email</h4><p><%= user.getEmail() %></p></div><span class="pill">SJSU</span></div>
                        </div>
                    <% } %>
                </article>
                <article class="card">
                    <h2>Academic summary</h2>
                    <p class="dashboard-subtitle">Review completed and in-progress coursework from your academic record.</p>
                    <div class="accent-line"></div>
                    <p><strong>Total Units Completed:</strong> <%= totalUnits %></p>
                    <p><strong>Cumulative GPA:</strong> <%= String.format("%.2f", gpa) %></p>
                </article>
            </section>

            <section class="card" style="margin-top:16px">
                <h2>Academic transcript</h2>
                <% if (transcript != null && !transcript.getClassStatusList().isEmpty()) { %>
                    <div class="table-wrapper">
                        <table class="transcript-table">
                            <thead><tr><th>Course Name</th><th>Units</th><th>Grade</th><th>Term</th></tr></thead>
                            <tbody>
                                <% for (ClassStatus row : transcript.getClassStatusList()) {
                                    String grade = row.getLetterGrade();
                                    if (grade == null) grade = "In Progress";
                                %>
                                    <tr>
                                        <td><%= row.getCourseTitle() %></td>
                                        <td><%= row.getUnits() %></td>
                                        <td><span class="pill <%= "In Progress".equals(grade) ? "gold" : "green" %>"><%= grade %></span></td>
                                        <td><%= row.getTermName() %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p class="no-results">No completed transcript records found.</p>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>
