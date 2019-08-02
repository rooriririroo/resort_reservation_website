<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 로그아웃</title>
	<style>
		.btn {background-color:mediumpurple; width:200px; color:#ffffff; 
			  height:40px; border:0; outline:0; border-radius:5px;}
	</style>
</head>
<body style="text-align:center;">
<script>parent.gourltop('top.jsp');</script>
	<br><br><br><br>
	<%
		String loginID = (String)session.getAttribute("login_id");
	%>
	<span style="font-size:20px;">관리자 <span style="font-weight:bold;"><%=loginID %></span>님 로그인 하셨습니다!</span><br><br><br>
	<input type="button" class="btn" value="로그아웃" onclick="location.href='adm_logoutcheck.jsp'" />
</body>
</html>