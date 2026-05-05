# Session Changes - 2026-05-05

This file summarizes the changes made during this session.

## Password Security

- Added `jBCrypt` to `YourSJSU/src/main/webapp/WEB-INF/lib/jbcrypt-0.4.jar`.
- Added `PasswordUtil` for bcrypt password hashing, bcrypt verification, legacy/plain password detection, and `$2a$`/`$2b$`/`$2y$` compatibility.
- Updated login to verify bcrypt hashes instead of comparing raw password strings only.
- Kept a legacy/plain password compatibility path so old `password123` rows can still log in once.
- Added automatic migration from legacy/plain passwords to bcrypt after successful login.
- Made login fail closed if a legacy/plain password verifies but the bcrypt migration update cannot be saved.
- Updated password change to verify the current password through bcrypt-aware logic.
- Updated password change to store only bcrypt hashes for new passwords.
- Updated password change to reject same-password updates using bcrypt-aware verification.
- Updated `CredentialDAO` to save password hashes with `last_changed = NOW()`.
- Updated `database/demo_accounts.sql` to seed bcrypt hashes for the demo password `password123`.
- Made `database/demo_accounts.sql` preserve changed demo passwords while upgrading old plaintext `password123` rows.
- Updated README password/auth documentation to mention bcrypt storage and migration.

## IntelliJ Dependency Fix

- Updated `YourSJSU.iml` so IntelliJ recognizes `jbcrypt-0.4.jar` as a module library.
- Verified `PasswordUtil.java` compiles when the bcrypt jar is on the classpath.

## Auth Filter And Direct JSP Protection

- Added `AuthFilter` to guard protected JSPs from direct access.
- Direct requests to protected JSPs now require login and redirect through servlet routes.
- Public paths remain accessible, including login, index, and static assets.
- Added response hardening headers:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: SAMEORIGIN`
  - `Referrer-Policy: same-origin`
- Added no-cache headers for protected paths.

## CSRF Protection

- Added `CsrfUtil` for session-backed CSRF token generation and validation.
- Added CSRF validation to state-changing servlets:
  - `LogoutServlet`
  - `RoleSelectionServlet`
  - `ChangePasswordServlet`
  - `EnrollSectionServlet`
  - `JoinWaitlistServlet`
  - `DropCourseServlet`
- Added hidden `csrfToken` fields to protected POST forms:
  - logout forms
  - role selection form
  - change password form
  - enroll form
  - join waitlist form
  - drop course form
- Left login without CSRF validation so first-time login still works without an existing authenticated session.

## Session Hardening

- Added `SessionDAO` for the existing database `session` table.
- Verified the live schema through JDBC:
  - `session_token`
  - `user_id`
  - `status`
  - `created_at`
  - `expires_at`
- Login now invalidates any existing session before creating an authenticated session.
- Login now creates an active DB session row with a 1-hour expiry.
- Authenticated requests validate and extend the DB session through `AuthFilter`.
- Expired DB sessions are marked expired.
- Logout invalidates the DB session before invalidating `HttpSession`.
- Password change invalidates the DB session and web session.
- `GET /logout` no longer logs users out; logout is POST-only.

## Waitlist And Registration Safety

- Refactored `RegistrationDAO.drop()` into a transaction.
- Dropping a course now locks the section row before updating enrollment and promoting waitlist users.
- Dropping a course marks the enrollment as `dropped` and sets `dropped_at = NOW()`.
- After a drop, the earliest eligible waitlisted student is automatically promoted into the opened seat.
- Waitlist promotion checks:
  - student eligibility and holds
  - exact-section duplicate enrollment
  - same-course/same-term duplicate enrollment
  - prerequisite completion
  - registration window
  - available section capacity
- Ineligible waitlist rows encountered during promotion are marked `expired`.
- Promoted waitlist rows are marked `enrolled`.
- Drop success messages now indicate whether a waitlisted student was promoted.
- Enrollment now locks the section before capacity checks to reduce race-condition over-enrollment.
- Waitlist join now locks the section before waitlist capacity checks to reduce race-condition overfilling.
- Waitlist join now rejects students who are already enrolled in another section of the same course and term.
- Waitlist join now checks prerequisites before adding a waiting row.

## Redirect And Input Safety

- Fixed invalid-section redirect messages to URL-encode the error value.
- Hardened `returnQuery` handling for enroll and waitlist redirects.
- `returnQuery` is now decoded, allowlisted, and re-encoded server-side.
- Allowed preserved search parameters are:
  - `keyword`
  - `courseNumber`
  - `instructorName`
  - `departmentCode`
  - `termId`
- Escaped the hidden `returnQuery` value in `search-courses.jsp` for HTML attribute safety.

## README Updates

- Updated the demo account section to include the dual-role TA account.
- Documented that demo passwords are stored as bcrypt hashes.
- Updated authentication requirements to mention bcrypt, DB-backed sessions, auth filter, and CSRF tokens.
- Updated waitlist and drop requirement descriptions to mention stronger validations and automatic promotion.
- Removed completed items from Future Work:
  - bcrypt password verification
  - database-backed session management
  - auth filter for protected pages
  - full prerequisite validation before enrollment
  - automatic waitlist promotion after a drop

## Verification Performed

- Compiled Java sources with:
  - Tomcat `servlet-api.jar`
  - MySQL connector jar
  - `jbcrypt-0.4.jar`
- Removed compile-generated `.class` files after verification.
- Used the code-review agent twice for bcrypt changes.
- Used the code-review agent twice for auth/session/CSRF/waitlist changes.
- Fixed all actionable review findings found during this session.

## Still Needs Manual Testing

- Rebuild/redeploy the IntelliJ/Tomcat artifact.
- Verify login creates a DB `session` row.
- Verify logout invalidates the DB `session` row.
- Verify password change invalidates the DB `session` row and web session.
- Verify direct protected JSP access redirects through servlet routes or login.
- Verify missing CSRF token POSTs fail.
- Verify enroll, waitlist, and drop still work through the UI.
- Verify dropping a full class promotes the earliest eligible waitlisted student.
- Verify ineligible waitlist records are expired and later eligible waitlisted students can be promoted.

## Excluding This File From Commits

This file is intended as local session documentation only. To exclude it locally without changing tracked project files, add this line to `.git/info/exclude`:

```gitignore
/SESSION_CHANGES_2026-05-05.md
```
