<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr"/>
<%
	String uid = request.getParameter("uid");
	String upw = request.getParameter("upw");
	int delChk = Integer.parseInt(request.getParameter("delChk"));
%>
<script>
<%if(mMgr.memberQuit(uid, upw)){	
	if(delChk==1){
		mMgr.delFile(uid);
		mMgr.delTbl(uid);
	}
	session.invalidate();%>
	alert("회원이 탈퇴되었습니다.");
	location.href="/index.jsp";
	
<%}else{%>
	alert("입력하신 회원정보와 일치하는 회원이 없습니다. 아이디나 비밀번호를 확인해주세요.\n만일 문제가 계속될 경우 고객센터(02-1234-5678)로 연락해주세요.")	
	history.back();
<%} %>
</script>
