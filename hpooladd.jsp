<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
 <body>
	<%
                org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		Connection connection = null;
       		connection = (new DBConnection()).getConnection();
		Statement statement=null;
		String nhpool = request.getParameter("nhpool");
		String storage = request.getParameter("storage");
		int count=0;
		try{
			ResultSet rs = null;
        		statement = connection.createStatement();
        		String query = "select max(id) from hpool";
			rs = statement.executeQuery(query);
               		rs.next();
               		count = rs.getInt(1);
               		rs.close();
			count++;
			logger.info("Adding new hpool with id:" + count);
			String sidquery = "select id from storage where type='" + storage + "'";
			rs = statement.executeQuery(sidquery);
			rs.next();
			int sid = rs.getInt(1);
			rs.close();
			String nquery="insert into hpool values(" + count + ",'" + nhpool + "'," + sid + ")";
			logger.info("Hpool added " + nquery);
			statement.executeUpdate(nquery);
			statement.close();
			
		}catch(Exception e){
			logger.info("Hpool add error" + e.getMessage());
		}
			
	%>
	<h1> <%= request.getQueryString() %> </h1>
</body>
</html>

