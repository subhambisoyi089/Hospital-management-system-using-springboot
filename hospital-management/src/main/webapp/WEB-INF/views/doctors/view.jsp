<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Doctor"/>
  <jsp:param name="active" value="doctors"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1><c:out value="${doctor.fullName}"/></h1>
    <p class="muted"><c:out value="${doctor.specialization}"/></p>
  </div>
  <div class="head-actions">
    <c:if test="${isAdmin}"><a class="btn ghost" href="${ctx}/doctors/${doctor.id}/edit">Edit</a></c:if>
    <c:if test="${doctor.available}">
      <a class="btn primary" href="${ctx}/appointments/new?doctorId=${doctor.id}">Book appointment</a>
    </c:if>
  </div>
</header>

<section class="panel">
  <dl class="detail">
    <div><dt>Status</dt><dd><c:choose>
        <c:when test="${doctor.available}"><h:pill label="Available" css="available"/></c:when>
        <c:otherwise><h:pill label="Unavailable" css="maintenance"/></c:otherwise></c:choose></dd></div>
    <div><dt>Qualification</dt><dd><c:out value="${empty doctor.qualification ? '-' : doctor.qualification}"/></dd></div>
    <div><dt>Experience</dt><dd><c:choose><c:when test="${doctor.experienceYears != null}">${doctor.experienceYears} years</c:when><c:otherwise>-</c:otherwise></c:choose></dd></div>
    <div><dt>Consultation fee</dt><dd><h:money value="${doctor.consultFee}"/></dd></div>
    <div><dt>Email</dt><dd><c:out value="${doctor.email}"/></dd></div>
    <div><dt>Phone</dt><dd><c:out value="${doctor.phone}"/></dd></div>
  </dl>
</section>

<section class="panel">
  <h2>Appointments</h2>
  <c:choose>
    <c:when test="${not empty appointments}">
      <div class="table-wrap"><table>
        <thead><tr><th>Token</th><th>When</th><th>Patient</th><th>Status</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="a" items="${appointments}">
            <tr>
              <td><a class="token-link" href="${ctx}/appointments/${a.id}"><c:out value="${a.token}"/></a></td>
              <td><c:out value="${a.dateText}"/>, <c:out value="${a.timeText}"/></td>
              <td><a href="${ctx}/patients/${a.patient.id}"><c:out value="${a.patient.fullName}"/></a></td>
              <td><h:pill label="${a.status.label}" css="${a.status.css}"/></td>
              <td class="row-actions"><h:appointmentActions a="${a}" next="/doctors/${doctor.id}"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div>
    </c:when>
    <c:otherwise><p class="empty">No appointments yet.</p></c:otherwise>
  </c:choose>
</section>

<c:if test="${isAdmin}">
  <form method="post" action="${ctx}/doctors/${doctor.id}/delete" class="delete-row"
        data-confirm="Delete this doctor?">
    <h:csrf/>
    <button class="btn small danger">Delete doctor</button>
  </form>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
