<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Patient Detail | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-person-circle me-2 text-primary"></i>Patient Profile</h1>
    <div class="d-flex gap-2">
      <a href="${pageContext.request.contextPath}/appointments/new?patientId=${patient.id}" class="btn btn-success btn-sm">
        <i class="bi bi-calendar-plus me-1"></i>Book Appointment</a>
      <a href="${pageContext.request.contextPath}/patients/edit/${patient.id}" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-pencil me-1"></i>Edit</a>
      <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back</a>
    </div>
  </div>
  <div class="row g-3">
    <div class="col-md-4">
      <div class="card text-center p-4">
        <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#6c5ce7,#5541d7);
          display:flex;align-items:center;justify-content:center;color:#fff;font-size:2rem;font-weight:700;margin:0 auto 1rem">
          ${patient.fullName.substring(0,1)}
        </div>
        <h5 class="fw-bold">${patient.fullName}</h5>
        <div class="text-muted small"><code>${patient.patientId}</code></div>
        <div class="mt-2">
          <span class="badge bg-light text-dark">${patient.bloodGroup}</span>
          <span class="badge bg-light text-dark ms-1">${patient.gender}</span>
        </div>
      </div>
    </div>
    <div class="col-md-8">
      <div class="card mb-3">
        <div class="card-header"><i class="bi bi-info-circle me-2 text-primary"></i>Patient Information</div>
        <div class="card-body">
          <div class="row g-3">
            <div class="col-6"><div class="text-muted small">Phone</div><div class="fw-semibold">${patient.phone}</div></div>
            <div class="col-6"><div class="text-muted small">Email</div><div class="fw-semibold">${patient.email}</div></div>
            <div class="col-6"><div class="text-muted small">Date of Birth</div><div class="fw-semibold">${patient.dateOfBirth}</div></div>
            <div class="col-6"><div class="text-muted small">Registered On</div><div class="fw-semibold">${patient.registeredOn}</div></div>
            <div class="col-12"><div class="text-muted small">Address</div><div class="fw-semibold">${patient.address}</div></div>
            <c:if test="${not empty patient.medicalHistory}">
              <div class="col-12"><div class="text-muted small">Medical History</div>
                <div class="fw-semibold text-muted">${patient.medicalHistory}</div></div>
            </c:if>
          </div>
        </div>
      </div>
      <div class="card">
        <div class="card-header"><i class="bi bi-calendar-check me-2 text-primary"></i>Appointments</div>
        <div class="card-body p-0">
          <table class="table mb-0">
            <thead><tr><th class="ps-3">Doctor</th><th>Date</th><th>Time</th><th>Token</th><th>Status</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${appointments}">
              <tr>
                <td class="ps-3">${a.doctor.fullName}</td>
                <td>${a.appointmentDate}</td>
                <td>${a.appointmentTime}</td>
                <td><code>${a.tokenNumber}</code></td>
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
            <c:if test="${empty appointments}">
              <tr><td colspan="5" class="text-center text-muted py-3">No appointments</td></tr>
            </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
