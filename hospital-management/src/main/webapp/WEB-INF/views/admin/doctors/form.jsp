<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Doctor Form | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><c:choose><c:when test="${doctor.id != null}">Edit Doctor</c:when><c:otherwise>Add Doctor</c:otherwise></c:choose></h1>
    <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left me-1"></i>Back
    </a>
  </div>
  <div class="card" style="max-width:750px">
    <div class="card-header"><i class="bi bi-person-badge me-2 text-primary"></i>Doctor Details</div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/doctors/save" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="id" value="${doctor.id}"/>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
            <input type="text" name="fullName" class="form-control" value="${doctor.fullName}" required placeholder="Dr. Name"/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Specialization <span class="text-danger">*</span></label>
            <input type="text" name="specialization" class="form-control" value="${doctor.specialization}" required placeholder="Cardiology"/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
            <input type="email" name="email" class="form-control" value="${doctor.email}" required/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Phone <span class="text-danger">*</span></label>
            <input type="text" name="phone" class="form-control" value="${doctor.phone}" required/>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Qualification</label>
            <input type="text" name="qualification" class="form-control" value="${doctor.qualification}" placeholder="MD, MS..."/>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Experience (years)</label>
            <input type="number" name="experienceYears" class="form-control" value="${doctor.experienceYears}" min="0"/>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Consult Fee (₹)</label>
            <input type="number" name="consultFee" class="form-control" value="${doctor.consultFee}" min="0" step="50"/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Gender</label>
            <select name="gender" class="form-select">
              <option value="">Select</option>
              <option value="Male"   ${doctor.gender == 'Male'   ? 'selected' : ''}>Male</option>
              <option value="Female" ${doctor.gender == 'Female' ? 'selected' : ''}>Female</option>
              <option value="Other"  ${doctor.gender == 'Other'  ? 'selected' : ''}>Other</option>
            </select>
          </div>
          <div class="col-md-6 d-flex align-items-end">
            <div class="form-check">
              <input type="checkbox" name="available" class="form-check-input" id="avail"
                     ${doctor.available ? 'checked' : ''}/>
              <label class="form-check-label fw-semibold" for="avail">Available for Appointments</label>
            </div>
          </div>
        </div>
        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Save Doctor</button>
          <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
