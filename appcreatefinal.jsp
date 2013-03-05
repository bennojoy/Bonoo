<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
 <body>
	 <%
		String resp;
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		String hid = request.getParameter("hpoolid");
                String isoname = request.getParameter("isoname");
                String appname = request.getParameter("appname");
                String appmem = request.getParameter("appmem");
                String appdisk = request.getParameter("appdisk");
                String bridge = request.getParameter("bridge");
                Connection connection = null;
                connection = (new DBConnection()).getConnection();
                Statement statement = connection.createStatement();
                String query = "select param from storage where id=(select strgid from hpool where id=" + hid + ")";
                ResultSet rs = statement.executeQuery(query);
                rs.next();
                String storage = rs.getString(1);
                rs.close();
		String cmd = "appdiskcreate#mkdir " + storage + "/appliances/" + appname + "#qemu-img create -f qcow2 " + storage + "/appliances/" + appname + "/system.img " + appdisk + "G#"; 
		logger.info("Appcreate Final disk creation cmd:" + cmd);
		String squery = "select name from servers where hpoolid=" + hid;
                rs = statement.executeQuery(squery);
                rs.next();
                String server = rs.getString(1);
                statement.close();
                rs.close();
                com.bonoo.VMHostAccess vm = new com.bonoo.VMHostAccess();
                String res = vm.AccessAgent(cmd,server);
		if(res.equals("App creation Succedded.")){
			statement = connection.createStatement();
			String bquery = "select script from bridge where bridgeno='" + bridge + "'";
			rs = statement.executeQuery(bquery);
			rs.next();
			String script = rs.getString(1);
			statement.close();
			rs.close();
			cmd="appcreate#-cdrom " + storage + "/iso/" + isoname + "/" + isoname + ".iso#-boot order=d#-m " + appmem + "#-net nic,vlan=0#-net tap,vlan=0,script=" + script +"#-vnc " + server + ":100#" + storage + "/appliances/" + appname + "/system.img#";
			logger.info("Appcreate cmd:" + cmd);
			vm.AccessAgent(cmd,server);
			resp="Appliance started in server:";
			resp = resp + server;
			resp = resp + " The app would be running on vnc port 6000, Connect and proceed"; 
		}else{
			resp="Appliance create failed check logs pleae";
		}

	%>
	<%= resp %><br>
  </body>
</html>
