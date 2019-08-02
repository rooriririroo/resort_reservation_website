<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
    request.setCharacterEncoding("UTF-8"); // 한글 처리

    // gongji_insert.jsp 또는 gongji_reply.jsp에서 filename값 가져온다
    String filename = request.getParameter("filename");
    filename = filename.substring(7);
    
    // 파일 업로드된 경로 설정
    String savePath = request.getSession().getServletContext().getRealPath("/")+"0729\\upload2";
    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String client = "";
    
    try{
        // 파일을 읽어 스트림에 담기
        try{ // 해당 파일이 있는 경우
            file = new File(savePath,filename);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){ // 해당 파일이 없는 경우
            skip = true;
        }

        client = request.getHeader("User-Agent");

        // 파일 다운로드 헤더 지정
        response.reset() ;
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");

        if(!skip){
         
         // IE
            if(client.indexOf("MSIE") != -1){
             response.setHeader ("Content-Disposition", "attachment; filename="+new String(filename.getBytes("KSC5601"),"ISO8859_1"));
            }else{
            // IE 이외
             response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            } 
            
            response.setHeader ("Content-Length", ""+file.length() );
           
            out.clear();
            pageContext.pushBody();
           
            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()];
            int leng = 0;
            
            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }

        }else{
         response.setContentType("text/html;charset=UTF-8");
            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
        }
        
        in.close();
        os.close();

    }catch(Exception e){
      e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>