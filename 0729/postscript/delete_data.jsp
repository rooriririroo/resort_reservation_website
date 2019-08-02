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

	PreparedStatement ps = null;
	PreparedStatement ps2 = null;
	PreparedStatement ps3 = null;
	PreparedStatement ps4 = null;
			
	int rsid =0; // ResultSet에서 사용할 id
	int rsrecnt = 0; // ResultSet에서 사용할 recnt
	int rsrelevel = 0; // ResultSet에서 사용할 relevel
	int setrecnt = 0; // 삭제할 글의 뒤의 글을 앞당긴다

	
	try{
		
		// gongji_view.jsp 또는 gongji_update.jsp에서 get으로 id값 받아온다
		String id = request.getParameter("id");
		int selectId = Integer.parseInt(id);
		
		// 받아온 key값이 없을 경우 예외처리
		if(id == null || id ==""){
			out.print("<script>alert('글번호를 받아올 수 없습니다!');</script>");
			out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");	
		}
		
		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement(); 
		
		// 받아온 글번호의 모든 정보를 받아온다
		ps = conn.prepareStatement("select * from postscript where id = ?");
		ps.setInt(1,selectId);
		ResultSet rset = ps.executeQuery();
				
		if(!rset.next())
		{
			out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
			out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");
		}	
				
		int rootid = rset.getInt("rootid"); // 댓글의 rootid
		int prerelevel  = rset.getInt("relevel"); // 댓글의 relevel
		int prerecnt = rset.getInt("recnt"); // 댓글의 recnt	
		
		int deletestart = prerecnt; // 삭제할 글의 시작 번호
		int deletecnt = 0; // 초기화
			
		// 같은 원글번호를 가지는 댓글들을 recnt를 기준으로 불러온다
		ps2 = conn.prepareStatement("select * from postscript where rootid = ? order by recnt asc");
		ps2.setInt(1,rootid);
		rset = ps2.executeQuery();
				
 		while(rset.next()){
 			
 			// 삭제할 글의 recnt까지 ResultSet의 커서 이동
 			if(prerecnt >= 0){
 				prerecnt--;
 				continue;
 			}
 			
 			// 입력한 댓글 밑에 대댓글이 있을 경우 대댓글의 수를 카운트
 			if(prerelevel < rset.getInt("relevel")){
 				deletecnt++;
 	 			continue;
 			}
 			else{
				break;
 			}
		}
 		
		// 삭제할 글 부터 삭제할 글에 달려있는 글까지 삭제 
		ps3 = conn.prepareStatement("delete from postscript where rootid = ? and recnt between ? and ?");
		ps3.setInt(1,rootid);
		ps3.setInt(2,deletestart);
		ps3.setInt(3,deletestart+deletecnt);
		ps3.executeUpdate();
		
		//삭제한 글의 수 만큼 뒤의 댓글들의 recnt를 조정
		setrecnt = deletecnt+1;
		ps4 = conn.prepareStatement("update postscript set recnt =  recnt - ? where rootid = ? and recnt > ?");
		ps4.setInt(1,setrecnt);
		ps4.setInt(2,rootid);
		ps4.setInt(3,deletestart + deletecnt);
		ps4.executeUpdate();
		
		// 파일명 가져오기
		String server_path = "";
		rset = stmt.executeQuery("select file_path from postscript where id='"+id+"';");
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
		out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");
	
	} catch(Exception e) {
		out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
		out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");
	}
%>
</body>
</html>