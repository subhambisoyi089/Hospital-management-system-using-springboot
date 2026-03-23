<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Dashboard | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-grid-1x2 me-2 text-primary"></i>Dashboard</h1>
    <span class="text-muted small">Welcome, <strong>${username}</strong></span>
  </div>

  <!-- Stat Cards -->
  <div class="row g-3 mb-4">
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#1b6ca8,#0f4c75)">
        <i class="bi bi-person-badge ico"></i>
        <div class="num">${totalDoctors}</div>
        <div class="lbl">Total Doctors</div>
      </div>
    </div>
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#00b894,#00a381)">
        <i class="bi bi-person-check ico"></i>
        <div class="num">${availableDoctors}</div>
        <div class="lbl">Available</div>
      </div>
    </div>
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#6c5ce7,#5541d7)">
        <i class="bi bi-people ico"></i>
        <div class="num">${totalPatients}</div>
        <div class="lbl">Patients</div>
      </div>
    </div>
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#0984e3,#0773c5)">
        <i class="bi bi-calendar-check ico"></i>
        <div class="num">${totalAppointments}</div>
        <div class="lbl">Total Appts</div>
      </div>
    </div>
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#e17055,#c0392b)">
        <i class="bi bi-calendar-day ico"></i>
        <div class="num">${todayAppointments}</div>
        <div class="lbl">Today</div>
      </div>
    </div>
    <div class="col-6 col-lg-2">
      <div class="stat-card" style="background:linear-gradient(135deg,#fdcb6e,#e6b800)">
        <i class="bi bi-hourglass-split ico"></i>
        <div class="num">${scheduledCount}</div>
        <div class="lbl">Scheduled</div>
      </div>
    </div>
  </div>

  <div class="row g-3">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span><i class="bi bi-clock-history me-2 text-primary"></i>Recent Appointments</span>
          <a href="${pageContext.request.contextPath}/appointments" class="btn btn-sm btn-outline-primary">View All</a>
        </div>
        <div class="card-body p-0">
          <table class="table mb-0">
            <thead><tr>
              <th class="ps-3">Patient</th><th>Doctor</th><th>Date</th><th>Time</th><th>Status</th>
            </tr></thead>
            <tbody>
            <c:forEach var="a" items="${recentAppointments}">
              <tr>
                <td class="ps-3 fw-semibold">${a.patient.fullName}</td>
                <td>${a.doctor.fullName}</td>
                <td>${a.appointmentDate}</td>
                <td>${a.appointmentTime}</td>
                <td>
                  <c:choose>
                    <c:when test="${a.status == 'SCHEDULED'}"><span class="badge" style="background:#dbeafe;color:#1e40af">Scheduled</span></c:when>
                    <c:when test="${a.status == 'COMPLETED'}"><span class="badge" style="background:#dcfce7;color:#166534">Completed</span></c:when>
                    <c:when test="${a.status == 'CANCELLED'}"><span class="badge" style="background:#fee2e2;color:#991b1b">Cancelled</span></c:when>
                    <c:otherwise><span class="badge bg-secondary">No Show</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty recentAppointments}">
              <tr><td colspan="5" class="text-center text-muted py-4">No appointments yet</td></tr>
            </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="card">
        <div class="card-header"><i class="bi bi-lightning me-2 text-warning"></i>Quick Actions</div>
        <div class="card-body d-flex flex-column gap-2">
          <a href="${pageContext.request.contextPath}/appointments/new" class="btn btn-success text-start">
            <i class="bi bi-plus-circle me-2"></i>Book Appointment
          </a>
          <a href="${pageContext.request.contextPath}/patients/new" class="btn btn-outline-primary text-start">
            <i class="bi bi-person-plus me-2"></i>Register Patient
          </a>
          <a href="${pageContext.request.contextPath}/appointments/today" class="btn btn-outline-info text-start">
            <i class="bi bi-calendar-day me-2"></i>Today's Schedule
          </a>
          <sec:authorize access="hasRole('ADMIN')">
          <a href="${pageContext.request.contextPath}/doctors/new" class="btn btn-outline-secondary text-start">
            <i class="bi bi-person-badge me-2"></i>Add Doctor
          </a>
          <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary text-start">
            <i class="bi bi-person-gear me-2"></i>Manage Users
          </a>
          </sec:authorize>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
