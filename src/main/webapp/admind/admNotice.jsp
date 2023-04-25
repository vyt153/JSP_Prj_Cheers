<%@page import="pack.admin.AdmBoardBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="javax.tools.DocumentationTool.Location"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ page import="pack.admin.AdminBean" %>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr"/>
<% request.setCharacterEncoding("UTF-8"); 

int nListSize = 0; // 1페이지에서 보여주는 데이터 수


List<AdmBoardBean> nList = null;
%>
<style>
#iconSample {
    width: 13px;
    height: 13px;
    color: #fff;
    font-size: 11px;
    text-align: center;
    line-height: 13px;
    border-radius: 50%;
    background-color: #f44;
    display: inline-block;
    transform: translate(2px, -2px);
}
div.bbsList tr.adminTr>td {
	text-align: center;
	padding: 20px 2px 10px;
	border-bottom: 1px solid #d2d2d2;
	color: #aaa;
	font-weight: bold;
}

div.bbsList tr.adminTr>td.subjectTd {
	text-align: left;
}
</style>
		<link rel="stylesheet" href="/style/style_BBS.css">
		<script src="/script/script_BBS.js"></script> 	
	    	<main id="main">
	    		<div id="innerWrap" class="dFlex">
	    		<div id="contents" class="bbsList">
	    			<h3><a href="/admin/admNotice.jsp">공지사항</a></h3>
	  
	    			<table id="noticeList">
	    				<thead>
	    					<tr>
	    						<th>번호</th>
	    						<th>제목</th>
	    						<th>이름</th>
	    						<th>날짜</th>
	    						<th>조회수</th>
	    					</tr>
	    					<tr>
	    						<td colspan="5" class="spaceTd"></td>
	    					</tr>
	    				</thead>
	    				<tbody>
	    				
	    				<%
	    					if(nList==null){%>
	    					<tr>
	    						<td colspan="5">
	    						<%="게시물이 없습니다." %>
	    						</td>
	    					</tr>
	    				<%} else{%>
	    				
	    				<% } %>
	    				</tbody>
	    			</table>
	    		</div>
	    		<!-- 실제 작업 영역 끝 -->
	    		</div>
	    	</main>