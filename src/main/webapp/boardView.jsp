<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardDto"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>  
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글 내용보기</title>
</head>
<body>
	<%
		String viewNum = request.getParameter("bnum"); //유저가 클릭한 글 번호
		
		String sql = "SELECT * FROM board WHERE bnum=?";
		
		String driverName = "com.mysql.jdbc.Driver"; 
		String url = "jdbc:mysql://localhost:3306/boardtest"; //db이름(스키마이름)
		String username = "root";
		String password = "12345";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //DB로부터 반환하는 레코드(게시글)를 받는 그릇
		BoardDto bDto = null;
				
		try {
			Class.forName(driverName); //jdbc 드라이버 로딩
			conn = DriverManager.getConnection(url, username, password);
			//DB와 jsp 서버간의 connenction(연결통로)가 생성
			
			//만들어진 커넥션을 통해서 sql문을 실행시키기 위한 단계
			pstmt = conn.prepareStatement(sql);
			
			//유저가 클릭한 번호를 파라미터로 입력하기(? 채우기)
			pstmt.setString(1, viewNum);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int bnum = rs.getInt("bnum");
				String btitle = rs.getString("btitle");
				String bcontent = rs.getString("bcontent");
				String bwriter = rs.getString("bwriter");
				int bhit = rs.getInt("bhit");
				String bdate = rs.getString("bdate");
				
				bDto = new BoardDto(bnum, btitle, bcontent, bwriter, bhit, bdate);
				
			} else {
				System.out.println("존재하지 않는 글입니다.");
			}
			
			//유저가 클릭한 글 1개만 저장
			request.setAttribute("boardDto", bDto);
 			
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
	
	<h2>게시판 글 내용보기</h2>
	<hr>
	<p>번호: ${boardDto.bnum}</p>
	<p>제목: ${boardDto.btitle}</p>
	<p>내용: ${boardDto.bcontent}</p>
	<p>작성자: ${boardDto.bwriter}</p>
	<p>작성일: ${boardDto.bdate}</p>
	<hr>
	<a href="boardList.jsp">글목록</a>
	<a href="#">글수정</a>
	<a href="#">글삭제</a>
	
</body>
</html>