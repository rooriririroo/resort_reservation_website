<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>리스트</title>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	
	<!-- 스타일 지정 -->
	<style>
		#table01 {margin:auto; margin-top:50px; border:2px solid mistyrose; width:700px; text-align:center;}
		#table02 {margin:auto; margin-top:50px; border:2px solid mistyrose; width:700px; text-align:center;}
		.idTd {width:50px; border:2px solid mistyrose; padding:5px 5px 5px 5px;}
		.titleTd {width:450px; border:2px solid mistyrose; padding:5px 5px 5px 5px;}
		.dateTd {width:130px; border:2px solid mistyrose; padding:5px 5px 5px 5px;}
		.btn {background-color:mistyrose; margin-top:15px; width:50px; height:30px; border:0; outline:0; border-radius:5px;}
		.countTd {width:70px; border:2px solid mistyrose; padding:5px 5px 5px 5px;}
		a {text-decoration:none;}
	</style>
	<%!
		// 특수문자 변환
		public String changeEscape(String s){
			String str = s;
			str = str.replace("&","&amp;");
			str = str.replace("<","&lt;");
			str = str.replace(">","&gt;");
			str = str.replace("&amp;quot;","\"");
			str = str.replace("&amp;#39;","'");
			str = str.replaceAll(" ","&nbsp;"); 
			return str;
		}
		
		// 한 글자당 바이트 계산
	    public int byteCheck(String s) {
	        // 바이트 체크 (영문 1, 한글 2, 특문 1)
	        int en = 0;
	        int ko = 0;
	        int etc = 0;
	 
	        char[] txtChar = s.toCharArray();
	        // 한글이면 2씩, 영문 또는 다른 문자이면 1씩 증가
	        for (int j = 0; j < txtChar.length; j++) {
	            if (txtChar[j] >= 'A' && txtChar[j] <= 'z') { // 영문에 대해
	                en++;
	            } else if (txtChar[j] >= '\uAC00' && txtChar[j] <= '\uD7A3') { // 한글에 대해
	                ko++;
	                ko++;
	            } else { // 영문과 한글을 제외한 나머지 문자에 대해
	                etc++;
	            }
	        }
	        int txtByte = en + ko + etc;
			return txtByte;
	    }
	%>
</head>
<body>
	<!-- 헤더 -->
	<table id="table01">
		<tr>
			<td style="background-color:mistyrose; width:233px;"><a href="gongji_list.jsp?from=1&cnt=10">공지사항</a></td>
			<td style="width:233px;">회원가입</td>
			<td style="width:234px;">로그인</td>
		</tr>
	</table>

	<!-- 내용 -->
	<table id="table02">
		<tr style="background-color:mistyrose; font-weight:bold;">
			<td class="idTd" >번호</td>
			<td class="titleTd" >제목</td>
			<td class="countTd" >조회수</td>
			<td class="dateTd" >등록일</td>
		</tr>
<%	
	// 주소창에서 get 방식으로 시작번호, 행 갯수를 가져온다
 	String from = request.getParameter("from");
	String cnt = request.getParameter("cnt");

	int fromPT=Integer.parseInt(from);
	int cntPT=Integer.parseInt(cnt); 
	
	int lineCntTotal=0; // 전체 행 갯수
	int lineCnt=0; // 행 갯수
	
 	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장 
	
	try{
		// jdbc 드라이버 및 mysql 연결
		Class.forName("com.mysql.jdbc.Driver"); 
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/gongjidb3?useSSL=false","root","cbfjqj2");
		Statement stmt = conn.createStatement(); 
		
		// 1. 전체 행 갯수 계산
		ResultSet rset = stmt.executeQuery("select * from gongji;"); // execute : 모든 쿼리 실행 가능
		while(rset.next()) {
			lineCntTotal++;
		}
		
		// 2. 행 출력
		rset = stmt.executeQuery("select * from gongji;"); // execute : 모든 쿼리 실행 가능
		while(rset.next()) {		
			lineCnt++; // 행 번호 카운트
			
			// 행 번호가 시작번호보다 크다면 출력문 건너뛰고 while문 반복
			if(lineCnt < fromPT) 
				continue;
			
			// 행 번호가 시작번호+가져올갯수 보다 크다면 while문 종료
			// 즉, 시작번호부터 가져올 갯수만큼 테이블 출력
			if(lineCnt >= fromPT+cntPT) 
				break;
			
			// 제목
			String title=rset.getString(2);
			
			// 제목 길이 자르기
			if(byteCheck(title) > 40) {
				title = title.substring(0,20)+"..";
			}
			title=changeEscape(title); // 제목에 포함되어 있을지 모르는 html 태그를 없앤다
%>
		<tr>
			<td class="idTd" style="background-color:mistyrose;">
				<a href="gongji_view.jsp?id=<%=rset.getInt(1) %>"><%=rset.getInt(1) %></a>
			</td>
			<td class="titleTd" style="text-align:left; text-overflow:ellipsis; overflow:hidden; white-space:nowrap;">
				<a href="gongji_view.jsp?id=<%=rset.getInt(1) %> "><nobr><%=title %></nobr></a>
<%
	// 파일이 존재한다면 표시
	if(rset.getString(9) != null) {
		%>
		<i class="fa fa-save"></i>
		<%
	}
%>				
			</td>
			<td class="countTd"><%=rset.getInt(5) %></td>
			<td class="dateTd"><%=rset.getString(3) %></td>
		</tr>
<%
		}
		
		// 닫아준다
		conn.close();
		stmt.close();
		rset.close();
	} catch(Exception e){
		out.print("<script>alert('접속 실패!!');</script>");
		out.print("<script>location.href='gongji_list.jsp?from=1&cnt=10';</script>");
	} 
