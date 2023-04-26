<%@page import="pack.admin.AdmBoardBean"%>
<%@page import="pack.bbs.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	int numParam = Integer.parseInt(request.getParameter("num"));
	
	//검색어 수신 시작
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	//검색어 수신 끝
	
	String nowPage = request.getParameter("nowPage");
	
	AdmBoardBean bean = admMgr.getNotice(numParam);  
	int num =  bean.getNum();
	String admId	=	bean.getAdmId();
	String admName	=	bean.getadmName();
	String subject	= bean.getSubject();
	String content	= bean.getContent();
	
	int post 	= bean.getPost();
	int fixed 	= bean.getFixed();
	int type 	= bean.getType();
	String filename	= bean.getFilename();
	double filesize 	= bean.getFilesize();
	String fUnit = "Bytes";
	if(filesize > 1024) {
		filesize /= 1024;	
		fUnit = "KBytes";
	} 
	
%>
<%@ include file="/ind/topTmp.jsp" %>
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/script/script_BBS.js"></script>	
<script>
$(function () {
	$("title").text("게시글 수정");
	$("#noticeModProcBtn").click(function () {
		$("#modFrm").attr("action","noticeModifyProc.jsp");
		$("#modFrm").submit();
	})
})
</script>
	<!-- 헤더템플릿 시작 -->
	<%@ include file="/admind/headerTmp.jsp" %>
	<!-- 헤더템플릿 끝 -->
   	
   	<main id="main" class="dFlex">
   		<div id="lnb">
    		<!--  메인 LNB 템플릿 시작 -->
			<%@ include file="/admind/mainLnbTmp.jsp" %>
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
	    						<%=admName %>
	    						<input type="hidden" name="admName" value="<%=admName%>"/>
	    						<input type="hidden" name="admId" value="<%=admId %>"/>
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
	    					<td>게시여부</td>
	    					<td>
	    						<label>
	    							<input type="radio" name="post" value="1" <%if(post==1) out.print("checked"); %>/>
	    							<span>게시</span></label>
	    						<label>
	    							<input type="radio" name="post" value="0" <%if(post==0) out.print("checked"); %>/>
	    							<span>저장</span></label>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>상단고정</td>
	    					<td>
	    						<label>
	    							<input type="radio" name="fixed" value="1" <%if(fixed==1) out.print("checked"); %>/>
	    							<span>고정</span></label>
	    						<label>
	    							<input type="radio" name="fixed" value="0" <%if(fixed==0) out.print("checked"); %>/>
	    							<span>고정안함</span></label>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>공지유형</td>
	    					<td>
	    						<label>
	    							<input type="radio" name="type" value="1" <%if(type==1) out.print("checked"); %>/>
	    							<span>필독</span></label>
	    						<label>
	    							<input type="radio" name="type" value="0" <%if(type==0) out.print("checked"); %>/>
	    							<span>공지</span></label>
	    					</td>
	    				</tr>
	    			</tbody>
	    			<tfoot>
	    				<tr>
	    					<td colspan="2"> <hr /></td>
	    				</tr>
	    				<tr>
	    					<td colspan="2">
		    					<button type="button" id="noticeModProcBtn">수정하기</button>
		    					<button type="button" id="resetBtn" onclick="reset()">되돌리기</button>
		    					<button type="button" id="listBtn">목록으로</button>
	    					</td>
	    				</tr>
	    			</tfoot>
	    		</table>
	    		<input type="hidden" name="num" value="<%=num%>"/>
    		</form>
    	</div>
   	</main>
   	<!--  푸터템플릿 시작 -->
	<%@ include file="/ind/footerTmp.jsp" %>
   	<!--  푸터템플릿 끝 -->  