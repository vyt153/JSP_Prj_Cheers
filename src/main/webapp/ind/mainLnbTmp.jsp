<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String uidSession_MLTmp = (String)session.getAttribute("uidSession");
	request.setCharacterEncoding("UTF-8");
	
	String gnbParam = "";
	if(request.getParameter("gnbParam")!=null){
		gnbParam = request.getParameter("gnbParam");
	}
%>
<style>
<%	if(gnbParam.equals("bbs")){%>
	ul>li:first-child {font-weight: bold;}
<%} else if(gnbParam.equals("gallery")){%>
	ul>li:nth-child(2) {font-weight: bold;}
<%}%>
</style>

	<nav id="mainLNB">
		<ul id="lnbMainMenu">
			
			<% if (gnbParam.equals("myPage")){ %>
			
			<li class="lnbMainLi"><a href="memberMod.jsp">회원정보수정</a></li>
			<li class="lnbMainLi"><a href="memberModPw.jsp">비밀번호변경</a></li>
			<li class="lnbMainLi"><a href="mypageAccessList.jsp?gnbParam=myPage">접속내역</a></li>
			<li class="lnbMainLi"><a href="memberQuit.jsp">회원탈퇴</a></li>
			<li class="lnbMainLi"><a href="#">menu5</a></li>
			
			<%} else{ %>
			<li class="lnbMainLi"><a href="/bbs/list.jsp?gnbParam=bbs">자유게시판</a></li>
			<li class="lnbMainLi"><a href="/gallery/list.jsp?gnbParam=gallery">갤러리게시판</a></li>
			<li class="lnbMainLi"><a href="#">공지사항</a></li>
			<li class="lnbMainLi"><a href="#">Q&A</a></li>
			<li class="lnbMainLi"><a href="#">FAQ</a></li>
			
			<%} %>
		
		</ul>
	</nav>