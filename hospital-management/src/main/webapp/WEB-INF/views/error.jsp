<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Something went wrong</title>
  <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700&family=Figtree:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body>
<main class="error-page">
  <p class="error-code"><c:out value="${empty status ? '' : status}"/></p>
  <h1>
    <c:choose>
      <c:when test="${status == 404}">That page doesn't exist</c:when>
      <c:when test="${status == 403}">You don't have access to that</c:when>
      <c:when test="${status == 400}">That request couldn't be processed</c:when>
      <c:otherwise>Something went wrong</c:otherwise>
    </c:choose>
  </h1>
  <p class="muted">
    <c:choose>
      <c:when test="${status == 403}">Ask an administrator if you need this permission.</c:when>
      <c:when test="${status == 400}">Your form may have expired. Go back, reload the page and try again.</c:when>
      <c:otherwise>Go back to the dashboard and try again.</c:otherwise>
    </c:choose>
  </p>
  <a class="btn primary" href="${ctx}/">Back to the dashboard</a>
</main>
</body>
</html>
