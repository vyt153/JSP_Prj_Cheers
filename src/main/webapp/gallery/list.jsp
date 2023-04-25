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
	String keyField =""; // DB 컬럼명
	String keyWord =""; // DB 검색어
	
	if(request.getParameter("keyWord")!=null){
		keyField = request.getParameter("keyField");
		keyWord= request.getParameter("keyWord");
	}
	
	// 페이지 관련 속성 값 시작 //
	// 페이징 = 페이지 나누기를 의미함

	int totalRecord = 0; // 전체 데이터 수
	int numPerPage = 3; // 페이지당 출력하는 데이터 수
	int pagePerBlock = 3; // 블럭당 표시되는 페이지 수의 개수
	int totalPage = 0; // 전체 페이지 수 
	int totalBlock = 0; // 전체 블럭 수 

	int nowPage = 1; // 사용자가 보고있는 페이지 번호
	int nowBlock = 1; // 사용자가 보고있는 블럭

	int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
	int end = 3; // 시작하는 인덱스 번호부터 반환하는 데이터 개수

	int listSize = 0; // 1페이지에서 보여주는 데이터 수

	// 게시판 검색 소스

	if(request.getParameter("keyWord")!=null){
		keyField = request.getParameter("keyField");
		keyWord= request.getParameter("keyWord");
	}

	if(request.getParameter("nowPage")!=null){
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
		start = (nowPage * numPerPage) - numPerPage;
		end = numPerPage;
	}

	Vector<GalleryBean> list = gMgr.getGalleryList(keyField, keyWord,start,end);
	
	totalRecord = gMgr.getTotalGallery(keyField, keyWord);

	totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
	nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);
	totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);
%>
<%@ include file="/ind/topTmp.jsp" %>
<script>
$(function () {
	$("title").text("갤러리게시판");
	$("#galleryBtn").click(function () {
		<%if(uidSession!=null){%>
		$("form").attr("action","/gallery/write.jsp");
		$("form").submit();
		<%} else{%>
		alert("로그인 후 글쓰기가 가능합니다.");
		<%}%>
	})
})
</script>
<style>
#container{display: grid; grid-template-columns: 1fr 1fr 1fr;}
div#post{border: 1px solid #000;}
#post{width: 258px; height: 420px; margin: 10px; text-align: center; cursor: pointer;}
#post>div{margin: 8px;}
#imgBox{width: 240px;height: 300px; overflow: hidden;}
img{width: 100%;height: 100%;}
#titleBox{text-align: center;font-weight: bold; margin: 5px;}
/* .dFlex{justify-content: space-between; margin: 5px; font-size: 13px;} */
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
			<!--  헤더템플릿 시작, iframe으로 변경 -->
			<%@ include file="/ind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->    	
    	
    	<main id="main" >
    		<div id="innerWrap" class="dFlex">
    		<div id="lnb">
	    		<!--  메인 LNB 템플릿 시작 -->
	    		
				<%@ include file="/ind/mainLnbTmp.jsp" %>
				
	    		<!--  메인 LNB 템플릿 끝 -->    	
    		</div>
    		
	    	<!-- 실제 작업 영역 시작 -->
    		<div id="contents">
    		<% if(keyWord==null||keyWord.equals("")){ %>
    			<h3><a href="list.jsp?gnbParam=gallery">갤러리게시판</a></h3>
    		<%} else{%>
    			<h3>검색결과</h3>
    			<%} %>
    			<div id="container">
				<% for(int i=0;i<list.size();i++){
					int num = list.get(i).getNum();
					String regtm = list.get(i).getRegtm();
					Date now = new Date();
			        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
					long time = Long.parseLong(formatter.format(now));
					long writeTm = Long.parseLong(regtm.replaceAll("[^0-9]", ""));
				%>
	    			<div id="post" onclick="read('<%=num %>', '<%=nowPage %>')">
		    			<div id="imgBox"><img src="../galleryupload/<%=list.get(i).getFilename() %>" alt="#" /></div>
		    			<div id="titleBox">
		    			제목 : <%=list.get(i).getSubject() %>
		    			<%if(time-writeTm<1000000){
							out.print("<span id='iconSample'>N</span>");
						}%>
		    			</div>
		    			<div id="uName">작성자 : <%=list.get(i).getUname() %> </div>
		    			<div id="date">작성일 : <%=list.get(i).getRegtm() %></div>
		    			<div id="viewCnt">조회수 : <%=list.get(i).getReadcnt() %></div>
	    			</div>
				<%} %>
				</div>
	    		<div id="listBtnArea">
	    			<button type="button" id="galleryBtn">글쓰기</button>
	    			<form>
						<div>
							<select name="keyField" id="keyField">
								<option value="subject"
									<%if(keyField.equals("subject")) out.print("selected"); %>>제  목
								</option>
								<option value="uName"
									<%if(keyField.equals("uName")) out.print("selected"); %>>이  름
								</option>
								<option value="content"
									<%if(keyField.equals("content")) out.print("selected"); %>>내  용
								</option>
							</select>	
							<input type="text" name="keyWord" id="keyWord" 
							size="20" maxlength="30" value="<%=keyWord%>"/>
							<button type="button" id="searchBtn">검색</button>
						</div>	
						<input type="hidden" id="pKeyField" value="<%=keyField %>" />
						<input type="hidden" id="pKeyWord" value="<%=keyWord %>"/>
   					</form>
	    		</div>
	    		
	    		<div id="listPagingArea">
    			
    			<div id="pagingTd">
    				<%
    					int pageStart = (nowBlock -1) * pagePerBlock +1;
    					int pageEnd = (nowBlock < totalBlock) ? pageStart + pagePerBlock - 1 : totalPage;
    					if (totalPage != 0) {
    				%>
    				<% if (nowBlock>1) { %>
    				<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock-1%>', '<%=pagePerBlock%>')">
						&lt; 
					</span>
    				<% } else { %>
    				<span class="moveBlockArea" ></span>
    				<% } %>
    				<%
    				for (; pageStart<=pageEnd; pageStart++) { %>
    				<% if (pageStart == nowPage) { %>
    				<span class="nowPageNum"><%=pageStart %></span>
    				<% } else { %>	
    					<span class="pageNum" onclick="movePage('<%=pageStart%>')">
    						<%=pageStart %>
    					</span>
    				<% } %>
    				
    				<% } %>
    						
    				<% if (totalBlock>nowBlock) { %>
    					<span  class="moveBlockArea" 
    					onclick="moveBlock('<%=nowBlock+1%>', '<%=pagePerBlock%>')">
							&gt;
						</span>
    				<% } else { %>
    					<span class="moveBlockArea"></span>
    				<% } %>
    				<%
					} else {
					out.print("<b>[ Paging Area ]</b>"); // End if
					}
					%>
    			</div>
    			
    		</div>
    		</div>
    		
    		
    		<!-- 실제 작업 영역 끝 -->
    		</div>
    	</main>
    	<!--  main#main  -->
    
    	<!--  푸터템플릿 시작 -->
		<%@ include file="/ind/footerTmp.jsp" %>
    	<!--  푸터템플릿 끝 -->  
