<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="gMgr" class="pack.gallery.GalleryMgr" />
<script>
<%
String uidSession = (String) session.getAttribute("uidSession");
if(uidSession!=null){%>
	setTimeout(function () {
	<%if(gMgr.updateGallery(request)==1){%>
		alert("수정이 완료되었습니다.");
		location.href="list.jsp";
	}, 2500);
	<%} else{%>
		alert("수정에 실패하였습니다.");
		history.back();
<%}
} else{%>
	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
	location.href = "../member/login.jsp";
<%}%>

</script>