%>
	</table>
	<div style="text-align:center; margin-left:650px;">
		<input type="button" class="btn" value="작성" onclick="location.href='gongji_insert.jsp';"/>
	</div>
	
   <!--  페이지바 출력부 -->
   <div class="page" align="center">
<%
   //1~10까지 표시되는 페이지바에서와 다른 페이지바에서 <<의 기능이 다름
   if ( fromPT < cntPT*10 ) {
%>
         <!--  특수문자 << -->
         <!--  1~10까지 표시되는 페이지바일 때는 1페이지로 이동 -->
         <a href='gongji_list.jsp?from=1&cnt=<%=cntPT%>'> &lt;&lt; </a>
<%
   } else {
%>
         <!--  특수문자 << -->
         <!-- 다른 페이지일 때는 이전 페이지바로 이동 -->
         <a href='gongji_list.jsp?from=<%=(fromPT/(cntPT*10)-1)*(cntPT*10)+1%>&cnt=<%=cntPT%>'> &lt;&lt; </a>
<%
   }

   //페이지바 표시
   //현재 페이지가 있는 페이지바(10단위)로 나타내기 위한 식(1~10/11~21/...)
   for (int i=fromPT/(cntPT*10)*10+1; i<fromPT/(cntPT*10)*10+11; i++) {
      
      //현재 페이지 표시
      if ( fromPT/cntPT+1 == i) {
%>
      <a style="color:tomato"
<% 
	  } else {
%>
      <!-- 페이지 이동 -->
      <a 
<% } %>
      href='gongji_list.jsp?from=<%=(i*cntPT-(cntPT-1))%>&cnt=<%=cntPT%>'><%=(i)%></a>
<%   

//마지막 페이지바는 10개 표시하지 않고 마지막 페이지까지만 출력
if ( lineCntTotal == 0 ) {
   break;
} else if ( lineCntTotal%cntPT == 0 ) {
   if ( i == lineCntTotal/cntPT ) break;
} else {
   if ( i == lineCntTotal/cntPT+1 ) break;
}
}

//마지막 페이지바에서와 다른 페이지바에서 >>의 기능이 다름
if ( fromPT > lineCntTotal-(lineCntTotal%(cntPT*10)+cntPT-1) ) {


   if ( lineCntTotal%cntPT == 0 ) {
%>

      <!--  특수문자 >> -->
      <!--  마지막 페이지바일 때는 마지막 페이지로 이동 -->      
      <a href='gongji_list.jsp?from=<%=(lineCntTotal-lineCntTotal%cntPT-cntPT-1)%>&cnt=<%=cntPT%>'> &gt;&gt; </a>
<% } else {
%>
      <a href='gongji_list.jsp?from=<%=(lineCntTotal-lineCntTotal%cntPT+1)%>&cnt=<%=cntPT%>'> &gt;&gt; </a>
<%
}

} else {
%>
      <!--  특수문자 >> -->
      <!-- 다른 페이지일 때는 다음 페이지바로 이동 -->
      <a href='gongji_list.jsp?from=<%=(fromPT/(cntPT*10)+1)*(cntPT*10)+1%>&cnt=<%=cntPT%>'> &gt;&gt; </a>
<%
}
%>
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
   </div>
</body>
</html>