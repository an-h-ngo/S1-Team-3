package com.yoursjsu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {
    public static class DropResult {
        private final String error;
        private final String successMessage;

        private DropResult(String error, String successMessage) {
            this.error = error;
            this.successMessage = successMessage;
        }

        public static DropResult error(String error) {
            return new DropResult(error, null);
        }

        public static DropResult success(String successMessage) {
            return new DropResult(null, successMessage);
        }

        public boolean isSuccess() {
            return error == null;
        }

        public String getError() {
            return error;
        }

        public String getSuccessMessage() {
            return successMessage;
        }
    }

    public String enroll(int userId, int sectionId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                lockSection(conn, sectionId);
                String eligibilityError = getEligibilityError(conn, userId);
                if (eligibilityError != null) {
                    conn.rollback();
                    return eligibilityError;
                }
                if (hasActiveEnrollment(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already enrolled in this section.";
                }
                if (hasActiveEnrollmentForSameCourse(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already enrolled in another section of this course.";
                }
                if (hasActiveWaitlist(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already waitlisted for this section.";
                }
                String prerequisiteError = getPrerequisiteError(conn, userId, sectionId);
                if (prerequisiteError != null) {
                    conn.rollback();
                    return prerequisiteError;
                }
                if (getAvailableSeats(conn, sectionId) <= 0) {
                    conn.rollback();
                    return "This section is full. Join the waitlist instead.";
                }

                if (hasDroppedEnrollment(conn, userId, sectionId)) {
                    String registrationWindowError = getRegistrationWindowError(conn, sectionId);
                    if (registrationWindowError != null) {
                        conn.rollback();
                        return registrationWindowError;
                    }
                    reactivateDroppedEnrollment(conn, userId, sectionId);
                    conn.commit();
                    return null;
                }

                String registrationWindowError = getRegistrationWindowError(conn, sectionId);
                if (registrationWindowError != null) {
                    conn.rollback();
                    return registrationWindowError;
                }

                String sql = "INSERT INTO student_has_enrollment "
                        + "(user_id, section_id, status, enrolled_at) VALUES (?, ?, 'enrolled', NOW())";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, sectionId);
                    stmt.executeUpdate();
                }
                conn.commit();
                return null;
            } catch (SQLException e) {
                conn.rollback();
                if ("23000".equals(e.getSQLState())) {
                    return "You already have a registration record for this section.";
                }
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Unable to enroll right now. Please try again.";
        }
    }

    public String joinWaitlist(int userId, int sectionId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                lockSection(conn, sectionId);
                String eligibilityError = getEligibilityError(conn, userId);
                if (eligibilityError != null) {
                    conn.rollback();
                    return eligibilityError;
                }
                if (hasActiveEnrollment(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already enrolled in this section.";
                }
                if (hasActiveEnrollmentForSameCourse(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already enrolled in another section of this course.";
                }
                if (hasActiveWaitlist(conn, userId, sectionId)) {
                    conn.rollback();
                    return "You are already waitlisted for this section.";
                }
                String prerequisiteError = getPrerequisiteError(conn, userId, sectionId);
                if (prerequisiteError != null) {
                    conn.rollback();
                    return prerequisiteError;
                }
                if (getAvailableSeats(conn, sectionId) > 0) {
                    conn.rollback();
                    return "This section has open seats. Enroll instead.";
                }
                if (getAvailableWaitlistSeats(conn, sectionId) <= 0) {
                    conn.rollback();
                    return "This section's waitlist is full.";
                }

                String registrationWindowError = getRegistrationWindowError(conn, sectionId);
                if (registrationWindowError != null) {
                    conn.rollback();
                    return registrationWindowError;
                }

                String sql = "INSERT INTO student_waitlist "
                        + "(user_id, section_id, requested_at, status) VALUES (?, ?, NOW(), 'waiting')";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, sectionId);
                    stmt.executeUpdate();
                }
                conn.commit();
                return null;
            } catch (SQLException e) {
                conn.rollback();
                if ("23000".equals(e.getSQLState())) {
                    return "You already have a waitlist record for this section.";
                }
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Unable to join the waitlist right now. Please try again.";
        }
    }

    public DropResult drop(int userId, int sectionId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                lockSection(conn, sectionId);
                if (!isDropAllowed(conn, userId, sectionId)) {
                    conn.rollback();
                    return DropResult.error("The drop deadline has passed or this section is not currently enrolled.");
                }

                String sql = "UPDATE student_has_enrollment "
                        + "SET status = 'dropped', dropped_at = NOW() "
                        + "WHERE user_id = ? AND section_id = ? AND status = 'enrolled'";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, sectionId);
                    if (stmt.executeUpdate() == 0) {
                        conn.rollback();
                        return DropResult.error("This section could not be dropped.");
                    }
                }

                String promotionMessage = promoteFirstEligibleWaitlistStudent(conn, sectionId);
                conn.commit();
                return DropResult.success(promotionMessage == null
                        ? "Course dropped."
                        : "Course dropped. " + promotionMessage);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return DropResult.error("Unable to drop the section right now. Please try again.");
        }
    }

    private void lockSection(Connection conn, int sectionId) throws SQLException {
        String sql = "SELECT section_id FROM section WHERE section_id = ? FOR UPDATE";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                rs.next();
            }
        }
    }

    private String promoteFirstEligibleWaitlistStudent(Connection conn, int sectionId) throws SQLException {
        List<Integer> waitingUserIds = getWaitingUsers(conn, sectionId);
        if (waitingUserIds.isEmpty()) {
            return null;
        }
        boolean skippedIneligible = false;
        for (Integer waitlistedUserId : waitingUserIds) {
            if (getAvailableSeats(conn, sectionId) <= 0) {
                return null;
            }
            if (getEligibilityError(conn, waitlistedUserId) != null
                    || hasActiveEnrollment(conn, waitlistedUserId, sectionId)
                    || hasActiveEnrollmentForSameCourse(conn, waitlistedUserId, sectionId)
                    || getPrerequisiteError(conn, waitlistedUserId, sectionId) != null
                    || getRegistrationWindowError(conn, sectionId) != null) {
                expireWaitlistEntry(conn, waitlistedUserId, sectionId);
                skippedIneligible = true;
                continue;
            }

            if (hasDroppedEnrollment(conn, waitlistedUserId, sectionId)) {
                reactivateDroppedEnrollment(conn, waitlistedUserId, sectionId);
            } else {
                String enrollSql = "INSERT INTO student_has_enrollment "
                        + "(user_id, section_id, status, enrolled_at) VALUES (?, ?, 'enrolled', NOW())";
                try (PreparedStatement stmt = conn.prepareStatement(enrollSql)) {
                    stmt.setInt(1, waitlistedUserId);
                    stmt.setInt(2, sectionId);
                    stmt.executeUpdate();
                }
            }

            String waitlistSql = "UPDATE student_waitlist SET status = 'enrolled' "
                    + "WHERE user_id = ? AND section_id = ? AND status = 'waiting'";
            try (PreparedStatement stmt = conn.prepareStatement(waitlistSql)) {
                stmt.setInt(1, waitlistedUserId);
                stmt.setInt(2, sectionId);
                stmt.executeUpdate();
            }
            return skippedIneligible
                    ? "Ineligible waitlist records were expired and a waitlisted student was promoted."
                    : "A waitlisted student was promoted.";
        }
        return skippedIneligible ? "No eligible waitlisted student was promoted." : null;
    }

    private List<Integer> getWaitingUsers(Connection conn, int sectionId) throws SQLException {
        String sql = "SELECT user_id FROM student_waitlist "
                + "WHERE section_id = ? AND status = 'waiting' "
                + "ORDER BY requested_at, user_id FOR UPDATE";
        List<Integer> userIds = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    userIds.add(rs.getInt("user_id"));
                }
                return userIds;
            }
        }
    }

    private void expireWaitlistEntry(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "UPDATE student_waitlist SET status = 'expired' "
                + "WHERE user_id = ? AND section_id = ? AND status = 'waiting'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);
            stmt.executeUpdate();
        }
    }

    private String getEligibilityError(Connection conn, int userId) throws SQLException {
        String sql = "SELECT hold_status, registration_status FROM student WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return "Only students can register for sections.";
                }
                if (!"none".equals(rs.getString("hold_status"))) {
                    return "You have a hold and cannot register.";
                }
                if ("not_eligible".equals(rs.getString("registration_status"))) {
                    return "You are not eligible to register.";
                }
                return null;
            }
        }
    }

    private boolean hasActiveEnrollment(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT 1 FROM student_has_enrollment "
                + "WHERE user_id = ? AND section_id = ? AND status = 'enrolled'";
        return exists(conn, sql, userId, sectionId);
    }

    private boolean hasActiveEnrollmentForSameCourse(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT 1 "
                + "FROM student_has_enrollment e "
                + "JOIN section enrolled_section ON e.section_id = enrolled_section.section_id "
                + "JOIN section requested_section ON requested_section.section_id = ? "
                + "WHERE e.user_id = ? "
                + "AND e.status = 'enrolled' "
                + "AND enrolled_section.course_id = requested_section.course_id "
                + "AND enrolled_section.term_id = requested_section.term_id "
                + "AND enrolled_section.section_id <> requested_section.section_id";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean hasDroppedEnrollment(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT 1 FROM student_has_enrollment "
                + "WHERE user_id = ? AND section_id = ? AND status = 'dropped'";
        return exists(conn, sql, userId, sectionId);
    }

    private boolean hasActiveWaitlist(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT 1 FROM student_waitlist "
                + "WHERE user_id = ? AND section_id = ? AND status = 'waiting'";
        return exists(conn, sql, userId, sectionId);
    }

    private String getPrerequisiteError(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT pc.course_number, pc.course_title "
                + "FROM section target_section "
                + "JOIN prerequisite p ON target_section.course_id = p.course_id "
                + "JOIN course pc ON p.prerequisite_id = pc.course_id "
                + "WHERE target_section.section_id = ? "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 "
                + "    FROM student_has_enrollment e "
                + "    JOIN section completed_section ON e.section_id = completed_section.section_id "
                + "    WHERE e.user_id = ? "
                + "    AND completed_section.course_id = p.prerequisite_id "
                + "    AND e.status = 'completed' "
                + "    AND e.letter_grade IS NOT NULL "
                + "    AND e.letter_grade NOT IN ('F', 'W', 'I', 'IP') "
                + ") "
                + "LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return "You have not completed the prerequisite: "
                            + rs.getString("course_number") + " " + rs.getString("course_title") + ".";
                }
                return null;
            }
        }
    }

    private boolean exists(Connection conn, String sql, int userId, int sectionId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private int getAvailableSeats(Connection conn, int sectionId) throws SQLException {
        String sql = "SELECT s.capacity - COALESCE(e.enrolled_count, 0) AS available_seats "
                + "FROM section s "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS enrolled_count "
                + "FROM student_has_enrollment WHERE status = 'enrolled' GROUP BY section_id) e "
                + "ON s.section_id = e.section_id WHERE s.section_id = ?";
        return getInt(conn, sql, sectionId);
    }

    private int getAvailableWaitlistSeats(Connection conn, int sectionId) throws SQLException {
        String sql = "SELECT s.waitlist_capacity - COALESCE(w.waitlist_count, 0) AS available_waitlist "
                + "FROM section s "
                + "LEFT JOIN (SELECT section_id, COUNT(*) AS waitlist_count "
                + "FROM student_waitlist WHERE status = 'waiting' GROUP BY section_id) w "
                + "ON s.section_id = w.section_id WHERE s.section_id = ?";
        return getInt(conn, sql, sectionId);
    }

    private int getInt(Connection conn, String sql, int sectionId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private boolean isDropAllowed(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "SELECT 1 FROM student_has_enrollment e "
                + "JOIN section s ON e.section_id = s.section_id "
                + "JOIN term t ON s.term_id = t.term_id "
                + "WHERE e.user_id = ? AND e.section_id = ? AND e.status = 'enrolled' "
                + "AND CURDATE() <= t.drop_deadline";
        return exists(conn, sql, userId, sectionId);
    }

    private String getRegistrationWindowError(Connection conn, int sectionId) throws SQLException {
        String sql = "SELECT t.registration_open_at, t.registration_close_at "
                + "FROM section s JOIN term t ON s.term_id = t.term_id "
                + "WHERE s.section_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return "This section was not found.";
                }
                java.sql.Timestamp opensAt = rs.getTimestamp("registration_open_at");
                java.sql.Timestamp closesAt = rs.getTimestamp("registration_close_at");
                java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                if (now.before(opensAt)) {
                    return "Registration has not opened for this section.";
                }
                if (now.after(closesAt)) {
                    return "The add deadline has passed for this section.";
                }
                return null;
            }
        }
    }

    private void reactivateDroppedEnrollment(Connection conn, int userId, int sectionId) throws SQLException {
        String sql = "UPDATE student_has_enrollment "
                + "SET status = 'enrolled', enrolled_at = NOW(), letter_grade = NULL "
                + "WHERE user_id = ? AND section_id = ? AND status = 'dropped'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, sectionId);
            stmt.executeUpdate();
        }
    }
}
