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
		stmt.execute("create table if not exists adminfo ( "+
					 "id varchar(20) primary key not null, pass varchar(20)) DEFAULT CHARSET=utf8");
		try{
			stmt.execute("insert into adminfo(id,pass) values('admin','1123')");
			out.print("<script>alert('관리자 데이터 저장 완료!');</script>");
			out.print("<Script>location.href='adm_login.jsp';</script>");
		} catch(SQLException e) {
			out.print("<script>alert('관리자 데이터 저장 오류!');</script>");
			out.print("<Script>location.href='index.html';</script>");			
		}
	} catch(SQLException e) {
		out.print("<script>alert('테이블 생성 오류!');</script>");
		out.print("<Script>location.href='index.html';</script>");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 데이터 생성</title>
</head>
<body>
</body>
</html>