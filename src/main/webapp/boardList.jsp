<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardDto"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>  
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글 목록</title>
</head>
<body>
	<%
		String sql="SELECT * FROM board ORDER BY bnum DESC"; //모든 글 가져오기 SQL문
		
		//DB 커넥션 준비를 위한 4개의 변수
		//사용하려는 DB의 드라이버이름, DB 서버의 주소(URL), 계정아이디, 계정비번
		String driverName = "com.mysql.jdbc.Driver"; 
		String url = "jdbc:mysql://localhost:3306/boardtest"; //db이름(스키마이름)
		String username = "root";
		String password = "12345";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //DB로부터 반환하는 레코드(게시글)를 받는 그릇
		ArrayList<BoardDto> boardList = new ArrayList<BoardDto>();
		
		try {
			Class.forName(driverName); //jdbc 드라이버 로딩
			conn = DriverManager.getConnection(url, username, password);
			//DB와 jsp 서버간의 connenction(연결통로)가 생성
			
			//만들어진 커넥션을 통해서 sql문을 실행시키기 위한 단계
			pstmt = conn.prepareStatement(sql);
				
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int bnum = rs.getInt("bnum");
				String btitle = rs.getString("btitle");
				String bcontent = rs.getString("bcontent");
				String bwriter = rs.getString("bwriter");
				int bhit = rs.getInt("bhit");
				String bdate = rs.getString("bdate");
				
				BoardDto bDto = new BoardDto(bnum, btitle, bcontent, bwriter, bhit, bdate);
				
				boardList.add(bDto);
			}
			
			request.setAttribute("boardList", boardList);
			
 			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try{
				if(pstmt != null) {
					pstmt.close();
				}
				if(conn != null) {
					conn.close();
				}
				
			} catch(Exception e) {
				
			}
		}
	
	%>
	
	<table border="1">
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회수</th>
				<th>작성일</th>
			<tr>
		</thead>
		<tbody>
			<c:forEach var="bDto" items="${boardList}">
				<tr>
					<td>${bDto.bnum}</td>
					<td>${bDto.btitle}</td>
					<td>${bDto.bwriter}</td>
					<td>${bDto.bhit}</td>
					<td>${bDto.bdate}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
</body>
</html>