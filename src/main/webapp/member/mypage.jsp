<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("마이페이지");
})
</script>
			<!--  헤더템플릿 시작, iframe으로 변경 -->
			<%@ include file="/ind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->    	
    	
    	<main id="main" class="dFlex">
    	
    		<div id="lnb">
	    		<!--  메인 LNB 템플릿 시작 -->
	    		
				<%@ include file="/ind/mainLnbTmp.jsp" %>
				
	    		<!--  메인 LNB 템플릿 끝 -->    	
    		</div>
    		
	    	<!-- 실제 작업 영역 시작 -->
    		<div id="contents">
	    		<h2>이용하실 서비스를 선택하세요</h2>
    		
    		</div>
    		<!-- 실제 작업 영역 끝 -->
    		    	
    	</main>
    	<!--  main#main  -->
    
    	<!--  푸터템플릿 시작 -->
		<%@ include file="/ind/footerTmp.jsp" %>
    	<!--  푸터템플릿 끝 -->  
    