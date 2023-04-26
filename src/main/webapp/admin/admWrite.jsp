<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr" />
<%
	String admin = (String) session.getAttribute("admSession");
	String uname = "관리자";
%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("공지사항 글쓰기");
	$("#noticeBtn").click(function(){
		let subject = $("#subject").val().trim();
		
		if(subject==""){
			alert("제목은 필수입력입니다.");
			$("#subject").focus();
		} else{
			$("#writeFrm").attr("action","/admin/admWriteProc.jsp");
			$("#writeFrm").submit();
		}
	});
})
</script>
		<link rel="stylesheet" href="/style/style_BBS.css">
		<script src="/script/script_BBS.js"></script>
			<!--  헤더템플릿 시작 -->
			<%@ include file="/ind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->
	    	
	    	<main id="main" class="dFlex">
    	
	    		<div id="lnb">
		    		<!--  메인 LNB 템플릿 시작 -->
					<%@ include file="/admind/mainLnbTmp.jsp" %>
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
			    						<input type="hidden" name="admName" value="<%=uname%>"/>
			    						<input type="hidden" name="admId" value="<%=admin%>"/>
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
			    						<input type="file" name="filename" id="filename" /></span>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td>게시여부</td>
			    					<td>
			    						<label>
			    							<input type="radio" name="post" value="1"/>
			    							<span>게시</span></label>
			    						<label>
			    							<input type="radio" name="post" value="0" checked/>
			    							<span>저장</span></label>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td>상단고정</td>
			    					<td>
			    						<label>
			    							<input type="radio" name="fixed" value="1"/>
			    							<span>고정</span></label>
			    						<label>
			    							<input type="radio" name="fixed" value="0" checked/>
			    							<span>고정안함</span></label>
			    					</td>
			    				</tr>
			    				<tr>
			    					<td>공지유형</td>
			    					<td>
			    						<label>
			    							<input type="radio" name="type" value="1"/>
			    							<span>필독</span></label>
			    						<label>
			    							<input type="radio" name="type" value="0" checked/>
			    							<span>공지</span></label>
			    					</td>
			    				</tr>
			    			</tbody>
			    			<tfoot>
			    				<tr>
			    					<td colspan="2"><hr /></td>
			    				</tr>
			    				<tr>
			    					<td colspan="2">
			    						<button id="noticeBtn" type="button">등록</button>
			    						<button type="reset" id="resetBtn">다시쓰기</button>
			    						<button type="button" id="listBtn">돌아가기</button>
			    					</td>
			    				</tr>
			    			</tfoot>
			    		</table>
			    	</form>
		    	</div>
	    	</main>
<!--  푸터템플릿 시작 -->
<%@ include file="/ind/footerTmp.jsp" %>
  	<!--  푸터템플릿 끝 --> 