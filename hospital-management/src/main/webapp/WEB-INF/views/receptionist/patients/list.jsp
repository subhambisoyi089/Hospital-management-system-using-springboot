<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Patients | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-people me-2 text-primary"></i>Patients</h1>
    <a href="${pageContext.request.contextPath}/patients/new" class="btn btn-primary btn-sm">
      <i class="bi bi-person-plus me-1"></i>Register Patient
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

  <div class="card mb-3">
    <div class="card-body py-2">
      <form action="${pageContext.request.contextPath}/patients" method="get" class="d-flex gap-2">
        <div class="input-group" style="max-width:300px">
          <span class="input-group-text"><i class="bi bi-search"></i></span>
          <input type="text" name="search" class="form-control" placeholder="Search by name..." value="${search}"/>
        </div>
        <button type="submit" class="btn btn-outline-primary btn-sm">Search</button>
        <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary btn-sm">Clear</a>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="card-header">All Patients (${patients.size()})</div>
    <div class="card-body p-0">
      <table class="table mb-0">
        <thead><tr>
          <th class="ps-3">#</th><th>Patient ID</th><th>Name</th><th>Phone</th>
          <th>Gender</th><th>Blood Group</th><th>Registered</th><th>Actions</th>
        </tr></thead>
        <tbody>
        <c:forEach var="p" items="${patients}" varStatus="s">
          <tr>
            <td class="ps-3 text-muted">${s.count}</td>
            <td><code>${p.patientId}</code></td>
            <td class="fw-semibold">${p.fullName}</td>
            <td>${p.phone}</td>
            <td>${p.gender}</td>
            <td><span class="badge bg-light text-dark">${p.bloodGroup}</span></td>
            <td>${p.registeredOn}</td>
            <td>
              <div class="d-flex gap-1">
                <a href="${pageContext.request.contextPath}/patients/view/${p.id}" class="btn btn-sm btn-outline-info"><i class="bi bi-eye"></i></a>
                <a href="${pageContext.request.contextPath}/patients/edit/${p.id}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-pencil"></i></a>
                <a href="${pageContext.request.contextPath}/appointments/new?patientId=${p.id}" class="btn btn-sm btn-outline-success" title="Book Appointment"><i class="bi bi-calendar-plus"></i></a>
                <a href="${pageContext.request.contextPath}/patients/delete/${p.id}" class="btn btn-sm btn-outline-danger"
                   onclick="return confirm('Delete this patient?')"><i class="bi bi-trash"></i></a>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty patients}">
          <tr><td colspan="8" class="text-center text-muted py-4">No patients found</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
