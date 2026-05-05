
# YourSJSU

Intuitive, Secure, and Responsive School System
CS 157A - Introduction to Database Management Systems | San Jose State University | Team 3
## Team 3 Members

- [@an-h-ngo](https://github.com/an-h-ngo)
- [@DooVinci](https://github.com/DooVinci)
- [@nathan-wong1](https://github.com/nathan-wong1)
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

**IDE:** Eclipse
## Prerequisites

- **Java 8+** installed
- **Apache Tomcat 9** installed (e.g. at `C:\tomcat8`)
- **MySQL 9.6** running on `localhost:3306`
- **Eclipse** for compiling the project
## Database Setup

```bash
  1. Open MySQL Workbench and connect to the local MySQL server
  2. Run the full yoursjsu database script which will create all the tables and sample data
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

Demo passwords are stored as bcrypt hashes in `database/demo_accounts.sql`. Do not commit real student, faculty, or team member credentials in README or SQL setup files.

## Deployment
- Import the **YourSJSU** folder as an existing project in Eclipse
- Edit the **DatabaseConnection.java** for your MySQL Workbench setup
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
- Go to **http://localhost:8080/YourSJSU/** and the login page should load
- Run **shutdown.bat** in `C:\tomcat8\bin\` to shutdown the tomcat server

## Demo Checklist

1. Start Tomcat and open `/YourSJSU/login`.
2. Log in with the dummy student account from `database/demo_accounts.sql`.
3. Verify the student dashboard shows academic status, current enrollments, and waitlists.
4. Search for course offerings and verify results show seats, waitlist counts, status, and registration actions.
5. Enroll in an open section and verify the confirmation message and schedule update.
6. Join a waitlist for a full section and verify the waitlist confirmation.
7. Drop an enrolled class and verify it leaves the active schedule.
8. Re-enroll before the registration close deadline and verify prior `dropped_at` history remains in the database.
9. View transcript and verify completed records show readable term names.
10. View financial summary and filter by term.
11. Change password and verify same-password updates are rejected.
12. Log out, then log in with the dummy faculty account and verify the faculty dashboard.

## Implemented Functional Requirements (Updated 5/4/2026)

- [Vincent, An] FR-S1 / FR-D1: Authentication (Login/Logout) - Users can log in and log out. Passwords are verified with bcrypt, legacy/plain passwords are upgraded after successful login, authenticated requests are backed by the database `session` table, protected JSPs are guarded by an auth filter, dual-role users choose whether to continue as student or faculty, can switch roles during a session, and pages are restricted by the active role.
- [Nathan, An] FR-S2: View Student Dashboard - Students can view hold status, registration status, active enrollments, and active waitlists from the database.
- [Vincent, An] FR-S3: Search for Courses - Users can search for courses using various search filters and criteria. Search results include live enrollment/waitlist counts and registration actions.
- [An] FR-S4: Enroll in a Section - Students can enroll in open sections after eligibility, same-course/same-term duplicate prevention, waitlist conflict, capacity, and registration window checks. Enrollment asks for confirmation and supports re-enrollment before the term registration close deadline.
- [An] FR-S5: Join a Waitlist - Students can join a waitlist when a section is full, registration is open, prerequisites are satisfied, no same-course enrollment conflict exists, and waitlist capacity remains. Waitlist requests ask for confirmation before submission.
- [Nathan, An] FR-S6: Drop a Course - Students can drop an enrolled course through a transactional server-side update that marks the enrollment dropped, records the drop timestamp when the term deadline allows it, and automatically promotes the earliest eligible waitlisted student when a seat opens. Drop asks for confirmation before submission.
- [Nathan, An] FR-S7: View Schedule - Students can view their current and completed courses with section meeting details.
- [Nathan, An] FR-S8: View Transcript - Students can view their GPA, completed classes, grades, and term names. Dropped in-progress classes remain in the database but are not shown on the transcript.
- [Vincent] FR-S9: View Financial Summary - Student can view their tuition balance, payments, and charges by term.
- [Vincent, An] FR-S10: Password change - Users can change their password, which stores a bcrypt hash, updates the last-changed timestamp, rejects same-password updates, invalidates the web session, and redirects them to login.
- [An] FR-F1: Faculty Dashboard - Faculty can view title, department, and assigned teaching sections with enrolled counts.

## Final Functional Requirement Status

| PDF Requirement | Implemented By | Main Files/Pages | Status | Notes |
|---|---|---|---|---|
| 2.1 Authentication Login/Logout | Vincent, An | LoginServlet, LogoutServlet, RoleSelectionServlet, RoleUtil, AuthFilter, SessionDAO, PasswordUtil, login.jsp, select-role.jsp | Implemented | Uses Java HttpSession plus the database `session` table. Verifies bcrypt passwords and upgrades legacy/plain passwords after successful login. Protected JSPs are guarded by a filter, state-changing forms use CSRF tokens, dual-role users choose active student or faculty role after login, can switch roles during a session, and protected pages enforce that role. |
| 2.2 Change/Reset Password | Vincent, An | ChangePasswordServlet, CredentialDAO, PasswordUtil, change-password.jsp | Implemented | Stores bcrypt password hashes, updates `last_changed`, rejects same-password updates, invalidates the web session, and uses role-aware navigation. |
| 2.3 View Student Academic Status | Nathan, An | StudentDashboardServlet, DashboardDAO, student-dashboard.jsp | Implemented | Shows hold status, registration status, enrollments, and waitlists. |
| 2.4 Search Course Offerings | Vincent, An | CourseSearchDAO, CourseSearchServlet, search-courses.jsp | Implemented | Includes term, department, course number, title, instructor, seat, and waitlist data. |
| 2.5 Enroll in a Section | An | RegistrationDAO, EnrollSectionServlet, search-courses.jsp | Implemented | Checks eligibility, same-section duplicates, same-course/same-term duplicates, active waitlist conflicts, section capacity, and the term registration window. Enrollment asks for confirmation. Re-enrollment after a drop is allowed before `term.registration_close_at`; `enrolled_at` is updated while prior `dropped_at` is preserved as history. |
| 2.6 Join a Waitlist | An | RegistrationDAO, JoinWaitlistServlet, search-courses.jsp | Implemented | Checks eligibility, prerequisites, same-course enrollment conflicts, active enrollment/waitlist conflicts, waitlist capacity, and the term registration window. Waitlist requests ask for confirmation. |
| 2.7 Drop an Enrolled Section | Nathan, An | RegistrationDAO, DropCourseServlet, schedule.jsp | Implemented | Updates database status to `dropped`, sets `dropped_at` if drop deadline has not passed, and promotes the earliest eligible waitlisted student in the same transaction when a seat opens. Drop asks for confirmation. If a student re-enrolls later, `status` is the source of truth and `dropped_at < enrolled_at` indicates prior drop/re-add history. |
| 2.8 View Grades/Academic Record | Nathan, An | TranscriptDAO, TranscriptServlet, ClassStatus, transcript.jsp | Implemented | Displays completed grade history from enrollment records with readable term names; dropped in-progress classes are excluded from transcript display. |
| 2.9 View Financial Records | Vincent | FinancialDAO, FinancialSummaryServlet, financial-summary.jsp | Implemented | Shows charges, payments, balance, and term filter. |
| 2.10 Faculty Teaching and Organizational Access | An | FacultyDAO, FacultyDashboardServlet, faculty-dashboard.jsp | Implemented | Shows title, department, assigned sections, and enrolled counts. |

## Future Work

- Admin screens for assigning faculty, courses, and sections
