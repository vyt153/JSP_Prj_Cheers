<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr"/>
<script>
<%

String admSession = (String) session.getAttribute("admSession");
if(admSession!=null){
	admMgr.insertNotice(request);
	response.sendRedirect("/admin/adminIndex.jsp");
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "/member/login.jsp";
<%}%>
</script>