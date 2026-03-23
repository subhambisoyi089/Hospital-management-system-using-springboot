<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Appointment Detail | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-receipt me-2 text-primary"></i>Appointment Detail</h1>
    <div class="d-flex gap-2">
      <c:if test="${appointment.status == 'SCHEDULED'}">
        <a href="${pageContext.request.contextPath}/appointments/status/${appointment.id}/COMPLETED"
           class="btn btn-success btn-sm"><i class="bi bi-check-circle me-1"></i>Mark Completed</a>
        <a href="${pageContext.request.contextPath}/appointments/status/${appointment.id}/CANCELLED"
           class="btn btn-warning btn-sm" onclick="return confirm('Cancel this appointment?')">
          <i class="bi bi-x-circle me-1"></i>Cancel</a>
      </c:if>
      <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back</a>
    </div>
  </div>

  <div class="card" style="max-width:750px">
    <div class="card-header d-flex justify-content-between align-items-center">
      <span><i class="bi bi-receipt me-2 text-primary"></i>Appointment #${appointment.id}</span>
      <c:choose>
        <c:when test="${appointment.status == 'SCHEDULED'}"><span class="badge" style="background:#dbeafe;color:#1e40af;font-size:.85rem">Scheduled</span></c:when>
        <c:when test="${appointment.status == 'COMPLETED'}"><span class="badge" style="background:#dcfce7;color:#166534;font-size:.85rem">Completed</span></c:when>
        <c:when test="${appointment.status == 'CANCELLED'}"><span class="badge" style="background:#fee2e2;color:#991b1b;font-size:.85rem">Cancelled</span></c:when>
        <c:otherwise><span class="badge bg-secondary">No Show</span></c:otherwise>
      </c:choose>
    </div>
    <div class="card-body">
      <div class="row g-4">
        <div class="col-md-6">
          <div class="p-3 rounded-3" style="background:#f8fafc;border:1px solid #e2e8f0">
            <div class="text-muted small mb-1"><i class="bi bi-people me-1"></i>Patient</div>
            <div class="fw-bold fs-6">${appointment.patient.fullName}</div>
            <div class="text-muted small"><code>${appointment.patient.patientId}</code></div>
            <div class="text-muted small">${appointment.patient.phone}</div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="p-3 rounded-3" style="background:#f8fafc;border:1px solid #e2e8f0">
            <div class="text-muted small mb-1"><i class="bi bi-person-badge me-1"></i>Doctor</div>
            <div class="fw-bold fs-6">${appointment.doctor.fullName}</div>
            <div class="text-muted small">${appointment.doctor.specialization}</div>
            <div class="text-muted small">${appointment.doctor.phone}</div>
          </div>
        </div>
        <div class="col-md-4"><div class="text-muted small">Date</div><div class="fw-semibold">${appointment.appointmentDate}</div></div>
        <div class="col-md-4"><div class="text-muted small">Time</div><div class="fw-semibold">${appointment.appointmentTime}</div></div>
        <div class="col-md-4"><div class="text-muted small">Token</div><div class="fw-semibold"><code>${appointment.tokenNumber}</code></div></div>
        <c:if test="${not empty appointment.symptoms}">
          <div class="col-12"><div class="text-muted small">Symptoms</div><div class="fw-semibold">${appointment.symptoms}</div></div>
        </c:if>
        <c:if test="${not empty appointment.notes}">
          <div class="col-12"><div class="text-muted small">Notes</div><div class="fw-semibold text-muted">${appointment.notes}</div></div>
        </c:if>
        <div class="col-md-6"><div class="text-muted small">Booked By</div><div class="fw-semibold">${appointment.bookedBy}</div></div>
        <div class="col-md-6"><div class="text-muted small">Created At</div><div class="fw-semibold">${appointment.createdAt}</div></div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
