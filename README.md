
# YourSJSU

Intuitive, Secure, and Responsive School System
CS 157A - Introduction to Database Management Systems | San Jose State University | Team 3
## Team 3 Members

- [@an-h-ngo (An Ngo)](https://github.com/an-h-ngo)
- [@DooVinci (Vincent Do)](https://github.com/DooVinci)
- [@nathan-wong1 (Nathan Wong)](https://github.com/nathan-wong1)
## Overview

YourSJSU is a reimagined student and faculty portal built as a Java web application backed by a MySQL database. It streamlines common university workflows such as registration, class scheduling, transcript access, and financial records.

## Database Tables
- charge
- course
- credential
- department
- department_faculty
- faculty
- payment
- prerequisite
- section
- section
- session
- student
- student_has_enrollment
- student_waitlist
- term
- user

## Tech Stack

**Frontend:** JSP, HTML, CSS, JS

**Backend:** Java Servlets (Servlet 4.0)

**Database:** MySQL 9.6 (via MySQL Workbench 8.0)

**Server:** Apache Tomcat 9

**Java:** Java 8

**IDE:** Eclipse/IntelliJ IDEA
## Prerequisites

- **Java 8+** installed
- **Apache Tomcat 9** installed (e.g. at `C:\tomcat8`)
- **MySQL 9.6** running on `localhost:3306`
- **Eclipse** for compiling the project
## Database Setup

```bash
  1. Open MySQL Workbench and connect to the local MySQL server
  2. Run the full YourSJSU database script, which will create all the tables and sample data
  2. Update src/main/java/com/yoursjsu/dao/DatabaseConnection.java with your MySQL Workbench password
```
## Deployment
- Import the **YourSJSU** folder as an existing project in Eclipse / IntelliJ
- Edit the **DatabaseConnection.java** for your MySQL Workbench setup
- **IMPORTANT — Source folder setup (so package declarations work for everyone):**
  - **Eclipse:** right-click `src/main/java` in Project Explorer > **Build Path** > **Use as Source Folder**
  - **IntelliJ:** right-click `src/main/java` in Project view > **Mark Directory as** > **Sources Root**
  - All Java files MUST use packages like `package com.yoursjsu.dao;` (NOT `package YourSJSU.src.main.java.com.yoursjsu.dao;`). If your IDE auto-generates the long form, your source folder is incorrect. Please fix it using the step above.
- In Eclipse, right-click the **YourSJSU** project > **Properties** > **Java Compiler**
- Enable **project specific settings**
- Set **Compiler compliance level** to **1.8**
- Right-click the project > **Properties** > **Java Build Path** > **Libraries**
- Under **Classpath**, click **Add Library** > **Server Runtime** > select **Apache Tomcat v9.0**
- In **Eclipse**, click **Project** > **Clean**, select **YourSJSU** > **OK**, wait until the bottom-right build progress is done
- Open file explorer to C:\tomcat8\bin\ and paste the files from `\YourSJSU\build\classes\com\` to `C:\tomcat8\webapps\YourSJSU\WEB-INF\classes\com\`
- Then copy the files from `\YourSJSU\src\main\webapp\` to `C:\tomcat8\webapps\YourSJSU\`
- Lastly, copy the files from `YourSJSU\src\main\webapp\css\style.css` to `C:\tomcat8\webapps\YourSJSU\css\style.css`
- Run **startup.bat** in `C:\tomcat8\bin\`
- Go to **http://localhost:8080/YourSJSU/**, and the login page should load
- Run **shutdown.bat** in `C:\tomcat8\bin\` to shutdown the tomcat server
## Functional Requirements (12/18) (Updated 5/5/2026)

- [Vincent] FR-S1: Authentication (Student) - Students must log in using their Student ID and password to access portal functions.
- [Nathan] FR-S2: View Student Dashboard - Students can view a dashboard summarizing the student’s current enrollment, holds, outstanding tasks, and key dates. 
- [Vincent] FR-S3: Search for Courses - Users can search for courses using various search filters and criteria.
- [PENDING] FR-S4: Enroll in a Course - Students can add a course section to their schedule.
- [PENDING] FR-S5: Join/Leave Waitlist - Students can join or drop a currently enrolled course within specified deadlines.
- [Vincent] FR-S6: Drop a Course - Students can drop a course by clicking the garbage button next to the class name in the courses page.
- [Nathan] FR-S7: View Schedule - Students can view the schedule for this term and their previous courses.  If a student wishes to drop a course, simply click the garbage button and the course will be removed.
- [Nathan] FR-S8: View Unofficial Transcript - Students can view their GPA, classes completed, and grades.
- [Vincent] FR-S9: View Financial Summary - Student can view their tuition balance, payments, and charges by term.
- [Vincent] FR-S10: Change Password (Student) - Users can change their password, which updates the database with the new password, redirects them to the login screen for re-login.
- [Vincent] FR-D1: Authentication (Faculty) - Faculty must log in using their Staff ID and password to access faculty portal functions.
- [PENDING] FR-D2: View Student’s Profile - Faculty can view enrolled students’ profiles in the database.
- [Vincent] FR-D3: Lift/Place Holds - Faculty staff can alter the hold status on students’ profiles.
- [Vincent] FR-D4: Denying/Granting Access to Students - Faculty staff can change student account settings, such as placing holds or deactivating their accounts.
- [PENDING] FR-D5: Adding Classes - Faculty can add new classes to the database.
- [PENDING] FR-D6: Removing Classes - Faculty can remove preexisting classes from the database.
- [PENDING] FR-D7: Update Course Information - Faculty can update preexisting classes from the database.
- [Vincent] FR-D8: Change Password (Faculty) - Faculty are able to change their password.
