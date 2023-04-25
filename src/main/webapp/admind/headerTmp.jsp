<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String admSession_HTMP = (String)session.getAttribute("admSession");
%>
<header id="header" class="dFlex">
	<!-- 로고, GNB -->
	<div id="innerWrap" class="dFlex">
		<div id="headerLogo">
			<a href="/index.jsp"> <img src="/images/logo.png" alt="헤더로고이미지">
			</a>
		</div>

		<nav id="gnb">

			<ul id="mainMenu" class="dFlex">

				<li class="mainLi"><a href="/index.jsp">HOME</a></li>
				<%if(admSession_HTMP!=null) {%>
				<li class="mainLi"><a href="/member/mypage.jsp?gnbParam=myPage">관리자 관리</a></li>
				<%} else{ %>
				<li class="mainLi"><a href="/admin/admLogin.jsp">로그인</a></li>
				<%} %>
				<li class="mainLi"><a href="#">고객센터</a></li>
				<li class="mainLi"><a href="/admin/logout.jsp">로그아웃</a></li>
				<!-- <li class="mainLi"><a href="/bbs/list.jsp?gnbParam=list">게시판</a></li> -->

			</ul>

		</nav>

		<%
		if (admSession_HTMP != null) {
			String loginIp = request.getRemoteAddr();
		%>
		<p id="userData">
			<span><b><%=admSession_HTMP%> </b>님 로그인 중</span>
			<%-- (<span id="headerclock"></span> / 
	    			<span>접속 IP : <%=loginIp %></span>) --%>
		</p>
		<!-- <script src="/script/header.js"></script> -->
		<%
		}
		%>
	</div>
</header>
<!--  header#header  -->
