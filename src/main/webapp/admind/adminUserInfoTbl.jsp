<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.List"%>
<%@page import="pack.member.MemberLoginBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id = "aMgr" class = "pack.admin.AdminMgr"/>

<%
// 게시판 검색 소스
String keyField =""; // DB 컬럼명
String keyWord =""; // DB 검색어

List<MemberLoginBean> list = null;
%>
<script src = "/script/script_Admin.js"></script>

<div id="userInfoTblArea">
	<div id="userInfohead">
		<h1>회원정보</h1>
	</div>
	
	<table id="userInfoTbl">
	<thead>
		<tr>
			<th>이름</th>
			<th>접속아이피</th>
			<th>마지막접속</th>
			<th>접속횟수</th>
			<th>접속수단</th>
		</tr>
		<tr>
	    	<td colspan="5" class="spaceTd"></td>
	    </tr>
	</thead>
	<tbody>
		<%
		list = aMgr.previewUserInfo();
		int uListSize = list.size();
			
			if(list.isEmpty()) {
		%>
		<tr>
			<td colspan="5">
			<%= "회원이 없습니다." %>
			</td>
		</tr>
		<% } else { %>
		
		<%
		for(int i=0;i<=10;i++) {
			if(i==uListSize) break;
			
			MemberLoginBean bean = list.get(i);
			
			String uid = bean.getUid();
			String loginip = bean.getLoginip();
			String logintm = bean.getLogintm();
			int logincnt = bean.getLogincnt();
			String conndev = bean.getConndev();
			
			String admAccName = "관리자";
			
		%>

		<tr class="adUser">
			<td><%=uid %></td>
			<td><%=loginip %></td>
			<td><%=logintm %></td>
			<td><%=logincnt %></td>
			<td><%=conndev %></td>
		</tr>

		
		<%
		}
		%>
		
		<% } %>

		</tbody>
</table>
</div>
