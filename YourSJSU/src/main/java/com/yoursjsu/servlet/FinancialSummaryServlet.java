package com.yoursjsu.servlet;
import com.yoursjsu.dao.CourseSearchDAO;
import com.yoursjsu.dao.FinancialDAO;
import com.yoursjsu.model.Charge;
import com.yoursjsu.model.Payment;
import com.yoursjsu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Shows
 *   - current balance
 *   - financial holds (if have overdue charges)
 *   - charge breakdown
 *   - payment history
 */
@WebServlet("/financial-summary")
public class FinancialSummaryServlet extends HttpServlet {

    private FinancialDAO financialDAO = new FinancialDAO();
    // Use getAllTerms() from the course-search DAO
    private CourseSearchDAO courseSearchDAO = new CourseSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = RoleUtil.requireStudent(request, response);
        if (user == null) {
            return;
        }
        int userId = user.getUserId();

        // Null = "all terms". Get term from url
        Integer termId = null;
        String termIdStr = request.getParameter("termId");
        if (termIdStr != null && !termIdStr.trim().isEmpty()) {
            try {
                termId = Integer.parseInt(termIdStr.trim());
            } catch (NumberFormatException e) {
                // fall back to all terms if none work
            }
        }

        // Get database values
        List<String[]>  terms    = courseSearchDAO.getAllTerms();
        List<Charge>    charges  = financialDAO.getCharges(userId, termId);
        List<Payment>   payments = financialDAO.getPayments(userId, termId);
        BigDecimal      balance  = financialDAO.getBalance(userId, termId);
        List<Charge>    holds    = financialDAO.getOverdueCharges(userId, termId);

        // Stash as request attributes
        request.setAttribute("terms",          terms);
        request.setAttribute("selectedTermId", termIdStr);
        request.setAttribute("charges",        charges);
        request.setAttribute("payments",       payments);
        request.setAttribute("balance",        balance);
        request.setAttribute("holds",          holds);

        request.getRequestDispatcher("/financial-summary.jsp").forward(request, response);
    }
}
