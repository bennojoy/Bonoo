import java.sql.*;
import java.io.*;
import org.apache.log4j.Logger;

public class VMstart {
	public Connection connection;
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
	public VMstart(){
		try{
			connection = new DBConnection().getConnection();
		}catch (Exception e){ }

	}

	public String serveroptions(String hostname){
		String result;
		try {
                        Statement statement = connection.createStatement();
                        String query = "select name from servers where hpoolid=(select hpoolid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
                        rs.next();
			logger.info("VMstart:Getting server options with query" + query);
			result = rs.getString(1);
		}catch(Exception e){
			logger.info("VMstart:get hosts server failed" + e.getMessage());
			result = "failed";

		}
		return result;
	}

        public String driveOptions(String hostname) {
		String drive = "";
                try {
                        Statement statement = connection.createStatement();
                        String query = "select * from drive where hostid=(select hostid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
			while(rs.next())
			{
				drive = drive + "#-drive file=";
				drive = drive + rs.getString(2) + ",if=";
				drive = drive + rs.getString(3);
				drive = drive + ",cache=" + rs.getString(4);
				drive = drive + ",boot=" + rs.getString(5);
			}
			
			
                	}catch (Exception e){
                        	logger.info("VMStart:Statement execution failed drive options:" + e.getMessage());
                  	}
                        return drive;

        }
        public String netNicOptions(String hostname) {
		String nic = "";
                try {
                        Statement statement = connection.createStatement();
                        String query = "select * from nic where hostid=(select hostid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
			while(rs.next())
			{
				nic = nic + "#-net nic vlan=";
				nic = nic + rs.getString(2) + ",macaddr=";
				nic = nic + rs.getString(3);
				nic = nic + ",model=" + rs.getString(4);
			}
			
			
                  }catch (Exception e){
                        	logger.info("VMStart:Statement execution failed nic options:" + e.getMessage());
                        System.out.println("Statement execution failed:" + e.getMessage());
                  }
                        return  nic;

        }
        public String netTapOptions(String hostname) {
		String tap = "";
                try {
                        Statement statement = connection.createStatement();
                        String query = "select * from tap where hostid=(select hostid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
			while(rs.next())
			{
				tap = tap + "#-net tap vlan=";
				tap = tap + rs.getString(2) + ",script=";
				tap = tap + rs.getString(3);
			}
			
			
                  }catch (Exception e){
                        	logger.info("VMStart:Statement execution failed tap options:" + e.getMessage());
                        System.out.println("Statement execution failed:" + e.getMessage());
                  }
                        return tap;

        }
        public String memOptions(String hostname) {
		String mem = "#-m ";
                try {
                        Statement statement = connection.createStatement();
                        String query = "select size from mem where hostid=(select hostid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
			rs.next();
			mem = mem + rs.getString(1);
			
                  }catch (Exception e){
                        	logger.info("VMStart:Statement execution failed mem options:" + e.getMessage());
                        System.out.println("Statement execution failed:" + e.getMessage());
                  }
                        return  mem;

        }
        public String smpOptions(String hostname) {
		String smp = "#-smp ";
                try {
                        Statement statement = connection.createStatement();
                        String query = "select ncpu from smp where hostid=(select hostid from host where hostname='" + hostname + "')";
                        ResultSet rs = statement.executeQuery(query);
			rs.next();
			smp = smp + rs.getString(1);
			
                  }catch (Exception e){
                        	logger.info("VMStart:Statement execution failed smp options:" + e.getMessage());
                        System.out.println("Statement execution failed:" + e.getMessage());
                  }
                        return smp;

        }
        public String monitorOptions(String servername,String hostname) {
		String monitor = "#-monitor tcp:localhost:";
		Integer count = 0;
		Integer hostno = 0;
		Integer startport = 4444;
                try {
                        Statement statement = connection.createStatement();
			String serverquery = "select id from servers where name='" + servername + "'";
			ResultSet serverset = statement.executeQuery(serverquery);
			serverset.next();
			int serverid = serverset.getInt(1);
			serverset.close();
			Integer maxport = 0;
			Integer result = 0;
                        String query = "select count(*) from monitor where serverid=" + serverid;
                        ResultSet rs = statement.executeQuery(query);
			rs.next();
			count = rs.getInt(1);
                       	Statement hstatement = connection.createStatement();
                       	String hquery = "select hostid from host where hostname='" + hostname + "'";
                       	ResultSet hrs = hstatement.executeQuery(hquery);
			hrs.next();
			hostno = hrs.getInt(1);
			if(count == 0){
				try {
                        		Statement updstatement = connection.createStatement();
					String updquery = "insert into monitor values(" + serverid + "," + startport + "," + hostno + ")";
					result = updstatement.executeUpdate(updquery);
					logger.info("VMStart:monitor:db updated" +  maxport + hostno );
					monitor = monitor + startport + ",server,nowait";
				}catch (Exception e){
					logger.info("VMStart:monitor:update of monitor failed");
					return "failed";
				}
				return monitor;
			}
                        Statement maxstatement = connection.createStatement();
                        String maxquery = "select max(port) from monitor where serverid=" + serverid;
                        ResultSet maxrs = maxstatement.executeQuery(maxquery);
			maxrs.next();
			maxport = maxrs.getInt(1);
			maxport++;
		  	logger.info("VMStart:monitor: port allocated:" + maxport);	
                        Statement updstatement = connection.createStatement();
			String updquery = "insert into monitor values(" + serverid + "," + maxport + "," + hostno + ")";
			result = updstatement.executeUpdate(updquery);
			logger.info("VMStart:monitor:db updated" +  maxport + hostno );
			monitor = monitor + maxport + ",server,nowait";
			logger.info("VMStart:monitor:cmd:" + monitor + maxport );
						

                  }catch (Exception e){
                       	logger.info("VMStart:Statement execution failed monitor options:" + e.getMessage());
                  }
		  return monitor;
        }

}

