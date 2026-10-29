<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Doctors"/>
  <jsp:param name="active" value="doctors"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Doctors</h1>
    <p class="muted">${doctors.size()} <c:out value="${empty q ? 'on staff' : 'match'}"/></p>
  </div>
  <c:if test="${isAdmin}"><a class="btn primary" href="${ctx}/doctors/new">Add doctor</a></c:if>
</header>

<form method="get" action="${ctx}/doctors" class="search">
  <input type="search" name="q" value="<c:out value='${q}'/>" placeholder="Search by name or specialization" aria-label="Search doctors">
  <button class="btn ghost">Search</button>
  <c:if test="${not empty q}"><a href="${ctx}/doctors" class="link-btn">Clear</a></c:if>
</form>

<section class="panel">
  <c:choose>
    <c:when test="${not empty doctors}">
      <div class="table-wrap"><table>
        <thead><tr><th>Doctor</th><th>Specialization</th><th>Experience</th><th>Fee</th><th>Status</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="d" items="${doctors}">
            <tr>
              <td><a href="${ctx}/doctors/${d.id}"><strong><c:out value="${d.fullName}"/></strong></a><br>
                  <span class="muted small"><c:out value="${empty d.qualification ? '' : d.qualification}"/></span></td>
              <td><c:out value="${d.specialization}"/></td>
              <td><c:choose><c:when test="${d.experienceYears != null}">${d.experienceYears} years</c:when><c:otherwise>-</c:otherwise></c:choose></td>
              <td><h:money value="${d.consultFee}"/></td>
              <td><c:choose>
                    <c:when test="${d.available}"><h:pill label="Available" css="available"/></c:when>
                    <c:otherwise><h:pill label="Unavailable" css="maintenance"/></c:otherwise>
                  </c:choose></td>
              <td class="row-actions">
                <a class="btn small ghost" href="${ctx}/doctors/${d.id}">View</a>
                <c:if test="${d.available}">
                  <a class="btn small primary" href="${ctx}/appointments/new?doctorId=${d.id}">Book</a>
                </c:if>
                <c:if test="${isAdmin}">
                  <a class="btn small ghost" href="${ctx}/doctors/${d.id}/edit">Edit</a>
                  <form method="post" action="${ctx}/doctors/${d.id}/toggle" class="inline">
                    <h:csrf/>
                    <button class="btn small ghost"><c:out value="${d.available ? 'Mark away' : 'Mark available'}"/></button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div>
    </c:when>
    <c:when test="${not empty q}">
      <p class="empty">No doctor matches "<c:out value="${q}"/>".</p>
    </c:when>
    <c:otherwise>
      <p class="empty">No doctors yet.<c:if test="${isAdmin}"> <a href="${ctx}/doctors/new">Add the first doctor.</a></c:if></p>
    </c:otherwise>
  </c:choose>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
