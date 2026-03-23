<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>User Form | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1>
      <c:choose>
        <c:when test="${user.id != null}">Edit User</c:when>
        <c:otherwise>Add User</c:otherwise>
      </c:choose>
    </h1>
    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left me-1"></i>Back
    </a>
  </div>

  <div class="card" style="max-width:600px;">
    <div class="card-header">
      <i class="bi bi-person-gear me-2 text-primary"></i>User Details
    </div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/users/save" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="id" value="${user.id}"/>
        <div class="row g-3">
          <div class="col-12">
            <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
            <input type="text" name="fullName" class="form-control"
                   value="${user.fullName}" required placeholder="Full name"/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
            <input type="text" name="username" class="form-control"
                   value="${user.username}" required placeholder="username"
                   ${user.id != null ? 'readonly' : ''}/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">
              Password
              <c:if test="${user.id == null}"><span class="text-danger">*</span></c:if>
              <c:if test="${user.id != null}">
                <small class="text-muted">(leave blank to keep)</small>
              </c:if>
            </label>
            <input type="password" name="password" class="form-control"
                   placeholder="Password" ${user.id == null ? 'required' : ''}/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
            <input type="email" name="email" class="form-control"
                   value="${user.email}" required/>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Phone</label>
            <input type="text" name="phone" class="form-control" value="${user.phone}"/>
          </div>
          <div class="col-12">
            <label class="form-label fw-semibold">Roles <span class="text-danger">*</span></label>
            <div class="d-flex gap-3 flex-wrap">
              <c:forEach var="role" items="${allRoles}">
                <div class="form-check border rounded px-3 py-2">
                  <input type="checkbox" class="form-check-input" name="roleNames"
                         value="${role.name}" id="role_${role.id}"
                         ${userRoleNames != null and userRoleNames.contains(role.name) ? 'checked' : ''}/>
                  <label class="form-check-label fw-semibold" for="role_${role.id}">
                    <c:choose>
                      <c:when test="${role.name == 'ROLE_ADMIN'}">Admin</c:when>
                      <c:otherwise>Receptionist</c:otherwise>
                    </c:choose>
                  </label>
                </div>
              </c:forEach>
            </div>
          </div>
          <div class="col-12">
            <div class="form-check">
              <input type="checkbox" name="enabled" class="form-check-input" id="enabledChk"
                     ${user.enabled or user.id == null ? 'checked' : ''}/>
              <label class="form-check-label fw-semibold" for="enabledChk">Active Account</label>
            </div>
          </div>
        </div>
        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-primary">
            <i class="bi bi-check-circle me-1"></i>Save User
          </button>
          <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
