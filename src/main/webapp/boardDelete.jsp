<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		//유저가 삭제하고자 하는 글의 번호를 받아서 해당 글을 삭제한 후에
		//글 목록으로 이동하도록 구현하시오.
		String dbnum = request.getParameter("bnum"); //삭제하려는 글 번호
		
		//PrepareStatement 방식의 SQL문 작성
		String sql = "DELETE FROM board WHERE bnum=?";
		
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
			pstmt.setString(1, dbnum); //삭제하려는 글의 번호가 저장된 변수->?			
				
			int result = pstmt.executeUpdate(); //SQL문 실행
			 //새로운 글작성 SQL문이 실행 성공하면 정수 1의 반환
			 
			if(result == 1) {
				System.out.println("글 삭제 성공!!");
				response.sendRedirect("boardList.jsp"); //삭제 후 글목록으로 이동
			} else { 
				System.out.println("글 삭제 실패!!");
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
	
	%>
</body>
</html>