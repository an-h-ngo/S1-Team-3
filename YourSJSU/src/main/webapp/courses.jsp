<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Courses</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
    <style>
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-box {
            background: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .modal-box p {
            margin-bottom: 20px;
            font-size: 16px;
        }
        .modal-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn-confirm {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-cancel {
            background: #95a5a6;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body class="dashboard-page">

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal-overlay" style="display:none">
        <div class="modal-box">
            <p>Are you sure you want to remove this course?</p>
            <div class="modal-buttons">
                <button class="btn-confirm" onclick="confirmRemove()">Yes</button>
                <button class="btn-cancel" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>

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
                <input type="hidden" name="csrfToken" value="${csrfToken}">
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
        <div class="nav-link" onclick="goTo('/change-password')">
            Reset Password
        </div>
    </nav>

    <script>
        function goTo(path) {
            window.location.href = "<%= request.getContextPath() %>" + path;
        }

        let currentBtn = null;

        function removeCourse(btn) {
            currentBtn = btn;
            document.getElementById('confirmModal').style.display = 'flex';
        }

        function confirmRemove() {
            if (currentBtn) {
                currentBtn.parentElement.remove();
            }
            closeModal();
        }

        function closeModal() {
            document.getElementById('confirmModal').style.display = 'none';
            currentBtn = null;
        }
    </script>

    <main class="dashboard-content">

        <section class="card">
            <h2>My Schedule</h2>
            <%
                List<String> sections = (List<String>) request.getAttribute("sections");
            %>
            <ul class="course-list" id="sectionList">
                <%
                    if (sections != null) {
                        for (String s : sections) {
                %>
                    <li class="course-item">
                        <span class="course-name"><%=s%></span>
                        <button class="remove-btn" onclick="removeCourse(this)">Remove</button>
                    </li>
                <%
                        }
                    }
                %>
            </ul>
        </section>

        <section class="card">
            <h2>Courses Taken</h2>
            <%
                List<String> courses = (List<String>) request.getAttribute("courses");
            %>
            <ul class="course-list" id="courseList">
                <%
                    if (courses != null) {
                        for (String c : courses) {
                %>
                    <li class="course-item">
                        <span class="course-name"><%=c%></span>
                    </li>
                <%
                        }
                    }
                %>
            </ul>
        </section>

    </main>
</body>
</html>
