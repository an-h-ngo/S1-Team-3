
# YourSJSU

Intuitive, Secure, and Responsive School System
CS 157A - Introduction to Database Management Systems | San Jose State University | Team 3
## Team 3 Members

- [@an-h-ngo](https://github.com/an-h-ngo)
- [@DooVinci](https://github.com/DooVinci)
- [@nathan-wong1](https://github.com/nathan-wong1)
## Overview

YourSJSU is a reimagined student and faculty portal built as a Java web application backed by a MySQL database. It streamlines common university workflows such as registration, class scheduling, transcript access, and financial records.

This project currently implements FR-S1 / FR-D1: Authentication (Login/Logout) — users can sign in with their SJSU ID or email and are routed to the appropriate dashboard based on their role (student or faculty).


## Tech Stack

**Frontend:** JSP, HTML, CSS

**Backend:** Java Servlets (Servlet 4.0)

**Database:** MySQL 9.6 (via MySQL Workbench 8.0)

**Server:** Apache Tomcat 9

**Java:** Java 17

**IDE:** Eclipse / IntelliJ
## Database Setup

```bash
  1. Open MySQL Workbench and connect to the local MySQL server
  2. Run the full yoursjsu database script which will create all the tables and sample data
```
    
## Deployment
```bash
  1. Import the YourSJSU folder as an existing project in Eclipse
  2. Configure Tomcat as a server in Eclipse
  3. Right click the project > Run As > Run on Server > select Tomcat
  4. Eclipse will deploy the app and open the browser to the login page
```
## Implemented Functional Requirements (Updated 4/2/2026)

- FR-S1 / FR-D1: Authentication (Login/Logout) - Users can log in and log out. Error messages are generic to avoid revealing whether the ID or password was incorrect.
## Future Work

- Real bcrypt password verification (add jBCrypt library)
- Database-backed session management (using the session table)
- Auth filter for protecting all pages
- Student dashboard content (enrollments, holds, schedule)
- Faculty dashboard content (sections taught, department info)
- Course search and enrollment (FR-S3, FR-S4)
- Financial records view (FR-S9)
- Password change (FR-S10)
