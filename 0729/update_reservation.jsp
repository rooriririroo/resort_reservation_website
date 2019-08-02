<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>예약 수정</title>
</head>
<%!
	// 특수문자 변환
	public String changeEscape(String s){
		String str = s;
		str = str.replace("'","&#39;");
		return str;
	}
%>
<body>
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
	
	try{
		// show_reservation.jsp에서 post로 값 가져온다

/* 		String name = new String(request.getParameter("name").getBytes("8859_1"),"utf-8");
		String resv_date = new String(request.getParameter("resv_date").getBytes("8859_1"),"utf-8");
		int room = Integer.parseInt(request.getParameter("room"));
		String addr = new String(request.getParameter("addr").getBytes("8859_1"),"utf-8");
		addr = changeEscape(addr); // 특수문자 변환
		String telnum = new String(request.getParameter("telnum").getBytes("8859_1"),"utf-8");
		String in_name = new String(request.getParameter("in_name").getBytes("8859_1"),"utf-8");
		String comment = new String(request.getParameter("comment").getBytes("8859_1"),"utf-8");
		comment = changeEscape(comment); // 특수문자 변환
		String write_date = new String(request.getParameter("write_date").getBytes("8859_1"),"utf-8");
		int processing = Integer.parseInt(request.getParameter("processing")); */
		
		String resv_date = request.getParameter("resv_date");
		int room = Integer.parseInt(request.getParameter("room"));
		
		// show_reservation.jsp에서 form으로 값 가져온다
		String name = request.getParameter("name");
		String change_resv_date = request.getParameter("change_resv_date");
		int change_room = Integer.parseInt(request.getParameter("change_room"));
		String addr = request.getParameter("addr");
		addr = changeEscape(addr); // 특수문자 변환
		String telnum = request.getParameter("telnum");
		String in_name = request.getParameter("in_name");
		String comment = request.getParameter("comment");
		comment = changeEscape(comment); // 특수문자 변환
		String write_date = request.getParameter("write_date");
		int processing = Integer.parseInt(request.getParameter("processing"));

 		// jdbc 드라이버 및 mysql 연결
		Class.forName("com.mysql.jdbc.Driver"); 
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement();
		
 		stmt.execute("update reservation set name='"+name+"', resv_date='"+change_resv_date+"', room="+change_room+
				 ", addr='"+addr+"', telnum='"+telnum+"', in_name='"+in_name+"', comment='"+comment+
				 "', write_date='"+write_date+"', processing="+processing+" where resv_date='"+resv_date+"' and room="+room+";"); 	
		out.print("<script>alert('예약 수정 완료!');</script>");
		//out.print("<script>location.href='adm_allview.jsp';</script>");	
%>
		<script>
			location.href="adm_allview.jsp?resv_date=<%=change_resv_date %>&room=<%=change_room %>";
		</script>
<%
		conn.close();
		stmt.close();
		
	} catch(Exception e) {
		out.print("<script>alert('이미 예약이 존재합니다!');</script>");
		out.print("<script>location.href='adm_allview.jsp';</script>");
	}
%>
<%} else {
	out.print("<script>alert('로그인 하세요!');</script>");
	out.print("<script>location.href='adm_login.jsp';</script>");
} %>
</body>
</html>

