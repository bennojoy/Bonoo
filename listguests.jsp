<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<html>
 <body>
   <script language="JavaScript">
        function checkstatus(form){
           var i,j;
	   if(typeof(form.radio.length) == "undefined"){
		j = form.radio.value;
		j = j.split("|");
                if (j[1] == 0){
        	        form.start.disabled=false;
     	 	        form.stop.disabled=true;
                	form.deletevm.disabled=false;
           	}else if(j[1] == 1){
                	form.start.disabled=true;
                	form.stop.disabled=false;
                	form.deletevm.disabled=true;
               }
          }
           for(i=0; i < form.radio.length; i++){
                if(form.radio[i].checked){
                        j = form.radio[i].value;
                        break;
                }

           }
           j = j.split("|");
	   if (j[1] == 0){
	   	form.start.disabled=false;
	   	form.stop.disabled=true;
		form.deletevm.disabled=false;
	   }else if(j[1] == 1){
		form.start.disabled=true;
                form.stop.disabled=false;
		form.deletevm.disabled=true;
	   }


        }
	
	function dsync(form){
            form.action = "/bonoo/vmdbsync";
            form.action.value = 'sync';
            form.submit();
        }

	function buttonAction(action, form) {
	    form.action.value = action;
	    form.submit();
	}
     </script>
    <% 
	String name = (String)session.getAttribute("name"); 
	if( (name == null) || name.equals("invalid") || (name.length() == 0) ) 
		response.sendRedirect("/bonoo/error.jsp");
   %>
    <%= name %>
   <form name="guestlist" method="GET" action="/bonoo/canooservlet">
    <input type="button" name="start" value="start" disabled onClick="buttonAction('start', this.form)">
    <input type="button" name="stop" value="stop" disabled onClick="buttonAction('stop', this.form)">
    <input type="button" name="sync" value="Sync" onClick="dsync(this.form)">
    <input type="button" name="deletevm" value="DeleteVM" disabled onClick="buttonAction('deletevm', this.form)"><br>
    <input type="hidden" name="action" value="">
    <table border="1">
	   <tr>
	       <th>Select</th>
	       <th>Hostname</th>
	       <th>Status</th>
	   </tr>
    <%	
	Connection connection = null;
        connection = (new DBConnection()).getConnection();
	Statement statement = connection.createStatement();
	String query = "select * from host";
	ResultSet rs = statement.executeQuery(query);
	while(rs.next()){
		String hostname = rs.getString(2);
		int status = rs.getInt(3);
	%>
			<tr>
			   <td><input type="radio" name="radio" value=<%= hostname + "|" + status %> onClick="checkstatus(this.form)" /> </td>		 
			   <td><%= hostname %> </td>		 
			   <td><%= (status == 0) ? "Down" : "Running"   %> </td>
			</tr>		 
	<%
	}
	%>
    </table>
   </form>
 </body>
</html>

