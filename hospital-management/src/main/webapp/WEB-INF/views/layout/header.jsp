<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><c:out value="${param.title}"/> - <c:out value="${hospitalName}"/></title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700&family=Figtree:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body>
<div class="shell">
  <aside class="side">
    <a class="brand" href="${ctx}/"><span class="cross" aria-hidden="true"></span><c:out value="${hospitalName}"/></a>
    <nav aria-label="Main">
      <a href="${ctx}/" class="${param.active == 'dashboard' ? 'on' : ''}">Dashboard</a>
      <a href="${ctx}/appointments" class="${param.active == 'appointments' ? 'on' : ''}">Appointments</a>
      <a href="${ctx}/patients" class="${param.active == 'patients' ? 'on' : ''}">Patients</a>
      <a href="${ctx}/doctors" class="${param.active == 'doctors' ? 'on' : ''}">Doctors</a>
      <c:if test="${isAdmin}">
        <a href="${ctx}/users" class="${param.active == 'users' ? 'on' : ''}">Staff accounts</a>
      </c:if>
    </nav>
    <div class="signout">
      <span class="who"><c:out value="${username}"/><small><c:out value="${isAdmin ? 'Administrator' : 'Receptionist'}"/></small></span>
      <a href="${ctx}/profile/password">Change password</a>
      <form method="post" action="${ctx}/logout">
        <h:csrf/>
        <button class="link-btn">Sign out</button>
      </form>
    </div>
  </aside>

  <main class="main">
    <c:if test="${not empty success or not empty error}">
      <div class="flashes" role="status">
        <c:if test="${not empty success}"><p class="flash success"><c:out value="${success}"/></p></c:if>
        <c:if test="${not empty error}"><p class="flash error"><c:out value="${error}"/></p></c:if>
      </div>
    </c:if>
