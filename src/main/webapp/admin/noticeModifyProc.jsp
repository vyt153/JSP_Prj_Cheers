<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr" />
<script>
<%
String admSession = (String) session.getAttribute("admSession");
if(admSession!=null){
	if(admMgr.updateNotice(request)==1){%>
	alert("게시글 수정이 완료되었습니다.");
	location.href="/admin/admNotice.jsp";
<%	} else{%>
	alert("게시글 수정이 실패하였습니다.");
	history.back();
<%}
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "/admin/admLogin/login.jsp";
<% } %>
</script>