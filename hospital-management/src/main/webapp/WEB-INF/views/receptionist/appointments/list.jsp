<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Appointments | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-calendar-check me-2 text-primary"></i>
      <c:choose><c:when test="${isToday}">Today's Appointments</c:when><c:otherwise>All Appointments</c:otherwise></c:choose>
    </h1>
    <a href="${pageContext.request.contextPath}/appointments/new" class="btn btn-primary btn-sm">
      <i class="bi bi-plus-circle me-1"></i>Book Appointment
    </a>
  </div>

  <c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle me-2"></i>${success}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle me-2"></i>${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>

  <!-- Filter -->
  <div class="card mb-3">
    <div class="card-body py-2">
      <form action="${pageContext.request.contextPath}/appointments" method="get" class="d-flex gap-2 align-items-center">
        <label class="fw-semibold small me-1">Filter by Date:</label>
        <input type="date" name="date" class="form-control" style="max-width:180px" value="${filterDate}"/>
        <button type="submit" class="btn btn-outline-primary btn-sm">Filter</button>
        <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary btn-sm">All</a>
        <a href="${pageContext.request.contextPath}/appointments/today" class="btn btn-outline-info btn-sm">Today</a>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="card-header">Appointments (${appointments.size()})</div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table mb-0">
          <thead><tr>
            <th class="ps-3">#</th><th>Token</th><th>Patient</th><th>Doctor</th>
            <th>Date</th><th>Time</th><th>Symptoms</th><th>Status</th><th>Actions</th>
          </tr></thead>
          <tbody>
          <c:forEach var="a" items="${appointments}" varStatus="s">
            <tr>
              <td class="ps-3 text-muted">${s.count}</td>
              <td><code>${a.tokenNumber}</code></td>
              <td class="fw-semibold">${a.patient.fullName}</td>
              <td>${a.doctor.fullName}<div class="text-muted small">${a.doctor.specialization}</div></td>
              <td>${a.appointmentDate}</td>
              <td>${a.appointmentTime}</td>
              <td class="text-muted small" style="max-width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${a.symptoms}</td>
              <td>
                <c:choose>
                  <c:when test="${a.status == 'SCHEDULED'}"><span class="badge" style="background:#dbeafe;color:#1e40af">Scheduled</span></c:when>
                  <c:when test="${a.status == 'COMPLETED'}"><span class="badge" style="background:#dcfce7;color:#166534">Completed</span></c:when>
                  <c:when test="${a.status == 'CANCELLED'}"><span class="badge" style="background:#fee2e2;color:#991b1b">Cancelled</span></c:when>
                  <c:otherwise><span class="badge bg-secondary">No Show</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <div class="d-flex gap-1">
                  <a href="${pageContext.request.contextPath}/appointments/view/${a.id}" class="btn btn-sm btn-outline-info"><i class="bi bi-eye"></i></a>
                  <c:if test="${a.status == 'SCHEDULED'}">
                    <a href="${pageContext.request.contextPath}/appointments/status/${a.id}/COMPLETED" class="btn btn-sm btn-outline-success" title="Mark Completed"><i class="bi bi-check-circle"></i></a>
                    <a href="${pageContext.request.contextPath}/appointments/status/${a.id}/CANCELLED" class="btn btn-sm btn-outline-warning" title="Cancel" onclick="return confirm('Cancel this appointment?')"><i class="bi bi-x-circle"></i></a>
                  </c:if>
                  <a href="${pageContext.request.contextPath}/appointments/delete/${a.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this appointment?')"><i class="bi bi-trash"></i></a>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty appointments}">
            <tr><td colspan="9" class="text-center text-muted py-4">No appointments found</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
