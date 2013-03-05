<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>

<html>
 <body>
    <script language="JavaScript">
        function getpoolconf(id){
                document.hpool.action.value='getappliance';
                document.hpool.id.value=id;
		document.hpool.submit();
                
        }
     </script>
    <%
        String sname = (String)session.getAttribute("name");
        if( (sname == null) || sname.equals("invalid") || (sname.length() == 0) )
                response.sendRedirect("/bonoo/error.jsp");
   %>
	
   <form name="hpool" method="get" action="/bonoo/getHpoolconf.jsp"
     <input type="hidden" name="action" value="" >
     <input type="hidden" name="id" value="" >
    <table border="1"
	<tr>
	   <th>Id</th>
	   <th>Hardware Pool</th>
	</tr>
   <%  

	Connection connection = null;
        connection = (new DBConnection()).getConnection();
        Statement statement = connection.createStatement();
        String query = "select id, name from hpool";
        ResultSet rs = statement.executeQuery(query);
        while(rs.next()){
                int id = rs.getInt(1);
                String name = rs.getString(2);
	%>
	<tr>
	  <td><%= id %> </td>
	  <td> <a href="javascript:getpoolconf('<%= id %>')"> <%= name %> </a>
	</tr>
    <%}rs.close(); %>
   </form>
   </table>
   <form name="newhpool" method="get" action="/bonoo/hpooladd.jsp">
    <tr>
      <td>NewPool:<input type="input" name="nhpool" />
      <td> Storage: <select name="storage" id="storage">
                <%
                String squery = "select type from storage";
                rs = statement.executeQuery(squery);
                while(rs.next()){
                %>
                <option name=<%= rs.getString(1)%> > <%= rs.getString(1)%> </option> </td>
                <%} statement.close();rs.close(); %>
		<td><input type="submit" value="Add" /> </td>
  </form>
  </body>
</html>



