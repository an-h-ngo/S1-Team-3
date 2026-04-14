<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Student Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-center">Courses</div>
        <div class="nav-right">
        
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

    <main class="dashboard-content">
		
        <!-- Example dashboard content -->
        <section class="card">
		    <h2>My Courses</h2>

			<ul class="course-list" id="courseList">
			
			    <li class="course-item">
			        <span class="course-name">Introduction to Java</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			    <li class="course-item">
			        <span class="course-name">Web Development</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			    <li class="course-item">
			        <span class="course-name">Database Systems</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			    <li class="course-item">
			        <span class="course-name">Introduction to Database Management</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			    <li class="course-item">
			        <span class="course-name">Introduction to Data Structures</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			    <li class="course-item">
			        <span class="course-name">Meteorology</span>
			        <button class="remove-btn" onclick="removeCourse(this)">-</button>
			    </li>
			
			</ul>
		</section>
    </main>
</body>
</html>