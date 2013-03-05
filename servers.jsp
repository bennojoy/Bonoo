<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<html>
 <body>
   <%
        String name = (String)session.getAttribute("name");
        if( (name == null) || name.equals("invalid") || (name.length() == 0) )
                response.sendRedirect("/bonoo/error.jsp");
   %>
    <form name="servers" method="GET" action="/bonoo/serveradd.jsp">
    <table border="1">
	   <tr>
	       <th>Server Name</th>
	       <th>Hpool</th>
	   </tr>
    <%	
	Connection connection = null;
        connection = (new DBConnection()).getConnection();
	Statement statement = connection.createStatement();
	String query = "select * from servers";
	ResultSet rs = statement.executeQuery(query);
	while(rs.next()){
		String server = rs.getString(2);
		String hpool = rs.getString(3);
	%>
			<tr>
			   <td><%= server %> </td>		 
			   <td><%= hpool  %> </td>
			</tr>		 
	<%
	}rs.close();%>
        </table>
	<input Servername: type="input" name="servername" /> 
	<td> Hpool: <select name="nhpool" id="nhpool">
                <%
                String squery = "select name from hpool";
                rs = statement.executeQuery(squery);
                while(rs.next()){
                %>
                <option name=<%= rs.getString(1)%> > <%= rs.getString(1)%> </option> </td>
                <%} statement.close();rs.close(); %>
    	<input type="submit" name="Add" value="Add" ></td>
   </form>
 </body>
</html>

