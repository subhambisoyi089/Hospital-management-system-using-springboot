<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Login | HospitalMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
<style>
  body { background: linear-gradient(135deg, #0f4c75 0%, #1b6ca8 50%, #0a3d62 100%);
         min-height: 100vh; display: flex; align-items: center; justify-content: center;
         font-family: 'Segoe UI', sans-serif; }
  .login-card { background: #fff; border-radius: 20px; padding: 2.5rem 2rem;
                width: 100%; max-width: 420px; box-shadow: 0 20px 60px rgba(0,0,0,.3); }
  .brand-icon { font-size: 3rem; color: #1b6ca8; }
  .brand-title { font-size: 1.6rem; font-weight: 700; color: #0f4c75; }
  .brand-sub { color: #6c757d; font-size: .88rem; }
  .form-control { border-radius: 10px; border: 1.5px solid #dee2e6; padding: .7rem 1rem; }
  .form-control:focus { border-color: #1b6ca8; box-shadow: 0 0 0 3px rgba(27,108,168,.12); }
  .btn-login { background: #1b6ca8; color: #fff; border: none; border-radius: 10px;
               padding: .75rem; font-weight: 600; width: 100%; font-size: 1rem; transition: all .2s; }
  .btn-login:hover { background: #0f4c75; transform: translateY(-1px); }
  .cred-box { background: #f0f7ff; border: 1px solid #bee3f8; border-radius: 12px;
              padding: 1rem; margin-top: 1.5rem; }
  .cred-box h6 { font-size: .75rem; text-transform: uppercase; letter-spacing: 1px;
                 color: #6c757d; margin-bottom: .5rem; }
  .cred-row { display: flex; justify-content: space-between; font-size: .83rem; padding: 2px 0; }
  .cred-row span:last-child { font-family: monospace; color: #1b6ca8; font-weight: 600; }
  .input-wrap { position: relative; }
  .input-wrap i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #adb5bd; }
  .input-wrap .form-control { padding-left: 2.3rem; }
</style>
</head>
<body>
<div class="login-card">
  <div class="text-center mb-4">
    <div class="brand-icon"><i class="bi bi-hospital"></i></div>
    <div class="brand-title">HospitalMS</div>
    <div class="brand-sub">Hospital Management System</div>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 mb-3" style="border-radius:10px;font-size:.88rem;">
      <i class="bi bi-exclamation-circle me-1"></i> ${error}
    </div>
  </c:if>
  <c:if test="${not empty message}">
    <div class="alert alert-success py-2 px-3 mb-3" style="border-radius:10px;font-size:.88rem;">
      <i class="bi bi-check-circle me-1"></i> ${message}
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div class="mb-3">
      <label class="form-label fw-semibold text-secondary" style="font-size:.85rem;">Username</label>
      <div class="input-wrap">
        <i class="bi bi-person"></i>
        <input type="text" name="username" class="form-control" placeholder="Enter username" required autofocus/>
      </div>
    </div>
    <div class="mb-4">
      <label class="form-label fw-semibold text-secondary" style="font-size:.85rem;">Password</label>
      <div class="input-wrap">
        <i class="bi bi-lock"></i>
        <input type="password" name="password" class="form-control" placeholder="Enter password" required/>
      </div>
    </div>
    <button type="submit" class="btn-login">
      <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
    </button>
  </form>

  <div class="cred-box">
    <h6><i class="bi bi-key me-1"></i>Demo Credentials</h6>
    <div class="cred-row"><span>Admin</span><span>admin / admin123</span></div>
    <div class="cred-row"><span>Receptionist</span><span>receptionist / rec123</span></div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
