<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("비밀번호 찾기");
	$("#findBtn").click(function () {
		$("#findFrm").attr("action","findProc.jsp?find=pw");
		$("#findFrm").submit();
	})
})
</script>
<style>
#contents{text-align: center;}
#loginArea{margin: 30px;}
#findFrm{margin: 30px;}
div#wrap>main#main>div.loginDiv>form#findFrm{
	padding: 20px;
	border: 2px solid rgba(0,0,0,0.1);
	display: inline-block;
}
#main>.loginDiv>#findFrm input{
	width: 320px;
	font-size: 17px;
	padding: 13px 16px;
	margin-bottom: 7px;
	display: block;
}
#main>.loginDiv>#findFrm button#findBtn{
	width: 320px;
	color: #fff;
	font-size: 18px;
	padding: 15px 20px;
	border: none;
	margin-top: 17px;
	margin-bottom: 7px;
	background-color: #50b639;
	cursor: pointer;
	display: block;
}
h2{margin-bottom: 20px;}
</style>
<!-- 헤더템플릿 시작 -->
<%@ include file="/ind/headerTmp.jsp" %>
<!-- 헤더템플릿 끝 -->

<main id="main" class="dFlex">
	<div id="lnb">
		<!-- 메인LNB 템플릿 시작 -->
		<%@ include file="/ind/mainLnbTmp.jsp" %>										
		<!-- 메인LNB 템플릿 끝 -->
	</div>
	
	<!-- 실제 작업 영역 시작 -->
	<div id="contents" class="loginDiv">
		<form method="post" id="findFrm" name="findFrm">
			<div id="loginArea">
				<h2>비밀번호 찾기</h2>
				<div id="loginInput">
					<input type="text" name="uname" placeholder="이름 입력" id="uid"/>
					<input type="text" name="uid" placeholder="아이디 입력"/>
				</div>
				<button type="button" id="findBtn">비밀번호 찾기</button>
			</div>
	<!-- div#loginArea -->
			<input type="hidden" name="find" value="pw" />
		</form>
	</div>
	
	<!-- 실제 작업 영역 끝 -->
</main>

<!-- 푸터 영역 시작 -->
<%@ include file = "/ind/footerTmp.jsp" %>
<!-- 푸터 영역 끝-->
