import java.sql.*;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.io.*;
import org.apache.log4j.Logger;

public class VMupdateStatus {
        public Connection connection;
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
        public VMupdateStatus(){
                try{
                        connection = new DBConnection().getConnection();
                }catch (Exception e){ }


        }
	public void updateRunning(String hostname){
		try {
			Statement statement = connection.createStatement();
			String query = "update host set status=1 where hostname='" + hostname + "'";
			int res = statement.executeUpdate(query); 
			logger.info("Status updated as running for " + hostname);
		}catch (Exception e){
			logger.info("Status update for host failed");
		}
	}
	public void updateShutdown(String hostname){
		try {
			Statement statement = connection.createStatement();
			String query = "update host set status=0 where hostname='" + hostname + "'";
			int res = statement.executeUpdate(query); 
			logger.info("Status updated as down for " + hostname);
		}catch (Exception e){
			logger.info("Status update for host failed");
                }

	}
	public void updateVMnic(String hostname,String action,String vlan,String model,String bridge){
		try {
			if(action.equals("nicupdate")){
				Statement niccstmt = connection.createStatement();
				String niccntquery = "select max(vlan) from nic where hostid =(select hostid from host where hostname='" + hostname + "')";
				ResultSet nicres = niccstmt.executeQuery(niccntquery);
				nicres.next();
				int niccount = nicres.getInt(1);
				niccstmt.close();
				nicres.close();
				logger.info("niccount is" + niccount + "and vlan is " + vlan); 
				if (niccount < Integer.parseInt(vlan)){
					logger.info("niccount is less adding nic");
					String hostq = "select hostid from host where hostname='" + hostname + "'";
					niccstmt = connection.createStatement();
					nicres = niccstmt.executeQuery(hostq);
					nicres.next();
					String hostid = nicres.getString(1);
					niccstmt.close();
					nicres.close();
					String addnicq = "insert into nic values('" + hostid + "','" + vlan + "','52:54:23:a2:2b:32','" + model + "')";
					niccstmt = connection.createStatement();
					logger.info("Adding nic:" + addnicq);
					int res = niccstmt.executeUpdate(addnicq); 
					niccstmt.close();
					nicres.close();
					niccstmt = connection.createStatement();
					String bridgeq = "select script from bridge where bridgeno='" + bridge + "'";
					logger.info("Bridgeq:" + bridgeq);
					nicres = niccstmt.executeQuery(bridgeq);
					nicres.next();
					String script = nicres.getString(1);
					logger.info("Script:" + script);
					niccstmt.close();
					nicres.close();
					String bridgeupdateq = "insert into tap values('" + hostid + "','" + vlan + "','" + script + "')";
					niccstmt = connection.createStatement();
					logger.info("Updating tap" + bridgeupdateq);
					res = niccstmt.executeUpdate(bridgeupdateq); 
					niccstmt.close();
				 }else{
					Statement statement = connection.createStatement();
					String query = "update nic set model='" + model +"' where hostid=(select hostid from host where hostname='" + hostname +"') and vlan='" + vlan + "'";
					int res = statement.executeUpdate(query);
					logger.info("VM NIC status updated as per query " + query);
					statement.close();
					statement = connection.createStatement();
					String bquery = "update tap set script=(select script from bridge where bridgeno='" + bridge + "') where vlan='" + vlan + "' and hostid=(select hostid from host where hostname='" + hostname + "')";
					logger.info("VM NIC status updated as per query " + bquery);
					res = statement.executeUpdate(bquery);
					statement.close();
				}

			}
			 
		}catch (Exception e){
			logger.info("NIC update Status failed" + e.getMessage());
                }

	}
	
	public void deleteVMnic( String hostname, String vlan){
		 try {
                        Statement statement = connection.createStatement();
                        String query = "delete from nic where vlan='" + vlan + "' and hostid=(select hostid from host where hostname='" + hostname + "')";
                        int res = statement.executeUpdate(query);
                        logger.info("Nic deleted as: " + query);
			statement.close();
                        statement = connection.createStatement();
                        String bquery = "delete from tap where vlan='" + vlan + "' and hostid=(select hostid from host where hostname='" + hostname + "')";
                        res = statement.executeUpdate(bquery);
                        logger.info("Tap deleted as: " + bquery);
			statement.close();	
                }catch (Exception e){
                        logger.info("Nic deletion failed" + e.getMessage());
                }
	}
	public void updateMem(String hostname,String mem){
		try {
			Statement statement = connection.createStatement();
			String query = "update mem set size='" + mem + "' where hostid=(select hostid from host where hostname='" + hostname + "')";
			logger.info("Mem updated for " + hostname + query);
			int res = statement.executeUpdate(query); 
		}catch (Exception e){
			logger.info("Memory update for host failed" + e.getMessage());
                }
	
	}
	 public void updateSmp(String hostname,String smp){
                try {
                        Statement statement = connection.createStatement();
                        String query = "update smp set ncpu='" + smp + "' where hostid=(select hostid from host where hostname='" + hostname + "')";
                        logger.info("SMP updated for " + hostname + query);
                        int res = statement.executeUpdate(query);
                }catch (Exception e){
                        logger.info("SMP update for host failed" + e.getMessage());
                }

        }

}


