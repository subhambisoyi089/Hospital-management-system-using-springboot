<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sign in - <c:out value="${hospitalName}"/></title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700&family=Figtree:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body>
<div class="login">
  <section class="login-brand">
    <span class="cross big" aria-hidden="true"></span>
    <h1><c:out value="${hospitalName}"/></h1>
    <p>Patients, doctors and appointments, in one place for the front desk.</p>
  </section>
  <section class="login-panel">
    <form method="post" action="${ctx}/login" class="login-form">
      <h:csrf/>
      <h2>Sign in</h2>
      <c:if test="${param.error != null}">
        <div class="flashes" role="alert"><p class="flash error">Wrong username or password, or the account is disabled.</p></div>
      </c:if>
      <c:if test="${param.logout != null}">
        <div class="flashes" role="status"><p class="flash success">You have been signed out.</p></div>
      </c:if>
      <label>Username
        <input type="text" name="username" autocomplete="username" required autofocus>
      </label>
      <label>Password
        <input type="password" name="password" autocomplete="current-password" required>
      </label>
      <button class="btn primary wide">Sign in</button>
    </form>
  </section>
</div>
</body>
</html>
