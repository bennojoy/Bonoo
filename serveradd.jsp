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
		String sname = request.getParameter("servername");
		String hpname = request.getParameter("nhpool");
		int count=0;
		try{
			ResultSet rs = null;
        		statement = connection.createStatement();
        		String query = "select max(id) from servers";
			rs = statement.executeQuery(query);
               		rs.next();
               		count = rs.getInt(1);
               		rs.close();
			count++;
			logger.info("Adding new server with id:" + count);
			String hid="select id from hpool where name='" + hpname + "'";
			rs = statement.executeQuery(hid);
			rs.next();
			int id = rs.getInt(1);
			rs.close();
			String nquery="insert into servers values(" + count + ",'" + sname + "'," + id  + ")";
			logger.info("Server added " + nquery);
			statement.executeUpdate(nquery);
			statement.close();
			
		}catch(Exception e){
			logger.info("Serveradd error" + e.getMessage());
		}
			
	%>
	<h1> <%= request.getQueryString() %> </h1>
</body>
</html>

