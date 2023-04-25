<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="javax.tools.DocumentationTool.Location"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="pack.bbs.BoardBean,java.util.Vector" %>
<jsp:useBean id="bMgr" class="pack.bbs.BoardMgr"/>
<% request.setCharacterEncoding("UTF-8"); 

//페이지 관련 속성 값 시작 //
//페이징 = 페이지 나누기를 의미함

int numPerPage = 10; // 페이지당 출력하는 데이터 수

int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 10; // 시작하는 인덱스 번호부터 반환하는 데이터 개수

int listSize = 0; // 1페이지에서 보여주는 데이터 수

//페이징 관련 속성 끝//
Vector<BoardBean> vList = null;
%>

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
		    	<!-- 실제 작업 영역 시작 -->
	    		<div id="contents" class="bbsList">
	    			<h3><a href="/bbs/list.jsp?gnbParam=bbs">자유게시판</a></h3>
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
	    				vList = bMgr.getBoardList("", "", start, end);
	    				
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
	    					<tr class="prnTr" onclick="read('<%=num%>', '<%=1%>')">
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
	    							}
	    							%>
	    						</td>
	    						<td><%=uname %></td>
	    						<td><%=regtm %></td>
	    						<td><%=readcnt %></td>
	    					</tr>
	    					<%  } 
	    					}%>
	    				</tbody>
	    			</table>
	    		</div>
	    		<!-- 실제 작업 영역 끝 -->
