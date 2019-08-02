<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<%@ page import="com.oreilly.servlet.MultipartRequest" %> 
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> 
<%@ page import="java.util.*, org.json.simple.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
<%!
	// 특수문자 변환
	public String changeEscape(String s){
		String str = s;
		str = str.replace("'","&#39;");
		//str = str.replace(" ","&nbsp;");
		
		//str = str.replace("&","&amp;");
		
		
		
		
		//str = str.replace("<","&lt;");
		//str = str.replace(">","&gt;");
		//str = str.replace("\"","&quot;");
		//str = str.replace("'","&#39;");
		//str = str.replaceAll(" ","&nbsp;");
		
		
		
		
		
/*  		str = str.replaceAll("<br>", "\r\n");
        str = str.replaceAll("<br>", "\r");
        str = str.replaceAll("<br>", "\n");  */
		return str;
	}
%>
</head>
<body>
<%
	/* file:///C:/Lecture/java-workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/webClass_07/0724/upload/ */
	ServletContext ctx = request.getServletContext();
	String uploadPath = ctx.getRealPath("0726/summernote_image_upload");
	
	int size = 10 * 1024 * 1024; // 업로드 사이즈 제한 10M 이
	String fileName     = "";
	String origFileName = "";
	String serverName = "";
	
 	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	try{
	    MultipartRequest multi = new MultipartRequest(request,uploadPath,size,"UTF-8",new DefaultFileRenamePolicy()); 
		
		// 파일 업로드 설정
	    Enumeration files = multi.getFileNames(); 
	    String file = (String)files.nextElement();
	    fileName = multi.getFilesystemName(file); // 폴더에 저장되는 파일명
	    origFileName = multi.getOriginalFileName(file); // 실제 파일명
	    serverName = "upload/"+fileName; // 데이터베이스 저장 경로
	    
	    JSONObject json = new JSONObject();
	    json.put("url",serverName);
	    response.setContentType("application/json");
	    out.print(json.toJSONString());
%>
<%		
		out.print("<script>location.href='gongji_list.jsp?from=1&cnt=10';</script>");
	    
	}catch(Exception e){
		out.print("<script>alert('업로드 실패!!');</script>");
		out.print("<script>history.go(-1);</script>");
	}
%>
</body>
</html>