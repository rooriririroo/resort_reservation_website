<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>예약하기</title>
	
	<!-- include libraries(jQuery, bootstrap) -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"
	integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
	crossorigin="anonymous"></script>
	<script src="jquery-ui-1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="jquery-ui-1.12.1/jquery-ui2.css"/>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 

	<!-- include summernote css/js -->
	<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.js"></script>
	
	<!-- 스타일 지정 -->
	<style> 
		#table01 {margin:auto; margin-top:50px; border:2px solid lavender; width:800px; text-align:center; }
		.firstTd {width:100px; background-color:lavender; padding:10px 10px 10px 10px; font-size:16px; text-align:left;}
		.secondTd {width:700px; border:2px solid lavender; text-align:left; padding:10px 10px 10px 10px;}
		.titleTd {text-align:center; font-weight:bold; background-color:lavender; padding:10px 10px 10px 10px;}
		.btn {background-color:mediumpurple; margin-top:5px; width:100px; color:#ffffff;}
		a {text-decoration:none;}
	</style>
	
	<script>
	$(document).ready(function() { /*홈페이지 로드 시*/
	    $("#resv_date").datepicker({
	    	dateFormat:"yy-mm-dd",
	    	prevText:"이전 달",
	    	nextText:"다음 달",
	    	changeYear:true,
	    	changeMonth:true,
	    	minDate:"0",
	    	maxDate:"+29D",
	    	dayNamesMin:['일','월','화','수','목','금','토'],
	    	monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	    }); /*datepicker 설정*/
	});
	// 특수문자 검사
	function checkSpecialCh() {
		var name = document.getElementById("name");
		var in_name = document.getElementById("in_name");
		var pattern = /[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9\s]/gi;

		name.value=name.value.replace(pattern,'');
		in_name.value=in_name.value.replace(pattern,'');
	}
	// 연락처 형식 검사
	function checkTel() {
		var telnum = document.getElementById("telnum");
		telnum.value = telnum.value.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
	}
	// 날짜 차이 비교
	function dateDiff(_date1, _date2) {
	    var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
	    var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);
	 
	    diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
	    diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());
	 
	    var diff = diffDate_2.getTime() - diffDate_1.getTime();
	    diff = Math.ceil(diff / (1000 * 3600 * 24));
	 
	    return diff; // 날짜 차이 리턴
	}
    // 등록하기 전 입력 여부 검사
    function checkWrite(){
		var name=document.getElementById("name").value;
		var resv_date=document.getElementById("resv_date").value;
		var addr=document.getElementById("addr").value;
		var telnum=document.getElementById("telnum").value;
		var in_name=document.getElementById("in_name").value;
		var comment=document.getElementById("comment").value;
		var phoneRule = /^\d{2,3}-\d{3,4}-\d{4}$/;
		
		// 현재 날짜
 		var now = new Date();
		var year = now.getFullYear();
		var month = now.getMonth()+1;
		var date = now.getDate(); 
		var today = year+"-"+month+"-"+date;
		
		if(name.length == 0) { // 이름 입력 안했을 경우
		 alert("이름을 입력하세요!");
		 $("#name").focus();
		} else if(name.length == 1) { // 이름 길이가 충족되지 않은 경우
			 alert("전체 이름을 입력하세요!");
			 $("#name").focus();
		} else if(addr.length == 0) { // 주소 입력 안했을 경우
			 alert("주소를 입력하세요!");
			 $("#addr").focus();
		} else if(dateDiff(resv_date,today) > 0) { // 이전 날짜를 입력했을 경우
			 alert("이전 날짜는 입력할 수 없습니다!");
			 $("#resv_date").focus();
			 document.getElementById("resv_date").value = "";	
		} else if(dateDiff(resv_date,today) <= -30) { // 예약가능일자를 넘어 입력했을 경우
			 alert("현재부터 한달까지의 예약만 진행할 수 있습니다!");
			 $("#resv_date").focus();
			 document.getElementById("resv_date").value = "";
		} else if(telnum.length == 0) { // 연락처 입력 안했을 경우
			 alert("연락처를 입력하세요!");
			 $("#telnum").focus();
		} else if(!telnum.match(phoneRule)) { // 연락처가 형식에 맞지 않는 경우
			 alert("잘못된 연락처입니다!");
			 $("#telnum").focus();
			 $("#telnum").val("");
		} else if(in_name.length == 0) { // 입금자명 입력 안했을 경우
			 alert("입금자명을 입력하세요!");
			 $("#in_name").focus();
		} else if(in_name.length == 1) { // 입금자명 길이가 충족되지 않은 경우
			 alert("전체 입금자명을 입력하세요!");
			 $("#in_name").focus();
		} else { // 모두 입력 했을 경우
			if(comment.length == 0) { // 전하는말은 선택 사항
				document.getElementById("comment").value = "";	
			} 
			reservation_form.action="make_reservation.jsp"; // make_reservation.jsp로 이동
			reservation_form.submit(); // make_reservation.jsp로 submit   
		}
   	 } 
	</script>
