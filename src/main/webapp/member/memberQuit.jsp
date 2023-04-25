<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String uidSession = (String)session.getAttribute("uidSession");
%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("회원탈퇴");
	
	$("#memQuitBtn").click(function () {
		if($("#id").val()==""){
			alert("아이디를 입력해주세요.")
		}else if($("#pw").val()==""){
			alert("비밀번호를 입력해주세요.")
		} else{
			$("#memQuitFrm").attr("action","memberQuitProc.jsp");
			$("#memQuitFrm").submit();
		}
	})
})
</script>
<style>
input{padding: 10px; margin: 10px; font-size: 20px;}
p{font-size: 13px;}
</style>
<script src="/script/script_MemMod.js"></script>
	<!-- 헤더템플릿 시작 -->
	<%@ include file="/ind/headerTmp.jsp" %>
	<!-- 헤더템플릿 끝 -->
	
	<main id="main" class="dFlex">
		<!-- 실제 작업 영역 시작 -->
		<div id="contents" class="memQuitDiv">
			<form name="memQuitFrm" id="memQuitFrm" method="post">
				<h1>회원탈퇴</h1>
				<div>
					<input type="text" name="uid" id="id" placeholder="아이디 입력" size="30"/>
				</div>
				<div>
					<input type="text" name="upw" id="pw" placeholder="비밀번호 입력" size="30"/>
				</div>
				<p>회원탈퇴 시, 모든 활동기록<br>ex. 게시글, 답글 등을<br>삭제하시겠습니까?</p>
				<div class="genderArea">
					<label class="radioTxt">
						예&ensp;<input type="radio" name="delChk" value="1" /><i></i>
					</label>
					<label class="radioTxt">
						아니오&ensp;<input type="radio" name="delChk" value="2" /><i></i>
					</label>
				</div>
				<button id="memQuitBtn" type="button">회원 탈퇴하기</button>
			</form>
		</div>
		<!-- 실제 작업 영역 끝 -->
	</main>
	
	<!--  푸터템플릿 시작 -->
	<%@ include file="/ind/footerTmp.jsp" %>
   	<!--  푸터템플릿 끝 -->  