<%@page import="pack.admin.AdmBoardBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="javax.tools.DocumentationTool.Location"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String admSession = (String)session.getAttribute("admSession");
%>
<%@ page import="pack.admin.AdminBean" %>
<jsp:useBean id="admMgr" class="pack.admin.AdminMgr"/>
<% request.setCharacterEncoding("UTF-8"); 

// 페이지 관련 속성 값 시작 //
// 페이징 = 페이지 나누기를 의미함

int totalRecord = 0; // 전체 데이터 수
int numPerPage = 10; // 페이지당 출력하는 데이터 수
int pagePerBlock = 5; // 페이지당 출력되는 블럭 수
int totalPage = 0; // 전체 페이지 수 
int totalBlock = 0; // 전체 블럭 수 

int nowPage = 1; // 사용자가 보고있는 페이지 번호
int nowBlock = 1; // 사용자가 보고있는 블럭

int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 10; // 시작하는 인덱스 번호부터 반환하는 데이터 개수

int listSize = 0; // 1페이지에서 보여주는 데이터 수

// 게시판 검색 소스
String keyField =""; // DB 컬럼명
String keyWord =""; // DB 검색어

if(request.getParameter("keyWord")!=null){
	keyField = request.getParameter("keyField");
	keyWord= request.getParameter("keyWord");
}

if(request.getParameter("nowPage")!=null){
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
}

totalRecord = admMgr.getTotalRecord();

totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);
totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);

