<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>

<html>
 <body>
	 <%
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
                String hid = request.getParameter("hpoolid");
                String appname = request.getParameter("appname");
                String vmname = request.getParameter("vmname");
                String vmmem = request.getParameter("vmmem");
                String vmcpu = request.getParameter("vmcpu");
                String drive = request.getParameter("drive");
                String nicmodel = request.getParameter("nicmodel");
                String bridge = request.getParameter("bridge");
                Connection connection = null;
                connection = (new DBConnection()).getConnection();
                Statement statement = connection.createStatement();
                String query = "select param from storage where id=(select strgid from hpool where id=" + hid + ")";
                ResultSet rs = statement.executeQuery(query);
                rs.next();
                String storage = rs.getString(1);
		rs.close();
		String cmd = "vmcreate#mkdir " + storage + "/machines/" + vmname + "#" + "qemu-img create -b " + storage + "/appliances/" + appname + "/system.img -f qcow2 " + storage + "/machines/" + vmname + "/system.img#";
		 String squery = "select name from servers where hpoolid=" + hid;
                 rs = statement.executeQuery(squery);
                 rs.next();
                 String server = rs.getString(1);
                 statement.close();
                 rs.close();
		 com.bonoo.VMHostAccess vm = new com.bonoo.VMHostAccess();
                 String res = vm.AccessAgent(cmd,server);
		 if(res.equals("Guest creation Succedded.")){
			logger.info("In Guest creation database updation");
			statement = connection.createStatement();
			String nohidquery = "select count(*) from host";
			rs = statement.executeQuery(nohidquery);
			rs.next();
			int hostid = rs.getInt(1);
			rs.close();
			if( hostid > 0){
				String hidquery = "select max(hostid) from host";
				rs = statement.executeQuery(hidquery);
				rs.next();
				hostid = rs.getInt(1);
				hostid = hostid + 1;
				rs.close();
			}
			String hidupdate = "insert into host values(" + hostid + ",'" + vmname + "',0," + hid + ")";
			logger.info("VMcreate hosttable update:" + hidupdate);
			statement.executeUpdate(hidupdate);
			String nicupdate = "insert into nic values(" + hostid  + ",0,'52:54:a2:32:44:22','" + nicmodel + "')";
			logger.info("VMcreate nic update:" + nicupdate);
			statement.executeUpdate(nicupdate);
			String bridgeq = "select script from bridge where bridgeno='" + bridge + "'";
			logger.info("VMcreate bridge Script:" + bridgeq);
			rs = statement.executeQuery(bridgeq);
			rs.next();
			String script = rs.getString(1);
			rs.close();
			String tapupdate = "insert into tap values(" + hostid  + ",0,'" + script + "')";
			logger.info("VMcreate tap update:" + tapupdate);
			statement.executeUpdate(tapupdate);
			String driveupdate = "insert into drive values(" + hostid + ",'" + storage + "/machines/" + vmname + "/system.img','" + drive + "','writeback','on')";
			logger.info("VMcreate drive update:" + driveupdate);
			statement.executeUpdate(driveupdate);
			String memupdate = "insert into mem values(" + hostid + ",'" + vmmem + "')";
			logger.info("VMcreate mem update:" + memupdate);
			statement.executeUpdate(memupdate);
			String cpuupdate = "insert into smp values(" + hostid + ",'" + vmcpu + "')";
			logger.info("VMcreate cpu update:" + cpuupdate);
			statement.executeUpdate(cpuupdate);
			statement.close();
			
		 }
			

	%>
	<%= request.getQueryString() %><br>
	<%= cmd %><br>
	<%= res %>
  </body>
</html>
