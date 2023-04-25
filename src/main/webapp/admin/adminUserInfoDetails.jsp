<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="pack.member.MemberLoginBean"%>
<%@ include file="/ind/topTmp.jsp" %>
<jsp:useBean id="aMgr" class="pack.admin.AdminMgr"/>
<%
request.setCharacterEncoding("UTF-8"); 

int totalRecord = 0; // 전체 데이터 수
int numPerPage = 2; // 페이지당 출력하는 데이터 수
int pagePerBlock = 2; // 페이지당 출력되는 블럭 수
int totalPage = 0; // 전체 페이지 수 
int totalBlock = 0; // 전체 블럭 수 

int nowPage = 1; // 사용자가 보고있는 페이지 번호
int nowBlock = 1; // 사용자가 보고있는 블럭

int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 2; // 시작하는 인덱스 번호부터 반환하는 데이터 개수

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

List<MemberLoginBean> list = null;

%>

<%@ include file="/ind/topTmp.jsp" %>
<script src = "/script/script_Admin.js"></script>

<main id="main">
<div id="userInfoTblArea">
	<div id="userInfohead">
		<h1>회원정보</h1>
	</div>
	<%
	list = aMgr.userInfo(keyField, keyWord, start, end);
	listSize = list.size();
	
	totalRecord = aMgr.getTotalCount(keyField, keyWord);
	
	totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
	nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);
	totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);
	
	String prnType = "";
	if (keyWord.equals("null") || keyWord.equals("")) {
		prnType = "전체 게시글";
	} else {
		prnType = "검색 결과";
	}
	%>
	<div id="pageInfo" class="dFlex">
		<span><%=prnType%> : <%=totalRecord%> 개</span> <span>페이지 : <%=nowPage + " / " + totalPage%></span>
	</div>
	
	<table id="userInfoTbl">
	<thead>
		<tr>
			<th>이름</th>
			<th>접속아이피</th>
			<th>마지막접속</th>
			<th>접속횟수</th>
			<th>접속수단</th>
		</tr>
		<tr>
	    	<td colspan="5" class="spaceTd"></td>
	    </tr>
	</thead>
	<tbody>
		<%
			if(list.isEmpty()) {
		%>
		<tr>
			<td colspan="5">
			<%= "회원이 없습니다." %>
			</td>
		</tr>
		<% } else { %>
		
		<%
		for(int i=0;i<numPerPage;i++) {
			if(i==listSize) break;
			
			MemberLoginBean bean = list.get(i);
			
			String uid = bean.getUid();
			String loginip = bean.getLoginip();
			String logintm = bean.getLogintm();
			int logincnt = bean.getLogincnt();
			String conndev = bean.getConndev();
			
		%>
		
		
		<tr class="prnTr" onclick="read('<%=uid%>', '<%=nowPage%>')">
			<td><%=uid %></td>
			<td><%=loginip %></td>
			<td><%=logintm %></td>
			<td><%=logincnt %></td>
			<td><%=conndev %></td>
		</tr>
		
		<%
		}
		%>
		
		<% } %>
		
		<tr id="listBtnArea">
			<td colspan="5">
				<form name="searchUidFrm" class="dFlex" id="searchUidFrm">
					<div>
						<select name="keyField" id="keyField">
							<option value="uid"
	    						<%if(keyField.equals("uid")) out.print("selected"); %>>아이디
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
				<input type="hidden" id="pKeyField" value="<%=keyField %>" />
				<input type="hidden" id="pKeyWord" value="<%=keyWord %>"/>
			</td>
		</tr>
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
</main>

<!--  푸터템플릿 시작 -->
<%@ include file="/ind/footerTmp.jsp" %>
<!--  푸터템플릿 끝 --> 