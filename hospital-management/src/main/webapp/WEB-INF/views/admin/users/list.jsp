<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Users | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../common/navbar.jsp"/>
<div class="main">
  <div class="topbar">
    <h1><i class="bi bi-person-gear me-2 text-primary"></i>User Management</h1>
    <a href="${pageContext.request.contextPath}/admin/users/new" class="btn btn-primary btn-sm">
      <i class="bi bi-person-plus me-1"></i>Add User
    </a>
  </div>

  <c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show">
      <i class="bi bi-check-circle me-2"></i>${success}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-triangle me-2"></i>${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="card">
    <div class="card-header">All System Users (${users.size()})</div>
    <div class="card-body p-0">
      <table class="table mb-0">
        <thead>
          <tr>
            <th class="ps-3">#</th>
            <th>Name</th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Roles</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}" varStatus="s">
          <tr>
            <td class="ps-3 text-muted">${s.count}</td>
            <td>
              <div class="d-flex align-items-center gap-2">
                <div style="width:34px;height:34px;border-radius:50%;
                  background:linear-gradient(135deg,#1b6ca8,#0f4c75);
                  display:flex;align-items:center;justify-content:center;
                  color:#fff;font-weight:700;font-size:.85rem;">
                  ${u.fullName.substring(0,1)}
                </div>
                <span class="fw-semibold">${u.fullName}</span>
              </div>
            </td>
            <td class="text-muted">${u.username}</td>
            <td class="text-muted small">${u.email}</td>
            <td class="text-muted small">${u.phone}</td>
            <td>
              <c:forEach var="r" items="${u.roles}">
                <c:choose>
                  <c:when test="${r.name == 'ROLE_ADMIN'}">
                    <span class="badge bg-danger me-1">Admin</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-info text-dark me-1">Receptionist</span>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </td>
            <td>
              <c:choose>
                <c:when test="${u.enabled}">
                  <span class="badge" style="background:#dcfce7;color:#166534;">Active</span>
                </c:when>
                <c:otherwise>
                  <span class="badge" style="background:#fee2e2;color:#991b1b;">Disabled</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <div class="d-flex gap-1">
                <a href="${pageContext.request.contextPath}/admin/users/edit/${u.id}"
                   class="btn btn-sm btn-outline-secondary" title="Edit">
                  <i class="bi bi-pencil"></i>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users/toggle/${u.id}"
                   class="btn btn-sm btn-outline-warning" title="Toggle Status">
                  <i class="bi bi-toggle-on"></i>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users/delete/${u.id}"
                   class="btn btn-sm btn-outline-danger" title="Delete"
                   onclick="return confirm('Delete this user?')">
                  <i class="bi bi-trash"></i>
                </a>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty users}">
          <tr>
            <td colspan="8" class="text-center text-muted py-4">No users found</td>
          </tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
