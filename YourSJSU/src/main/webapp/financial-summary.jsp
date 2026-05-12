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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
</head>
<body class="dashboard-page">
<%
    User user = (User) session.getAttribute("user");
    List<String[]> terms = (List<String[]>) request.getAttribute("terms");
    String selectedTermId = (String) request.getAttribute("selectedTermId");
    List<Charge> charges = (List<Charge>) request.getAttribute("charges");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    BigDecimal balance = (BigDecimal) request.getAttribute("balance");
    List<Charge> holds = (List<Charge>) request.getAttribute("holds");
    boolean owingMoney = balance != null && balance.compareTo(BigDecimal.ZERO) > 0;
    String userInitials = user != null && user.getFirstName() != null && user.getLastName() != null && user.getFirstName().length() > 0 && user.getLastName().length() > 0
            ? (user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1)).toUpperCase()
            : "SJ";
%>
    <div class="portal-shell">
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand"><div class="seal">SJ</div><div class="brand-copy"><h1>YourSJSU</h1><span>Student Portal</span></div></div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/student-dashboard" aria-label="Overview"><span class="nav-icon nav-icon-overview" aria-hidden="true"></span><span class="nav-label">Overview</span></a>
                <a href="${pageContext.request.contextPath}/search-courses" aria-label="Course Search"><span class="nav-icon nav-icon-search" aria-hidden="true"></span><span class="nav-label">Course Search</span></a>
                <a href="${pageContext.request.contextPath}/schedule" aria-label="Term Schedule"><span class="nav-icon nav-icon-schedule" aria-hidden="true"></span><span class="nav-label">Term Schedule</span></a>
                <a href="${pageContext.request.contextPath}/transcript" aria-label="Transcript"><span class="nav-icon nav-icon-transcript" aria-hidden="true"></span><span class="nav-label">Transcript</span></a>
                <a class="active" href="${pageContext.request.contextPath}/financial-summary" aria-label="Finances"><span class="nav-icon nav-icon-finances" aria-hidden="true"></span><span class="nav-label">Finances</span> <span class="nav-badge"><%= owingMoney ? "Due" : "Clear" %></span></a>
            </nav>
            <details class="account-menu-wrap">
                <summary class="rail-footer">
                    <div class="footer-icon" aria-hidden="true"><%= userInitials %></div>
                    <div class="footer-user">
                        <strong><%= user != null ? user.getFirstName() + " " + user.getLastName() : "Student" %></strong>
                        <span><%= user != null ? "ID " + user.getSjsuId() : "YourSJSU" %></span>
                    </div>
                </summary>
                <div class="account-menu">
                    <a href="${pageContext.request.contextPath}/change-password">Change password</a>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <button type="submit" class="signout-action">Sign out</button>
                    </form>
                </div>
            </details>
        </aside>

        <main class="portal-main">
            <header class="topbar">
                <div class="title-block">
                    <p>Student account - Charges and payments</p>
                    <h1>Financial summary</h1>
                </div>
            </header>

            <form method="get" action="${pageContext.request.contextPath}/financial-summary" class="term-filter-form">
                <label for="termId" class="eyebrow">Filter by term</label>
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

            <section class="balance-card <%= owingMoney ? "owing" : "zero" %>">
                <div class="balance-label">Current Balance</div>
                <div class="balance-amount"><%= balance != null ? String.format("$%,.2f", balance) : "$0.00" %></div>
                <div class="balance-sub"><%= owingMoney ? "Total of pending and overdue charges." : "All clear; nothing owed." %></div>
            </section>

            <section class="grid two-column">
                <article class="financial-section">
                    <h2>Financial holds</h2>
                    <% if (holds == null || holds.isEmpty()) { %>
                        <p class="no-holds">No financial holds on your account.</p>
                    <% } else { %>
                        <ul class="holds-list">
                            <% for (Charge h : holds) { %>
                                <li class="hold-item">
                                    <div>
                                        <h4><%= h.getDescription() %></h4>
                                        <p><%= h.getTermName() %></p>
                                    </div>
                                    <span class="pill red"><%= String.format("$%,.2f", h.getAmount()) %></span>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </article>

                <article class="financial-section">
                    <h2>Account status</h2>
                    <div class="list">
                        <div class="row"><div><h4>Payment standing</h4><p><%= owingMoney ? "A balance is currently due." : "Your account has no outstanding balance." %></p></div><span class="pill <%= owingMoney ? "gold" : "green" %>"><%= owingMoney ? "Due" : "Clear" %></span></div>
                        <div class="row"><div><h4>Financial holds</h4><p><%= holds != null ? holds.size() : 0 %> hold records found.</p></div><span class="pill <%= holds != null && !holds.isEmpty() ? "red" : "green" %>"><%= holds != null && !holds.isEmpty() ? "Review" : "No holds" %></span></div>
                    </div>
                </article>
            </section>

            <section class="financial-section" style="margin-top:16px">
                <h2>Charge breakdown</h2>
                <% if (charges == null || charges.isEmpty()) { %>
                    <p class="no-results">No charges on record.</p>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="results-table">
                            <thead><tr><th>Description</th><th>Term</th><th>Amount</th><th>Status</th><th>Posted</th></tr></thead>
                            <tbody>
                                <% for (Charge c : charges) {
                                    String statusClass = "status-" + c.getStatus();
                                %>
                                    <tr>
                                        <td><%= c.getDescription() %></td>
                                        <td><%= c.getTermName() %></td>
                                        <td class="mono"><%= String.format("$%,.2f", c.getAmount()) %></td>
                                        <td><span class="<%= statusClass %>"><%= c.getStatus().toUpperCase() %></span></td>
                                        <td><%= c.getPostedAt() %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </section>

            <section class="financial-section">
                <h2>Payment history</h2>
                <% if (payments == null || payments.isEmpty()) { %>
                    <p class="no-results">No payments on record.</p>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="results-table">
                            <thead><tr><th>Term</th><th>Amount</th><th>Paid</th></tr></thead>
                            <tbody>
                                <% for (Payment p : payments) { %>
                                    <tr><td><%= p.getTermName() %></td><td class="mono"><%= String.format("$%,.2f", p.getAmount()) %></td><td><%= p.getPaidAt() %></td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>
