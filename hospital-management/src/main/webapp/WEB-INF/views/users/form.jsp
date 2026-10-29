<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Staff account"/>
  <jsp:param name="active" value="users"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1><c:out value="${empty user.id ? 'Add account' : 'Edit account'}"/></h1>
    <c:if test="${not empty user.id}"><p class="muted">Leave the password blank to keep the current one.</p></c:if>
  </div>
</header>

<section class="panel narrow">
  <form method="post" action="${ctx}/users/save" class="stack" autocomplete="off">
    <h:csrf/>
    <input type="hidden" name="id" value="<c:out value='${user.id}'/>">
    <div class="grid-2">
      <label>Username
        <input type="text" name="username" maxlength="30" value="<c:out value='${user.username}'/>"
               ${empty user.id ? 'required' : 'readonly'}>
      </label>
      <label>Full name
        <input type="text" name="fullName" maxlength="100" value="<c:out value='${user.fullName}'/>" required>
      </label>
      <label>Email
        <input type="email" name="email" maxlength="100" value="<c:out value='${user.email}'/>" required>
      </label>
      <label>Phone
        <input type="tel" name="phone" maxlength="15" value="<c:out value='${user.phone}'/>">
      </label>
      <label>Password
        <input type="password" name="password" minlength="6" autocomplete="new-password" ${empty user.id ? 'required' : ''}>
      </label>
      <label>Role
        <select name="role" required>
          <c:forEach var="r" items="${roleOptions}">
            <option value="${r.name}" ${selectedRole == r.name ? 'selected' : ''}><c:out value="${r.description}"/></option>
          </c:forEach>
        </select>
      </label>
    </div>
    <label class="check">
      <input type="hidden" name="_enabled" value="on">
      <input type="checkbox" name="enabled" ${empty user.id or user.enabled ? 'checked' : ''}>
      Account is active (can sign in)
    </label>
    <div class="form-actions">
      <a class="btn ghost" href="${ctx}/users">Cancel</a>
      <button class="btn primary">Save account</button>
    </div>
  </form>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
