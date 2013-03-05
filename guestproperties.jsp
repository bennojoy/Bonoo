<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<html>
 <body>
   <script language="JavaScript">
        function vmdetails(hostname){
		document.guestconf.vmname.value = hostname;
		document.guestconf.submit();
        }
     </script>
     <%
        String name = (String)session.getAttribute("name");
        if( (name == null) || name.equals("invalid") || (name.length() == 0) )
                response.sendRedirect("/bonoo/error.jsp");
   %>

    <form name="guestconf" method="get" action="/bonoo/guestconfig.jsp">
	<input type="hidden" name="vmname" value="">
    </form> 
    <table border="1">
	   <tr>
	       <th>Hostname</th>
	   </tr>
      <%	
	Connection connection = null;
        connection = (new DBConnection()).getConnection();
	Statement statement = connection.createStatement();
	String query = "select * from host";
	ResultSet rs = statement.executeQuery(query);
	while(rs.next()){
		String hostname = rs.getString(2);
	%>
		<tr>	
			<td> <a href="javascript:vmdetails('<%= hostname %>')"> <%= hostname %> </a>
		</tr> 
	<%
	}
	%>
    </table>
   </form>
 </body>
</html>
