<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Doctor Detail | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-person-badge me-2 text-primary"></i>Doctor Profile</h1>
    <div class="d-flex gap-2">
      <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/doctors/edit/${doctor.id}" class="btn btn-outline-secondary btn-sm">
          <i class="bi bi-pencil me-1"></i>Edit</a>
      </sec:authorize>
      <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back</a>
    </div>
  </div>
  <div class="row g-3">
    <div class="col-md-4">
      <div class="card text-center p-4">
        <div style="width:90px;height:90px;border-radius:50%;background:linear-gradient(135deg,#1b6ca8,#0f4c75);
          display:flex;align-items:center;justify-content:center;color:#fff;font-size:2.2rem;font-weight:700;margin:0 auto 1rem">
          ${doctor.fullName.substring(0,1)}
        </div>
        <h5 class="fw-bold">${doctor.fullName}</h5>
        <div class="text-muted">${doctor.specialization}</div>
        <div class="mt-2">
          <c:choose>
            <c:when test="${doctor.available}">
              <span class="badge" style="background:#dcfce7;color:#166534;font-size:.85rem">Available</span>
            </c:when>
            <c:otherwise>
              <span class="badge" style="background:#fee2e2;color:#991b1b;font-size:.85rem">Unavailable</span>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="mt-2 fw-bold text-success fs-5">&#8377;${doctor.consultFee}</div>
      </div>
    </div>
    <div class="col-md-8">
      <div class="card">
        <div class="card-header"><i class="bi bi-info-circle me-2 text-primary"></i>Information</div>
        <div class="card-body">
          <div class="row g-3">
            <div class="col-6"><div class="text-muted small">Email</div><div class="fw-semibold">${doctor.email}</div></div>
            <div class="col-6"><div class="text-muted small">Phone</div><div class="fw-semibold">${doctor.phone}</div></div>
            <div class="col-6"><div class="text-muted small">Qualification</div><div class="fw-semibold">${doctor.qualification}</div></div>
            <div class="col-6"><div class="text-muted small">Experience</div><div class="fw-semibold">${doctor.experienceYears} years</div></div>
            <div class="col-6"><div class="text-muted small">Gender</div><div class="fw-semibold">${doctor.gender}</div></div>
            <div class="col-6"><div class="text-muted small">Consult Fee</div><div class="fw-semibold text-success">&#8377;${doctor.consultFee}</div></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
