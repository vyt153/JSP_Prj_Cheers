<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="gMgr" class="pack.gallery.GalleryMgr"/>


<script>
<%
String uidSession = (String) session.getAttribute("uidSession");
if(uidSession!=null){
	if(gMgr.insertGallery(request)){%>
	setTimeout(function () {
		alert("게시글이 작성되었습니다.");
		location.href="list.jsp";
		}, 2500);
	<%} else{%>
		alert("갤러리게시판에는 이미지를 첨부해주세요.");
		history.back();
	<%}
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "../member/login.jsp";
<%}%>
</script>