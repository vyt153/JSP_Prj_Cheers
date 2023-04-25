<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="gMgr" class="pack.gallery.GalleryMgr" />
<script>
<%
String uidSession = (String) session.getAttribute("uidSession");
if(uidSession!=null){
	int num = Integer.parseInt(request.getParameter("num"));
	if(gMgr.delGallery(num)){
		response.sendRedirect("list.jsp");
	}
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "../member/login.jsp";
<%}%>
</script>