<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "javax.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.lang.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.util.regex.*"  %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8"); // 한글 처리

	try{		
		// show_reservation.jsp에서 post으로 값 받아온다
		String resv_date = request.getParameter("resv_date");
		int room = Integer.parseInt(request.getParameter("room"));
		
		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement(); 
		
		// delete
		stmt.execute("delete from reservation where resv_date='"+resv_date+"' and room="+room+";");
		
		out.print("<script>alert('예약 삭제 완료!');</script>");
		out.print("<script>location.href='adm_allview.jsp';</script>");
	
	} catch(Exception e) {
		out.print("<script>alert('해당 번호의 예약이 존재하지 않습니다!');</script>");
		out.print("<script>location.href='adm_allview.jsp';</script>");
	}
%>
</body>
</html>