
$(function(){
	$("button#searchBtn").click(function(){
		let keyWord = $("#keyWord").val().trim();
		if(keyWord==""){
			alert("검색어를 입력해주세요");
			$("#keyWord").focus();
		} else{
			$("form").submit();
		}
	});
})

function read(p1, p2){
	let p3 = $("#pKeyField").val().trim();
	let p4 = $("#pKeyWord").val().trim();
	let param = "read.jsp?num="+p1;
		param += "&nowPage="+p2;
		param += "&keyField="+p3;
		param += "&keyWord="+p4 ;
	location.href= param;
}

/* 게시판 페이지 이동 시작 /bbs/list.jsp */

	function movePage(pageStart) {
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    	let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
    	let url = "/gallery/list.jsp?gnbParam=list&nowPage="+pageStart;
    		url += "&keyField=" + p3 ;
			url += "&keyWord=" + p4 ;
		location.href = url;
	}
	
	function moveBlock(nowBlock,pagePerBlock) {
		let nowPage = (nowBlock -1) * pagePerBlock +1;
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    	let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
    	let url = "/gallery/list.jsp?gnbParam=list&nowPage="+nowPage;
    		url += "&keyField=" + p3 ;
			url += "&keyWord=" + p4 ;
		location.href = url;
	}
	