<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Manage Sections</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-right">
            <%
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span class="nav-user"><%= currentUser.getFirstName() %> <%= currentUser.getLastName() %></span>
            <% } %>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-logout-form">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>

    <main class="search-content">
        <h1>Manage Sections</h1>
        <p class="dashboard-subtitle" style="text-align:left;margin-bottom:18px;">
            Faculty tools for adding new sections (FR-D5) and removing existing sections (FR-D6).
        </p>

        <%
            String result = request.getParameter("result");
            if (result != null) {
                String msg;
                String msgClass;
                if      ("added".equals(result))        { msg = "Section added.";                          msgClass = "success-message"; }
                else if ("ok".equals(result))           { msg = "Section removed.";                        msgClass = "success-message"; }
                else if ("has-students".equals(result)) { msg = "Cannot remove — students are enrolled or waitlisted in this section."; msgClass = "error-message"; }
                else if ("bad-input".equals(result))    { msg = "Invalid form input. Please fill in every field with the correct type."; msgClass = "error-message"; }
                else                                    { msg = "Action failed.";                           msgClass = "error-message"; }
        %>
            <div class="<%= msgClass %>"><%= msg %></div>
        <% } %>

        <!-- ========== ADD A NEW SECTION ========== -->
        <section class="financial-section">
            <h2>Add a New Section (FR-D5)</h2>

            <form method="post" action="${pageContext.request.contextPath}/manage-sections" class="search-form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="search-row">
                    <label style="flex:1;">
                        Course
                        <select name="courseId" required style="width:100%;padding:10px 12px;">
                            <option value="">— select a course —</option>
                            <% List<String[]> courses = (List<String[]>) request.getAttribute("courses");
                               if (courses != null) for (String[] c : courses) { %>
                                <option value="<%= c[0] %>"><%= c[1] %></option>
                            <% } %>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Term
                        <select name="termId" required style="width:100%;padding:10px 12px;">
                            <option value="">— select a term —</option>
                            <% List<String[]> terms = (List<String[]>) request.getAttribute("terms");
                               if (terms != null) for (String[] t : terms) { %>
                                <option value="<%= t[0] %>"><%= t[1] %></option>
                            <% } %>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Professor
                        <select name="facultyId" style="width:100%;padding:10px 12px;">
                            <option value="">— unassigned —</option>
                            <% List<String[]> faculty = (List<String[]>) request.getAttribute("faculty");
                               if (faculty != null) for (String[] f : faculty) { %>
                                <option value="<%= f[0] %>"><%= f[1] %></option>
                            <% } %>
                        </select>
                    </label>
                </div>

                <div class="search-row">
                    <label style="flex:1;">
                        Meeting Days
                        <input type="text" name="meetingDays" placeholder="e.g. MW or TR" maxlength="10"
                               style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Start Time
                        <input type="time" name="startTime" style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        End Time
                        <input type="time" name="endTime" style="width:100%;padding:10px 12px;">
                    </label>
                </div>

                <div class="search-row">
                    <label style="flex:1;">
                        Location
                        <input type="text" name="location" placeholder="e.g. DH 282 or Online"
                               style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Modality
                        <select name="modality" required style="width:100%;padding:10px 12px;">
                            <option value="in-person">in-person</option>
                            <option value="online">online</option>
                            <option value="hybrid">hybrid</option>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Capacity
                        <input type="number" name="capacity" min="1" value="30" required
                               style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Waitlist Capacity
                        <input type="number" name="waitlistCapacity" min="0" value="10" required
                               style="width:100%;padding:10px 12px;">
                    </label>
                </div>

                <div class="search-row">
                    <button type="submit" class="btn-search">Add Section</button>
                </div>
            </form>
        </section>

        <!-- ========== REMOVE A SECTION ========== -->
        <section class="financial-section">
            <h2>Existing Sections (FR-D6)</h2>

            <%
                List<SectionResult> sections = (List<SectionResult>) request.getAttribute("sections");
                if (sections == null || sections.isEmpty()) {
            %>
                <p class="no-results">No sections in the database.</p>
            <% } else { %>
                <div class="table-wrapper">
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>Course</th>
                                <th>Title</th>
                                <th>Term</th>
                                <th>Days/Time</th>
                                <th>Location</th>
                                <th>Mode</th>
                                <th>Capacity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (SectionResult r : sections) {
                                String label = r.getDepartmentCode() + " " + r.getCourseNumber() + " - " + r.getCourseTitle();
                            %>
                            <tr>
                                <td><%= r.getDepartmentCode() %> <%= r.getCourseNumber() %></td>
                                <td><%= r.getCourseTitle() %></td>
                                <td><%= r.getTermName() %></td>
                                <td><%= r.getMeetingDays() %> <%= r.getStartTime() %> - <%= r.getEndTime() %></td>
                                <td><%= r.getLocation() %></td>
                                <td><%= r.getModality() %></td>
                                <td><%= r.getCapacity() %></td>
                                <td>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/manage-sections"
                                          onsubmit="return confirm('Remove <%= label.replace("'", "") %>?');"
                                          style="margin:0;">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="sectionId" value="<%= r.getSectionId() %>">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <button type="submit" class="btn-drop">Remove</button>
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
</body>
</html>
