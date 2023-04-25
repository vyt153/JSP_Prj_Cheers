<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr" />
<%
String id = request.getParameter("admId");
String pw = request.getParameter("admPw");

if(admMgr.login(id, pw)){
	session.setAttribute("admSession", id);
	response.sendRedirect("adminIndex.jsp");
} else{%>
<script>
	alert("입력하신 정보와 일치하는 관리자 계정이 없습니다.");
	history.back();
</script>
<%}%>