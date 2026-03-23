<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
:root{--sidebar:240px;--brand:#0f4c75;--accent:#1b6ca8}
body{background:#f0f4f8;font-family:'Segoe UI',sans-serif;min-height:100vh}
.sidebar{width:var(--sidebar);position:fixed;top:0;left:0;height:100vh;background:var(--brand);
  color:#fff;display:flex;flex-direction:column;z-index:1000;box-shadow:3px 0 15px rgba(0,0,0,.2)}
.sb-brand{padding:1.4rem 1.2rem;border-bottom:1px solid rgba(255,255,255,.1);font-size:1.15rem;font-weight:700}
.sb-brand i{color:#74b9ff;margin-right:8px}
.sb-nav{padding:1rem 0;flex:1;overflow-y:auto}
.sb-section{padding:.35rem 1rem;font-size:.66rem;text-transform:uppercase;letter-spacing:1px;
  color:rgba(255,255,255,.38);margin-top:.5rem}
.sb-nav a{display:flex;align-items:center;gap:10px;padding:.58rem 1.2rem;
  color:rgba(255,255,255,.75);text-decoration:none;font-size:.88rem;
  border-left:3px solid transparent;transition:all .2s}
.sb-nav a:hover,.sb-nav a.active{background:rgba(255,255,255,.09);color:#fff;border-left-color:#74b9ff}
.sb-nav a i{width:18px;text-align:center}
.sb-footer{padding:1rem 1.2rem;border-top:1px solid rgba(255,255,255,.1)}
.sb-footer .uname{font-weight:600;color:#fff;font-size:.9rem}
.sb-footer .urole{font-size:.78rem;color:rgba(255,255,255,.55)}
.main{margin-left:var(--sidebar);padding:1.5rem 2rem}
.topbar{background:#fff;padding:.7rem 1.5rem;margin:-1.5rem -2rem 1.5rem;
  border-bottom:1px solid #e2e8f0;display:flex;align-items:center;
  justify-content:space-between;box-shadow:0 1px 3px rgba(0,0,0,.05)}
.topbar h1{font-size:1.15rem;font-weight:700;color:#1e293b;margin:0}
.card{border:none;border-radius:12px;box-shadow:0 1px 4px rgba(0,0,0,.07)}
.card-header{background:#fff;border-bottom:1px solid #f1f5f9;font-weight:600;
  padding:1rem 1.25rem;border-radius:12px 12px 0 0!important}
.table th{font-weight:600;font-size:.8rem;text-transform:uppercase;
  letter-spacing:.5px;color:#64748b;background:#f8fafc}
.table td{vertical-align:middle;font-size:.88rem}
.btn-primary{background:var(--accent)!important;border-color:var(--accent)!important}
.form-control,.form-select{border-radius:10px;border:1.5px solid #dee2e6}
.form-control:focus,.form-select:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(27,108,168,.1)}
.stat-card{border-radius:14px;padding:1.4rem;color:#fff;position:relative;overflow:hidden}
.stat-card .num{font-size:2.1rem;font-weight:700;line-height:1}
.stat-card .lbl{font-size:.8rem;opacity:.85;margin-top:.3rem}
.stat-card .ico{position:absolute;right:1rem;top:1rem;font-size:2.5rem;opacity:.2}
</style>

<div class="sidebar">
  <div class="sb-brand"><i class="bi bi-hospital"></i> HospitalMS</div>
  <nav class="sb-nav">
    <div class="sb-section">Main</div>
    <a href="${pageContext.request.contextPath}/home"><i class="bi bi-grid-1x2"></i> Dashboard</a>

    <div class="sb-section">Catalogue</div>
    <a href="${pageContext.request.contextPath}/doctors"><i class="bi bi-person-badge"></i> Doctors</a>
    <a href="${pageContext.request.contextPath}/patients"><i class="bi bi-people"></i> Patients</a>

    <div class="sb-section">Appointments</div>
    <a href="${pageContext.request.contextPath}/appointments"><i class="bi bi-calendar-check"></i> All Appointments</a>
    <a href="${pageContext.request.contextPath}/appointments/today"><i class="bi bi-calendar-day"></i> Today</a>
    <a href="${pageContext.request.contextPath}/appointments/new"><i class="bi bi-plus-circle"></i> Book Appointment</a>

    <sec:authorize access="hasRole('ADMIN')">
      <div class="sb-section">Admin</div>
      <a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-person-gear"></i> Manage Users</a>
    </sec:authorize>
  </nav>
  <div class="sb-footer">
    <div class="uname"><sec:authentication property="name"/></div>
    <sec:authorize access="hasRole('ADMIN')">
      <div class="urole"><i class="bi bi-shield-check"></i> Administrator</div>
    </sec:authorize>
    <sec:authorize access="hasRole('RECEPTIONIST')">
      <div class="urole"><i class="bi bi-person-badge"></i> Receptionist</div>
    </sec:authorize>
    <a href="${pageContext.request.contextPath}/logout"
       class="btn btn-sm btn-outline-light mt-2 w-100">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</div>
