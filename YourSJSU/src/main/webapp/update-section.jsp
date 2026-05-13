<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Update Section</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User currentUser = (User) session.getAttribute("user");
    SectionResult s = (SectionResult) request.getAttribute("section");
    
    String userInitials = currentUser != null && currentUser.getFirstName() != null
            ? (currentUser.getFirstName().substring(0,1) + currentUser.getLastName().substring(0,1)).toUpperCase()
            : "SJ";
%>
<div class="portal-shell">
    <aside class="portal-rail" aria-label="Portal navigation">
        <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Faculty Portal</span></div></div>
        <nav class="portal-nav">
            <a href="${pageContext.request.contextPath}/faculty-dashboard"><span class="nav-icon nav-icon-faculty"></span><span class="nav-label">Faculty Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/manage-students"><span class="nav-icon nav-icon-overview"></span><span class="nav-label">Manage Students</span></a>
            <a class="active" href="${pageContext.request.contextPath}/manage-sections"><span class="nav-icon nav-icon-schedule"></span><span class="nav-label">Manage Sections</span></a>
            <a href="${pageContext.request.contextPath}/complete-classes"><span class="nav-icon nav-icon-transcript"></span><span class="nav-label">Complete Classes</span></a>
        </nav>
        <details class="account-menu-wrap">
            <summary class="rail-footer">
                <div class="footer-icon"><%= userInitials %></div>
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
                <h1>Update Section</h1>
            </div>
            <a href="${pageContext.request.contextPath}/manage-sections" class="btn">← Back to Sections</a>
        </header>

        <% String result = request.getParameter("result");
           if ("error".equals(result)) { %>
            <div class="error-message">Update failed. Please try again.</div>
        <% } %>

        <section class="financial-section">
            <h2><%= s.getDepartmentCode() %> <%= s.getCourseNumber() %> — <%= s.getCourseTitle() %></h2>

            <form method="post" action="${pageContext.request.contextPath}/update-section"
                  class="search-form section-admin-form">
                <input type="hidden" name="sectionId" value="<%= s.getSectionId() %>">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="search-row">
                    <label style="flex:1;">
                        Course
                        <select name="courseId" required style="width:100%;padding:10px 12px;">
                            <% List<String[]> courses = (List<String[]>) request.getAttribute("courses");
                               if (courses != null) for (String[] c : courses) {
                                   boolean selected = c[0].equals(String.valueOf(s.getCourseId())); %>
                                <option value="<%= c[0] %>" <%= selected ? "selected" : "" %>><%= c[1] %></option>
                            <% } %>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Term
                        <select name="termId" required style="width:100%;padding:10px 12px;">
                            <% List<String[]> terms = (List<String[]>) request.getAttribute("terms");
                               if (terms != null) for (String[] t : terms) {
                                   boolean selected = t[0].equals(String.valueOf(s.getTermId())); %>
                                <option value="<%= t[0] %>" <%= selected ? "selected" : "" %>><%= t[1] %></option>
                            <% } %>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Professor
                        <select name="facultyId" required style="width:100%;padding:10px 12px;">
                            <% List<String[]> faculty = (List<String[]>) request.getAttribute("faculty");
                               if (faculty != null) for (String[] f : faculty) {
                                   boolean selected = f[0].equals(String.valueOf(s.getFacultyId())); %>
                                <option value="<%= f[0] %>" <%= selected ? "selected" : "" %>><%= f[1] %></option>
                            <% } %>
                        </select>
                    </label>
                </div>

                <div class="search-row">
                    <label style="flex:1;">
                        Meeting Days
                        <input type="text" name="meetingDays" value="<%= s.getMeetingDays() %>"
                               maxlength="10" required style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
					    Start Time
					    <div style="display:flex;gap:6px;align-items:center;">
					        <%
					            String[] startParts = s.getStartTime() != null ? s.getStartTime().split(":") : new String[]{"08","00"};
					            int startH24 = Integer.parseInt(startParts[0]);
					            int startMin = Integer.parseInt(startParts.length > 1 ? startParts[1] : "00");
					            int startH12 = startH24 % 12 == 0 ? 12 : startH24 % 12;
					            String startAmPm = startH24 < 12 ? "AM" : "PM";
					        %>
					        <select name="startHour" required style="flex:1;padding:10px 12px;">
					            <% for (int h = 1; h <= 12; h++) { %>
					                <option value="<%= h %>" <%= h == startH12 ? "selected" : "" %>><%= h %></option>
					            <% } %>
					        </select>
					        <span>:</span>
					        <select name="startMinute" required style="flex:1;padding:10px 12px;">
					            <% for (int m = 0; m < 60; m += 5) {
					                String mv = String.format("%02d", m); %>
					                <option value="<%= mv %>" <%= m == startMin ? "selected" : "" %>><%= mv %></option>
					            <% } %>
					        </select>
					        <select name="startAmPm" required style="flex:1;padding:10px 12px;">
					            <option value="AM" <%= "AM".equals(startAmPm) ? "selected" : "" %>>AM</option>
					            <option value="PM" <%= "PM".equals(startAmPm) ? "selected" : "" %>>PM</option>
					        </select>
					    </div>
					</label>
                    <label style="flex:1;">
					    End Time
					    <div style="display:flex;gap:6px;align-items:center;">
					        <%
					            String[] endParts = s.getEndTime() != null ? s.getEndTime().split(":") : new String[]{"09","00"};
					            int endH24 = Integer.parseInt(endParts[0]);
					            int endMin = Integer.parseInt(endParts.length > 1 ? endParts[1] : "00");
					            int endH12 = endH24 % 12 == 0 ? 12 : endH24 % 12;
					            String endAmPm = endH24 < 12 ? "AM" : "PM";
					        %>
					        <select name="endHour" required style="flex:1;padding:10px 12px;">
					            <% for (int h = 1; h <= 12; h++) { %>
					                <option value="<%= h %>" <%= h == endH12 ? "selected" : "" %>><%= h %></option>
					            <% } %>
					        </select>
					        <span>:</span>
					        <select name="endMinute" required style="flex:1;padding:10px 12px;">
					            <% for (int m = 0; m < 60; m += 5) {
					                String mv = String.format("%02d", m); %>
					                <option value="<%= mv %>" <%= m == endMin ? "selected" : "" %>><%= mv %></option>
					            <% } %>
					        </select>
					        <select name="endAmPm" required style="flex:1;padding:10px 12px;">
					            <option value="AM" <%= "AM".equals(endAmPm) ? "selected" : "" %>>AM</option>
					            <option value="PM" <%= "PM".equals(endAmPm) ? "selected" : "" %>>PM</option>
					        </select>
					    </div>
					</label>
                </div>

                <div class="search-row">
                    <label style="flex:1;">
                        Location
                        <input type="text" name="location" value="<%= s.getLocation() %>"
                               required style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Modality
                        <select name="modality" required style="width:100%;padding:10px 12px;">
                            <option value="in_person"  <%= "in_person".equals(s.getModality())  ? "selected" : "" %>>in-person</option>
                            <option value="online"     <%= "online".equals(s.getModality())     ? "selected" : "" %>>online</option>
                            <option value="hybrid"     <%= "hybrid".equals(s.getModality())     ? "selected" : "" %>>hybrid</option>
                        </select>
                    </label>
                    <label style="flex:1;">
                        Capacity
                        <input type="number" name="capacity" value="<%= s.getCapacity() %>"
                               min="1" required style="width:100%;padding:10px 12px;">
                    </label>
                    <label style="flex:1;">
                        Waitlist Capacity
                        <input type="number" name="waitlistCapacity" value="<%= s.getWaitlistCapacity() %>"
                               min="0" required style="width:100%;padding:10px 12px;">
                    </label>
                </div>

                <div class="search-row">
                    <button type="submit" class="btn-search">Save Changes</button>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>