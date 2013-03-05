import org.apache.log4j.Logger;
import java.io.*;
import java.sql.*;
public class VMDelete {
        public Connection connection;
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
        public VMDelete(){
		 try{
                        connection = new DBConnection().getConnection();
                }catch (Exception e){ }


        }
	public void callVMDelete(String hostname){
		Integer port;
		try {
			Statement stmt = connection.createStatement();
			String query = "select hostid from host where hostname='" + hostname + "'"; 
			ResultSet rs = stmt.executeQuery(query);
			rs.next();
			int id = rs.getInt(1);
			logger.info("VMDelete: Going to delete vm with id" + id );
			rs.close();
			String nicdelete="delete from nic where hostid=" + id;
			String tapdelete="delete from tap where hostid=" + id;
			String memdelete="delete from mem where hostid=" + id;
			String smpdelete="delete from smp where hostid=" + id;
			String hostdelete="delete from host where hostid=" + id;
			String drivedelete="delete from drive where hostid=" + id;
			stmt.executeUpdate(nicdelete);
			stmt.executeUpdate(tapdelete);
			stmt.executeUpdate(memdelete);
			stmt.executeUpdate(smpdelete);
			stmt.executeUpdate(drivedelete);
			stmt.executeUpdate(hostdelete);
			stmt.close();

		}catch (Exception e){
			logger.info("VMDelete: Deletion of vmfailed:" + e.getMessage() );
			
		}
	}

}
