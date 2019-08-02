<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,
java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<%
	try{
		// jdbc 드라이버 및 mysql 연결
		Class.forName("com.mysql.jdbc.Driver"); 
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement(); 
		
		String jump = request.getParameter("jump");
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");

		// 데이터베이스에서 로그인 정보와 일치하는 데이터가 있는지 확인한다
		ResultSet rset = stmt.executeQuery("select * from adminfo where id='"+id+"' and pass='"+pass+"';");
		if(rset.next()) {
				session.setAttribute("login_ok","yes");
				session.setAttribute("login_id",id);
				response.sendRedirect(jump);				
	
		} else {
			out.print("<script>alert('일치하는 정보가 없습니다!');</script>");
			out.print("<script>location.href='adm_login.jsp';</script>");			
		}

	} catch(SQLException e) {
		out.print("<script>alert('접속 오류!');</script>");
		out.print("<script>location.href='adm_login.jsp';</script>");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 로그인 체크</title>
</head>
<body>
</body>
</html>