/**
 * 
 */
 
 $(function(){
	$("#userInfohead").children("h1").click(function(){
		location.href = "/admin/adminUserInfoDetails.jsp";
	});
});

function movePage(pageStart) {
	let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	let url = "/admin/adminUserInfoDetails.jsp?nowPage="+pageStart;
		url += "&keyField=" + p3 ;
		url += "&keyWord=" + p4 ;
	location.href = url;
}

function moveBlock(nowBlock,pagePerBlock) {
	let nowPage = (nowBlock -1) * pagePerBlock +1;
	let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	let url = "/admin/adminUserInfoDetails.jsp?nowPage="+nowPage;
		url += "&keyField=" + p3 ;
		url += "&keyWord=" + p4 ;
	location.href = url;
}

// 상세내용 보기 페이지 이동
function read(p1,p2){
	let p3 = $("#pKeyField").val().trim();
	let p4 = $("#pKeyWord").val().trim();
	let param = "/admin/readUserDetails.jsp?uid="+p1;
		param += "&nowPage="+p2;
		param += "&keyField="+p3;
		param += "&keyWord="+p4;
	location.href = param;
}