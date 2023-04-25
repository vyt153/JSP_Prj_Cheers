<%@page import="pack.bbs.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	int numParam = Integer.parseInt(request.getParameter("num"));
	
	//검색어 수신 시작
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	//검색어 수신 끝
	
	String nowPage = request.getParameter("nowPage");
	
	BoardBean bean = bMgr.getBoard(numParam);  
	int num =  bean.getNum();
	String uid	=	bean.getUid();
	String uname	=	bean.getUname();
	String subject	= bean.getSubject();
	String content	= bean.getContent();
	
	int pos	= bean.getPos();
	int ref	= bean.getRef();
	int depth	= bean.getDepth();
	String regtm	= bean.getRegtm();
	int readcnt 	= bean.getReadcnt();
	String filename	= bean.getFilename();
	double filesize 	= bean.getFilesize();
	String fUnit = "Bytes";
	if(filesize > 1024) {
		filesize /= 1024;	
		fUnit = "KBytes";
	} 
	
	String ip	= bean.getIp();

%>
<%@ include file="/ind/topTmp.jsp" %>
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/script/script_BBS.js"></script>	
<script>
$(function () {
	$("title").text("게시글 수정");
})
</script>
	<!-- 헤더템플릿 시작 -->
	<%@ include file="/ind/headerTmp.jsp" %>
	<!-- 헤더템플릿 끝 -->
   	
   	<main id="main" class="dFlex">
   		<div id="lnb">
    		<!--  메인 LNB 템플릿 시작 -->
			<%@ include file="/ind/mainLnbTmp.jsp" %>
    		<!--  메인 LNB 템플릿 끝 -->    	
  			</div>
   	
   	
    	<div id="content" class="bbsWrite">
    		<h2>글 수정하기</h2>
    		
    		<form name="modFrm" enctype="multipart/form-data" method="post" id="modFrm">
	    		<table>
	    			<tbody>
	    				<tr>
	    					<td class="req">성명</td>
	    					<td>
	    						<%=uname %>
	    						<input type="hidden" name="uname" value="<%=uname%>"/>
	    						<input type="hidden" name="uid" value="<%=uid %>"/>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td class="req">제목</td>
	    					<td>
	    						<input type="text" id="subject" name="subject" value="<%=subject%>"/>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td class="contentTD">내용</td>
	    					<td>
	    						<textarea name="content" 
									id="content" cols="60" wrap="hard"><%=content %></textarea>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>파일첨부</td>
	    					<td>
	    						<span class="spanFile">
	    							<input type="file" name="filename" id="filename"/>
	    						</span>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>내용타입</td>
	    					<td>
	    						<label><input type="radio" name="contentType" value="HTML" />
	    						<span>HTML</span></label>
	    						<label><input type="radio" name="contentType" value="HTML" checked/>
	    						<span>TEXT</span></label>
	    					</td>
	    				</tr>
	    			</tbody>
	    			<tfoot>
	    				<tr>
	    					<td colspan="2"> <hr /></td>
	    				</tr>
	    				<tr>
	    					<td colspan="2">
		    					<button type="button" id="modProcBtn">수정하기</button>
		    					<button type="button" id="resetBtn" onclick="reset()">다시쓰기</button>
		    					<button type="button" id="listBtn">리스트</button>
	    					</td>
	    				</tr>
	    			</tfoot>
	    		</table>
	    		<input type="hidden" name="num" value="<%=num%>"/>
	    		<input type="hidden" name="ip" value="<%=request.getRemoteAddr()%>"/>
    		</form>
    	</div>
   	</main>
   	<!--  푸터템플릿 시작 -->
	<%@ include file="/ind/footerTmp.jsp" %>
   	<!--  푸터템플릿 끝 -->  