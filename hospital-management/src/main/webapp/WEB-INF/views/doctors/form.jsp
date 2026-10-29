<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/taglibs.jspf" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="title" value="Doctor"/>
  <jsp:param name="active" value="doctors"/>
</jsp:include>

<header class="page-head">
  <div>
    <h1><c:out value="${empty doctor.id ? 'Add doctor' : 'Edit doctor'}"/></h1>
  </div>
</header>

<section class="panel narrow">
  <form method="post" action="${ctx}/doctors/save" class="stack">
    <h:csrf/>
    <input type="hidden" name="id" value="<c:out value='${doctor.id}'/>">
    <div class="grid-2">
      <label>Full name
        <input type="text" name="fullName" maxlength="100" value="<c:out value='${doctor.fullName}'/>" required>
      </label>
      <label>Specialization
        <input type="text" name="specialization" maxlength="100" value="<c:out value='${doctor.specialization}'/>" required>
      </label>
      <label>Qualification
        <input type="text" name="qualification" maxlength="50" value="<c:out value='${doctor.qualification}'/>">
      </label>
      <label>Experience (years)
        <input type="number" name="experienceYears" min="0" max="70" value="<c:out value='${doctor.experienceYears}'/>">
      </label>
      <label>Email
        <input type="email" name="email" maxlength="100" value="<c:out value='${doctor.email}'/>" required>
      </label>
      <label>Phone
        <input type="tel" name="phone" maxlength="15" value="<c:out value='${doctor.phone}'/>" required>
      </label>
      <label>Gender
        <select name="gender">
          <option value="">Not stated</option>
          <c:forTokens items="Male,Female,Other" delims="," var="g">
            <option value="${g}" ${doctor.gender == g ? 'selected' : ''}>${g}</option>
          </c:forTokens>
        </select>
      </label>
      <label>Consultation fee (₹)
        <input type="number" name="consultFee" min="0" step="0.01" value="<c:out value='${doctor.consultFee}'/>">
      </label>
    </div>
    <label class="check">
      <input type="hidden" name="_available" value="on">
      <input type="checkbox" name="available" ${doctor.available ? 'checked' : ''}>
      Available for new appointments
    </label>
    <div class="form-actions">
      <a class="btn ghost" href="${ctx}/doctors">Cancel</a>
      <button class="btn primary">Save doctor</button>
    </div>
  </form>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
