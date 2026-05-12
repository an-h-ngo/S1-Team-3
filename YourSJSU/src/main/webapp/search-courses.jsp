<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
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
    <title>YourSJSU - Search Courses</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    List<SectionResult> results = (List<SectionResult>) request.getAttribute("results");
    Boolean searched = (Boolean) request.getAttribute("searched");
    String returnQuery = (String) request.getAttribute("returnQuery");
    String escapedReturnQuery = h(returnQuery);
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div id="confirmModal" class="modal-overlay" style="display:none">
        <div class="modal-box">
            <p id="confirmMessage">Confirm this action?</p>
            <div class="modal-buttons">
                <button class="btn-confirm" type="button" onclick="confirmRegistrationAction()">Yes</button>
                <button class="btn-cancel" type="button" onclick="closeRegistrationModal()">Cancel</button>
            </div>
        </div>
    </div>

    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Student Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/student-dashboard" aria-label="Overview"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Overview</span></a>
                <a class="active" href="${pageContext.request.contextPath}/search-courses" aria-label="Course Search"><span class="nav-icon nav-icon-search" aria-hidden="true"></span><span class="nav-label">Course Search</span></a>
                <a href="${pageContext.request.contextPath}/schedule" aria-label="Term Schedule"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Term Schedule</span></a>
                <a href="${pageContext.request.contextPath}/transcript" aria-label="Transcript"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Transcript</span></a>
                <a href="${pageContext.request.contextPath}/financial-summary" aria-label="Finances"><span class="nav-icon nav-icon-finances" aria-hidden="true"></span><span class="nav-label">Finances</span></a>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= h(user != null ? user.getFirstName() + " " + user.getLastName() : "Student") %></strong>
                        <span><%= h(user != null ? "ID " + user.getSjsuId() : "YourSJSU") %></span>
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
                    <p>Registration</p>
                    <h1>Course search</h1>
                </div>
            </header>

            <form method="get" action="${pageContext.request.contextPath}/search-courses" class="search-form">
                <div class="search-row">
                    <input type="text" name="keyword" placeholder="Course title keyword" value="<%= h(request.getAttribute("keyword")) %>">
                    <input type="text" name="courseNumber" placeholder="Course number, e.g. 157A" value="<%= h(request.getAttribute("courseNumber")) %>">
                    <input type="text" name="instructorName" placeholder="Instructor name" value="<%= h(request.getAttribute("instructorName")) %>">
                    <input type="text" name="departmentCode" placeholder="Department code, e.g. CS" value="<%= h(request.getAttribute("departmentCode")) %>">
                    <select name="termId">
                        <option value="">All Terms</option>
                        <%
                            List<String[]> terms = (List<String[]>) request.getAttribute("terms");
                            String selectedTerm = (String) request.getAttribute("termId");
                            if (terms != null) {
                                for (String[] term : terms) {
                                    String sel = term[0].equals(selectedTerm) ? "selected" : "";
                        %>
                            <option value="<%= h(term[0]) %>" <%= sel %>><%= h(term[1]) %></option>
                        <%      }
                            }
                        %>
                    </select>
                    <button type="submit" class="btn-search">Search</button>
                </div>
            </form>

            <% String error = (String) request.getAttribute("error"); if (error != null) { %>
                <div class="error-message"><%= h(error) %></div>
            <% } %>
            <% String success = (String) request.getAttribute("success"); if (success != null) { %>
                <div class="success-message"><%= h(success) %></div>
            <% } %>

            <% if (results != null && !results.isEmpty()) { %>
            <article class="card">
                <h2>Search results</h2>
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
                                <th>Action</th>
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
                                <td class="mono"><%= h(r.getDepartmentCode()) %> <%= h(r.getCourseNumber()) %></td>
                                <td><strong><%= h(r.getCourseTitle()) %></strong></td>
                                <td><%= r.getUnits() %></td>
                                <td><%= h(r.getTermName()) %></td>
                                <td><%= h(r.getInstructorName()) %></td>
                                <td><%= h(r.getMeetingDays()) %> <%= h(r.getStartTime()) %> - <%= h(r.getEndTime()) %></td>
                                <td><%= h(r.getLocation()) %></td>
                                <td><%= h(r.getModality()) %></td>
                                <td><%= seatsAvail %> / <%= r.getCapacity() %></td>
                                <td><%= wlAvail %> / <%= r.getWaitlistCapacity() %></td>
                                <td><span class="<%= statusClass %>"><%= status %></span></td>
                                <td>
                                    <% if (seatsAvail > 0) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/enroll-section" onsubmit="return confirmRegistration(this, 'Enroll in this class?', 'Yes, Enroll')">
                                            <input type="hidden" name="sectionId" value="<%= r.getSectionId() %>">
                                            <input type="hidden" name="returnQuery" value="<%= escapedReturnQuery %>">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <button type="submit" class="btn-search">Enroll</button>
                                        </form>
                                    <% } else if (wlAvail > 0) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/join-waitlist" onsubmit="return confirmRegistration(this, 'Join the waitlist for this class?', 'Yes, Join Waitlist')">
                                            <input type="hidden" name="sectionId" value="<%= r.getSectionId() %>">
                                            <input type="hidden" name="returnQuery" value="<%= escapedReturnQuery %>">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <button type="submit" class="btn-search">Join Waitlist</button>
                                        </form>
                                    <% } else { %>
                                        <span class="no-results">Unavailable</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </article>
            <% } else if (searched != null && searched) { %>
                <p class="no-results">No courses found matching your criteria.</p>
            <% } %>
        </main>
    </div>

    <script>
        let pendingRegistrationForm = null;

        function confirmRegistration(form, message, confirmLabel) {
            pendingRegistrationForm = form;
            document.getElementById('confirmMessage').textContent = message;
            document.querySelector('#confirmModal .btn-confirm').textContent = confirmLabel;
            document.getElementById('confirmModal').style.display = 'flex';
            return false;
        }

        function confirmRegistrationAction() {
            if (pendingRegistrationForm) {
                pendingRegistrationForm.submit();
            }
        }

        function closeRegistrationModal() {
            document.getElementById('confirmModal').style.display = 'none';
            pendingRegistrationForm = null;
        }
    </script>
</body>
</html>
