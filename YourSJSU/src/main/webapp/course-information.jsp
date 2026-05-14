<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.yoursjsu.model.User" %>
<%@ page import="com.yoursjsu.model.SectionResult" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YourSJSU – Course Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20260507-sidebar-edge">
    <style>

		.course-hero {
		    background: #ffffff;
		    border: 1px solid #e5e7eb;
		    border-radius: 12px;
		    padding: 28px 32px;
		    display: flex;
		    align-items: flex-start;
		    justify-content: space-between;
		    gap: 24px;
		    flex-wrap: wrap;
		    margin-bottom: 16px;
		}
		.course-hero-left  { flex: 1 1 0; min-width: 0; }
		.course-hero-right {
		    flex: 0 0 auto;
		    display: flex;
		    flex-direction: column;
		    align-items: flex-end;
		    gap: 10px;
		}
		.course-hero-left .eyebrow {
		    display: block;
		    font-size: 0.72rem;
		    font-weight: 700;
		    letter-spacing: 0.12em;
		    text-transform: uppercase;
		    color: #6b7280;
		    margin-bottom: 8px;
		}
		.course-hero-left h1 {
		    font-size: 1.5rem;
		    font-weight: 700;
		    margin: 0 0 10px;
		    line-height: 1.25;
		    color: #111827;
		}
		.hero-sub {
		    font-size: 0.875rem;
		    color: #6b7280;
		}
		.section-id-badge {
		    font-size: 2rem;
		    font-weight: 800;
		    letter-spacing: -1px;
		    color: #4f8ef7;
		    line-height: 1;
		}
		.pill-lg {
		    font-size: 0.78rem;
		    padding: 5px 16px;
		    border-radius: 20px;
		    font-weight: 700;
		    letter-spacing: 0.04em;
		}
		
		/* Detail grid */
		.detail-grid {
		    display: grid;
		    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
		    gap: 16px;
		}
		.detail-card {
		    background: #ffffff;
		    border: 1px solid #e5e7eb;
		    border-radius: 12px;
		    padding: 22px 26px;
		}
		.detail-card h3 {
		    font-size: 0.68rem;
		    text-transform: uppercase;
		    letter-spacing: 0.12em;
		    color: #9ca3af;
		    margin: 0 0 16px;
		}
		
		/* Key/value rows */
		.kv-list { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; }
		.kv-list li {
		    display: flex;
		    justify-content: space-between;
		    align-items: baseline;
		    gap: 12px;
		    font-size: 0.86rem;
		    border-bottom: 1px solid #f3f4f6;
		    padding: 10px 0;
		    color: #111827;
		}
		.kv-list li:first-child { padding-top: 0; }
		.kv-list li:last-child  { border-bottom: none; padding-bottom: 0; }
		.kv-list .k { color: #6b7280; white-space: nowrap; flex-shrink: 0; }
		.kv-list .v { font-weight: 600; text-align: right; word-break: break-word; color: #111827; }
		
		/* Capacity bar */
		.cap-section { margin-top: 16px; padding-top: 14px; border-top: 1px solid #f3f4f6; }
		.cap-bar-track {
		    height: 7px;
		    border-radius: 4px;
		    background: #e5e7eb;
		    overflow: hidden;
		    margin-bottom: 6px;
		}
		.cap-bar-fill { height: 100%; border-radius: 4px; background: #4f8ef7; }
		.cap-bar-fill.warn { background: #e8a020; }
		.cap-bar-fill.full { background: #d94f4f; }
		.cap-labels {
		    display: flex;
		    justify-content: space-between;
		    font-size: 0.74rem;
		    color: #6b7280;
		}
		
		/* Full-width card */
		.full-width { grid-column: 1 / -1; }
		
		/* Back link */
		.back-link {
		    display: inline-flex;
		    align-items: center;
		    gap: 6px;
		    font-size: 0.8rem;
		    color: #6b7280;
		    text-decoration: none;
		    margin-bottom: 18px;
		    transition: color 0.15s;
		}
		.back-link:hover { color: #111827; }
		.back-link::before { content: "←"; }
		
		/* Modality badge */
		.modality-tag {
		    display: inline-block;
		    font-size: 0.72rem;
		    font-weight: 700;
		    letter-spacing: 0.06em;
		    text-transform: uppercase;
		    padding: 3px 10px;
		    border-radius: 6px;
		    background: #f3f4f6;
		    color: #374151;
		}
        
	    .compact-table tbody tr.clickable-row td {
	        position: relative;
	        padding: 0;           /* padding moves inside the <a> instead */
	    }

	    .compact-table tbody tr.clickable-row td a.row-link {
	        display:         block;
	        position:        absolute;
	        inset:           0;          /* shorthand for top/right/bottom/left: 0 */
	        padding:         10px 12px;  /* match your existing td padding */
	        color:           inherit;
	        text-decoration: none;
	        white-space:     nowrap;
	        overflow:        hidden;
	        text-overflow:   ellipsis;
	    }
	
	    .compact-table tbody tr.clickable-row {
	        min-height: 44px;
	    }
	
	    .compact-table tbody tr.clickable-row:hover {
	        background: var(--surface-hover, rgba(255,255,255,0.04));
	        cursor: pointer;
	    }
	
	    .compact-table tbody tr.clickable-row td .pill {
	        position: relative;
	        z-index:  1;
	        pointer-events: none;   /* clicks pass through to the <a> below */
	    }

	    .compact-table tbody tr.clickable-row td.status-cell {
	        text-align: center;
	        vertical-align: middle;
	    }
    </style>
    
</head>
<body class="dashboard-page">
<%

    User user           = (User)          session.getAttribute("user");
    SectionResult sr    = (SectionResult) request.getAttribute("section");
    String enrollStatus = (String)        request.getAttribute("enrollStatus");
    String sectionIdStr = (String)        request.getAttribute("sectionId");
    if (enrollStatus  == null) enrollStatus  = "Not Enrolled";
    if (sectionIdStr  == null) sectionIdStr  = "—";

    /* Nav initials */
    String userInitials = (user != null
            && user.getFirstName() != null && !user.getFirstName().isEmpty()
            && user.getLastName()  != null && !user.getLastName().isEmpty())
            ? (user.getFirstName().substring(0,1) + user.getLastName().substring(0,1)).toUpperCase()
            : "SJ";

    java.util.function.Function<Object, String> safe = v ->
        (v == null || v.toString().isBlank()) ? "—" : v.toString().trim();

    int enrolled      = sr != null ? sr.getEnrolledCount()    : 0;
    int capacity      = sr != null ? sr.getCapacity()          : 0;
    int waitlisted    = sr != null ? sr.getWaitlistCount()     : 0;
    int waitlistCap   = sr != null ? sr.getWaitlistCapacity()  : 0;
    int available     = (capacity > 0) ? Math.max(0, capacity - enrolled) : 0;
    double fillPct    = (capacity > 0) ? (double) enrolled / capacity * 100.0 : 0;
    String barClass   = fillPct >= 100 ? "full" : fillPct >= 80 ? "warn" : "";

    String pillClass = "green";
    if ("Waitlisted".equalsIgnoreCase(enrollStatus))   pillClass = "gold";
    else if ("Not Enrolled".equalsIgnoreCase(enrollStatus)) pillClass = "red";
%>
    <div class="portal-shell">

        <!-- ── Sidebar (identical to dashboard) ──────────────────────────── -->
        <aside class="portal-rail" aria-label="Portal navigation">
            <div class="brand">
                <div class="seal">SJ</div>
                <div class="brand-copy">
                    <h1>YourSJSU</h1>
                    <span>Student Portal</span>
                </div>
            </div>
            <nav class="portal-nav">
                <a href="${pageContext.request.contextPath}/student-dashboard" aria-label="Overview">
                    <span class="nav-icon nav-icon-overview" aria-hidden="true"></span>
                    <span class="nav-label">Overview</span>
                </a>
                <a href="${pageContext.request.contextPath}/search-courses" aria-label="Course Search">
                    <span class="nav-icon nav-icon-search" aria-hidden="true"></span>
                    <span class="nav-label">Course Search</span>
                </a>
                <a href="${pageContext.request.contextPath}/schedule" aria-label="Term Schedule">
                    <span class="nav-icon nav-icon-schedule" aria-hidden="true"></span>
                    <span class="nav-label">Term Schedule</span>
                </a>
                <a href="${pageContext.request.contextPath}/transcript" aria-label="Transcript">
                    <span class="nav-icon nav-icon-transcript" aria-hidden="true"></span>
                    <span class="nav-label">Transcript</span>
                </a>
                <a href="${pageContext.request.contextPath}/financial-summary" aria-label="Finances">
                    <span class="nav-icon nav-icon-finances" aria-hidden="true"></span>
                    <span class="nav-label">Finances</span>
                </a>
                <% if (user != null && user.getIsStudent() && user.getIsFaculty()) { %>
                    <a href="${pageContext.request.contextPath}/select-role" aria-label="Switch Role">
                        <span class="nav-icon nav-icon-switch" aria-hidden="true"></span>
                        <span class="nav-label">Switch Role</span>
                    </a>
                <% } %>
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
                    <p>San Jose State University</p>
                    <h1>Course Detail</h1>
                </div>
            </header>

            <div style="margin-top:16px">
                <a class="back-link" href="${pageContext.request.contextPath}/student-dashboard">
                    Back to Dashboard
                </a>

                <div class="course-hero">
                    <div class="course-hero-left">
                        <span class="eyebrow">
                            <%= safe.apply(sr != null ? sr.getDepartmentCode() : null) %>
                            &nbsp;<%= safe.apply(sr != null ? sr.getCourseNumber() : null) %>
                            &nbsp;·&nbsp; Section ID <%= sectionIdStr %>
                        </span>
                        <h1><%= safe.apply(sr != null ? sr.getCourseTitle() : null) %></h1>
                        <p class="hero-sub">
                            <%= safe.apply(sr != null ? sr.getTermName() : null) %>
                            &nbsp;·&nbsp;
                            <span class="modality-tag"><%= safe.apply(sr != null ? sr.getModality() : null) %></span>
                            &nbsp;·&nbsp;
                            <%= safe.apply(sr != null ? sr.getUnits() : null) %> unit<%= (sr != null && sr.getUnits() == 1) ? "" : "s" %>
                        </p>
                    </div>
                    <div class="course-hero-right">
                        <span class="section-id-badge">#<%= sectionIdStr %></span>
                        <span class="pill pill-lg <%= pillClass %>"><%= enrollStatus %></span>
                    </div>
                </div>

                <div class="detail-grid">

                    <!-- Card 1 · Course info -->
                    <div class="detail-card">
                        <h3>Course</h3>
                        <ul class="kv-list">
                            <li>
                                <span class="k">Title</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getCourseTitle() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Department code</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getDepartmentCode() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Course number</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getCourseNumber() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Units</span>
                                <span class="v"><%= sr != null ? sr.getUnits() : "—" %></span>
                            </li>
                            <li>
                                <span class="k">Term</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getTermName() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Modality</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getModality() : null) %></span>
                            </li>
                        </ul>
                    </div>


                    <div class="detail-card">
                        <h3>Schedule &amp; location</h3>
                        <ul class="kv-list">
                            <li>
                                <span class="k">Meeting days</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getMeetingDays() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Start time</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getStartTime() : null) %></span>
                            </li>
                            <li>
                                <span class="k">End time</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getEndTime() : null) %></span>
                            </li>
                            <li>
                                <span class="k">Location</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getLocation() : null) %></span>
                            </li>
                        </ul>
                    </div>

                    <div class="detail-card">
                        <h3>Instructor</h3>
                        <ul class="kv-list">
                            <li>
                                <span class="k">Name</span>
                                <span class="v"><%= safe.apply(sr != null ? sr.getInstructorName() : null) %></span>
                            </li>
                        </ul>
                    </div>

                    <div class="detail-card full-width">
                        <h3>Enrollment &amp; capacity</h3>
                        <ul class="kv-list">
                            <li>
                                <span class="k">Section ID</span>
                                <span class="v"><%= sectionIdStr %></span>
                            </li>
                            <li>
                                <span class="k">Enrolled</span>
                                <span class="v"><%= enrolled %></span>
                            </li>
                            <li>
                                <span class="k">Section capacity</span>
                                <span class="v"><%= capacity > 0 ? capacity : "—" %></span>
                            </li>
                            <li>
                                <span class="k">Available seats</span>
                                <span class="v"><%= capacity > 0 ? available : "—" %></span>
                            </li>
                            <li>
                                <span class="k">Waitlisted</span>
                                <span class="v"><%= waitlisted %></span>
                            </li>
                            <li>
                                <span class="k">Waitlist capacity</span>
                                <span class="v"><%= waitlistCap > 0 ? waitlistCap : "—" %></span>
                            </li>
                            <li>
                                <span class="k">Your status</span>
                                <span class="v">
                                    <span class="pill <%= pillClass %>"><%= enrollStatus %></span>
                                </span>
                            </li>
                        </ul>

                        <% if (capacity > 0) { %>
                        <div class="cap-section">
                            <div class="cap-bar-track">
                                <div class="cap-bar-fill <%= barClass %>"
                                     style="width:<%= Math.min(100, (int) Math.round(fillPct)) %>%">
                                </div>
                            </div>
                            <div class="cap-labels">
                                <span>Seat fill rate</span>
                                <span><%= enrolled %> / <%= capacity %> &nbsp;(<%= String.format("%.0f", fillPct) %>%)</span>
                            </div>
                        </div>
                        <% } %>
                    </div>

                </div>
            </div>
        </main>
    </div>
</body>
</html>
