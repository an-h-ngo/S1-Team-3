package com.yoursjsu.dao;
import com.yoursjsu.model.Charge;
import com.yoursjsu.model.Payment;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FinancialDAO {

    // Returns all charges that is on a user account
    // Use term table to get term name
    public List<Charge> getCharges(int userId, Integer termId) {
        List<Charge> charges = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ch.charge_id, ch.amount, ch.description, ch.posted_at, ch.status, t.term_name\n");
        sql.append("FROM charge ch\n");
        sql.append("JOIN term t ON ch.term_id = t.term_id\n"); // joins with the term table
        sql.append("WHERE ch.user_id = ?\n");
        if (termId != null) {
            sql.append("AND ch.term_id = ?\n");
        }
        sql.append("ORDER BY ch.posted_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Plug values into the ? marks
            // term_id only if the user picked one
            stmt.setInt(1, userId);
            if (termId != null) {
                stmt.setInt(2, termId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Charge c = new Charge();
                    c.setChargeId(rs.getInt("charge_id"));
                    c.setAmount(rs.getBigDecimal("amount"));
                    c.setDescription(rs.getString("description"));
                    c.setPostedAt(rs.getString("posted_at"));
                    c.setStatus(rs.getString("status"));
                    c.setTermName(rs.getString("term_name"));
                    charges.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return charges;
    }

    // Return all payment user made
    // Gets the charges from payment table
    public List<Payment> getPayments(int userId, Integer termId) {
        List<Payment> payments = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.payment_id, p.amount, p.paid_at, t.term_name\n");
        sql.append("FROM payment p\n");
        sql.append("JOIN term t ON p.term_id = t.term_id\n");
        sql.append("WHERE p.user_id = ?\n");
        if (termId != null) {
            sql.append("AND p.term_id = ?\n");
        }
        sql.append("ORDER BY p.paid_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setInt(1, userId);
            if (termId != null) {
                stmt.setInt(2, termId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setAmount(rs.getBigDecimal("amount"));
                    p.setPaidAt(rs.getString("paid_at"));
                    p.setTermName(rs.getString("term_name"));
                    payments.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ADd up all charges that hasnt been paid and returns the total, returns as current balance
    // COALESCE turns the null values into 0
    public BigDecimal getBalance(int userId, Integer termId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COALESCE(SUM(ch.amount), 0) AS balance\n"); // turn null values into 0
        sql.append("FROM charge ch\n");
        sql.append("WHERE ch.user_id = ?\n");
        sql.append("AND ch.status IN ('pending', 'overdue')\n");
        if (termId != null) {
            sql.append("  AND  ch.term_id = ?\n");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setInt(1, userId);
            if (termId != null) {
                stmt.setInt(2, termId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("balance");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // Returns overdue charges if the status is overdue
    public List<Charge> getOverdueCharges(int userId, Integer termId) {
        List<Charge> overdue = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ch.charge_id, ch.amount, ch.description, ch.posted_at, ch.status, t.term_name\n");
        sql.append("FROM charge ch\n");
        sql.append("JOIN term t ON ch.term_id = t.term_id\n");
        sql.append("WHERE ch.user_id = ?\n");
        sql.append("AND ch.status = 'overdue'\n");
        if (termId != null) {
            sql.append("AND ch.term_id = ?\n");
        }
        sql.append("ORDER BY ch.posted_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setInt(1, userId);
            if (termId != null) {
                stmt.setInt(2, termId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Charge c = new Charge();
                    c.setChargeId(rs.getInt("charge_id"));
                    c.setAmount(rs.getBigDecimal("amount"));
                    c.setDescription(rs.getString("description"));
                    c.setPostedAt(rs.getString("posted_at"));
                    c.setStatus(rs.getString("status"));
                    c.setTermName(rs.getString("term_name"));
                    overdue.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return overdue;
    }
}
