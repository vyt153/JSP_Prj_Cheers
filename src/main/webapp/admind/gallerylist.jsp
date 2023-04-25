<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="pack.gallery.GalleryBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="gMgr" class="pack.gallery.GalleryMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	String uidSession = (String)session.getAttribute("uidSession");
	
	int galStart = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
	int galEnd = 3; // 시작하는 인덱스 번호부터 반환하는 데이터 개수


	Vector<GalleryBean> gList = gMgr.getGalleryList("", "",galStart,galEnd);
%>
<%@ include file="/ind/topTmp.jsp" %>

<style>
#container{display: grid; grid-template-columns: 1fr 1fr 1fr;}
div#post{border: 1px solid #000;}
#post{width: 258px; height: 420px; margin: 10px; text-align: center; cursor: pointer;}
#post>div{margin: 8px;}
#imgBox{width: 240px;height: 300px; overflow: hidden;}
#imgBox>img{width: 100%;height: 100%;}
#titleBox{text-align: center;font-weight: bold; margin: 5px;}
#uName{text-align: center; margin: 5px;}
#listBtnArea{display: flex; justify-content: space-between;}
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
.pageNum{cursor: pointer;}
</style>
<script src="../script/script_Gallery.js"></script>
    	    		
	    	<!-- 실제 작업 영역 시작 -->
    		<div id="contents">
    			<h1>갤러리게시판</h1>
    			<div id="container">
				<% for(int i=0;i<gList.size();i++){
					int num = gList.get(i).getNum();
					String regtm = gList.get(i).getRegtm();
					Date now = new Date();
			        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
					long time = Long.parseLong(formatter.format(now));
					long writeTm = Long.parseLong(regtm.replaceAll("[^0-9]", ""));
				%>
	    			<div id="post" onclick="read('<%=num %>', '<%=1 %>')">
		    			<div id="imgBox"><img src="../galleryupload/<%=gList.get(i).getFilename() %>" alt="#" /></div>
		    			<div id="titleBox">
		    			제목 : <%=gList.get(i).getSubject() %>
		    			<%if(time-writeTm<1000000){
							out.print("<span id='iconSample'>N</span>");
						}%>
		    			</div>
		    			<div id="uName">작성자 : <%=gList.get(i).getUname() %> </div>
		    			<div id="date">작성일 : <%=gList.get(i).getRegtm() %></div>
		    			<div id="viewCnt">조회수 : <%=gList.get(i).getReadcnt() %></div>
	    			</div>
				<%} %>
				</div>
    		</div>
    		
    		<!-- 실제 작업 영역 끝 -->
