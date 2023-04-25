<%@page import="pack.member.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr"/>
<%
	String uidSession = (String)session.getAttribute("uidSession");
	if(uidSession==null) response.sendRedirect("/index.jsp");
	MemberBean mBean = mMgr.modifyMember(uidSession);
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>회원정보수정</title>
	    <script src="/resource/jquery-3.6.0.min.js"></script>
	    <script src="/script/script_MemMod.js"></script>
	</head>
	<style>
		#wrap{margin: 20px auto; padding: 10px; width: 400px; border: 3px solid #aaa;}
		ul{margin-left:50px; }
		table{border-collapse: collapse; margin: 10px auto;}
		td{padding: 10px; border: 1px solid #aaa;}
		input{padding: 10px;}
		#wrap>div{text-align: center;}
		button{padding: 10px; color: #fff; background-color: #08f; width: 200px;}
	</style>
	<body>
		<div id="wrap">
			<ul>
				<li><%=uidSession %> 님 비밀번호 수정</li>
			</ul>
			<form action="">
				<table>
					<tr>
						<td>현재 비밀번호</td>
						<td>
						<input type="text" name="pw"/>
						</td>
					</tr>
					<tr>
						<td>새 비밀번호</td>
						<td>
						<input type="text" id="newPw" name="newPw"/>		
						</td>
					</tr>
					<tr>
						<td>새 비밀번호 확인</td>
						<td>
						<input type="text" id="newPwChk" name="newPwChk"/>
						</td>
					</tr>
				</table>
				</form>
			<div>
				<button type="button">변경</button>
			</div>
		</div>
		<!-- div#wrap -->
	</body>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
	<script>
	$(function(){
		$("button").click(function () {
			if($("input").val()==""){
				alert("기존 비밀번호를 입력해주세요");
			} else if($("#newPw").val()==""){
				alert("변경하실 비밀번호를 입력해주세요");
			}else if($("#newPw").val().trim()!=$("#newPwChk").val().trim()){
				alert("새 비밀번호가 일치하지 않습니다.");
			} else{
				$("form").attr("action","memberModPwProc.jsp");
				$("form").submit();
			}
		})
	});
	</script>
</html>