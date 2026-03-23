<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Patient Form | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><c:choose><c:when test="${patient.id != null}">Edit Patient</c:when><c:otherwise>Register Patient</c:otherwise></c:choose></h1>
    <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Back</a>
  </div>
  <div class="card" style="max-width:750px">
    <div class="card-header"><i class="bi bi-person-plus me-2 text-primary"></i>Patient Details</div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/patients/save" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="id" value="${patient.id}"/>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
            <input type="text" name="fullName" class="form-control" value="${patient.fullName}" required/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Phone <span class="text-danger">*</span></label>
            <input type="text" name="phone" class="form-control" value="${patient.phone}" required/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Email</label>
            <input type="email" name="email" class="form-control" value="${patient.email}"/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Date of Birth</label>
            <input type="date" name="dateOfBirth" class="form-control" value="${patient.dateOfBirth}"/>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Gender</label>
            <select name="gender" class="form-select">
              <option value="">Select</option>
              <option value="Male"   ${patient.gender == 'Male'   ? 'selected' : ''}>Male</option>
              <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
              <option value="Other"  ${patient.gender == 'Other'  ? 'selected' : ''}>Other</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Blood Group</label>
            <select name="bloodGroup" class="form-select">
              <option value="">Select</option>
              <option value="A+"  ${patient.bloodGroup == 'A+'  ? 'selected' : ''}>A+</option>
              <option value="A-"  ${patient.bloodGroup == 'A-'  ? 'selected' : ''}>A-</option>
              <option value="B+"  ${patient.bloodGroup == 'B+'  ? 'selected' : ''}>B+</option>
              <option value="B-"  ${patient.bloodGroup == 'B-'  ? 'selected' : ''}>B-</option>
              <option value="AB+" ${patient.bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
              <option value="AB-" ${patient.bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
              <option value="O+"  ${patient.bloodGroup == 'O+'  ? 'selected' : ''}>O+</option>
              <option value="O-"  ${patient.bloodGroup == 'O-'  ? 'selected' : ''}>O-</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Address</label>
            <input type="text" name="address" class="form-control" value="${patient.address}"/>
          </div>
          <div class="col-12">
            <label class="form-label fw-semibold">Medical History</label>
            <textarea name="medicalHistory" class="form-control" rows="3" placeholder="Any known conditions, allergies...">${patient.medicalHistory}</textarea>
          </div>
        </div>
        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Save Patient</button>
          <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
