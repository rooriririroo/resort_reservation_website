<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.*,java.util.Date,java.text.SimpleDateFormat" %> <!-- 패키지 import -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style>
		td {font-size:14px; text-align:center; }
		a:link {text-decoration:none; color:black;}
		a:visited {text-decoration:none; color:black;}
		a:hover {text-decoration:none; color:black;}
		a:active {text-decoration:nonoe; color:black;}
	</style>
	<script>
		var menuCnt = 5; // 상단 메뉴 갯수
		// 하위 메뉴 보여주기
		function fncShow(pos) {
			var i = 0;
			for(i; i<menuCnt; i++) {
				var obj = document.getElementById("menu"+i);
				var obj2 = document.getElementById("m"+i);
				if(i == pos) {
					obj.style.display='';
					obj2.style.color="tomato";
				} else {
					obj.style.display='none';
					obj2.style.color="#000000";				
				}
			}
		}
		// 하위 메뉴 숨기기
		function fncHide(pos) {
			var obj = document.getElementById("menu"+pos);
			obj.style.display='none';
		}
	</script>
</head>
<body style="text-align:center;" >
	<%
		Date now = new Date(); // 현재 날짜 가져온다
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd hh-mm-ss"); // 날짜 포맷 설정
		String today = sf.format(now); // 변경된 형식으로 날짜 저장
		
		Cookie cookieDate = new Cookie("today",today);
		cookieDate.setMaxAge(-1); // 브라우저 켜있을 때 까지 쿠키 저장
		response.addCookie(cookieDate); // response 객체에 보내야 사용 가능 함
	
	%>
	<!-- <a href='main.html' target=main><img src = "logo.PNG" onclick="parent.gourl('top.jsp','main.html');" /></a><br> -->
	<img src = "logo.PNG" onclick="parent.gourl('top.jsp','main.html');" /><br>
	<span style="font-size:13px;">최근 방문일 :
	<%
	if(cookieDate != null) {
		Cookie[] cookies = request.getCookies();
		for(int i=0; i<cookies.length; i++) {
			Cookie thisCookie = cookies[i];
			if("today".equals(thisCookie.getName())) {
	%>
	 <%=thisCookie.getValue() %></span>
	<%
			}
		}	
	}
	%>
	<table cellpadding=0 cellspacing=1 border=0 style="margin:auto; margin-top:10px;">
		<td width=150><a href="main.html" target=main></a></td>
		<td>
			<table cellpadding=0 cellspacing=1 border=0 width=600 height=60>
			<!-- 상단 메인 메뉴 정의 -->
				<tr height=30> 
					<td width=100 onmouseover="fncShow(0);" id="m0"><b>리조트 소개</b></td>
					<td width=100 onmouseover="fncShow(1);" id="m1"><b>찾아오기</b></td>
					<td width=100 onmouseover="fncShow(2);" id="m2"><b>주변 여행지</b></td>
					<td width=100 onmouseover="fncShow(3);" id="m3"><b>예약하기</b></td>
					<td width=100 onmouseover="fncShow(4);" id="m4"><b>리조트 소식</b></td>
					<td width=100></td>
				</tr>
				<!-- 상단 메인 메뉴 별 하위 메뉴 정의 -->
				<tr height=30>
					<td colspan=6>
					<table id="menu0" style="display:none;" cellpadding=0 cellspacing=0 border=0 width=600 height=30> 
						<tr>
							<td width='0'></td>
							<td width='600' style='text-align:left;'>
								<a href='main.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 하얏트 리젠시 제주</span>
								</a>
								<a href='a_01.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 스위트룸</span>
								</a>
								<a href='a_02.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 일반룸</span>
								</a>
								<a href='a_03.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 특별룸 |</span>
								</a>															
							</td>
						</tr>
					</table>
					<table id="menu1" style="display:none;" cellpadding=0 cellspacing=0 border=0 width=600 height=30> 
						<tr>
							<td width='0'></td>
							<td width='500' style='text-align:left;'>
								<a href='b_01.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 찾아오는길</span>
								</a>
								<a href='b_02.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 대중교통 이용</span>
								</a>
								<a href='b_03.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 자가용 이용 |</span>
								</a>															
							</td>
						</tr>
					</table>
					<table id="menu2" style="display:none;" cellpadding=0 cellspacing=0 border=0 width=600 height=30> 
						<tr>
							<td width='200'></td>
							<td width='400' style='text-align:left;'>
								<a href='c_01.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 한라산</span>
								</a>
								<a href='c_02.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 중문 관광단지</span>
								</a>
								<a href='c_03.html' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 제주 여미지 식물원 |</span>
								</a>															
							</td>
						</tr>
					</table>
					<table id="menu3" style="display:none;" cellpadding=0 cellspacing=0 border=0 width=600 height=30> 
						<tr>
							<td width='100'></td>
							<td width='400' style='text-align:left;'>
								<a href='d_01.jsp' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 예약현황</span>
								</a>
								<a href='d_02.jsp?mode=new' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 예약하기</span>
								</a>
								<a href='adm_allview.jsp' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 관리자 페이지</span>
								</a>	
<%
								// 로그인 세션 체크
								String loginOK=(String)session.getAttribute("login_ok");
								if(loginOK != null) {
%>
								<a href='adm_logout.jsp' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 관리자 로그아웃 |</span>
								</a>	
<%
	} else {
%>			
								<a href='adm_login.jsp' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 관리자 로그인 |</span>
								</a>
<%
	}
%>										
							</td>
						</tr>
					</table>
					<table id="menu4" style="display:none;" cellpadding=0 cellspacing=0 border=0 width=600 height=30> 
						<tr>
							<td width='350'></td>
							<td width='250' style="text-align:left;">
								<a href='e_01.jsp?from=1&cnt=10' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 리조트 소식</span>
								</a>
								<a href='e_02.jsp?from=1&cnt=10' target=main>
									<span onmouseover=this.style.color="tomato" onmouseout=this.style.color="#000000">| 이용 후기 |</span>
								</a>														
							</td>
						</tr>
					</table>	
				</td>					
				</tr>	
				</table>
				</td>
	</table>
</body>
</html>    