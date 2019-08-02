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
		.btn {background-color:mediumpurple; margin-top:5px; color:#ffffff;}
		a {text-decoration:none;}
	</style>

	<script>
	$(document).ready(function() { /*홈페이지 로드 시*/
	    $("#change_resv_date").datepicker({
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
    // 수정하기 전 입력 여부 검사
    function checkEdit(resv_date,room){
		var name=document.getElementById("name").value;
		var addr=document.getElementById("addr").value;
		var telnum=document.getElementById("telnum").value;
		var in_name=document.getElementById("in_name").value;
		var comment=document.getElementById("comment").value;
		var processing=document.getElementById("processing").value;
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
		} else if(processing.length == 0) {
			 alert("진행상황을 입력하세요!");
			 $("#processing").focus();		
		} else { // 모두 입력 했을 경우
			if(comment.length == 0) { // 전하는말은 선택 사항
				document.getElementById("comment").value = "";	
			} 
			reservation_form.action="update_reservation.jsp?resv_date="+resv_date+"&room="+room; // update_reservation.jsp로 이동
			reservation_form.submit(); // update_reservation.jsp로 submit   
		}
   	 } 
	// 삭제하기 전 한번 더 물어보기
	function checkDelete(resv_date,room) {
		if(confirm('삭제하시겠습니까?')) {
			reservation_form.action="delete_reservation.jsp?resv_date="+resv_date+"&room="+room; // delete_reservation.jsp로 이동
			reservation_form.submit(); // delete_reservation.jsp로 submit  
		} else {
		}
	} 
	</script>
</head>
<body style="text-align:center; ">
	<!-- 헤더 -->
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">예약확인</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	String loginOK = (String)session.getAttribute("login_ok");
	String loginID = (String)session.getAttribute("login_id");

	if((loginOK != null) && (loginID.equals(loginID))) {
%>
<%
	request.setCharacterEncoding("UTF-8"); // 한글처리

	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	// input type=date에 범위 제한을 두기 위한 설정
	Calendar cal = Calendar.getInstance(); // 현재 날짜 가져오기 위한 Calendar
	sf.format(cal.getTime());
	cal.add(Calendar.DATE,30);
	String max_date = sf.format(cal.getTime()); 

	try{
		// d_01.jsp에서 get으로 값 가져온다
		String resv_date = request.getParameter("resv_date");
		resv_date = resv_date.substring(0,10);
		int room = Integer.parseInt(request.getParameter("room"));
		
		// jdbc 드라이버 및 mysql 연결
		Class.forName("com.mysql.jdbc.Driver"); 
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery("select * from reservation where resv_date='"+resv_date+"' and room="+room+";");
		
		if(rset.next()) {
	%>
		<!-- 내용 -->
		<form name="reservation_form" method="post"> <!-- submit위해 form 설정 -->
			<table id="table01">
				<tr>
					<td class="firstTd">성명</td>
					<td class="secondTd" >
						<input type="text" id="name" name="name" style="width:680px; height:40px;" 
						onkeyup="checkSpecialCh();" maxlength=10 value="<%=rset.getString("name") %>" />
					</td>
				</tr>
				<tr>
					<td class="firstTd">예약일자</td>
					<td class="secondTd" >
						<input type="text" id="change_resv_date" name="change_resv_date" 
						style="width:680px; height:40px;" value="<%=rset.getString("resv_date") %>" readonly />
					</td>
				</tr>
				<tr>
					<td class="firstTd">예약방</td>
					<td class="secondTd" >
						<select id="change_room" name="change_room" style="width:200px; height:40px;" >
							<!-- 사용자가 방을 선택해 들어왔다면 해당 방을 selected 아니면 스위트룸이 default로 selected -->
							<option value="1" <%if(rset.getInt("room") == 1) {out.print("selected");} %>>스위트룸</option>
							<option value="2" <%if(rset.getInt("room") == 2) {out.print("selected");} %>>일반룸</option>
							<option value="3" <%if(rset.getInt("room") == 3) {out.print("selected");} %>>특별룸</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="firstTd">주소</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<input type="text" id="addr" name="addr" style="width:680px; height:40px;" maxlength=50 
						value="<%=rset.getString("addr") %>" />
					</td>			
				</tr>
				<tr>
					<td class="firstTd">전화번호</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<input type="text" id="telnum" name="telnum" style="width:680px; height:40px;" onblur="checkTel();"
						value="<%=rset.getString("telnum") %>"  />				
					</td>			
				</tr>
				<tr>
					<td class="firstTd">입금자명</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<input type="text" id="in_name" name="in_name" 
						style="width:680px; height:40px;" onkeyup="checkSpecialCh();" maxlength=10 
						value="<%=rset.getString("in_name") %>"  />				
					</td>			
				</tr>
				<tr>
					<td class="firstTd">전하는말</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<textarea id="comment" name="comment" style="width:680px" maxlength=200 ><%=rset.getString("comment") %></textarea>
						<!-- <input type="text" id="comment" name="comment" style="width:680px"  />	 -->			
					</td>			
				</tr>
				<tr>
					<td class="firstTd">접수일자</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<input type="text" id="write_date" name="write_date" style="width:680px; height:40px; border:none;" 
						value="<%=rset.getString("write_date") %>" readonly />			
					</td>			
				</tr>
				<tr>
					<td class="firstTd">진행상황</td>
					<td class="secondTd" style="word-break:break-all; wrap:hard;">
						<input type="number" id="processing" name="processing" style="width:680px; height:40px;" 
							value="<%=rset.getInt("processing") %>" />			
					</td>			
				</tr>
			</table><br>
			
			<div style="text-align:center; margin-left:640px;">
				<input type="button" class="btn" value="목록" onclick="location.href='adm_allview.jsp';"/> 
				<input type="button" class="btn" id="writeBtn" value="수정" 
					onclick="checkEdit('<%=rset.getString("resv_date") %>',<%=rset.getInt("room") %>);"/> <!-- 입력 여부 검사 함수 호출 -->
				<input type="button" class="btn" id="deleteBtn" value="삭제" 
					onclick="checkDelete('<%=rset.getString("resv_date") %>',<%=rset.getInt("room") %>);" />
			<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
			</div>
		</form>
	<%
	} else{
		out.print("<script>alert('해당 예약이 존재하지 않습니다!');</script>");
		out.print("<script>location.href='adm_allview.jsp';</script>");		
	}
	} catch(Exception e){
		out.print("<script>alert('접속 실패!');</script>");
		out.print("<script>location.href='adm_allview.jsp';</script>");			
	} 
%>
<%} else {
	out.print("<script>alert('로그인 하세요!');</script>");
	out.print("<script>location.href='index.html';</script>");
} %>
</body>
</html>

