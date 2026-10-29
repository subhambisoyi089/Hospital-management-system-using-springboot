<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Patient"/>
  <jsp:param name="active" value="patients"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1><c:out value="${empty patient.id ? 'Register patient' : 'Edit patient'}"/></h1>
    <p class="muted"><c:out value="${empty patient.id ? 'A patient ID is created when you save.' : patient.patientId}"/></p>
  </div>
</header>

<section class="panel narrow">
  <form method="post" action="${ctx}/patients/save" class="stack">
    <h:csrf/>
    <input type="hidden" name="id" value="<c:out value='${patient.id}'/>">
    <div class="grid-2">
      <label>Full name
        <input type="text" name="fullName" maxlength="100" value="<c:out value='${patient.fullName}'/>" required>
      </label>
      <label>Phone
        <input type="tel" name="phone" maxlength="15" value="<c:out value='${patient.phone}'/>" required>
      </label>
      <label>Email
        <input type="email" name="email" maxlength="100" value="<c:out value='${patient.email}'/>">
      </label>
      <label>Date of birth
        <input type="date" name="dateOfBirth" max="<c:out value='${today}'/>" value="<c:out value='${patient.dateOfBirth}'/>">
      </label>
      <label>Gender
        <select name="gender">
          <option value="">Not stated</option>
          <c:forTokens items="Male,Female,Other" delims="," var="g">
            <option value="${g}" ${patient.gender == g ? 'selected' : ''}>${g}</option>
          </c:forTokens>
        </select>
      </label>
      <label>Blood group
        <select name="bloodGroup">
          <option value="">Not known</option>
          <c:forTokens items="A+,A-,B+,B-,AB+,AB-,O+,O-" delims="," var="bg">
            <option value="${bg}" ${patient.bloodGroup == bg ? 'selected' : ''}>${bg}</option>
          </c:forTokens>
        </select>
      </label>
    </div>
    <label>Address
      <input type="text" name="address" maxlength="200" value="<c:out value='${patient.address}'/>">
    </label>
    <label>Medical history (allergies, long-term conditions)
      <textarea name="medicalHistory" rows="3" maxlength="500"><c:out value="${patient.medicalHistory}"/></textarea>
    </label>
    <div class="form-actions">
      <a class="btn ghost" href="${ctx}/patients">Cancel</a>
      <button class="btn primary">Save patient</button>
    </div>
  </form>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
