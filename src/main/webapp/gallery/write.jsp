<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr" />
<%
	String uid = (String) session.getAttribute("uidSession");
	String uname = mMgr.getMemberName(uid);
%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("게시판 글쓰기");
	
	// 글쓰기 페이지 게시글 등록
	$("#regBtn").click(function(){
		let subject = $("#subject").val().trim();
		
		if(subject==""){
			alert("제목은 필수입력입니다.");
			$("#subject").focus();
		} else{
			$("#writeFrm").attr("action","/gallery/writeProc.jsp");
			$("#writeFrm").submit();
		}
	});
})
</script>
		<link rel="stylesheet" href="/style/style_BBS.css">
			<!--  헤더템플릿 시작 -->
			<%@ include file="/ind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->
	    	
	    	<main id="main" class="dFlex">
    	
	    		<div id="lnb">
		    		<!--  메인 LNB 템플릿 시작 -->
					<%@ include file="/ind/mainLnbTmp.jsp" %>
		    		<!--  메인 LNB 템플릿 끝 -->    	
	    		</div>
    		
	    		<div id="contents" class="bbsWrite">
		    	<h2>글쓰기</h2>
			    	<form name="writeFrm" enctype="multipart/form-data" method="post" id="writeFrm">
<!-- input type="file"이 있다면 무조건 enctype 지정 method="post" 필수(데이터 전송 용량 한계를 없애기 위해) -->
			    		<table>
			    			<tbody>
			    				<tr>
			    					<td class="req">성명</td>
			    					<td>
			    						<%=uname %>
			    						<input type="hidden" name="uname" value="<%=uname%>"/>
			    						<input type="hidden" name="uid" value="<%=uid%>"/>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td class="req">제목</td>
			    					<td>
			    						<input type="text" name="subject" maxlength="50" id="subject" />
			    					</td>
			    				</tr>
			    				<tr>
			    					<td class="contentTD">내용</td>
			    					<td>
			    						<textarea name="content" id="content" wrap="hard" cols="60"></textarea>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td>파일첨부</td>
			    					<td>
			    						<span class="spanFile">
			    						<input type="file" name="filename" id="filename" multiple/></span>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td>내용타입</td>
			    					<td>
			    						<label>
			    							<input type="radio" name="contentType" value="HTML"/>
			    							<span>HTML</span></label>
			    						<label>
			    							<input type="radio" name="contentType" value="TEXT" checked/>
			    							<span>TEXT</span></label>
			    					</td>
			    				</tr>
			    			</tbody>
			    			<tfoot>
			    				<tr>
			    					<td colspan="2"><hr /></td>
			    				</tr>
			    				<tr>
			    					<td colspan="2">
			    						<button type="button" id="regBtn">등록</button>
			    						<button type="reset">다시쓰기</button>
			    						<button type="button" id="listBtn">리스트</button>
			    					</td>
			    				</tr>
			    			</tfoot>
			    		</table>
			    		<input type="hidden" name="ip" value="<%=request.getRemoteAddr() %>" />
			    	</form>
		    	</div>
	    	</main>
<!--  푸터템플릿 시작 -->
<%@ include file="/ind/footerTmp.jsp" %>
  	<!--  푸터템플릿 끝 --> 