$(function() {
	//헤더 날짜 및 시계
	let dom = document.getElementById("headerclock");
	time();
	function time() {
		let clock = "";
		const now = new Date();
		let monthOrigin = now.getMonth() + 1;
		let month = String(monthOrigin).padStart(2, "0");
		let today = String(now.getDate()).padStart(2, "0");
		const weekday = ["일", "월", "화", "수", "목", "금", "토"];
		let week = weekday[now.getDay()];
		let hour = String(now.getHours()).padStart(2, "0");
		let min = String(now.getMinutes()).padStart(2, "0");
		let sec = String(now.getSeconds()).padStart(2, "0");
		clock = month + "." + today + "." + week + " " + hour + ":" + min + ":" + sec;
		dom.innerText = clock;
	}
	setInterval(time, 1000);
});