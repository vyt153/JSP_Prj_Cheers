<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>이용약관 동의</title>
		<link rel="stylesheet" href="/style/style_Common.css">
		<link rel="stylesheet" href="/style/style_Template.css">
		<link rel="stylesheet" href="/style/style_Member.css">
		<script src="/resource/jquery-3.6.0.min.js"></script>
   		<script src="/script/script_Join.js"></script>
	</head>
	<body>
		<div id="wrap">
			<main id="main" class="joinAgreePage dFlex">
				<div class="logoArea">
					<a href="/index.jsp">
	    				<img src="/images/logo.png" alt="헤더로고이미지">
	    			</a>
				</div>
				<!-- 실제 작업영역 시작 -->
				<div class="joinAgree">
					<div id="chkAllArea">
						<label>
							<input type="checkbox" id="chkAll" /><i></i>&ensp;
							이용약관 및 개인정보수집 및 이용, 쇼핑정보 수신(선택)에 모두 동의합니다.
						</label>
					</div>
					
					<div id="licenseArea">
						<div class="termArea">
							<h3>[필수] 이용약관 동의</h3>
							<iframe src="/ind/usingAgree.jsp" class="usingAgree"></iframe>
							<label>
								이용약관에 동의하십니까?
								<input type="checkbox" class="usingAgreeChk chkRequired" data-link="0"/>
								<i></i>&ensp;동의함 (필수)
							</label>
						</div>
					
						<div class="termArea">
							<h3>[필수] 개인정보 수집 및 이용 동의</h3>
							<iframe src="/ind/personalInfoAgree.jsp" class="usingAgree"></iframe>
							<label>
								개인정보 수집 및 이용에 동의하십니까?
								<input type="checkbox" class="usingAgreeChk chkRequired" data-link="1"/>
								<i></i>&ensp;동의함 (필수)
							</label>
						</div>
						
						<div class="termArea">
							<h3>[선택] 쇼핑정보 수신 동의</h3>
							<iframe src="/ind/shopInfoAgree.jsp" class="usingAgree"></iframe>
							<label>
								쇼핑정보 수신에 동의하십니까?
								<input type="checkbox" class="usingAgreeChk chkRequired" data-link="1"/>
								<i></i>&ensp;동의함 (선택)
							</label>
						</div>
					</div> <!--  div#licenseArea -->
					
				</div>
				<form action="/member/member.jsp" method="post" id="joinFrm">
					<input type="hidden" name="vCode" value="chkOK1234" />
					<div id="formArea">
						<button type="button">확인</button>
					</div>
				</form> <!-- form#joinFrm -->
			<!-- 실제 작업영역 끝 -->
			</main>	
		</div>
		<!-- div#wrap -->
	</body>
</html>