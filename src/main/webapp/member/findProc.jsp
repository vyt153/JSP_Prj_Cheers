<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr" />
<jsp:useBean id="mBean" class="pack.member.MemberBean" />
<jsp:setProperty name="mBean" property="*" />
<script>
<% 
	String find = request.getParameter("find");
	if(find.equals("id")){
		if(mMgr.findId(mBean)!=""){
			String uid = mMgr.findId(mBean);%>
			alert("회원님의 아이디는 <%=uid%> 입니다.");
			location.href="login.jsp";
		<%} else{%>
		alert("입력하신 정보와 일치하는 회원정보가 없습니다.");
		history.back();
	<%}
	} else{
		if(mMgr.findPw(mBean)!=""){
			String upw = mMgr.findPw(mBean);%>
			alert("회원님의 비밀번호는 <%=upw%> 입니다.");
			location.href="login.jsp";
		<%} else{%>
		alert("입력하신 정보와 일치하는 회원정보가 없습니다.");
		history.back();
	<%}
	} %>
</script>