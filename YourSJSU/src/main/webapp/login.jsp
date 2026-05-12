<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Sign In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260512-sliding-login">
</head>
<body class="login-page">
    <%
        String selectedRole = (String) request.getAttribute("selectedRole");
        boolean facultySelected = "faculty".equals(selectedRole);
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
    %>
    <main class="sliding-login <%= facultySelected ? "faculty-panel-active" : "" %>" id="loginContainer">
        <section class="login-form-panel student-login-panel" aria-label="Student login form">
            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form sliding-role-form">
                <input type="hidden" name="role" value="student">
                <div class="login-form-brand">
                    <div class="seal">SJ</div>
                    <strong>YourSJSU</strong>
                </div>
                <h1>Student Sign In</h1>
                <span>Access registration, schedule, transcript, and finances.</span>

                <% if (!facultySelected && success != null) { %>
                    <div class="success-message"><%= success %></div>
                <% } %>
                <% if (!facultySelected && error != null) { %>
                    <div class="error-message"><%= error %></div>
                <% } %>

                <div class="form-group">
                    <label for="studentIdentifier">SJSU ID or Email</label>
                    <input type="text" id="studentIdentifier" name="identifier"
                           placeholder="e.g. student@sjsu.edu" required>
                </div>

                <div class="form-group">
                    <label for="studentPassword">Password</label>
                    <input type="password" id="studentPassword" name="password"
                           placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn-login">Sign In as Student</button>
            </form>
        </section>

        <section class="login-form-panel faculty-login-panel" aria-label="Faculty login form">
            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form sliding-role-form">
                <input type="hidden" name="role" value="faculty">
                <div class="login-form-brand">
                    <div class="seal">SJ</div>
                    <strong>YourSJSU</strong>
                </div>
                <h1>Faculty Sign In</h1>
                <span>Manage students, teaching sections, and faculty tools.</span>

                <% if (facultySelected && success != null) { %>
                    <div class="success-message"><%= success %></div>
                <% } %>
                <% if (facultySelected && error != null) { %>
                    <div class="error-message"><%= error %></div>
                <% } %>

                <div class="form-group">
                    <label for="facultyIdentifier">SJSU ID or Email</label>
                    <input type="text" id="facultyIdentifier" name="identifier"
                           placeholder="e.g. faculty@sjsu.edu" required>
                </div>

                <div class="form-group">
                    <label for="facultyPassword">Password</label>
                    <input type="password" id="facultyPassword" name="password"
                           placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn-login">Sign In as Faculty</button>
            </form>
        </section>

        <section class="login-overlay-container" aria-label="Role selection">
            <div class="login-overlay">
                <div class="login-overlay-panel login-overlay-left">
                    <img src="${pageContext.request.contextPath}/images/sjsu-campus.jpg"
                         alt="San Jose State University campus" class="login-role-image">
                    <span class="eyebrow">Faculty Portal</span>
                    <h2>Shaping the future. Building the next generation of scholars.</h2>
                    <button type="button" class="btn-login-ghost" id="studentLogin">Student Login</button>
                </div>
                <div class="login-overlay-panel login-overlay-right">
                    <img src="${pageContext.request.contextPath}/images/tower-hall.jpg"
                         alt="Tower Hall at San Jose State University" class="login-role-image">
                    <span class="eyebrow">Student Portal</span>
                    <h2>Your education begins here. Find everything you need to succeed.</h2>
                    <button type="button" class="btn-login-ghost" id="facultyLogin">Faculty Login</button>
                </div>
            </div>
        </section>
    </main>

    <footer class="login-footer">
        <p>CS 157A - Team 3</p>
    </footer>

    <script>
        const facultyLoginButton = document.getElementById('facultyLogin');
        const studentLoginButton = document.getElementById('studentLogin');
        const loginContainer = document.getElementById('loginContainer');

        facultyLoginButton.addEventListener('click', () => {
            loginContainer.classList.add('faculty-panel-active');
        });

        studentLoginButton.addEventListener('click', () => {
            loginContainer.classList.remove('faculty-panel-active');
        });
    </script>
</body>
</html>
