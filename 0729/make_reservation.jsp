<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<%@ page import="com.oreilly.servlet.MultipartRequest" %> 
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> 
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
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
	request.setCharacterEncoding("UTF-8"); // 한글 처리

 	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	try{
		// d_02.jsp에서 값 가져온다
		String mode = request.getParameter("mode");
		
  		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement();

		String name = request.getParameter("name");
		String resv_date = request.getParameter("resv_date");
		resv_date = resv_date.substring(0,10); // 요일 제외 입력
		int room = Integer.parseInt(request.getParameter("room"));
		String addr = request.getParameter("addr");
		addr = changeEscape(addr); // 특수문자 변환
		String telnum = request.getParameter("telnum");
		String in_name = request.getParameter("in_name");
		String comment = request.getParameter("comment");
		comment = changeEscape(comment); // 특수문자 변환
		
		ResultSet rset = stmt.executeQuery("select * from reservation where resv_date='"+resv_date+"' and room="+room+";");
		if(rset.next()) {
			rset.close();
			out.print("<script>alert('이미 예약된 방입니다!');</script>");
			out.print("<script>location.href='d_01.jsp';</script>");
		} else {
			out.print(resv_date+room);
			stmt.execute("insert into reservation(name,resv_date,room,addr,telnum,in_name,comment,write_date,processing) "+
					 "values('"+name+"','"+resv_date+"',"+room+",'"+addr+"','"+telnum+"','"+in_name+"','"+comment+"','"+
					 today+"',"+1+");");
			out.print("<script>alert('예약 완료!');</script>");
			//out.print("<script>location.href='d_01.jsp';</script>");
%>
			<script>
				location.href="d_01.jsp?resv_date=<%=resv_date %>&room=<%=room %>";
			</script>
<%
		}
		
		rset.close();
		conn.close();
		stmt.close();  

	} catch(Exception e) {
		out.print("<script>alert('접속 실패!');</script>");
		out.print("<script>location.href='d_01.jsp';</script>");
	}
    
%>
</body>
</html>