// 페이징 관련 속성 끝//
List<AdmBoardBean> list = admMgr.getNoticeList(keyWord, keyField, start, end);
%>
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
</style>
<script>
$(function () {
	$("title").text("공지사항");
})
function Read(p1,p2){
	let p3 = $("#pKeyField").val().trim();
	let p4 = $("#pKeyWord").val().trim();
	let param = "/admin/noticeRead.jsp?num="+p1;
		param += "&nowPage="+p2;
		param += "&keyField="+p3;
		param += "&keyWord="+p4;
	location.href = param;
}
</script>
		<link rel="stylesheet" href="/style/style_BBS.css">
		<script src="/script/script_BBS.js"></script>
			<!--  헤더템플릿 시작 -->
			<%@ include file="/admind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->    	
	    	
	    	<main id="main">
	    		<div id="innerWrap" class="dFlex">
	    		<div id="lnb">
	    			<!--  메인 LNB 템플릿 시작 -->
					<%@ include file="/admind/mainLnbTmp.jsp" %>
		    		<!--  메인 LNB 템플릿 끝 -->    	
	    		</div>
	    		<div id="contents" class="bbsList">
	    			<h3><a href="/admin/admNotice.jsp">공지사항</a></h3>
	    		<%
	    			String prnType = "";
	    			if(keyWord.equals("null")||keyWord.equals("")){
	    				prnType="전체 게시글";
	    			}else{
	    				prnType = "검색 결과";
	    			}
	    		%>
	    			<div id="pageInfo" class="dFlex">
	    			<span><%=prnType %> : <%=totalRecord %> 개</span>
	    			<span>페이지 : <%=nowPage + " / " + totalPage %></span>
	    			</div>
	    			
	    			<table id="noticeList">
	    				<thead>
	    					<tr>
	    						<th>번호</th>
	    						<th>제목</th>
	    						<th>이름</th>
	    						<th>날짜</th>
	    						<th>조회수</th>
	    					</tr>
	    					<tr>
	    						<td colspan="5" class="spaceTd"></td>
	    					</tr>
	    				</thead>
	    				<tbody>
	    				
	    				<%
	    					if(list==null){%>
	    					<tr>
	    						<td colspan="5">
	    						<%="게시물이 없습니다." %>
	    						</td>
	    					</tr>
	    				<%} else{
	    				for(int i=0; i<numPerPage;i++){
	 							if(i==list.size()) break;
	 							AdmBoardBean bean = list.get(i);
	 							String filename = bean.getFilename();
    							%>
	   					<tr onclick="Read('<%=bean.getNum()%>', '<%=nowPage%>')">
	   						<td><%=bean.getNum() %></td>
	   						<td class="subjectTd">
   							<%out.print(bean.getSubject());
   							if(filename!=null){
   								out.print("<img src='/images/clip_16x10.png' alt=''>");
   							}
   							;%>
	    						</td>
	   						<td><%=bean.getadmName() %></td>
	   						<td><%=bean.getPostTM() %></td>
	   						<td><%=bean.getReadcnt() %></td>
	   					</tr>
	   				<%}%>
	    					
	    				<% } %>
	    					<tr id="listBtnArea">
	    						<td colspan="2">
	    						<% if(admSession == null) {%>
	    							<button type="button" id="loginAlertBtn" class="listBtnStyle" >글쓰기</button>
	    						<%} else{ %>
	    							<button type="button" class="listBtnStyle" onclick="location.href='/admin/admWrite.jsp'">글쓰기</button>
	    						<%} %>
	    						</td>
	    						<td colspan="3">
	    							<form name="searchFrm" class="dFlex" id="searchFrm">
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
	    								</div>
	    								<div>
	    									<input type="text" name="keyWord" id="keyWord" 
	    									size="20" maxlength="30" value="<%=keyWord%>"/>
	    								</div>
	    								<div>
	    									<button type="button" id="searchBtn" class="listBtnStyle">검색</button>
	    								</div>
	    							</form>
	    							<!-- 검색결과 유지용 매개변수 데이터 -->
	    							<input type="hidden" id="pKeyField" value="<%=keyField %>" />
	    							<input type="hidden" id="pKeyWord" value="<%=keyWord %>"/>
	    							
	    						</td>
	    					</tr> <!-- tr#listBtnArea -->
	    					
	    					<tr id="listPagingArea">
	    					<!-- 페이징 시작 -->
	    						<td colspan="5" id="pagingTd">
	    					<%
	    					int pageStart = (nowBlock-1)*pagePerBlock+1;
	    					int pageEnd = (nowBlock<totalBlock) ? pageStart+pagePerBlock - 1 : totalPage;
	    					if(totalPage != 0){
	    						if(nowBlock>1){%>
	    							<span id="moveBlockArea" onclick="moveBlock('<%=nowBlock-1%>','<%=pagePerBlock%>')">
	    							&lt;</span>
	    						<%} else{ %>
	    							<span class="moveBlockArea"></span>
	    					<%} %>
	    					
	    					<!-- 페이지 나누기용 페이지번호 출력 시작 -->
	    					<% 
	    						for(; pageStart<=pageEnd; pageStart++){
	    					 		if(pageStart == nowPage){%>
	    					 		<span class="nowPageNum"><%=pageStart %></span>
	    					 <% } else{ %>
	    					 		<span class="PageNum" onclick="movePage('<%=pageStart %>')">
	    					 		<%=pageStart %></span>
	    					 <% }
	    					 } %>
	    					 <!-- 페이지 나누기용 페이지번호 출력 끝 -->
	    					 
	    					 <%if(totalBlock>nowBlock){//다음 블럭이 남아 있다면 %>
	    					 		<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock+1 %>','<%=pagePerBlock %>')">
	    					 		&gt;</span>
	    					 <% } else{ %>
	    					 		<span class="moveBlockArea"></span>
	    					 <%}
	    					} else{ 
	    					 		out.print("<b>[ Paging Area ]</b>");
	    					 }%>
	    					 
	    						</td>
	    					</tr>
	    				</tbody>
	    			</table>
	    		</div>
	    		<!-- 실제 작업 영역 끝 -->
	    		</div>
	    	</main>
	    	
	    	<!--  푸터템플릿 시작 -->
			<%@ include file="/ind/footerTmp.jsp" %>
	    	<!--  푸터템플릿 끝 --> 