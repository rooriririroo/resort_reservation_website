<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>글 하나 보기</title>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	
	<!-- 스타일 지정 -->
	<style>
		#table01 {margin:auto; margin-top:50px; border:2px solid lavender; width:700px; text-align:center;}
		.firstTd {width:100px; background-color:lavender; padding:5px 5px 5px 5px; text-align:left;}
		.secondTd {width:600px; border:2px solid lavender; text-align:left; padding:5px 5px 5px 5px;}
		.titleTd {text-align:center; font-weight:bold; background-color:lavender; padding:5px 5px 5px 5px;}
		.btn {background-color:mediumpurple; margin-top:5px; width:50px; height:30px; border:0; outline:0; border-radius:5px; color:#ffffff;}
		a {text-decoration:none;}
	</style>
	<%!
		// 특수문자 변환
		public String changeEscape(String s){
			String str = s;
			str = str.replace("&","&amp;");
			str = str.replace("<","&lt;");
			str = str.replace(">","&gt;");
			//str = str.replace("&amp;quot;","\"");
			str = str.replace("&amp;#39;","'");
			str = str.replace("\"","&quot;");
			str = str.replaceAll(" ","&nbsp;");
  			str = str.replaceAll("<br>", "\r\n");
            str = str.replaceAll("<br>", "\r");
            str = str.replaceAll("<br>", "\n"); 
			return str;
		}
	%>
	<script>
	// 삭제하기 전 한번 더 물어보기
	function checkDelete(id) {
		if(confirm('삭제하시겠습니까?')) {
			location.href="delete_data.jsp?id="+id;
		} else {
		}
	} 
	</script>
</head>
<body style="text-align:center;">
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">글 보기</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	request.setCharacterEncoding("UTF-8"); // 한글처리
	
	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장 

	try{
		// gongji_list.jsp에서 get으로 id값 받아온다
		String id = request.getParameter("id");
		int selectId = Integer.parseInt(id);

		// id값이 없을 경우 예외처리
		if(id == null || id == ""){
			out.print("<script>alert('글번호를 받아올 수 없습니다!');</script>");
			out.print("<script>location.href='gongji_list.jsp?from=1&cnt=10';</script>");
		}
	
		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
	
		// 링크 클릭 시 해당글의 조회수를 1 증가
		PreparedStatement psmt = conn.prepareStatement("update gongji set count = count+1 where id = ?");
		psmt.setInt(1,selectId);
		psmt.executeUpdate();
		
		// 링크 클릭 시 해당 id의 모든 정보 가져온다
		PreparedStatement psmt2 = conn.prepareStatement("select * from gongji where id = ?");
		psmt2.setInt(1,selectId);
		ResultSet rset = psmt2.executeQuery();
		
		// 해당 번호의 글이 존재하지 않을 경우 예외처리
		if(!rset.next())
		{
			out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
			out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
		}
		// 해당 번호의 글이 존재할 경우
		else{
			String title=changeEscape(rset.getString("title"));
			String content=changeEscape(rset.getString("content"));
	
%>
	<!-- 내용 -->
	<form id="view_form" name="vuew_form" method="POST">
	<table id="table01">
		<tr>
			<td colspan=4 class="titleTd"><span>확인</span></td>
		</tr>
		<tr>
			<td class="firstTd">번호</td>
			<td class="secondTd" colspan=3><span style="font-size:14px;"><%=rset.getInt("id") %></span></td>
		</tr>
		<tr>
			<td class="firstTd">제목</td>
			<td class="secondTd" colspan=3 >
				<input type="text" id="title" name="title" style="width:500px; overflow:scroll; border:none;" value="<%=title %>" readonly />
			</td>
		</tr>
		<tr>
			<td class="firstTd">일자</td>
			<td class="secondTd" colspan=3><%=rset.getString("date") %></td>
		</tr>
		<tr>
			<td class="firstTd">조회수</td>
			<td class="secondTd" colspan=3><%=rset.getInt("count") %></td>
		</tr>
		<tr>
			<td class="firstTd">내용</td>
			<td class="secondTd" style="word-break:break-all; wrap:hard;" colspan=3><%=rset.getString("content") %></td>
		</tr>
<%
	// 파일이 있을 경우 표시
	if(rset.getString("file_path") != null) {
		%>
		<tr>
			<td class="firstTd">파일</td>
			<td class="secondTd" colspan=3>
				<a href="file_download.jsp?filename=<%=rset.getString("file_path") %>" >
					<i class="fa fa-paperclip"></i><%=rset.getString("file_path").substring(7) %>
				</a>
			</td>
		</tr>
		<%
	}
%>	
	</table>

<%
	String loginOK=(String)session.getAttribute("login_ok");
	String loginID=(String)session.getAttribute("login_id");
	if((loginOK != null) && loginID.equals("admin")) {
%>
	<!-- 버튼 -->
	<div style="text-align:center; margin-left:490px;">
		<input type="button" class="btn" value="목록" onclick="location.href='../e_01.jsp?from=1&cnt=10';"/> <!-- 목록으로 이동 -->
		<input type="button" class="btn" id="editBtn" value="수정" 
				onclick="location.href='gongji_update.jsp?id=<%=id %>';"/>
		<input type="button" class="btn" id="deleteBtn" value="삭제" onclick="checkDelete(<%=id %>);" />
		<input type="button" class="btn" id="replyBtn" value="댓글" 
				onclick="location.href='gongji_reply.jsp?id=<%=id %>';"/>
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	</div>
<%	} else {
	
%>
	<!-- 버튼 -->
	<div style="text-align:center; margin-left:650px;">
		<input type="button" class="btn" value="목록" onclick="location.href='../e_01.jsp?from=1&cnt=10';"/> <!-- 목록으로 이동 -->
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	</div>
<%	
}
%>
	</form>		
		
<% 
	}
	}catch(Exception e)
	{
		out.print("<script>alert('접속 실패!!');</script>");
		out.print("<script>location.href='../e_01.jsp?from=1&cnt=10';</script>");
	}
  
%>
</body>
</html>