<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,
java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>전체 예약 현황</title>
	
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
		#table01 {margin:auto; margin-top:50px; border:2px solid lavender; width:800px; text-align:center;}
		td {width:200px; border:2px solid lavender; padding:7px 7px 7px 7px;}
		a {text-decoration:none;}
	</style>
</head>
<body style="text-align:center;">
<script>parent.gourltop('top.jsp');</script>
<%
	String jump = request.getParameter("jump");
	String loginOK = (String)session.getAttribute("login_ok");
	String loginID = (String)session.getAttribute("login_id");

	if((loginOK != null) && (loginID.equals(loginID))) {
%>
	<!-- 헤더 -->
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">전체 예약 현황</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	Calendar cal = Calendar.getInstance(); // 현재 날짜 가져오기 위한 Calendar 
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd (E)"); // 날짜 포맷 설정 
	String[][] resv_arr = new String[4][30];
	
	String resv_date = "";
	int room = 0;
	if(request.getParameter("resv_date")!=null && request.getParameter("room")!=null) {
		resv_date = request.getParameter("resv_date");
		room = Integer.parseInt(request.getParameter("room"));
	}

	// jdbc 드라이버 및 mysql 연결
	Class.forName("com.mysql.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
	Statement stmt = conn.createStatement(); 
	ResultSet rset = stmt.executeQuery("select * from reservation;");
	
	// 배열 초기화
	for(int i=0; i<30; i++) {
		resv_arr[0][i] = sf.format(cal.getTime());
		resv_arr[1][i] = "예약가능";
		resv_arr[2][i] = "예약가능";
		resv_arr[3][i] = "예약가능";	
		cal.add(Calendar.DATE,1); // 날짜 +1
	}
	
	cal = Calendar.getInstance(); // 현재 날짜로 재설정
	sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 비교 위해 포맷 재설정
	sf.format(cal.getTime());
	
	// 한 행씩 읽어들이면서
	while(rset.next()) {
		for(int i=0; i<30; i++) { // 한달 치 예약 리스트 배열 탐색
			// 현재 배열의 날짜와 데이터베이스의 날짜가 동일하다면 예약가능 대신 이름으로 변경
			if(sf.format(cal.getTime()).equals(rset.getString("resv_date"))) {
				resv_arr[rset.getInt("room")][i] = rset.getString("name");
				cal = Calendar.getInstance(); // 다음 탐색 위해 현재 날짜로 재설정
				break;
			} 
			cal.add(Calendar.DATE,1); // 날짜 +1
		}
	}
%>
		<!-- 내용 -->
		<table id="table01">
			<tr style="background-color:lavender;">
				<td style="font-weight:bold;">날짜</td>
				<td style="font-weight:bold;">스위트룸</td>
				<td style="font-weight:bold;">일반룸</td>
				<td style="font-weight:bold;">특별룸</td>
			</tr>
	<%
		// 배열 크기만큼 돌리면서
		for(int i=0; i<30; i++) {
	%>
			<tr>
<%
	if(resv_arr[0][i].charAt(12) == '토') { // 토요일인 경우 slateblue색으로 표시
%>
		<td><span style="color:slateblue;"><%=resv_arr[0][i] %></span></td>
<%
	} else if(resv_arr[0][i].charAt(12) == '일'){ // 일요일인 경우 tomato색으로 표시
%> 
		<td><span style="color:tomato;"><%=resv_arr[0][i] %></span></td>
<%
	} else {
%>
		<td><span><%=resv_arr[0][i] %></span></td>
	<% 
	}
		if(resv_arr[1][i].equals("예약가능")) { // 예약자가 없을 경우
	%>
				<td><a href="d_02.jsp?mode=select&resv_date=<%=resv_arr[0][i] %>&room=1"><%=resv_arr[1][i] %></a></td>
	<%
		} else { // 예약자가 있을 경우
	%>
				<td style="
				<%if((resv_date.equals(resv_arr[0][i].substring(0,10))) && (room == 1)){
						out.print("background-color:gold;");
				} else {
					out.print("background-color:#ececec;");
				}%>">
					<a href="show_reservation.jsp?resv_date=<%=resv_arr[0][i] %>&room=1" style="color:gray;"><%=resv_arr[1][i] %></a>
				</td>
	<%
		} 
	%>
	<%
		if(resv_arr[2][i].equals("예약가능")) { // 예약자가 없을 경우
	%>
				<td><a href="d_02.jsp?mode=select&resv_date=<%=resv_arr[0][i] %>&room=2"><%=resv_arr[2][i] %></a></td>
	<%
		} else { // 예약자가 있을 경우
	%>
				<td style="
				<%if((resv_date.equals(resv_arr[0][i].substring(0,10))) && (room == 2)){
						out.print("background-color:gold;");
				} else {
					out.print("background-color:#ececec;");
				}%>">
					<a href="show_reservation.jsp?resv_date=<%=resv_arr[0][i] %>&room=2" style="color:gray;"><%=resv_arr[2][i] %></a>
				</td>
	<%
		} 
	%>
	<%
		if(resv_arr[3][i].equals("예약가능")) { // 예약자가 없을 경우
	%>
				<td><a href="d_02.jsp?mode=select&resv_date=<%=resv_arr[0][i] %>&room=3"><%=resv_arr[3][i] %></a></td>
	<%
		} else { // 예약자가 있을 경우
	%>
				<td style="
				<%if((resv_date.equals(resv_arr[0][i].substring(0,10))) && (room == 3)){
						out.print("background-color:gold;");
				} else {
					out.print("background-color:#ececec;");
				}%>">
					<a href="show_reservation.jsp?resv_date=<%=resv_arr[0][i] %>&room=3" style="color:gray;"><%=resv_arr[3][i] %></a>
				</td>
	<%
		} 
	%>
			</tr>
	<%
			cal.add(Calendar.DATE,1); // 날짜+1
		} 
	%>
<%
	} else {
		//out.print("<script>alert('관리자로 로그인 하세요!');</script>");
		String jumpURL = "adm_login.jsp?jump=adm_allview.jsp";
		response.sendRedirect(jumpURL);	
	}
%>
		</table><br><br><br><br><br><br><br><br><br><br><br>
</body>
</html>