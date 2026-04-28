<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.Charge" %>
<%@ page import="com.yoursjsu.model.Payment" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU - Financial Summary</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">
    <nav class="navbar">
        <div class="nav-brand">YourSJSU</div>
        <div class="nav-right">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
                <span class="nav-user"><%= user.getFirstName() %> <%= user.getLastName() %></span>
            <% } %>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-logout-form">
                <button type="submit" class="btn-logout">Sign Out</button>
            </form>
        </div>
    </nav>

    <nav class="nav-bar1">
        <div class="nav-link" onclick="goTo('/student-dashboard')">Student Dashboard</div>
        <div class="nav-link" onclick="goTo('/courses')">Courses</div>
        <div class="nav-link" onclick="goTo('/schedule')">Term Schedule</div>
        <div class="nav-link" onclick="goTo('/transcript')">Transcript</div>
        <div class="nav-link active" onclick="goTo('/financial-summary')">Financial Summary</div>
    </nav>

    <script>
        function goTo(path) {
            window.location.href = "<%= request.getContextPath() %>" + path;
        }
    </script>

    <main class="financial-content">
        <h1>Financial Summary</h1>

        <%
            List<String[]> terms          = (List<String[]>) request.getAttribute("terms");
            String         selectedTermId = (String) request.getAttribute("selectedTermId");
            List<Charge>   charges        = (List<Charge>) request.getAttribute("charges");
            List<Payment>  payments       = (List<Payment>) request.getAttribute("payments");
            BigDecimal     balance        = (BigDecimal) request.getAttribute("balance");
            List<Charge>   holds          = (List<Charge>) request.getAttribute("holds");

            boolean owingMoney = balance != null && balance.compareTo(BigDecimal.ZERO) > 0;
        %>

        <!-- Term filter dropdown -->
        <form method="get" action="${pageContext.request.contextPath}/financial-summary" class="term-filter-form">
            <label for="termId">Filter by term:</label>
            <select id="termId" name="termId" onchange="this.form.submit()">
                <option value="">All Terms</option>
                <% if (terms != null) {
                    for (String[] t : terms) {
                        String selected = t[0].equals(selectedTermId) ? "selected" : "";
                %>
                    <option value="<%= t[0] %>" <%= selected %>><%= t[1] %></option>
                <%  }
                   } %>
            </select>
        </form>

        <!-- Current Balance card -->
        <section class="balance-card <%= owingMoney ? "owing" : "zero" %>">
            <div class="balance-label">Current Balance</div>
            <div class="balance-amount">
                <%= balance != null ? String.format("$%,.2f", balance) : "$0.00" %>
            </div>
            <% if (!owingMoney) { %>
                <div class="balance-sub">All clear &mdash; nothing owed.</div>
            <% } else { %>
                <div class="balance-sub">Total of pending and overdue charges.</div>
            <% } %>
        </section>

        <!-- Financial Holds (overdue charges) -->
        <section class="financial-section">
            <h2>Financial Holds</h2>
            <% if (holds == null || holds.isEmpty()) { %>
                <p class="no-holds">No financial holds on your account.</p>
            <% } else { %>
                <ul class="holds-list">
                    <% for (Charge h : holds) { %>
                        <li class="hold-item">
                            <div class="hold-desc"><%= h.getDescription() %></div>
                            <div class="hold-meta">
                                <span><%= h.getTermName() %></span>
                                <span class="hold-amount"><%= String.format("$%,.2f", h.getAmount()) %></span>
                            </div>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </section>

        <!-- Charge Breakdown -->
        <section class="financial-section">
            <h2>Charge Breakdown</h2>
            <% if (charges == null || charges.isEmpty()) { %>
                <p class="no-results">No charges on record.</p>
            <% } else { %>
                <div class="table-wrapper">
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>Description</th>
                                <th>Term</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Posted</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Charge c : charges) {
                                String statusClass = "status-" + c.getStatus();
                            %>
                                <tr>
                                    <td><%= c.getDescription() %></td>
                                    <td><%= c.getTermName() %></td>
                                    <td><%= String.format("$%,.2f", c.getAmount()) %></td>
                                    <td><span class="<%= statusClass %>"><%= c.getStatus().toUpperCase() %></span></td>
                                    <td><%= c.getPostedAt() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </section>

        <!-- Payment History -->
        <section class="financial-section">
            <h2>Payment History</h2>
            <% if (payments == null || payments.isEmpty()) { %>
                <p class="no-results">No payments on record.</p>
            <% } else { %>
                <div class="table-wrapper">
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>Term</th>
                                <th>Amount</th>
                                <th>Paid</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Payment p : payments) { %>
                                <tr>
                                    <td><%= p.getTermName() %></td>
                                    <td><%= String.format("$%,.2f", p.getAmount()) %></td>
                                    <td><%= p.getPaidAt() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </section>
    </main>
</body>
</html>
