<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Dashboard"/>
  <jsp:param name="active" value="dashboard"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1>Today</h1>
    <p class="muted"><c:out value="${todayText}"/></p>
  </div>
  <div class="head-actions">
    <a class="btn ghost" href="${ctx}/patients/new">Register patient</a>
    <a class="btn primary" href="${ctx}/appointments/new">Book appointment</a>
  </div>
</header>

<dl class="strip">
  <div><dt>Waiting today</dt><dd>${d.todayWaiting}</dd><small>of ${d.todayTotal} booked</small></div>
  <div><dt>Seen today</dt><dd>${d.todayDone}</dd><small>consultations completed</small></div>
  <div><dt>Upcoming</dt><dd>${d.upcoming}</dd><small>scheduled after today</small></div>
  <div><dt>Doctors on duty</dt><dd>${d.availableDoctors}</dd><small>of ${d.totalDoctors} doctors</small></div>
  <div><dt>Patients</dt><dd>${d.totalPatients}</dd><small>registered</small></div>
</dl>

<section class="panel">
  <div class="panel-head">
    <h2>Today's queue</h2>
    <ul class="legend">
      <li class="s-scheduled">Waiting</li>
      <li class="s-completed">Seen</li>
      <li class="s-noshow">No show</li>
      <li class="s-cancelled">Cancelled</li>
    </ul>
  </div>
  <c:choose>
    <c:when test="${not empty d.queues}">
      <div class="queues">
        <c:forEach var="q" items="${d.queues}">
          <article class="queue">
            <header>
              <h3><a href="${ctx}/doctors/${q.doctor.id}"><c:out value="${q.doctor.fullName}"/></a></h3>
              <p class="muted small"><c:out value="${q.doctor.specialization}"/>, ${q.waiting} waiting</p>
            </header>
            <ul class="tickets">
              <c:forEach var="a" items="${q.appointments}">
                <li class="ticket s-${a.status.css}">
                  <a href="${ctx}/appointments/${a.id}">
                    <span class="tk"><c:out value="${a.token}"/></span>
                    <span class="tk-who"><c:out value="${a.patient.fullName}"/></span>
                    <span class="tk-at"><c:out value="${a.timeText}"/></span>
                  </a>
                </li>
              </c:forEach>
            </ul>
          </article>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <p class="empty">No appointments today. <a href="${ctx}/appointments/new">Book the first one.</a></p>
    </c:otherwise>
  </c:choose>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
