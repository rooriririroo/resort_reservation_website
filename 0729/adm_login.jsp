<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 로그인</title>
	<style>
		.btn {background-color:mediumpurple; width:400px; color:#ffffff; 
			  height:40px; border:0; outline:0; border-radius:5px;}
	</style>
	<script>
		function checkLogin() {
			var id = document.getElementById("id").value;
			var pass = document.getElementById("pass").value;
			
			if(id.length == 0) {
				alert("아이디를 입력하세요!");
			} else if(pass.length == 0) {
				alert("비밀번호를 입력하세요!");
			} else {
				login_form.action="adm_logincheck.jsp";
				login_form.submit();	
			}
		}
	</script>
</head>
<body style="text-align:center;">
<%
	String jump = request.getParameter("jump");
	
	if(jump == null) {
		String jumpURL = "adm_login.jsp?jump=adm_logout.jsp";
		response.sendRedirect(jumpURL);	
	}
%>
	<!-- 헤더 -->
	<h3 style="color:#6b639f; margin-top:50px; font-size:25px; font-weight:bold;">로그인</h3>
	<hr style="width:100px; border:2px solid #6b639f;">
	
	<!-- 내용 -->
	<form name="login_form" method="post">
		<div style="width:800px; margin:auto; margin-top:50px;" >
			<input type="text" id="id" name="id" placeholder="아이디" style="width:400px; height:40px;" maxlength=20 /><br><br><br>
			<input type="password" id="pass" name="pass" placeholder="비밀번호" style="width:400px; height:40px;" maxlength=20 /><br><br><br>
			<input type="button" id="login_btn" class="btn" value="로그인" onclick="checkLogin();" />			
		</div><br>
		<input type="hidden" name="jump" value="<%=jump %>" />
	</form>
</body>
</html>

