<%@page import="pack.bbs.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr" />
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String uidSession = (String)session.getAttribute("uidSession");
	String nowPage = request.getParameter("nowPage");
	String reqNum = request.getParameter("num");
	int numParam = Integer.parseInt(reqNum);
	
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	
	BoardBean bean =(BoardBean)session.getAttribute("bean");
	
	String url = "/bbs/list.jsp?nowPage="+nowPage;
			url += "&keyField="+keyField;
			url += "&keyWord="+keyWord;
%>
<script>
	<%if(uidSession!=null){
		int extCnt = bMgr.deleteBoard(numParam);%>
		alert("삭제되었습니다.");
		location.href = "<%=url%>";
<%	} else{%>
		alert("세션이 만료되었습니다. 다시 로그인해주세요.");
		location.href = "../member/login.jsp";
	<%}%>
</script>