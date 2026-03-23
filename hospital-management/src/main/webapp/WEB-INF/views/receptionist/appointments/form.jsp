<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Book Appointment | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-calendar-plus me-2 text-success"></i>Book Appointment</h1>
    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left me-1"></i>Back
    </a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle me-2"></i>${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>

  <div class="card" style="max-width:700px">
    <div class="card-header"><i class="bi bi-calendar-plus me-2 text-success"></i>Appointment Details</div>
    <div class="card-body">
      <div class="alert alert-info py-2 px-3 mb-4" style="border-radius:10px;font-size:.88rem;">
        <i class="bi bi-info-circle me-1"></i>
        Token number is auto-generated per doctor per day.
      </div>
      <form action="${pageContext.request.contextPath}/appointments/save" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label fw-semibold">Patient <span class="text-danger">*</span></label>
            <select name="patientId" class="form-select" required>
              <option value="">-- Select Patient --</option>
              <c:forEach var="p" items="${patients}">
                <option value="${p.id}" ${p.id == selectedPatientId ? 'selected' : ''}>${p.fullName} (${p.patientId})</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Doctor <span class="text-danger">*</span></label>
            <select name="doctorId" class="form-select" required>
              <option value="">-- Select Doctor --</option>
              <c:forEach var="d" items="${doctors}">
                <option value="${d.id}">${d.fullName} — ${d.specialization}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Appointment Date <span class="text-danger">*</span></label>
            <input type="date" name="appointmentDate" class="form-control" required
                   min=""/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Appointment Time <span class="text-danger">*</span></label>
            <input type="time" name="appointmentTime" class="form-control" required/>
          </div>
          <div class="col-12">
            <label class="form-label fw-semibold">Symptoms / Reason</label>
            <textarea name="symptoms" class="form-control" rows="3" placeholder="Describe symptoms or reason for visit..."></textarea>
          </div>
          <div class="col-12">
            <label class="form-label fw-semibold">Notes</label>
            <textarea name="notes" class="form-control" rows="2" placeholder="Any additional notes..."></textarea>
          </div>
        </div>
        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-success"><i class="bi bi-check-circle me-1"></i>Book Appointment</button>
          <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
