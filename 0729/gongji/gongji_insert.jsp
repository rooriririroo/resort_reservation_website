<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>새 글 추가</title>
	
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
		.firstTd {width:80px; background-color:lavender; padding:5px 5px 5px 5px; font-size:16px; text-align:left;}
		.secondTd {width:620px; border:2px solid lavender; text-align:left; padding:5px 5px 5px 5px;}
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
				url:'./summernote_image_upload.jsp', // jsp파일에서 이미지 업로드 처리
				//url:'http://192.168.23.37:8080/webClass_07/0723/upload.php',
				cache:false,
				contentType:false,
				processData:false,
				success:function(data){
					editor.insertImage(welEditable,data.url); //url
				}
			});
		}
		
		// 파일 선택 적용
		$("#upload").change(function(){ 
			var fileType = $("#upload").val();
			fileType = fileType.substr(fileType.length-3,3); // 확장자 자르기 
			// 이미지 파일 형식일 경우 미리보기 가능
			if(fileType != "jpg" && fileType != "png" 
					&& fileType != "gif" && fileType != "bmp" && fileType != "PNG") {
				$("#img_div").css("display","none");
			} else {	
				$("#img_div").css("display","block");
				readURL(this); // 미리보기 함수 호출
			}
		});	
		// 불러온 파일 미리보기 함수
		function readURL(input) { 
		    if (input.files && input.files[0]) {
		        var reader = new FileReader();
		 
		        reader.onload = function (e) {
		            $('#img').attr('src', e.target.result);
		        }	 
		        reader.readAsDataURL(input.files[0]);
		    }
		}
	});
    // 등록하기 전 입력 여부 검사
    function checkWrite(){
      var title=document.getElementById("title").value; 
      var content=document.getElementById("summernote").value;
      
      if(title.length == 0) { // 제목 입력 안했을 경우
    	  alert("제목을 입력하세요!");
    	  $("#title").focus();
      } else if(content.length == 0) { // 내용 입력 안했을 경우
    	  alert("내용을 입력하세요!");
    	  $("#summernote").focus();
      } else { // 모두 입력 했을 경우
          write_form.action="write_data.jsp?key=insert"; // write_data.jsp로 이동
          write_form.submit(); // write_data.jsp로 submit   
      }
   } 
    
	// 취소하기 전 한번 더 물어보기
	function checkCancel() {
		if(confirm('작성 내용이 저장되지 않습니다. 나가시겠습니까?')) {
			location.href='../e_01.jsp?from=1&cnt=10';
		} else {
		}
	}
	
	</script>
</head>
<body style="text-align:center;">
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">글 작성</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
<%
	String loginOK = (String)session.getAttribute("login_ok");
	String loginID = (String)session.getAttribute("login_id");

	if((loginOK != null) && (loginID.equals(loginID))) {
%>
<%
	Date now = new Date(); // 현재 날짜 가져온다
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 설정
	String today = sf.format(now); // 변경된 형식으로 날짜 저장
%>
	<!-- 내용 -->
	<form name="write_form" method="post" enctype="multipart/form-data"> <!-- submit위해 form 설정 -->
		<table id="table01">
			<tr>
				<td colspan=2 class="titleTd"><span>작성</span></td>
			</tr>
			<tr>
				<td class="firstTd">번호</td>
				<td class="secondTd" ><span style="font-size:13px;">신규</span></td>
			</tr>
			<tr>
				<td class="firstTd">제목</td>
				<td class="secondTd" ><input type="text" id="title" name="title" style="width:620px" maxlength=50 placeholder="최대 50자" /></td>
			</tr>
			<tr>
				<td class="firstTd">일자</td>
				<td class="secondTd" ><input type="text" id="date" name="date" style="width:600px; border:none;" value="<%=today %>" readonly /></td>
			</tr>
			<tr>
				<td class="firstTd">내용</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<textarea id="summernote" name="content" style="width:600px; height:200px; resize:vertical;" ></textarea>
				</td>			
			</tr>
			<tr>
				<td class="firstTd">파일</td>
				<td class="secondTd" style="word-break:break-all; wrap:hard;">
					<input type="file" id="upload" name="upload" style="margin-top:5px;"/> <!-- 파일 탐색기 -->
					<div id="img_div" style="width:100px; height:100px; display:none;">
						<img id="img" style="max-width:100%; max-height:100%;"/> <!-- 이미지 불러오기 창 -->
					</div>				
				</td>			
			</tr>
		</table><br>
		
		<!-- 버튼 -->
		<div style="text-align:center; margin-left:590px;">
			<input type="button" class="btn" id="cancelBtn" value="취소" onclick="checkCancel();"/> <!-- 취소 재확인 함수 호출 -->
			<input type="button" class="btn" id="writeBtn" value="쓰기" onclick="checkWrite();"/> <!-- 입력 여부 검사 함수 호출 -->
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
		</div>
	</form>
<%} else {
	out.print("<script>alert('로그인 하세요!');</script>");
	out.print("<script>location.href='../index.html';</script>");
} %>
</body>
</html>