</head>
<body style="text-align:center; ">
	<!-- 헤더 -->
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">예약하기</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	// input type=date에 범위 제한을 두기 위한 설정
	Calendar cal = Calendar.getInstance(); // 현재 날짜 가져오기 위한 Calendar
	sf.format(cal.getTime());
	cal.add(Calendar.DATE,29);
	String max_date = sf.format(cal.getTime()); 
	
	String mode = request.getParameter("mode");
	String resv_date = "";
	int room=0;
	
	if(mode.equals("select")) { // 예약 현황에서 사용자가 날짜와 방을 선택했을 경우
		resv_date = request.getParameter("resv_date");
		room = Integer.parseInt(request.getParameter("room"));	
	} else { // 예약하기를 통해 바로 들어온 경우
		resv_date = "";
		room = 0;
	}
%>
	<!-- 내용 -->
	<form name="reservation_form" method="post"> <!-- submit위해 form 설정 -->
		<table id="table01">
			<tr>
				<td class="firstTd">성명</td>
				<td class="secondTd" >
					<input type="text" id="name" name="name" style="width:680px; height:40px;" 
					onkeyup="checkSpecialCh();" maxlength=10 />
				</td>
			</tr>
			<tr>
				<td class="firstTd">예약일자</td>
				
<%
			if(mode.equals("select")) { // 사용자가 날짜와 방을 선택해 들어왔다면 날짜 받아오기
%>
				<td class="secondTd" >
					<input type="text" id="resv_date" name="resv_date" style="width:680px; height:40px;" value="<%=resv_date.substring(0,10) %>" readonly />
				</td>
<%		
			} else { // 예약하기를 통해 바로 들어왔다면 날짜 선택할 수 있게 하기
%>
				<td class="secondTd" >
					<input type="text" id="resv_date" name="resv_date" style="width:680px; height:40px;" value="<%=today %>" readonly />
				</td>
<%			} 
%>
			</tr>
			<tr>
				<td class="firstTd">예약방</td>
				<td class="secondTd" >
					<select id="room" name="room" style="width:200px; height:40px;">
						<!-- 사용자가 방을 선택해 들어왔다면 해당 방을 selected 아니면 스위트룸이 default로 selected -->
						<option value="1" <%if(room == 0 || room == 1) {out.print("selected");} %>>스위트룸</option>
						<option value="2" <%if(room == 2) {out.print("selected");} %>>일반룸</option>
						<option value="3" <%if(room == 3) {out.print("selected");} %>>특별룸</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="firstTd">주소</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<input type="text" id="addr" name="addr" style="width:680px; height:40px;" maxlength=50 />
				</td>			
			</tr>
			<tr>
				<td class="firstTd">전화번호</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<input type="text" id="telnum" name="telnum" style="width:680px; height:40px;" onblur="checkTel();" />				
				</td>			
			</tr>
			<tr>
				<td class="firstTd">입금자명</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<input type="text" id="in_name" name="in_name" 
					style="width:680px; height:40px;" onkeyup="checkSpecialCh();" maxlength=10 />				
				</td>			
			</tr>
			<tr>
				<td class="firstTd">전하는말</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<textarea id="comment" name="comment" style="width:680px" maxlength=200 ></textarea>
					<!-- <input type="text" id="comment" name="comment" style="width:680px"  />	 -->			
				</td>			
			</tr>
		</table><br>
		
		<div style="text-align:center; margin-left:710px;">
			<input type="button" class="btn" id="writeBtn" value="예약" onclick="checkWrite();"/> <!-- 입력 여부 검사 함수 호출 -->
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
		</div>
	</form>
</body>
</html>

