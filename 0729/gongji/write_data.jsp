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

	PreparedStatement ps = null;
	PreparedStatement ps2 = null;
	PreparedStatement ps3 = null;
	PreparedStatement ps4 = null;
	PreparedStatement ps5 = null;
	PreparedStatement ps6 = null;
	
	int id =0; // 글 번호 저장	
	int rsid = 0; // 댓글 ResultSet에서 가져온 id
	int rsrecnt =0; // 댓글 ResultSet에서 가져온 recnt

	ServletContext ctx = request.getServletContext();
	String uploadPath = ctx.getRealPath("0729/upload");
	
	int size = 10 * 1024 * 1024;
	String fileName     = "";
	String origFileName = "";
	String serverName = "";
	
 	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	
	//try{
		// DefaultFileRenamePolicy() 호출해 파일이름이 중복될경우 파일 이름을 rename해준다
		MultipartRequest multi = new MultipartRequest(request,uploadPath,size,"utf-8",new DefaultFileRenamePolicy());  
		
		// gongji_insert.jsp 또는 gongji_reply.jsp에서 값 가져온다
		String key = multi.getParameter("key"); 
		String title = multi.getParameter("title"); 
		String content = multi.getParameter("content"); 

		// 특수문자 변환
	 	String changeTitle = changeEscape(title);
		String changeContent = changeEscape(content);

		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement();
		
		// 받아온 key값이 없을 경우 예외처리
		if(key == null || key == ""){
			out.print("<script>alert('잘못된 접근입니다!');</script>");
			out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
		}
		
		// 1. key = insert일 경우 글을 작성
		if(key.equals("insert")){
			// 파일 업로드 설정
			String fname = multi.getParameter("filename");        
		    Enumeration files = multi.getFileNames(); 
		    String file = (String)files.nextElement();
		    fileName = multi.getFilesystemName(file); // 폴더에 저장되는 파일명
		    origFileName = multi.getOriginalFileName(file); // 실제 파일명
		    serverName = "upload/"+fileName; // 데이터베이스 저장 경로
			
			// 파일은 선택사항이므로 파일은 첨부했을 때와 안했을 때로 나눈다
			if(origFileName == null) {
				// 글 insert
				stmt.execute("insert into gongji(title,date,content) "+
						 "values('"+changeTitle+"','"+today+"','"+changeContent+"');");
			} else {
				// 글 insert
				stmt.execute("insert into gongji(title,date,content,file_path) "+
							 "values('"+changeTitle+"','"+today+"','"+changeContent+"','"+serverName+"');");			
			}
			out.print("<script>alert('글 등록 완료!');</script>");
			out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
		}

		// 3. key = id값일 경우 수정
		else{
			id = Integer.parseInt(key);
			
			//받아온 글번호의 모든 정보를 받아온다
			ps = conn.prepareStatement("select * from gongji where id = ?");
			ps.setInt(1,id);
			ResultSet rset = ps.executeQuery();
					
			if(!rset.next())
			{
				out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
				out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
			}	
			
			stmt.execute("update gongji set title='"+changeTitle+"',date='"+today+"',content='"+changeContent+"' where id="+id+";");
			out.print("<script>alert('수정 완료!');</script>");
			out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
			rset.close();
		}
		conn.close();
		stmt.close();
	//} catch(Exception e) {
		//out.print("<script>alert('접속 실패!');</script>");
		//out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
	//}
    
%>
</body>
</html>