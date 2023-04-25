<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="javax.tools.DocumentationTool.Location"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String uidSession = (String)session.getAttribute("uidSession");
%>
<%@ page import="pack.bbs.BoardBean,java.util.Vector" %>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr"/>
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

totalRecord = bMgr.getTotalCount(keyField, keyWord);

totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);
totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);

// 페이징 관련 속성 끝//
Vector<BoardBean> vList = null;
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
/* 	background-color: rgba(170,170,175,0.1); */
}

div.bbsList tr.adminTr>td.subjectTd {
	text-align: left;
}
</style>
<script>
$(function () {
	$("title").text("게시판");
})
</script>
		<link rel="stylesheet" href="/style/style_BBS.css">
		<script src="/script/script_BBS.js"></script>
			<!--  헤더템플릿 시작 -->
			<%@ include file="/ind/headerTmp.jsp" %>
	    	<!--  헤더템플릿 끝 -->    	
	    	
	    	<main id="main">
	    		<div id="innerWrap" class="dFlex">
	    		<div id="lnb">
	    			<!--  메인 LNB 템플릿 시작 -->
					<%@ include file="/ind/mainLnbTmp.jsp" %>
		    		<!--  메인 LNB 템플릿 끝 -->    	
	    		</div>
	    		<div id="contents" class="bbsList">
	    			<h3><a href="/bbs/list.jsp?gnbParam=bbs">자유게시판</a></h3>
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
	    			
	    			<table id="boardList">
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
	    				vList = bMgr.getBoardList(keyField, keyWord, start, end);
	    				listSize = vList.size();
	    					
	    					if(vList.isEmpty()){%>
	    					<tr>
	    						<td colspan="5">
	    						<%="게시물이 없습니다." %>
	    						</td>
	    					</tr>
	    				<%} // 데이터가 없을 경우 출력 끝
	    					else{ 
	    					// 데이터가 있을 경우 출력 시작
	    				 %>
	    				
	    				<%
	    					for(int i=0;i<numPerPage;i++){
	    						if(i==listSize) break;
	    						
	    						BoardBean bean = vList.get(i);
	    						
	    						int num = bean.getNum();
	    						String uname = bean.getUname();
	    						String subject = bean.getSubject();
	    						String regtm = bean.getRegtm();
	    						String filename = bean.getFilename();
	    						int depth = bean.getDepth();
	    						int readcnt = bean.getReadcnt();
	    						
	    						Date now = new Date();
	    				        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	    						long time = Long.parseLong(formatter.format(now));
								long writeTm = Long.parseLong(regtm.replaceAll("[^0-9]", ""));
								String newChk = "";
								if(time-writeTm<1000000){
    								newChk = "<span id='iconSample'>N</span>";
    							} else{
    								regtm = regtm.substring(0, 10);
    							}
	    				%>
	    				<%if(uname.equals("관리자")) {%>
	    					<tr class="adminTr">
	    						<td>
	    							<% if(depth==0) out.print(num);// 답변글이 아님을 의미함 %>
	    						</td>
	    						<td class="subjectTd">
	    							<%
    								if(depth>0){
    									for(int blank=0;blank<depth;blank++){
    										out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
    									}
   									out.print("<img src='/images/replyImg.png' alt=''>");
    								}
	    							out.print(subject);
	    							if(filename!=null){
	    								out.print("<img src='/images/clip_16x10.png' alt=''>"+newChk);
	    							}
	    							if(time-writeTm<1000000){
	    								out.print("<span id='iconSample'>N</span>");
	    							}
	    							%>
	    						</td>
	    						<td><%=uname %></td>
	    						<td><%=regtm %></td>
	    						<td><%=readcnt %></td>
	    					</tr>
	    					<%} else{%>
	    					<tr class="prnTr" onclick="read('<%=num%>', '<%=nowPage%>')">
	    						<td>
	    							<% if(depth==0) out.print(num);// 답변글이 아님을 의미함 %>
	    						</td>
	    						<td class="subjectTd">
	    							<%
    								if(depth>0){
    									for(int blank=0;blank<depth;blank++){
    										out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
    									}
   									out.print("<img src='/images/replyImg.png' alt=''>");
    								}
	    							out.print(subject);
	    							if(filename!=null){
	    								out.print("<img src='/images/clip_16x10.png' alt=''>");
	    							}
	    							if(time-writeTm<1000000){
	    								out.print("<span id='iconSample'>N</span>");
	    							}else{
	    								regtm = regtm.substring(0, 10);
	    							}
	    							%>
	    						</td>
	    						<td><%=uname %></td>
	    						<td><%=regtm %></td>
	    						<td><%=readcnt %></td>
	    					</tr>
	    					<%} %>
	    					<%  } 
	    					}%>
	    					<tr id="listBtnArea">
	    						<td colspan="2">
	    						<% if(uidSession == null) {%>
	    							<button type="button" id="loginAlertBtn" class="listBtnStyle">글쓰기</button>
	    						<%} else{ %>
	    							<button type="button" id="writeBtn" class="listBtnStyle">글쓰기</button>
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
	    					 <% }
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