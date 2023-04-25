<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr"/>
<script>
<%
String uidSession = (String) session.getAttribute("uidSession");
if(uidSession!=null){
	bMgr.insertBoard(request);
	response.sendRedirect("/bbs/list.jsp");
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "../member/login.jsp";
<%}%>
</script>