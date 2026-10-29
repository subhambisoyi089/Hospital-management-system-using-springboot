<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Change password"/>
  <jsp:param name="active" value=""/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Change password</h1>
    <p class="muted">Signed in as <strong><c:out value="${username}"/></strong>.</p>
  </div>
</header>

<section class="panel narrow">
  <form method="post" action="${ctx}/profile/password" class="stack" autocomplete="off">
    <h:csrf/>
    <label>Current password
      <input type="password" name="currentPassword" autocomplete="current-password" required>
    </label>
    <div class="grid-2">
      <label>New password
        <input type="password" name="newPassword" minlength="6" autocomplete="new-password" required>
      </label>
      <label>Confirm new password
        <input type="password" name="confirmPassword" minlength="6" autocomplete="new-password" required>
      </label>
    </div>
    <div class="form-actions">
      <a class="btn ghost" href="${ctx}/">Cancel</a>
      <button class="btn primary">Change password</button>
    </div>
  </form>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
