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
		
		String sql1 = "UPDATE board SET bhit = bhit + 1 WHERE bnum=?"; //조회수 증가 sql문
		String sql2 = "SELECT * FROM board WHERE bnum=?"; //유저가 클릭한 글 번호 내용 가져오기
		
		String driverName = "com.mysql.jdbc.Driver"; 
		String url = "jdbc:mysql://localhost:3306/boardtest"; //db이름(스키마이름)
		String username = "root";
		String password = "12345";
		
		Connection conn = null;
		PreparedStatement pstmt1 = null; //sql1번 실행용
		PreparedStatement pstmt2 = null; //sql2번 실행용
		ResultSet rs = null; //DB로부터 반환하는 레코드(게시글)를 받는 그릇
		BoardDto bDto = null;
				
		try {
			Class.forName(driverName); //jdbc 드라이버 로딩
			conn = DriverManager.getConnection(url, username, password);
			//DB와 jsp 서버간의 connenction(연결통로)가 생성
			
			
			//=================slq1 실행 : 조회수 증가 ==================
			
			pstmt1 = conn.prepareStatement(sql1); //sql1 실행
			
			//유저가 클릭한 번호를 파라미터로 입력하기(? 채우기)
			pstmt1.setString(1, viewNum);
			
			pstmt1.executeUpdate(); //sql1->update문
			
			//=================slq2 실행 : 글 상세 내용 조회 ==================
			
			pstmt2 = conn.prepareStatement(sql2); //sql2 실행
			
			pstmt2.setString(1, viewNum);
			
			rs = pstmt2.executeQuery();
			
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
				if(rs != null) {
					rs.close();
				}
				if(pstmt1 != null) {
					pstmt1.close();
				}
				if(pstmt2 != null) {
					pstmt2.close();
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
	<p>조회수: ${boardDto.bhit}</p>
	<p>제목: ${boardDto.btitle}</p>
	<p>내용: ${boardDto.bcontent}</p>
	<p>작성자: ${boardDto.bwriter}</p>
	<p>작성일: ${boardDto.bdate}</p>
	<hr>
	<input type="button" value="글목록" onclick="location.href='boardList.jsp'">
	<input type="button" value="글수정" onclick="location.href='boardModifyForm.jsp?bnum=${boardDto.bnum}'">
	<input type="button" value="글삭제" onclick="location.href=''">	
	
	
</body>
</html>