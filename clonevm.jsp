<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="org.apache.log4j.Logger" %>

<html>
 <body>
    <form name="vmclone" method="get" action="/bonoo/cloneguestfinal.jsp">
     <table border="1">
	<tr> 
          <td>VMName:<input type="input" name="vmname" value="" /> </td>
	<tr>
          <td>Memory:<input type="input" name="vmmem" value="256" />MB </td>
	<tr>
          <td>Cpu   :<input type="input" name="vmcpu" value="2" /> </td>
	
	<%
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		String actions = request.getParameter("action");
		String query;
		query = request.getQueryString();
		String hpoolid = request.getParameter("hpoolid");	
		String appid = request.getParameter("appid");	
		logger.info("VMclone: hpoolid:" + hpoolid + "Appliance id:" + appid);
		Connection connection = null;
                connection = (new DBConnection()).getConnection();
		Statement statement = connection.createStatement();
		String appquery = "select name from appliance where hpoolid=" + hpoolid + "and id=" + appid;
		ResultSet app = statement.executeQuery(appquery);
		app.next();
		String appname =  app.getString(1);
		app.close();
		statement.close();
		%>
		<input type="hidden" name="appname" value=<%= appname %>
		<input type="hidden" name="hpoolid" value=<%= hpoolid %>
        	<tr>
          	 <td> NicModel:<select name="nicmodel" id="nicmodel" >  
		<%
		statement = connection.createStatement();
                String modelquery = "select * from nicmodel";
                ResultSet modelset = statement.executeQuery(modelquery);
                while(modelset.next()){
                %>
                   <option name=<%= modelset.getString(1)%> > <%= modelset.getString(1)%> </option>
                <%} statement.close();modelset.close(); %>
		  </select>
                <tr>             
          	 <td> Bridge: <select name="bridge" id="bridge">
		<%
		statement = connection.createStatement();
                String bridgequery = "select bridgeno from bridge";
                ResultSet bridgeset = statement.executeQuery(bridgequery);
                while(bridgeset.next()){
		%>
                <option name=<%= bridgeset.getString(1)%> > <%= bridgeset.getString(1)%> </option>
                <%} statement.close();bridgeset.close();%>
		</select>
		<tr>
                 <td> DriveModel: <select name="drive" id="drive"> 
		 <%
                statement = connection.createStatement();
                String drivequery = "select * from drivemodel";
                ResultSet driveset = statement.executeQuery(drivequery);
                while(driveset.next()){
                %>
                <option name=<%= driveset.getString(1)%> > <%= driveset.getString(1)%> </option>
                <%} statement.close();driveset.close();
       %>
  	</select>	
       <tr>
     	<td> <input type="submit" name="submit" value="submit"></td>
      </table>
   </form>
</body>
</html>

