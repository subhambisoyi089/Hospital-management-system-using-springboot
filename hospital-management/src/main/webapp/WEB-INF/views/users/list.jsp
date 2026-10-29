<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Staff accounts"/>
  <jsp:param name="active" value="users"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Staff accounts</h1>
    <p class="muted">${users.size()} accounts. Only administrators can see this page.</p>
  </div>
  <a class="btn primary" href="${ctx}/users/new">Add account</a>
</header>

<section class="panel">
  <div class="table-wrap"><table>
    <thead><tr><th>Username</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th></th></tr></thead>
    <tbody>
      <c:forEach var="u" items="${users}">
        <tr>
          <td><strong><c:out value="${u.username}"/></strong><c:if test="${u.username == username}"> <span class="muted small">(you)</span></c:if></td>
          <td><c:out value="${u.fullName}"/></td>
          <td><c:out value="${u.email}"/></td>
          <td><c:out value="${u.roleLabel}"/></td>
          <td><c:choose>
                <c:when test="${u.enabled}"><h:pill label="Active" css="available"/></c:when>
                <c:otherwise><h:pill label="Disabled" css="maintenance"/></c:otherwise>
              </c:choose></td>
          <td class="row-actions">
            <a class="btn small ghost" href="${ctx}/users/${u.id}/edit">Edit</a>
            <c:if test="${u.username != username}">
              <form method="post" action="${ctx}/users/${u.id}/toggle" class="inline">
                <h:csrf/>
                <button class="btn small ghost"><c:out value="${u.enabled ? 'Disable' : 'Enable'}"/></button>
              </form>
              <form method="post" action="${ctx}/users/${u.id}/delete" class="inline"
                    data-confirm="Delete this account?">
                <h:csrf/>
                <button class="btn small danger">Delete</button>
              </form>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
