<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
 <body>
    <form name="appcreate" method="get" action="/bonoo/appcreatefinal.jsp">
     <table border="1">
	<tr> 
          <td>AppName:<input type="input" name="appname" value="" /> </td>
	<tr>
          <td>Memory:<input type="input" name="appmem" value="256" />MB </td>
	<tr>
          <td>Disk:<input type="input" name="appdisk" value="2" />GB </td>
           <%
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
                String actions = request.getParameter("action");
                String query;
                String hpoolid = request.getParameter("hpoolid");
                String isoid = request.getParameter("isoid");
                logger.info("Appclone: hpoolid:" + hpoolid + "ISO id:" + isoid);
                Connection connection = null;
                connection = (new DBConnection()).getConnection();
                Statement statement = connection.createStatement();
                String isoquery = "select isoname from iso where hpoolid=" + hpoolid + "and id=" + isoid;
                ResultSet iso = statement.executeQuery(isoquery);
                iso.next();
                String isoname =  iso.getString(1);
                iso.close();
		%>
		<input type="hidden" name="isoname" value=<%= isoname %>
                <input type="hidden" name="hpoolid" value=<%= hpoolid %>
                <tr>
                 <td> Bridge: <select name="bridge" id="bridge">
                <%
                String bridgequery = "select bridgeno from bridge";
                ResultSet bridgeset = statement.executeQuery(bridgequery);
                while(bridgeset.next()){
                %>
                <option name=<%= bridgeset.getString(1)%> > <%= bridgeset.getString(1)%> </option>
                <%} statement.close();bridgeset.close();
      %>
           </select>
	  <tr>
	  <td> <input type="submit" name="submit" value="submit"> </td>
	</table>
   </form>
</body>
</html>

