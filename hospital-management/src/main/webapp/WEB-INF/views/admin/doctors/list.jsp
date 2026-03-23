<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Doctors | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-person-badge me-2 text-primary"></i>Doctors</h1>
    <sec:authorize access="hasRole('ADMIN')">
      <a href="${pageContext.request.contextPath}/doctors/new" class="btn btn-primary btn-sm">
        <i class="bi bi-plus-circle me-1"></i> Add Doctor
      </a>
    </sec:authorize>
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
      <form action="${pageContext.request.contextPath}/doctors" method="get" class="d-flex gap-2">
        <div class="input-group" style="max-width:300px">
          <span class="input-group-text"><i class="bi bi-search"></i></span>
          <input type="text" name="search" class="form-control" placeholder="Search by name..." value="${search}"/>
        </div>
        <button type="submit" class="btn btn-outline-primary btn-sm">Search</button>
        <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-secondary btn-sm">Clear</a>
      </form>
    </div>
  </div>

  <div class="row g-3">
    <c:forEach var="d" items="${doctors}">
    <div class="col-md-6 col-lg-4">
      <div class="card h-100">
        <div class="card-body">
          <div class="d-flex align-items-center gap-3 mb-3">
            <div style="width:50px;height:50px;border-radius:50%;background:linear-gradient(135deg,#1b6ca8,#0f4c75);
                        display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:1.2rem;">
              ${d.fullName.substring(0,1)}
            </div>
            <div>
              <div class="fw-bold">${d.fullName}</div>
              <div class="text-muted small">${d.specialization}</div>
            </div>
          </div>
          <div class="small text-muted mb-1"><i class="bi bi-telephone me-1"></i>${d.phone}</div>
          <div class="small text-muted mb-1"><i class="bi bi-envelope me-1"></i>${d.email}</div>
          <div class="small text-muted mb-2"><i class="bi bi-award me-1"></i>${d.qualification} &bull; ${d.experienceYears} yrs exp</div>
          <div class="d-flex justify-content-between align-items-center">
            <c:choose>
              <c:when test="${d.available}">
                <span class="badge" style="background:#dcfce7;color:#166534">Available</span>
              </c:when>
              <c:otherwise>
                <span class="badge" style="background:#fee2e2;color:#991b1b">Unavailable</span>
              </c:otherwise>
            </c:choose>
            <span class="fw-semibold text-success">&#8377;${d.consultFee}</span>
          </div>
        </div>
        <div class="card-footer bg-transparent d-flex gap-1">
          <a href="${pageContext.request.contextPath}/doctors/view/${d.id}" class="btn btn-sm btn-outline-info"><i class="bi bi-eye"></i></a>
          <sec:authorize access="hasRole('ADMIN')">
            <a href="${pageContext.request.contextPath}/doctors/edit/${d.id}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-pencil"></i></a>
            <a href="${pageContext.request.contextPath}/doctors/toggle/${d.id}" class="btn btn-sm btn-outline-warning"><i class="bi bi-toggle-on"></i></a>
            <a href="${pageContext.request.contextPath}/doctors/delete/${d.id}" class="btn btn-sm btn-outline-danger"
               onclick="return confirm('Delete this doctor?')"><i class="bi bi-trash"></i></a>
          </sec:authorize>
        </div>
      </div>
    </div>
    </c:forEach>
    <c:if test="${empty doctors}">
      <div class="col-12 text-center text-muted py-5">No doctors found.</div>
    </c:if>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
