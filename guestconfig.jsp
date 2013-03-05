<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>

<html>
 <body>
	<script language="JavaScript">
        	function jsnicupdate(form){
			var nicid;
			for(i=0;i<form.radio.length;i++)
				if(form.radio[i].checked)
					break;
			nicid=i;
			for(i=0;i<form.radio.length;i++){
		        	form.nicmodelselect[i].disabled=true;
		        	form.bridgeselect[i].disabled=true;
			}
		        form.nicmodelselect[nicid].disabled=false;
		        form.bridgeselect[nicid].disabled=false;
			form.nicupdate.disabled=true;
			form.delnic.disabled=false;
		}
		function jsnicupdateselect(form){
			form.nicupdate.disabled=false;
		}
		function jsnicupdateserver(form,hostname){
			for(i=0;i<form.radio.length;i++)
				if(form.radio[i].checked)
				break;
			form.vmname.value=hostname;
			form.action.value='nicupdate';
			form.submit();
		}
		function delnnic(form,hostname){
			for(i=0;i<form.radio.length;i++)
				if(form.radio[i].checked){
					form.vmname.value=hostname;
					form.action.value='nicdelete';
					form.submit();
				}
		}	
			
		function addnic(form){
			var maxval = parseInt('0');
			var radval;
			if( parseInt(form.radio.value) >= 0){
				maxval = form.radio.value;
				rvalue = form.radio.value;
			}else{
				for(i=0;i<form.radio.length;i++){
					radval = parseInt(form.radio[i].value);
						if(radval > maxval)
							maxval = radval;
				}
				rvalue = form.radio[0].value;
			}
			var tbl = document.getElementById('nictb');
			tlength = tbl.rows.length;
			maxval++;
			var newrow = tbl.insertRow(tlength);
			var cell0 = newrow.insertCell(0);
			var radio = document.createElement('input');
			radio.setAttribute("type","radio");
			radio.setAttribute("name","radio");
			radio.setAttribute("onClick","jsnicupdate(this.form)");
                        radio.value = maxval;
			cell0.appendChild(radio);
			var cell1 = newrow.insertCell(1);
			var mac = document.createTextNode('54:52:ab:02:23:01');
			cell1.appendChild(mac);
			var cell2 = newrow.insertCell(2);
                        var nicmodel = document.getElementById("model" + rvalue);
                        nnicmodel =  nicmodel.cloneNode(true);
                        cell2.appendChild(nnicmodel);
			var cell3 = newrow.insertCell(3);
                        var bridge = document.getElementById("bridge" + rvalue);
                        nbridge =  bridge.cloneNode(true);
                        cell3.appendChild(nbridge);
			form.nicupdate.disabled=false;

		}
		function memupdate(form,hostname){
			form.vmname.value=hostname;
			form.action.value='updatemem';
			form.submit();
		}
		function cpuupdate(form,hostname){
			form.vmname.value=hostname;
			form.action.value='updatesmp';
			form.submit();
		}

	</script>
	
	<% 
		String hostname = request.getParameter("vmname");
	%>
         <h1> Network Details for <%= hostname %> </h1>
	<form name="nicform" method="get" action="/bonoo/vmconfservlet">
	 <table id="nictb" border="1">
	  <tr>
	     <th> Id </th>
	     <th> Mac </th>
	     <th> Model </th>
	     <th> Bridge </th>
	     <td> <input type="button" name="nicupdate" value="Update"  onClick="jsnicupdateserver(this.form,'<%= hostname %>')" disabled>  </td>
	     <input type="hidden" name="vmname" value="">  
	     <input type="hidden" name="action" value="">  
	     <input type="button" name="addnnic" value="AddNic" onClick="addnic(this.form)">  
	     <input type="button" name="delnic" value="DelNic" onClick="delnnic(this.form, '<%= hostname %>')" disabled>  
           <%
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		Connection connection = null;
        	connection = (new DBConnection()).getConnection();
       		Statement statement = connection.createStatement();
        	String query = "select a.vlan, a.macaddr, a.model, b.bridgeno from nic a, bridge b, tap c where a.hostid=(select hostid from host where hostname='" + hostname + "') and a.hostid=c.hostid and c.script=b.script and a.vlan = c.vlan";
		logger.info("VmConfiguration details jsp:" + query);
       		ResultSet rs = statement.executeQuery(query);
        	while(rs.next()){
		String id = rs.getString(1);
		String macaddr = rs.getString(2);
		String model = rs.getString(3);
		String bridge = rs.getString(4);
	  %>
		<tr>
		<td><input type="radio" name="radio" value="<%= id %>" onClick="jsnicupdate(this.form)"/> </td>
		<td><%= macaddr %></td>
		<td><select name="nicmodelselect" id="model<%= id %>" onChange="jsnicupdateselect(this.form)" disabled>
                    <option name=<%= model %> selected> <%= model %> </option>
	      <%
		Statement modelstmt = connection.createStatement();
		String modelquery = "select * from nicmodel where model != '" + model + "'";
		ResultSet modelset = modelstmt.executeQuery(modelquery);
		while(modelset.next()){
	        %>
		<option name=<%= modelset.getString(1) %> > <%= modelset.getString(1) %> </option>
		<%} modelstmt.close();modelset.close(); %>
		  </select>
		 </td>
		<td><select name="bridgeselect" id="bridge<%= id %>" onChange="jsnicupdateselect(this.form)" disabled" >
                    <option name=<%= bridge %> selected> <%= bridge %> </option>
	       <%
		Statement bridgestmt = connection.createStatement();
		String bridgequery = "select bridgeno from bridge where bridgeno != '" + bridge + "'";
		ResultSet bridgeset = bridgestmt.executeQuery(bridgequery);
		while(bridgeset.next()){
	        %>
		<option name=<%= bridgeset.getString(1) %> > <%= bridgeset.getString(1) %> </option>
                <%} bridgestmt.close();bridgeset.close(); %>
                  </select>
                 </td>
	  <%}statement.close();rs.close();%>
    </table>
   </form>
   <--------------------------------------------------------------------------------------->
    <h1> Memory Details for VM <%= hostname %> </h1>
      <form name="memform" method="get" action="/bonoo/vmconfservlet">
	  <table border="1" >
		<tr>
		  <th>Memory</th>
	 <% 
		statement = connection.createStatement();
		String memquery = "select size from mem where hostid=(select hostid from host where hostname='" + hostname + "')";
		rs = statement.executeQuery(memquery);
		rs.next();
		String vmmem = rs.getString(1); 
		statement.close();
		rs.close();
	%>
	      <tr>	
	      <td><input type="input" name="vmmemory" value=<%= vmmem %>  />MB </td>
	      <td><input type="button" name="updmem" value="UpdateMem" onClick="memupdate(this.form,'<%= hostname %>')"/> </td>	
	      <td><input type="hidden" name="vmname" value="" /> </td>	
	      <td><input type="hidden" name="action" value="" /> </td>
	</table>	
      </form> 

    <--------------------------------------------------------------------------------------->
       <h1> CPU Details for VM <%= hostname %> </h1>
      <form name="smpform" method="get" action="/bonoo/vmconfservlet">
          <table border="1" >
                <tr>
                  <th>CPU</th>
         <%
                statement = connection.createStatement();
                String smpquery = "select ncpu from smp where hostid=(select hostid from host where hostname='" + hostname + "')";
                rs = statement.executeQuery(smpquery);
                rs.next();
                String vmsmp = rs.getString(1);
                statement.close();
                rs.close();
        %>
              <tr>
              <td><input type="input" name="vmsmp" value=<%= vmsmp %>  />cpus </td>
              <td><input type="button" name="updsmp" value="UpdateCPU" onClick="cpuupdate(this.form,'<%= hostname %>')"/> </td>
              <td><input type="hidden" name="vmname" value="" /> </td>
              <td><input type="hidden" name="action" value="" /> </td>
        </table>
      </form>

 </body>
</html>
