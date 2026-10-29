<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Appointment"/>
  <jsp:param name="active" value="appointments"/>
</jsp:include>

<header class="page-head no-print">
  <div>
    <h1>Appointment</h1>
    <p class="muted">Print the slip for the patient to carry to the doctor.</p>
  </div>
  <div class="head-actions">
    <a class="btn ghost" href="${ctx}/appointments">Back to list</a>
    <button type="button" class="btn primary" data-print>Print slip</button>
  </div>
</header>

<article class="slip">
  <header class="slip-top">
    <div class="slip-token">
      <span>Token</span>
      <strong><c:out value="${appointment.token}"/></strong>
    </div>
    <div class="slip-head">
      <h2><c:out value="${hospitalName}"/></h2>
      <p><c:out value="${appointment.dateText}"/> at <c:out value="${appointment.timeText}"/></p>
      <h:pill label="${appointment.status.label}" css="${appointment.status.css}"/>
    </div>
  </header>

  <dl class="detail">
    <div><dt>Patient</dt><dd><a href="${ctx}/patients/${appointment.patient.id}"><c:out value="${appointment.patient.fullName}"/></a>
      <span class="muted small">(<c:out value="${appointment.patient.patientId}"/>)</span></dd></div>
    <div><dt>Phone</dt><dd><c:out value="${appointment.patient.phone}"/></dd></div>
    <div><dt>Doctor</dt><dd><c:out value="${appointment.doctor.fullName}"/>
      <span class="muted small"><c:out value="${appointment.doctor.specialization}"/></span></dd></div>
    <div><dt>Consultation fee</dt><dd><h:money value="${appointment.doctor.consultFee}"/></dd></div>
    <div class="wide"><dt>Symptoms</dt><dd><c:out value="${empty appointment.symptoms ? '-' : appointment.symptoms}"/></dd></div>
    <c:if test="${not empty appointment.notes}">
      <div class="wide"><dt>Notes</dt><dd><c:out value="${appointment.notes}"/></dd></div>
    </c:if>
    <div><dt>Booked by</dt><dd><c:out value="${empty appointment.bookedBy ? '-' : appointment.bookedBy}"/></dd></div>
  </dl>
</article>

<c:if test="${appointment.scheduled}">
  <section class="panel no-print">
    <h2>Update this appointment</h2>
    <div class="row-actions left"><h:appointmentActions a="${appointment}" next=""/></div>
  </section>
</c:if>

<c:if test="${isAdmin}">
  <form method="post" action="${ctx}/appointments/${appointment.id}/delete" class="no-print delete-row"
        data-confirm="Delete this appointment record for good?">
    <h:csrf/>
    <button class="btn small danger">Delete record</button>
  </form>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
