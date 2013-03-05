<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<html>
 <body>
   <%
        String name = (String)session.getAttribute("name");
        if( (name == null) || name.equals("invalid") || (name.length() == 0) )
                response.sendRedirect("/bonoo/error.jsp");
   %>
   <script language="JavaScript">
	
	function buttonAction(action, form) {
	    form.action.value = action;
	    form.submit();
	}
     </script>
    <form name="storage" method="GET" action="/bonoo/storageadd.jsp">
    <table border="1">
	   <tr>
	       <th>Strorage Type</th>
	       <th>Param</th>
	   </tr>
    <%	
	Connection connection = null;
        connection = (new DBConnection()).getConnection();
	Statement statement = connection.createStatement();
	String query = "select * from storage";
	ResultSet rs = statement.executeQuery(query);
	while(rs.next()){
		String stype = rs.getString(2);
		String param = rs.getString(3);
	%>
			<tr>
			   <td><%= stype %> </td>		 
			   <td><%= param  %> </td>
			</tr>		 
	<%
	}
	%>
	<tr>
	<td><input type="input" name="strtype" /> </td>
	<td><input type="input" name="strparam" /> </td>
    	<td><input type="submit" name="Add" value="Add" ></td>
    </table>
   </form>
 </body>
</html>

