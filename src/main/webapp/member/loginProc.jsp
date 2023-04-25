<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="mLoginBean" class="pack.member.MemberLoginBean" />
<jsp:useBean id="mMgr" class="pack.member.MemberMgr"/>
<jsp:setProperty name="mLoginBean" property="*" />
<%
request.setCharacterEncoding("UTF-8");
String uid = request.getParameter("uid");
String upw = request.getParameter("upw");
boolean loginRes = mMgr.loginMember(uid, upw);
%>
<script>
<%
if(loginRes){
	session.setAttribute("uidSession", uid);
// 	session.setMaxInactiveInterval(10);
	mLoginBean.setLoginip(request.getRemoteAddr());
	int loginCnt = mMgr.memberLoginCnt(uid);
	mMgr.memberInsertLogin(mLoginBean, loginCnt+1);
	%>
	location.href = "/index.jsp";
<%} else{%>
	alert("아이디 또는 비밀번호를 확인하세요.");
	location.href = "/member/login.jsp";
<%}%>
</script>