<%@ page import="java.sql.*" %>
<%@ page import="com.bonoo.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
 <body>
	<%
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		String hid;
                Connection connection = null;
       		connection = (new DBConnection()).getConnection();
		Statement statement=null;
		String action = request.getParameter("action");
		ResultSet rs = null;
		if(action.equals("populatevm")){
			String[] apps;
			String uquery;
			hid = request.getParameter("hpoolid");
        		statement = connection.createStatement();
        		String query = "select param from storage where id=(select strgid from hpool where id=" + hid + ")";
        		rs = statement.executeQuery(query);
			rs.next();
			String storage = rs.getString(1);
			statement.close();
			rs.close();
		
			statement = connection.createStatement();
			String squery = "select name from servers where hpoolid=" + hid;
			rs = statement.executeQuery(squery);
                	rs.next();
                	String server = rs.getString(1);
                	statement.close();
                	rs.close();
			logger.info("In Vm populate:" + storage);
			String cmd = "vmapppopulate#" + storage + "/appliances/#"; 
			com.bonoo.VMHostAccess vm = new com.bonoo.VMHostAccess();
			String res = vm.AccessAgent(cmd,server);
			logger.info("Appliances got from server" + res);
			statement = connection.createStatement();
			String dquery = "delete from appliance where hpoolid=" + hid;
			statement.executeUpdate(dquery);
			statement.close();
			apps = res.split("#");
			statement = connection.createStatement();
			for(int i=0; i < apps.length;i++){
				uquery = "insert into appliance values(" + i + ",'" + apps[i] + "'," + hid + ")";
				logger.info("Applinace added:" + uquery);
				statement.executeUpdate(uquery);
			}
			statement.close();
			
		}else if(action.equals("isopopulate")){
			String[] isoapps;
			String isouquery;
                        hid = request.getParameter("hpoolid");
                        connection = (new DBConnection()).getConnection();
                        statement = connection.createStatement();
                        String stquery = "select param from storage where id=(select strgid from hpool where id=" + hid + ")";
                        rs = statement.executeQuery(stquery);
                        rs.next();
                        String sstorage = rs.getString(1);
                        statement.close();
                        rs.close();

                        statement = connection.createStatement();
                        String squery = "select name from servers where hpoolid=" + hid;
                        rs = statement.executeQuery(squery);
                        rs.next();
                        String sserver = rs.getString(1);
                        statement.close();
                        rs.close();
                        logger.info("In VM ISO Pool:" + sstorage);
                        String cmd = "vmisopopulate#" + sstorage + "/iso/#";
			com.bonoo.VMHostAccess vm = new com.bonoo.VMHostAccess();
                        String isores = vm.AccessAgent(cmd,sserver);
                        logger.info(" Resp got from server for ISO populate" + isores);
			statement = connection.createStatement();
                        String idquery = "delete from iso where hpoolid=" + hid;
                        statement.executeUpdate(idquery);
                        statement.close();
                        isoapps  = isores.split("#");
                        statement = connection.createStatement();
                        for(int i=0; i < isoapps.length;i++){
                                isouquery = "insert into iso values(" + i + ",'" + isoapps[i] + "'," + hid + ")";
                                logger.info("Iso added:" + isouquery);
                                statement.executeUpdate(isouquery);
                        }
                        statement.close();

		}
			
	%>
	<h1> Bonoo </h1>
</body>
</html>

