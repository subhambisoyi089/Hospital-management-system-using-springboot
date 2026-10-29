<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Book appointment"/>
  <jsp:param name="active" value="appointments"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Book appointment</h1>
    <p class="muted">A queue token is given automatically for the chosen doctor and day.</p>
  </div>
</header>

<section class="panel narrow">
  <c:choose>
    <c:when test="${empty patients}">
      <p class="empty">There are no patients yet. <a href="${ctx}/patients/new">Register the patient first.</a></p>
    </c:when>
    <c:when test="${empty doctorOptions}">
      <p class="empty">No doctor is available right now. <a href="${ctx}/doctors">Check the doctors list.</a></p>
    </c:when>
    <c:otherwise>
      <form method="post" action="${ctx}/appointments/save" id="appointment-form" class="stack"
            data-booked-url="${ctx}/api/booked-times">
        <h:csrf/>
        <div class="grid-2">
          <label>Patient
            <select name="patientId" required>
              <option value="" disabled ${empty selectedPatientId ? 'selected' : ''}>Choose a patient</option>
              <c:forEach var="p" items="${patients}">
                <option value="${p.id}" ${selectedPatientId == p.id ? 'selected' : ''}><c:out value="${p.fullName}"/> (<c:out value="${p.patientId}"/>)</option>
              </c:forEach>
            </select>
          </label>
          <label>Doctor
            <select name="doctorId" required>
              <option value="" disabled ${empty selectedDoctorId ? 'selected' : ''}>Choose a doctor</option>
              <c:forEach var="d" items="${doctorOptions}">
                <option value="${d.id}" ${selectedDoctorId == d.id ? 'selected' : ''}><c:out value="${d.fullName}"/>, <c:out value="${d.specialization}"/></option>
              </c:forEach>
            </select>
          </label>
          <label>Date
            <input type="date" name="appointmentDate" min="<c:out value='${today}'/>"
                   value="<c:out value='${appointment.appointmentDate}'/>" required>
          </label>
          <label>Time
            <input type="time" name="appointmentTime" step="900"
                   value="<c:out value='${appointment.appointmentTime}'/>" required>
          </label>
        </div>
        <p class="hint" id="booked-hint" hidden></p>
        <label>Symptoms
          <textarea name="symptoms" rows="2" maxlength="500"><c:out value="${appointment.symptoms}"/></textarea>
        </label>
        <label>Notes (optional)
          <textarea name="notes" rows="2" maxlength="500"><c:out value="${appointment.notes}"/></textarea>
        </label>
        <div class="form-actions">
          <a class="btn ghost" href="${ctx}/appointments">Cancel</a>
          <button class="btn primary">Book appointment</button>
        </div>
      </form>
    </c:otherwise>
  </c:choose>
</section>

<script src="${ctx}/js/appointment-form.js"></script>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
