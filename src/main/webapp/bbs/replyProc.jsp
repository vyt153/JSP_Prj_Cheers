<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr" />
<jsp:useBean id="reBean" class="pack.bbs.BoardBean" />
<jsp:setProperty name="reBean" property="*"/>
<%
String uidSession = (String) session.getAttribute("uidSession");
int repUpCnt = bMgr.replyUpBoard(reBean.getRef(), reBean.getPos());
	// 끼어들기가 아닐경우 실행되는 소스 없음.
	
	String nowPage = request.getParameter("nowPage");
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
%>
<script>
<%
if(uidSession!=null){
	int resInsCnt = bMgr.replyBoard(reBean);
	if(resInsCnt>0){
		String url = "/bbs/list.jsp?nowPage="+nowPage;
				url += "&keyField="+keyField;
				url += "&keyWord="+keyWord;%>
		location.href="<%=url%>";
	<%} else{%>
		let msg = "답변글 등록중 오류가 발생했습니다.\n";
		     msg += "다시 시도해주세요\n";
		     msg += "오류가 지속되면 관리자에게 연락바랍니다.";
			alert(msg);
			history.back();
	<%}
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "../member/login.jsp";
<% }%>
</script>