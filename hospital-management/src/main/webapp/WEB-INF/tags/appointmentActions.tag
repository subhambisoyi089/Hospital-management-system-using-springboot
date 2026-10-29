<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="h" tagdir="/WEB-INF/tags" %>
<%@ attribute name="a" required="true" type="com.hospital.entity.Appointment" %>
<%@ attribute name="next" required="false" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:if test="${a.scheduled}">
  <form method="post" action="${ctx}/appointments/${a.id}/status" class="inline">
    <h:csrf/>
    <input type="hidden" name="status" value="COMPLETED">
    <input type="hidden" name="next" value="<c:out value='${next}'/>">
    <button class="btn small primary">Complete</button>
  </form>
  <form method="post" action="${ctx}/appointments/${a.id}/status" class="inline">
    <h:csrf/>
    <input type="hidden" name="status" value="NO_SHOW">
    <input type="hidden" name="next" value="<c:out value='${next}'/>">
    <button class="btn small ghost">No show</button>
  </form>
  <form method="post" action="${ctx}/appointments/${a.id}/status" class="inline" data-confirm="Cancel this appointment?">
    <h:csrf/>
    <input type="hidden" name="status" value="CANCELLED">
    <input type="hidden" name="next" value="<c:out value='${next}'/>">
    <button class="btn small danger">Cancel</button>
  </form>
</c:if>
