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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User currentUser = (User) session.getAttribute("user");
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
                <a class="active" href="${pageContext.request.contextPath}/manage-sections" aria-label="Manage Sections"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Manage Sections</span></a>
                <a href="${pageContext.request.contextPath}/complete-classes" aria-label="Complete Classes"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Complete Classes</span></a>
                <% if (currentUser != null && currentUser.getIsStudent() && currentUser.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role" aria-label="Switch Role"><span class="nav-icon nav-icon-switch" aria-hidden="true"></span><span class="nav-label">Switch Role</span></a>
                <% } %>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= currentUser != null ? currentUser.getFirstName() + " " + currentUser.getLastName() : "Faculty" %></strong>
                        <span><%= currentUser != null ? "ID " + currentUser.getSjsuId() : "YourSJSU" %></span>
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
                    <p>Section administration</p>
                    <h1>Manage sections</h1>
                </div>
            </header>

        <%
            String result = request.getParameter("result");
            if (result != null) {
                String msg;
                String msgClass;
                if      ("added".equals(result))        { msg = "Section added.";                          msgClass = "success-message"; }
                else if ("updated".equals(result))      { msg = "Section updated.";                        msgClass = "success-message"; }
                else if ("ok".equals(result))           { msg = "Section removed.";                        msgClass = "success-message"; }
                else if ("has-students".equals(result)) { msg = "Cannot remove — students are enrolled or waitlisted in this section."; msgClass = "error-message"; }
                else if ("bad-input".equals(result))    { msg = "Invalid form input. Please fill in every field with the correct type."; msgClass = "error-message"; }
                else                                    { msg = "Action failed.";                           msgClass = "error-message"; }
        %>
            <div class="<%= msgClass %>"><%= msg %></div>
        <% } %>

        <section class="financial-section">
            <h2>Add a New Section</h2>

            <form method="post" action="${pageContext.request.contextPath}/manage-sections" class="search-form section-admin-form">
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
                        <select name="facultyId" required style="width:100%;padding:10px 12px;">
                            <option value="">— select a professor —</option>
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
                        <input type="text" name="meetingDays" placeholder="e.g. MW or TR" maxlength="10" required
                               style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Start Time
                        <input type="time" name="startTime" required style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        End Time
                        <input type="time" name="endTime" required style="width:100%;padding:10px 12px;">
                    </label>
                </div>

                <div class="search-row">
                    <label style="flex:1;">
                        Location
                        <input type="text" name="location" placeholder="e.g. DH 282 or Online"
                               required style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Modality
                        <select name="modality" required style="width:100%;padding:10px 12px;">
                            <option value="in_person">in-person</option>
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

        <section class="financial-section">
            <h2>Existing Sections</h2>

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
                            <tr style="cursor:pointer;" 
    							onclick="if(event.target.closest('form,button')==null) window.location='${pageContext.request.contextPath}/update-section?sectionId=<%= r.getSectionId() %>'">
							
							    <td><%= r.getDepartmentCode() %> <%= r.getCourseNumber() %></td>
							
							    <td><%= r.getCourseTitle() %></td>
							
							    <td><%= r.getTermName() %></td>
							
							    <td>
							        <%= r.getMeetingDays() %>
							        <%= r.getStartTime() %> -
							        <%= r.getEndTime() %>
							    </td>
							
							    <td><%= r.getLocation() %></td>
							
							    <td><%= r.getModality() %></td>
							
							    <td><%= r.getCapacity() %></td>
							
							    <td>
							        <form method="post"
							              action="${pageContext.request.contextPath}/manage-sections"
							              onsubmit="event.stopPropagation(); return confirm('Remove section?');"
							              style="margin:0;">
							
							            <input type="hidden" name="action" value="remove">
							
							            <input type="hidden"
							                   name="sectionId"
							                   value="<%= r.getSectionId() %>">
							
							            <input type="hidden"
							                   name="csrfToken"
							                   value="${csrfToken}">
							
							            <button type="submit"
							                    class="btn-drop"
							                    onclick="event.stopPropagation();">
							
							                Remove
							
							            </button>
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