<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>예약하기</title>
	
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
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
		.btn {background-color:lavender; margin-top:5px}
		a {text-decoration:none;}
	</style>
	
	<script>
	$(document).ready(function() { /*홈페이지 로드 시*/
	    $("#resv_date1").datepicker({
	    	dateFormat:"yy-mm-dd",
	    	prevText:"이전 달",
	    	nextText:"다음 달",
	    	changeYear:true,
	    	changeMonth:true,
	    	yearRange:"-100:+0",
	    	dayNamesMin:['일','월','화','수','목','금','토'],
	    	monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	    }); /*datepicker 설정*/
	    $("#resv_date2").datepicker({
	    	dateFormat:"yy-mm-dd",
	    	prevText:"이전 달",
	    	nextText:"다음 달",
	    	changeYear:true,
	    	changeMonth:true,
	    	yearRange:"-100:+0",
	    	dayNamesMin:['일','월','화','수','목','금','토'],
	    	monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	    }); /*datepicker 설정*/
	});
	// 특수문자 검사
	function checkSpecialCh() {
		var name = document.getElementById("name");
		var in_name = document.getElementById("in_name");
		var pattern = /[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]/gi;

		name.value=name.value.replace(pattern,'');
		in_name.value=in_name.value.replace(pattern,'');
	}
	// 연락처 형식 검사
	function checkTel() {
		var telnum = document.getElementById("telnum").value;
		var phoneRule1 = /^\d{3}-\d{3,4}-\d{4}$/; /*xxx-xxxx-xxxx*/
		var phoneRule2 = /^\d{3}\d{3,4}\d{4}$/; /*xxxxxxxxxxx*/
		
		// 정규식에 맞지 않는 연락처일 경우
		if(telnum.length != 0 && !telnum.match(phoneRule1)&&!telnum.match(phoneRule2)) {
			alert("올바른 연락처를 입력해주세요!");
			document.getElementById("telnum").value = "";
			$("#telnum").focus();
		}
	}
    // 등록하기 전 입력 여부 검사
    function checkWrite(){
		var name=document.getElementById("name").value; 
		var addr=document.getElementById("addr").value;
		var telnum=document.getElementById("telnum").value;
		var in_name=document.getElementById("in_name").value;
		var comment=document.getElementById("comment").value;
		
		if(name.length == 0) { // 이름 입력 안했을 경우
		 alert("이름을 입력하세요!");
		 $("#name").focus();
		} else if(addr.length == 0) { // 주소 입력 안했을 경우
			 alert("주소를 입력하세요!");
			 $("#addr").focus();
		} else if(telnum.length == 0) { // 연락처 입력 안했을 경우
			 alert("연락처를 입력하세요!");
			 $("#telnum").focus();
		} else if(in_name.length == 0) { // 입금자명 입력 안했을 경우
			 alert("입금자명을 입력하세요!");
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
<body style="text-align:center; background-color:#efefef;">
	<hr style="width:800px;">
	<h3>Reservation Form</h3>
	<hr style="width:800px;">
<%
	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	// input type=date에 범위 제한을 두기 위한 설정
	Calendar cal = Calendar.getInstance(); // 현재 날짜 가져오기 위한 Calendar
	sf.format(cal.getTime());
	cal.add(Calendar.DATE,1);
	String next_date = sf.format(cal.getTime()); 
	
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
	<div style="display:inline-block; width:810px;">
			<input type="text" id="resv_date1" name="resv_date" value="<%=today %>" style="width:400px; height:40px;"/>
			<input type="text" id="resv_date2" name="resv_date" value="<%=next_date %>"  style="width:400px; height:40px;"/><br>
			<span style="float:left; margin-top:30px;">
				<i class="far fa-user"></i><span style="font-size:18px;">예약자명</span>
				<input type="text" id="name" name="name" style="width:400px; height:40px;"/>
			</span>
	</div>
	</form>
</body>
</html>

