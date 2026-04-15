
# YourSJSU

Intuitive, Secure, and Responsive School System
CS 157A - Introduction to Database Management Systems | San Jose State University | Team 3
## Team 3 Members

- [@an-h-ngo](https://github.com/an-h-ngo)
- [@DooVinci](https://github.com/DooVinci)
- [@nathan-wong1](https://github.com/nathan-wong1)
## Overview

YourSJSU is a reimagined student and faculty portal built as a Java web application backed by a MySQL database. It streamlines common university workflows such as registration, class scheduling, transcript access, and financial records.


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
  2. Update src/main/java/com/yoursjsu/dao/DatabaseConnection.java with your MySQL Workbench password
```
## Deployment
- Import the **YourSJSU** folder as an existing project in Eclipse
- Edit the **DatabaseConnection.java** for your MySQL Workbench setup
- In Eclipse, right-click the **YourSJSU** project > **Properties** > **Java Compiler**
- Enable **project specific settings**
- Set **Compiler compliance level** to **1.8**
- Right-click the project > **Properties** > **Java Build Path** > **Libraries**
- Under **Classpath**, click **Add Library** > **Server Runtime** > select **Apache Tomcat v9.0**
## Implemented Functional Requirements (Updated 4/14/2026)

- FR-S1 / FR-D1: Authentication (Login/Logout) - Users can log in and log out.
- FR-S3: Search for Courses - Users can search for courses using various search filters and criteria.
- FR-S7: View Schedule - Students can view schedule this term and their previous courses.  If a student wishes to drop a course, simply click the garbage button and the course will be removed.
- FR-S10: Password change - Users can change their password, which updates the database with the new password, redirects them to the login screen for re-login.
## Future Work

- Real bcrypt password verification (add jBCrypt library)
- Database-backed session management (using the session table)
- Auth filter for protecting all pages
- Student dashboard content (enrollments, holds, schedule)
- Faculty dashboard content (sections taught, department info)
- Course enrollment (FR-S4)
- Financial records view (FR-S9)
