<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Patient"/>
  <jsp:param name="active" value="patients"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1><c:out value="${patient.fullName}"/></h1>
    <p class="muted"><c:out value="${patient.patientId}"/>, registered <c:out value="${patient.registeredOnText}"/></p>
  </div>
  <div class="head-actions">
    <a class="btn ghost" href="${ctx}/patients/${patient.id}/edit">Edit</a>
    <a class="btn primary" href="${ctx}/appointments/new?patientId=${patient.id}">Book appointment</a>
  </div>
</header>

<section class="panel">
  <dl class="detail">
    <div><dt>Phone</dt><dd><c:out value="${patient.phone}"/></dd></div>
    <div><dt>Email</dt><dd><c:out value="${empty patient.email ? '-' : patient.email}"/></dd></div>
    <div><dt>Date of birth</dt><dd><c:out value="${patient.dateOfBirthText}"/><c:if test="${patient.age != null}"> (${patient.age} years)</c:if></dd></div>
    <div><dt>Gender</dt><dd><c:out value="${empty patient.gender ? '-' : patient.gender}"/></dd></div>
    <div><dt>Blood group</dt><dd><c:out value="${empty patient.bloodGroup ? '-' : patient.bloodGroup}"/></dd></div>
    <div><dt>Address</dt><dd><c:out value="${empty patient.address ? '-' : patient.address}"/></dd></div>
    <div class="wide"><dt>Medical history</dt><dd><c:out value="${empty patient.medicalHistory ? '-' : patient.medicalHistory}"/></dd></div>
  </dl>
</section>

<section class="panel">
  <h2>Appointments</h2>
  <c:choose>
    <c:when test="${not empty appointments}">
      <div class="table-wrap"><table>
        <thead><tr><th>Token</th><th>When</th><th>Doctor</th><th>Status</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="a" items="${appointments}">
            <tr>
              <td><a class="token-link" href="${ctx}/appointments/${a.id}"><c:out value="${a.token}"/></a></td>
              <td><c:out value="${a.dateText}"/>, <c:out value="${a.timeText}"/></td>
              <td><c:out value="${a.doctor.fullName}"/> <span class="muted small"><c:out value="${a.doctor.specialization}"/></span></td>
              <td><h:pill label="${a.status.label}" css="${a.status.css}"/></td>
              <td class="row-actions"><h:appointmentActions a="${a}" next="/patients/${patient.id}"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div>
    </c:when>
    <c:otherwise><p class="empty">No appointments yet.</p></c:otherwise>
  </c:choose>
</section>

<c:if test="${isAdmin}">
  <form method="post" action="${ctx}/patients/${patient.id}/delete" class="delete-row"
        data-confirm="Delete this patient record?">
    <h:csrf/>
    <button class="btn small danger">Delete patient</button>
  </form>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
