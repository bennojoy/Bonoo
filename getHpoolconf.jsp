<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<html>
 <body>
	<%
		String hid= request.getParameter("id");
	%>
     <script language="JavaScript">
        function apppopulate(form){
		form.hpoolid.value=<%= hid %>;
		form.action.value='populatevm';
		form.submit();
	}
        function isopopulate(form){
		form.hpoolid.value=<%= hid %>;
		form.action.value='isopopulate';
		form.submit();
	}
        function create(form){
		form.hpoolid.value=<%= hid %>;
		form.action='/bonoo/clonevm.jsp';
		form.action.value='createvm';
		for(i=0; i < form.id.length; i++){
                	if(form.id[i].checked){
                        	form.appid.value = form.id[i].value;
				break;
			}
		}
		if(typeof(form.id.length) == "undefined")
                        	form.appid.value = form.id.value;
		form.submit();
	}
        function appcr(form){
		alert(form.id.length);
		form.hpoolid.value=<%= hid %>;
		form.action='/bonoo/appcreate.jsp';
		form.action.value='appcreate';
		for(i=0; i < form.id.length; i++){
                	if(form.id[i].checked){
                        	form.isoid.value = form.id[i].value;
				break;
			}
		}
		if(typeof(form.id.length) == "undefined")
                        	form.isoid.value = form.id.value;
		form.submit();
	}
        function enableclone(form){
		form.vmcreate.disabled=false;
	}
        function enableiso(form){
		form.appcreate.disabled=false;
	}
      </script>

    <h1> Appliances </h1>
    <form name="hpoolapp" method="get" action="/bonoo/populateApp.jsp">
	<input type="button" name="discoverapp" value="DiscoverApp" onClick="apppopulate(this.form)" > 	
	<input type="button" name="vmcreate" value="Clone" onClick="create(this.form)" disabled > 	
	<input type="hidden" name="hpoolid" value="" > 	
	<input type="hidden" name="action" value="" > 	
	<input type="hidden" name="appid" value="" > 	
      <table border ="1">
        <tr>
          <th> Id </th>
          <th> Appliance Name </th>
         </tr>
	<%
                Connection connection = null;
                connection = (new DBConnection()).getConnection();
       		Statement statement = connection.createStatement();
        	String iquery = "select id,name from appliance where hpoolid='" + hid + "'";
        	ResultSet rs = statement.executeQuery(iquery);
        	while(rs.next()){
                	int id = rs.getInt(1);
                	String name = rs.getString(2);
                %>
		<tr>
                   <td><input type="radio" name="id" value=<%= id %> onClick="enableclone(this.form)"</td>
                   <td><%= name %></td>
                </tr>
	<%}statement.close();rs.close();%>
	</table>
    </form>
	<h1> ISO List </h1>
	<form name="isoform" method="get" action="/bonoo/populateApp.jsp">
        <input type="button" name="discoveriso" value="DiscoverISO" onClick="isopopulate(this.form)" >
        <input type="button" name="appcreate" value="AppCreate" onClick="appcr(this.form)" disabled >
        <input type="hidden" name="hpoolid" value="" >
        <input type="hidden" name="action" value="" >
        <input type="hidden" name="isoid" value="" >
      <table border ="1">
	<tr>
          <th> Id </th>
          <th> ISO Name </th>
         </tr>
        <%
                statement = connection.createStatement();
                String query = "select id,isoname from iso where hpoolid='" + hid + "'";
                rs = statement.executeQuery(query);
                while(rs.next()){
                        int id = rs.getInt(1);
                        String name = rs.getString(2);
                %>
                <tr>
                   <td><input type="radio" name="id" value=<%= id %> onClick="enableiso(this.form)"</td>
                   <td><%= name %></td>
                </tr>
        <%}statement.close();rs.close();%>
        </table>
    </form>
  </body>
</html>
