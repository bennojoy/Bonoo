import org.apache.log4j.Logger;
import java.io.*;
import java.sql.*;
public class VMstatus {
        public Connection connection;
	Integer res;
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
        public VMstatus(){
		 try{
                        connection = new DBConnection().getConnection();
                }catch (Exception e){ }


        }
	public int getstatus(){
		Integer port;
		String hquery;
		String dquery;
		String server;
		res = 0;	
		String monitorsucess = "vmmonitorsuccess";
		String monitorfailed = "vmmonitorfailed";
		ResultSet rst;
		Statement statement;
		try {
			Statement stmt = connection.createStatement();
			statement = connection.createStatement();
			String query = "select hostid from host where status=1";
			ResultSet rs = stmt.executeQuery(query);
			while(rs.next()){
				int hostid = rs.getInt(1);
				hquery = "select a.port,b.name from monitor a,servers b where a.hostid=" + hostid;
				rst = statement.executeQuery(hquery);
				rst.next();
				port = rst.getInt(1);
				server = rst.getString(2);
				String cmd = "vmstatus#" + port + "#info status#";
				VMHostAccess host = new VMHostAccess(); 
				String result = host.AccessAgent(cmd,server);
				logger.info("Checking status for server" + cmd + server);
				if(result.charAt(9) == 'f'){
					dquery="delete from monitor where hostid=" + hostid;
					statement.executeUpdate(dquery);
					logger.info("Status check failed deleting" + dquery);
					dquery="update host set status=0 where hostid=" + hostid;
					statement.executeUpdate(dquery);
				} 
				System.out.println(result);
				

			}
		}catch (Exception e){
			res = 1;
			logger.info("VMStatus: the stopping failed for host database entry might be wrong" + e.getMessage() );
			
		}
			return res;
	}

}
