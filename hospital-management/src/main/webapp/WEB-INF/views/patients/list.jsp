<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Patients"/>
  <jsp:param name="active" value="patients"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Patients</h1>
    <p class="muted">${patients.size()} <c:out value="${empty q ? 'registered' : 'match'}"/></p>
  </div>
  <a class="btn primary" href="${ctx}/patients/new">Register patient</a>
</header>

<form method="get" action="${ctx}/patients" class="search">
  <input type="search" name="q" value="<c:out value='${q}'/>" placeholder="Search by name, phone or patient ID" aria-label="Search patients">
  <button class="btn ghost">Search</button>
  <c:if test="${not empty q}"><a href="${ctx}/patients" class="link-btn">Clear</a></c:if>
</form>

<section class="panel">
  <c:choose>
    <c:when test="${not empty patients}">
      <div class="table-wrap"><table>
        <thead><tr><th>Patient ID</th><th>Name</th><th>Phone</th><th>Blood group</th><th>Registered</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="p" items="${patients}">
            <tr>
              <td><c:out value="${p.patientId}"/></td>
              <td><a href="${ctx}/patients/${p.id}"><strong><c:out value="${p.fullName}"/></strong></a><br>
                  <span class="muted small"><c:out value="${empty p.gender ? '' : p.gender}"/><c:if test="${not empty p.gender and p.age != null}">, </c:if><c:if test="${p.age != null}">${p.age} years</c:if></span></td>
              <td><c:out value="${p.phone}"/></td>
              <td><c:out value="${empty p.bloodGroup ? '-' : p.bloodGroup}"/></td>
              <td><c:out value="${p.registeredOnText}"/></td>
              <td class="row-actions">
                <a class="btn small ghost" href="${ctx}/patients/${p.id}">View</a>
                <a class="btn small primary" href="${ctx}/appointments/new?patientId=${p.id}">Book</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div>
    </c:when>
    <c:when test="${not empty q}">
      <p class="empty">No patient matches "<c:out value="${q}"/>". Try part of the name or the phone number.</p>
    </c:when>
    <c:otherwise>
      <p class="empty">No patients yet. <a href="${ctx}/patients/new">Register the first one.</a></p>
    </c:otherwise>
  </c:choose>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
