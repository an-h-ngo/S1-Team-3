
# YourSJSU

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
  2. Run the full yoursjsu database script, which will create all the tables and sample data
  3. Optional: run database/demo_accounts.sql to add safe local demo accounts
  4. Update src/main/java/com/yoursjsu/dao/DatabaseConnection.java with your MySQL Workbench password
```

## Demo Accounts

For local testing, run `database/demo_accounts.sql` after loading the main database dump. It creates safe dummy accounts only:

| Role | Email | Password |
|---|---|---|
| Student | `student@sjsu.edu` | `password123` |
| Faculty | `faculty@sjsu.edu` | `password123` |
| Student + Faculty | `ta@sjsu.edu` | `password123` |

Demo passwords are stored as bcrypt hashes in `database/demo_accounts.sql`.

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

## Implemented Student Functional Requirements (Updated 5/11/2026)

- [Vincent (50%), An (50%)] FR-S1: Authentication (Student) - Users can log in and log out. Passwords are verified with bcrypt, legacy/plain passwords are upgraded after successful login. Authenticated requests are backed by the database `session` table, protected JSPs are guarded by an auth filter, dual-role users choose whether to continue as student or faculty, can switch roles during a session, and pages are restricted by the active role.
- [Nathan (50%), An (50%)] FR-S2: View Student Dashboard - Students can view hold status, registration status, active enrollments, and active waitlists from the database.
- [Vincent] FR-S3: Search for Courses - Users can search for courses using various search filters and criteria. Search results include live enrollment/waitlist counts and registration actions.
- [An] FR-S4: Enroll in a Section - Students can enroll in open sections after eligibility, same-course/same-term duplicate prevention, waitlist conflict, capacity, and registration window checks. Enrollment asks for confirmation and supports re-enrollment before the term registration deadline.
- [An] FR-S5: Join a Waitlist - Students can join a waitlist when a section is full, registration is open, prerequisites are satisfied, no same-course enrollment conflict exists, and waitlist capacity remains. Waitlist requests ask for confirmation before submission.
- [Nathan (50%), An (50%)] FR-S6: Drop a Course - Students can drop an enrolled course through a transactional server-side update that marks the enrollment dropped, records the drop timestamp when the term deadline allows it, and automatically promotes the earliest eligible waitlisted student when a seat opens. Drop asks for confirmation before submission.
- [Nathan (70%), An (30%)] FR-S7: View Schedule - Students can view their current and completed courses with section meeting details.
- [Nathan (50%), An (50%)] FR-S8: View Transcript - Students can view their GPA, completed classes, grades, and term names. Dropped in-progress classes remain in the database but are not shown on the transcript.
- [Vincent] FR-S9: View Financial Summary - Student can view their tuition balance, payments, and charges by term.
- [Vincent (70%), An (30%)] FR-S10: Password change - Users can change their password, which stores a bcrypt hash, updates the last-changed timestamp, rejects same-password updates, invalidates the web session, and redirects them to login.
- [Nathan] FR-S11: Course Information - Students can view the course information details including the start/end time, waitlist capacity, and more.

## Implemented Faculty Functional Requirements (Updated 5/11/2026)

- [Vincent (50%), An (50%)] FR-D1: Authentication (Faculty) - Faculty can log in, log out, select the faculty role when applicable, and access faculty-only pages through the shared authentication and role-checking flow.
- [An] FR-D2: View Student's Profile - Faculty can view student profile rows through Manage Students, including name, SJSU ID, email, account status, and hold count.
- [Vincent] FR-D3: Lift/Place Holds - Faculty can place a financial hold on a student account or lift existing holds through Manage Students.
- [Vincent] FR-D4: Denying/Granting Access to Students - Faculty can activate or deactivate student accounts through Manage Students.
- [Vincent] FR-D5: Adding Classes - Faculty class creation.
- [Vincent] FR-D6: Removing Classes - Faculty class removal.
- [Nathan] FR-D7: Update Course Information - Faculty class editing, including changing start/end time, course title, and professor.
- [Vincent (70%), An (30%)] FR-D8: Change Password (Faculty) - Faculty can change their password through the same bcrypt-backed password change flow used by students.
- [An] FR-F9: Faculty Dashboard - Faculty can view title, department, and assigned teaching sections with enrolled counts.
- [An] FR-D9: Complete Classes - Faculty can select one of their assigned sections, view actively enrolled students, assign a final letter grade, and mark the enrollment completed so it appears on the student transcript.
