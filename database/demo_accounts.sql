-- Local-only demo accounts for YourSJSU testing.
-- These accounts use fake emails and IDs so README/demo instructions do not expose real users.
-- Demo passwords are seeded as bcrypt hashes for password123.

INSERT INTO `user` (sjsu_id, email, first_name, last_name, status)
VALUES
    ('900000001', 'student@sjsu.edu', 'Demo', 'Student', 'active'),
    ('900000002', 'faculty@sjsu.edu', 'Demo', 'Faculty', 'active'),
    ('900000003', 'ta@sjsu.edu', 'Demo', 'TA', 'active')
ON DUPLICATE KEY UPDATE
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    status = VALUES(status);

SET @demo_student_id = (SELECT user_id FROM `user` WHERE email = 'student@sjsu.edu');
SET @demo_faculty_id = (SELECT user_id FROM `user` WHERE email = 'faculty@sjsu.edu');
SET @demo_ta_id = (SELECT user_id FROM `user` WHERE email = 'ta@sjsu.edu');

INSERT INTO student (user_id, hold_status, registration_status)
VALUES
    (@demo_student_id, 'none', 'eligible'),
    (@demo_ta_id, 'none', 'eligible')
ON DUPLICATE KEY UPDATE
    hold_status = VALUES(hold_status),
    registration_status = VALUES(registration_status);

INSERT INTO faculty (user_id, staff_title)
VALUES
    (@demo_faculty_id, 'Lecturer'),
    (@demo_ta_id, 'Teaching Assistant')
ON DUPLICATE KEY UPDATE
    staff_title = VALUES(staff_title);

INSERT INTO department_faculty (user_id, department_id)
VALUES
    (@demo_faculty_id, 2),
    (@demo_ta_id, 2)
ON DUPLICATE KEY UPDATE
    department_id = VALUES(department_id);

INSERT INTO credential (user_id, password_hash, last_changed)
VALUES
    (@demo_student_id, '$2a$12$0b7zJJLTrjGWMXzYDsXY1OsakzIWLIcw.nlTq.AFxehtZuKpO6fJu', NOW()),
    (@demo_faculty_id, '$2a$12$fNEE8IQEWMiPs3nE/.NQ1ujDyt7WU60W7Iu7fPLCJW3bksN0aEwYu', NOW()),
    (@demo_ta_id, '$2a$12$3.K06SlCTeg0B4SaCr9Ebe3Thr/fWd2iPV2xcXszNK.PbTNR.aKu.', NOW())
ON DUPLICATE KEY UPDATE
    last_changed = CASE
        WHEN password_hash = 'password123' THEN VALUES(last_changed)
        ELSE last_changed
    END,
    password_hash = CASE
        WHEN password_hash = 'password123' THEN VALUES(password_hash)
        ELSE password_hash
    END;
