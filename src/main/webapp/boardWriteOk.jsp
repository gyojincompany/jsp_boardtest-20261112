<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글 저장</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		//사용자가 입력한 글제목, 글내용, 작성자 가져오기
		String btitle = request.getParameter("btitle");
		String bcontent = request.getParameter("bcontent");
		String bwriter = request.getParameter("bwriter");
		
		//PrepareStatement 방식의 SQL문 작성
		String sql = "INSERT INTO board(btitle, bcontent, bwriter, bhit) VALUES (?,?,?,0)";
		
		//DB 커넥션 준비를 위한 4개의 변수
		//사용하려는 DB의 드라이버이름, DB 서버의 주소(URL), 계정아이디, 계정비번
		String driverName = "com.mysql.jdbc.Driver"; 
		String url = "jdbc:mysql://localhost:3306/boardtest"; //db이름(스키마이름)
		String username = "root";
		String password = "12345";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			Class.forName(driverName); //jdbc 드라이버 로딩
			conn = DriverManager.getConnection(url, username, password);
			//DB와 jsp 서버간의 connenction(연결통로)가 생성
			
			//만들어진 커넥션을 통해서 sql문을 실행시키기 위한 단계
			pstmt = conn.prepareStatement(sql);
			
			//sql문의 ? 값 채우기
			pstmt.setString(1, btitle);
			pstmt.setString(2, bcontent);
			pstmt.setString(3, bwriter);
				
			int result = pstmt.executeUpdate(); //SQL문 실행
			 //새로운 글작성 SQL문이 실행 성공하면 정수 1의 반환
			 
			if(result == 1) {
				System.out.println("글 작성 성공!!");
			} else {
				System.out.println("글 작성 실패!!");
			}
 			
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
		
		response.sendRedirect("boardList.jsp"); //글목록 보기로 강제 이동
	
	%>
</body>
</html>