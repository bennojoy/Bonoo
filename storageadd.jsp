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
		String sname = request.getParameter("strtype");
		String sparam = request.getParameter("strparam");
		int count=0;
		try{
			ResultSet rs = null;
        		statement = connection.createStatement();
        		String query = "select max(id) from storage";
			rs = statement.executeQuery(query);
               		rs.next();
               		count = rs.getInt(1);
               		rs.close();
			count++;
			logger.info("Adding new storage with id:" + count);
			String nquery="insert into storage values(" + count + ",'" + sname + "','" + sparam + "')";
			logger.info("Storage added " + nquery);
			statement.executeUpdate(nquery);
			statement.close();
			
		}catch(Exception e){
			logger.info("Storage add error" + e.getMessage());
		}
			
	%>
	<h1> Bonoo </h1>
</body>
</html>

