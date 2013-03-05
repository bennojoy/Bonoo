import org.apache.log4j.Logger;
import java.io.*;
import java.sql.*;
public class VMShutdown {
        public Connection connection;
	Integer res;
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
        public VMShutdown(){
		 try{
                        connection = new DBConnection().getConnection();
                }catch (Exception e){ }


        }
	public int callVMshutdown(String hostname){
		Integer port;
		String monitorsucess = "vmmonitorsuccess";
		String monitorfailed = "vmmonitorfailed";
		VMstart vm = new VMstart();
		String servername = vm.serveroptions(hostname);
		try {
			Statement stmt = connection.createStatement();
			String query = "select port from monitor where hostid=(select hostid from host where hostname='" + hostname + "')";
			ResultSet rs = stmt.executeQuery(query);
			rs.next();
			port = rs.getInt(1);
			String cmd = "vmshutdown#" + port + "#system_powerdown#";
			logger.info("VMShutdown: Going to shutdown vm with command " + cmd + "on server:" + servername );
			VMHostAccess host = new VMHostAccess();
			String result = host.AccessAgent(cmd,servername);
			System.out.println(result);
			if(result.charAt(9) == 's'){
				Statement ustmt = connection.createStatement();
				String updquery = "delete from monitor where port=" + port;
				int ress = ustmt.executeUpdate(updquery);
				VMupdateStatus nvm = new VMupdateStatus();
		        	nvm.updateShutdown(hostname);
				res = 0;
			}
			if(result.charAt(9) == 'f'){
				System.out.println("comand failed" + result.charAt(9));
				logger.info("VMShutdown: the stopping failed for host Monitor port may be Wrong");
				res = 1;
			}
			stmt.close();

		}catch (Exception e){
			res = 1;
			logger.info("VMShutdown: the stopping failed for host database entry might be wrong" + e.getMessage() );
			
		}
			return res;
	}

}
