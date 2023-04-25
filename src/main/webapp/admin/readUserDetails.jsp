<%@page import="java.util.Arrays"%>
<%@page import="pack.member.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.member.MemberMgr"/> 
    
<% 
request.setCharacterEncoding("UTF-8");
String uidParam = request.getParameter("uid");
if (uidParam == null) response.sendRedirect("/admin/adminUserInfoDetails.jsp");
MemberBean mBean = mMgr.modifyMember(uidParam);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<link rel="stylesheet" href="/style/style_Common.css">
<script src="/resource/jquery-3.6.0.min.js"></script>
</head>
<body>

	<div id="wrap">
			<!-- 실제 작업영역 시작-->
			<main id="main" class="dFlex">
			
				<div id="contents" class="memUpdate">
					<form name="modFrm" id="modFrm">
					
						<table id="modFrmTbl">
							<caption>회원 정보 수정</caption>
							<tbody>
								<tr>
									<td class="req">아이디</td>
									<td>
										<%=mBean.getUid() %>
										<input type="hidden" name="uid" value="<%=mBean.getUid() %>" >
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td class="req">이름</td>
									<td>
										<input type="text" name="uname" id="uname" maxlength="20"
										value="<%=mBean.getUname()%>"/>
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td class="req">Email</td>
									<td>
										<% 
											String uemail = mBean.getUemail();
											String[] email = uemail.split("@");
										%>
										<input type="text" id="uemail_01" maxlength="20" size="7"
										value="<%=email[0]%>"/>
										<span>@</span>
										<input type="text" id="uemail_02" maxlength="20" size="10"
										value="<%=email[1]%>"/>
										
										<select id="emailDomain" class="frmDropMenu">
											<option value="">직접입력</option>
											<option>naver.com</option>
											<option>daum.net</option>
										</select>
										
										<button type="button" id="emailAuthBtn" class="frmBtn">인증코드받기</button>
										
										<!-- 이메일 인증영역 시작 : Authentication Code 인증코드 -->
										
										<div id="emailAuthArea">
											<span>인증코드 입력</span>
											<input type="text" id="emailAuth" size="25" />
											<button type="button" class="frmBtn">인증하기</button>
										</div>
										<!-- div#emailAuthArea -->
										
										<input type="hidden" name="uemail" id="uemail" />
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>성별</td>
									<td>
									<%
										String gender = mBean.getGender();
										String chkMale = "";
										String chkFemale = "";
										if(gender!=null){
											if(gender.equals("1")){
												chkMale = "checked";
											}else if(gender.equals("1")){
												chkFemale = "checked";
											}
										}
									%>
									<label>
										남<input type="radio" name="gender" value="1" <%=chkMale %>/></label>
									<label>
										여<input type="radio" name="gender" value="2" <%=chkFemale %>/></label>
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>생년월일</td>
									<td>
									<%if(mBean.getUbirthday()!=null){%>
										<input type="text" name="ubirthday" id="ubirthday"
									 maxlength="6" size="8" value="<%=mBean.getUbirthday()%>"/>
									<%} else{ %>
										<input type="text" name="ubirthday" id="ubirthday"
									 maxlength="6" size="8" value=""/>
									 <%} %>
									 </td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>우편번호</td>
									<td>
									<%if(mBean.getUzipcode()!=null){%>
										<input type="text" name="uzipcode" id="uzipcode" maxlength="7" size="7" value="<%=mBean.getUzipcode() %>" readonly />
									<%} else{ %>
										<input type="text" name="uzipcode" id="uzipcode" maxlength="7" size="7" value="" readonly />
									 <%} %>
										<button type="button" id="findZipBtn" class="frmBtn">우편번호찾기</button>
									</td>
									<td><span>우편번호 찾기 버튼을 클릭하세요.</span></td>
								</tr>
								<tr>
									<td>주소</td>
									<td>
									<%if(mBean.getUaddr()!=null){%>
										<input type="text" name="uaddr" id="uaddr" maxlength="100" size="50" value="<%=mBean.getUaddr() %>" />
									<%} else{ %>
										<input type="text" name="uaddr" id="uaddr" maxlength="100" size="50" value="" />
										<%} %>
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>취미</td>
									<%
										String[] uhobby = mBean.getUhobby();
									%>
									
									<script>
										$(function () {
											let chkBoxAry = <%=Arrays.toString(uhobby)%>;
											let len = chkBoxAry.length;
											
											let chkToF;
											for (var i = 0; i < len; i++) {
												if(chkBoxAry[i]==1) chkToF = true;
												$("input[name=uhobby]").eq(i).prop("checked", chkToF);
												chkToF=false;
											}
										})
									</script>
									
									<td>
										<label><input type="checkbox" name="uhobby" value="인터넷"/>인터넷</label>
										<label><input type="checkbox" name="uhobby" value="여행"/>여행</label>
										<label><input type="checkbox" name="uhobby" value="게임"/>게임</label>
										<label><input type="checkbox" name="uhobby" value="영화"/>영화</label>
										<label><input type="checkbox" name="uhobby" value="운동"/>운동</label>
									</td>
									<td></td>
								</tr>
								<tr>
									<td>직업</td>
									<%
										String ujob = mBean.getUjob();
									%>
									<td>
										<select name="ujob" id="ujob" class="frmDropMenu">
										<%if(ujob!=null){ %>
											<option <% if(ujob.equals("")) out.print("selected"); %> value="">- 선택 -</option>
											<option <% if(ujob.equals("교수")) out.print("selected"); %>>교수</option>
											<option <% if(ujob.equals("학생")) out.print("selected"); %>>학생</option>
											<option <% if(ujob.equals("회사원")) out.print("selected"); %>>회사원</option>
											<option <% if(ujob.equals("공무원")) out.print("selected"); %>>공무원</option>
											<option <% if(ujob.equals("자영업")) out.print("selected"); %>>자영업</option>
											<option <% if(ujob.equals("전문직")) out.print("selected"); %>>전문직</option>
											<option <% if(ujob.equals("주부")) out.print("selected"); %>>주부</option>
											<option <% if(ujob.equals("무직")) out.print("selected"); %>>무직</option>
											<%} else{%>
											<option>- 선택 -</option>
											<option>교수</option>
											<option>학생</option>
											<option>회사원</option>
											<option>공무원</option>
											<option>자영업</option>
											<option>전문직</option>
											<option>주부</option>
											<option>무직</option>
											<%} %>
										</select>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="3">
										<button type="button" id="modSbmBtn" class="frmBtn">수정하기</button>
										<button type="reset" class="frmBtn">다시쓰기</button>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				<!-- form[name=regFrm -->
				</div>
			</main>
			<!-- 실제 작업영역 끝 -->
	</div>

</body>
</html>