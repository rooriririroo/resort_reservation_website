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
		
		// gongji_view.jsp 또는 gongji_update.jsp에서 get으로 id값 받아온다
		String id = request.getParameter("id");
		int selectId = Integer.parseInt(id);
		
		// 받아온 key값이 없을 경우 예외처리
		if(id == null || id ==""){
			out.print("<script>alert('글번호를 받아올 수 없습니다!');</script>");
			out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");	
		}
		
		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement(); 
		
		stmt.execute("delete from gongji where id="+id+";");
		
		// 파일명 가져오기
		String server_path = "";
		ResultSet rset = stmt.executeQuery("select file_path from gongji where id='"+id+"';");
		while(rset.next()) {
			server_path = rset.getString(1);
		}
		// 서버 내 파일 지우기
		ServletContext ctx = getServletConfig().getServletContext();
		String file = ctx.getRealPath("0729/") + server_path;
		File fileEx = new File(file);
		if(fileEx.exists()) {
			fileEx.delete();
		}
		out.print("<script>alert('삭제 완료!');</script>");
		out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
	
	} catch(Exception e) {
		out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
		out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
	}
%>
</body>
</html>