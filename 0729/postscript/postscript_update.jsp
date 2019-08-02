<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>글 수정</title>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	
	<!-- include libraries(jQuery, bootstrap) -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"
	integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
	crossorigin="anonymous"></script>
	<script src="jquery-ui-1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="jquery-ui-1.12.1/jquery-ui2.css"/>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 

	<!-- include summernote css/js -->
	<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.css" rel="stylesheet">
	<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.js"></script>	
	
	<!-- 스타일 지정 -->
	<style>
		#table01 {margin:auto; margin-top:50px; border:2px solid lavender; width:700px; text-align:center;}
		.firstTd {width:100px; background-color:lavender; padding:5px 5px 5px 5px; text-align:left; font-size:16px;}
		.secondTd {width:600px; border:2px solid lavender; text-align:left; padding:5px 5px 5px 5px;}
		.titleTd {text-align:center; font-weight:bold; background-color:lavender; padding:10px 10px 10px 10px;}
		.btn {background-color:mediumpurple; margin-top:5px; color:#ffffff;}
		a {text-decoration:none;}
	</style>
	<script>
		$(document).ready(function() { // 페이지 로드 시
			// 써머노트 웹에디터 설정
			$('#summernote').summernote({ 
				lang:'ko-KR',
			    placeholder: '내용을 입력하세요.',
			    tabsize: 2,
			    height: 400,
			    onImageUpload:function(files,editor,$editable) {
			    	sendFile(files[0],editor,$editable);
			    }
			    
			  }); 
			// 이미지 업로드 함수
			function sendFile(file,editor,welEditable) { 
				data = new FormData();
				data.append("file",file);
				$.ajax({
					data:data,
					type:'POST',
					url:'./upload/',
					//url:'http://192.168.23.37:8080/webClass_07/0723/upload.php',
					cache:false,
					contentType:false,
					processData:false,
					success:function(data){
						editor.insertImage(welEditable,data.url);
					}
				});
			}
		});
 		// 수정하기 전 입력 여부 검사
		function checkEdit(id){
			var title=document.getElementById("title").value;
			var content=document.getElementById("summernote").value;
			
			if(title.length == 0) { // 제목 입력 안했을 경우
				alert("제목을 입력하세요!");
			} else if(content.length == 0) { // 내용 입력 안했을 경우
				alert("내용을 입력하세요!");
			} else { // 모두 입력 했을 경우
				edit_form.action="write_data.jsp?key="+id; // write_data.jsp로 이동
				edit_form.submit();	// write_data.jsp로 submit
			}
		}
		// 삭제하기 전 한번 더 물어보기
		function checkDelete(id) {
			if(confirm('삭제하시겠습니까?')) {
				location.href="delete_data.jsp?id="+id;
			} else {
			}
		} 
		// 취소하기 전 한번 더 물어보기
		function checkCancel() {
			if(confirm('수정 내용이 저장되지 않습니다. 나가시겠습니까?')) {
				location.href='../e_02.jsp?from=1&cnt=10';
			} else {
			}
		}
	</script>
	<%!
		// 특수문자 변환
		public String changeEscape(String s){
			String str = s;
			str = str.replace("&","&amp;");
			str = str.replace("<","&lt;");
			str = str.replace(">","&gt;");
			str = str.replace("&amp;#39;","'");
			str = str.replace("\"","&quot;");
  			str = str.replaceAll("<br>", "\r\n");
            str = str.replaceAll("<br>", "\r");
            str = str.replaceAll("<br>", "\n");  
			return str;
		}
	%>
</head>
<body style="text-align:center;">
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">글 수정</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	request.setCharacterEncoding("UTF-8"); // 한글 처리
	
	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
	
	try{
		// postscript_view.jsp에서 get으로 id값 받아온다
		String id = request.getParameter("id");
		int selectId = Integer.parseInt(id);

		// id값이 없을 경우 예외처리
		if(id == null || id == ""){
			out.print("<script>alert('글번호를 받아올 수 없습니다!');</script>");
			out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");	
		}
		
		// 데이터베이스 연결
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/resortdb?useSSL=false","root","cbfjqj2");
	
		// 링크 클릭 시 해당글의 조회수를 1 증가
		PreparedStatement pset = conn.prepareStatement("update postscript set count = count+1 where id = ?");
		pset.setInt(1,selectId);
		pset.executeUpdate();
		
		// 링크 클릭 시 해당글의 id에 해당하는 모든 정보를 가져온다
		PreparedStatement pset2 = conn.prepareStatement("select * from postscript where id = ?");
		pset2.setInt(1,selectId);
		ResultSet rset = pset2.executeQuery();
		
		//해당 번호의 글이 존재하지 않을 경우 예외처리부분
		if(!rset.next())
		{
			out.print("<script>alert('해당 번호의 글이 존재하지 않습니다!');</script>");
			out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");
		}
		//해당 번호의 글이 존재할 경우
		else{
			String title=changeEscape(rset.getString(2));
			String content=changeEscape(rset.getString(4));
	
%>
	<!-- 내용 -->
	<form id="edit_form" name="edit_form" method="POST" enctype="multipart/form-data">
	<table id="table01">
		<tr>
			<td colspan=4 class="titleTd"><span>수정</span></td>
		</tr>
		<tr>
			<td class="firstTd">번호</td>
			<td class="secondTd" colspan=3><span style="font-size:14px;"><%=rset.getInt(1) %></span></td>
		</tr>
		<tr>
			<td class="firstTd">제목</td>
			<td class="secondTd" colspan=3>
				<input type="text" id="title" name="title" style="width:600px; overflow:scroll;" 
					value="<%=title %>" maxlength=50 placeholder="최대 50자" />
			</td>
		</tr>
		<tr>
			<td class="firstTd">일자</td>
			<td class="secondTd" colspan=3>
				<input type="text" id="date" name="date" style="width:600px; border:none;" value="<%=today %>" readonly />
			</td>
		</tr>
		<tr>
			<td class="firstTd">내용</td>
			<td class="secondTd" style="word-break:break-all; wrap:hard;" colspan=3>
				<textarea id="summernote" name="content" style="width:600px; height:200px; resize:vertical;"><%=content %></textarea>
			</td>
		</tr>
		<%
			if(rset.getString(9) != null) { // 파일이 존재한다면 
				%>
				<tr>
					<td class="firstTd">파일</td>
					<td class="secondTd" colspan=3><i class="fa fa-paperclip"></i><%=rset.getString(9).substring(8) %></td>
				</tr>
				<%
			}
		%>	
		<tr>
			<td class="firstTd">원글</td>
			<td class="secondTd" colspan=3>
			<input type="text" id="rootid" name="rootid" style="width:600px; border:none;" 
				value="<%=rset.getInt("rootid") %>" readonly />
			</td>
		</tr>
		<tr>
			<td class="firstTd">댓글수준</td>
			<td style="width:250px; text-align:left; padding:5px 5px 5px 5px;" >
				<input type="text" id="level" name="level" style="width:50px; border:none;" value="<%=rset.getInt("relevel") %>" readonly />
			</td>
			<td class="firstTd"><span style="font-size:16px;">댓글순서</span></td>
			<td style="width:250px; text-align:left; padding:5px 5px 5px 5px;">
				<input type="text" id="order" name="order" style="width:50px; border:none;" value="<%=rset.getInt("recnt") %>" readonly />
			</td>
		</tr>	
	</table>
	
		<!-- 버튼 -->
		<div style="text-align:center; margin-left:530px;">
			<input type="button" class="btn" id="cancelBtn" value="취소" onclick="checkCancel();" /> <!-- 취소 재확인 함수 호출 -->
			<input type="button" class="btn" id="writeBtn" value="쓰기" onclick="checkEdit(<%=id %>);" /> <!-- 입력 여부 검사 함수 호출 -->
			<input type="button" class="btn" id="deleteBtn" value="삭제" onclick="checkDelete(<%=id %>);" /> <!-- 삭제 재확인 함수 호출 -->
		<br><br><br><br><br><br><br>
		<br><br><br><br><br><br><br>
		<br><br><br><br>
		</div>
	</form>		
<% 
	}
	}catch(Exception e)
	{
		out.print("<script>alert('접속 실패!!');</script>");
		out.print("<script>location.href='../e_02.jsp?from=1&cnt=10';</script>");
	}
  
%>

</body>
</html>
