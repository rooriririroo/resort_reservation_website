<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate();
	//out.print("<script>location.href='adm_login.jsp';</script>");
	out.print("<script>parent.gourl('top.jsp','adm_login.jsp');</script>");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 로그아웃</title>
</head>
<body>
</body>
</html>