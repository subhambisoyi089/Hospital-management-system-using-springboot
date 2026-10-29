<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Appointments"/>
  <jsp:param name="active" value="appointments"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Appointments</h1>
    <p class="muted">${appointments.size()} shown</p>
  </div>
  <a class="btn primary" href="${ctx}/appointments/new">Book appointment</a>
</header>

<form method="get" action="${ctx}/appointments" class="filter-bar">
  <label>Date
    <input type="date" name="date" value="<c:out value='${filterDate}'/>">
  </label>
  <label>Status
    <select name="status">
      <option value="">All</option>
      <c:forEach var="s" items="${statuses}">
        <option value="${s}" ${selectedStatus == s ? 'selected' : ''}><c:out value="${s.label}"/></option>
      </c:forEach>
    </select>
  </label>
  <label>Doctor
    <select name="doctorId">
      <option value="">All</option>
      <c:forEach var="d" items="${doctors}">
        <option value="${d.id}" ${selectedDoctorId == d.id ? 'selected' : ''}><c:out value="${d.fullName}"/></option>
      </c:forEach>
    </select>
  </label>
  <button class="btn ghost">Apply</button>
  <a href="${ctx}/appointments?date=${today}" class="link-btn">Today only</a>
  <a href="${ctx}/appointments" class="link-btn">Clear</a>
</form>

<section class="panel">
  <c:choose>
    <c:when test="${not empty appointments}">
      <div class="table-wrap"><table>
        <thead><tr><th>Token</th><th>When</th><th>Patient</th><th>Doctor</th><th>Status</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="a" items="${appointments}">
            <tr>
              <td><a class="token-link" href="${ctx}/appointments/${a.id}"><c:out value="${a.token}"/></a></td>
              <td><c:out value="${a.dateText}"/><br><span class="muted small"><c:out value="${a.timeText}"/></span></td>
              <td><a href="${ctx}/patients/${a.patient.id}"><c:out value="${a.patient.fullName}"/></a><br>
                  <span class="muted small"><c:out value="${a.patient.patientId}"/></span></td>
              <td><c:out value="${a.doctor.fullName}"/><br><span class="muted small"><c:out value="${a.doctor.specialization}"/></span></td>
              <td><h:pill label="${a.status.label}" css="${a.status.css}"/></td>
              <td class="row-actions"><h:appointmentActions a="${a}" next="/appointments"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div>
    </c:when>
    <c:otherwise>
      <p class="empty">No appointments match these filters. <a href="${ctx}/appointments/new">Book one.</a></p>
    </c:otherwise>
  </c:choose>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
