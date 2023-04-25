<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr"/>
<jsp:useBean id="mBean" class="pack.member.MemberBean"/>
<jsp:setProperty name="mBean" property="*" />

<%
	String uidSession = (String)session.getAttribute("uidSession");
	boolean modRes = mMgr.modifyMemberProc(mBean);
%>
<script>
<%
if(uidSession!=null){
	if(modRes) { %>
		alert("정보를 수정하셨습니다.");
		location.href = "/index.jsp";
	<%} else{%>
		alert("회원정보 수정 중 문제가 발생했습니다. 다시 시도해주세요.\n만일 문제가 계속될 경우 고객센터(02-1234-5678)로 연락해주세요.")
		history.back();	
	<%}
} else{ %>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "login.jsp";
	<%}%>
</script>
