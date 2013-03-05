<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
 <body>
	<%
		String iuser="invalid";
                org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		Connection connection = null;
       		connection = (new DBConnection()).getConnection();
		Statement statement=null;
		String uname = request.getParameter("uname");
		String upass = request.getParameter("upass");
		try{
			ResultSet rs = null;
        		statement = connection.createStatement();
        		String query = "select passwd from users where username='" + uname + "'";
			rs = statement.executeQuery(query);
			if(rs == null){
				response.sendRedirect("/bonoo/error.jsp");
			}
               		rs.next();
               		String pass = rs.getString(1);
               		statement.close();
               		rs.close();
			logger.info("In Authentication got user:" + uname);
			if(upass.equals(pass)){
				logger.info("Authentication passed user:" + uname);
				session.setAttribute("name",uname);
			}else{
				session.setAttribute("name",iuser);
			}
		}catch(Exception e){
			logger.info("Authentication error");
			session.setAttribute("name",iuser);
		}
		logger.info("hello");
			
	%>
	<h1> Bonoo </h1>
</body>
</html>

