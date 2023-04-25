<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/ind/topTmp.jsp" %>
<style>
#iconSample {
    width: 13px;
    height: 13px;
    color: #fff;
    font-size: 11px;
    text-align: center;
    line-height: 13px;
    border-radius: 50%;
    background-color: #f44;
    display: inline-block;
    transform: translate(2px, -2px);
}
div.bbsList tr.adminTr>td {
	text-align: center;
	padding: 20px 2px 10px;
	border-bottom: 1px solid #d2d2d2;
	color: #aaa;
	font-weight: bold;
}

div.bbsList tr.adminTr>td.subjectTd {
	text-align: left;
}
div#inner{
	width: 1800px;
	margin: 0 auto;
}
#lnb{height: 340px;}
</style>
<script>
$(function () {
	$("title").text("관리자 메인페이지");
})
</script>
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/script/script_BBS.js"></script>
 	
    	<!--  헤더템플릿 시작, iframe으로 변경 -->
		<%@ include file="/admind/headerTmp.jsp" %>
    	<!--  헤더템플릿 끝 -->    	
    	
    	
    	<main id="main">
    		<div id="inner" class="dFlex">
	    		<div id="lnb">
		    		<!--  메인 LNB 템플릿 시작 -->
					<%@ include file="/admind/mainLnbTmp.jsp" %>
		    		<!--  메인 LNB 템플릿 끝 -->    	
	    		</div>
	    		<div id="left">
	    			<%@include file="/admind/admNotice.jsp" %>
	    			<%@include file="/admind/bbslist.jsp"%>
	    		</div>
	    		<div id="right">
    				<%@include file="/admind/adminUserInfoTbl.jsp" %>
	    			<%@include file="/admind/gallerylist.jsp" %>
	    		</div>
    		</div>
    	</main>
    	<!--  main#main  -->
    
        	   	
    	<!--  푸터템플릿 시작 -->
		<%@ include file="/ind/footerTmp.jsp" %>
    	<!--  푸터템플릿 끝 -->  