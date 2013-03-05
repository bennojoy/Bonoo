
import java.sql.*;
import org.apache.log4j.Logger;

public class DBConnection{
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
	Connection connection = null;
	public Connection getConnection()
	{

		try {
                          Class.forName("org.postgresql.Driver");
                } catch (ClassNotFoundException e) {
                        System.out.println("Where is your PostgreSQL JDBC Driver? Include in your library path!");
                        logger.info("Postgres JDBC driver not found ... check classspath and jar files..");
                }

                try {
                         connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bonoo","bonoo", "");
                } catch (SQLException e) {
                        logger.info("Connection to database failed");
                        System.out.println("Connection Failed! Check output console");
                }
		return connection;
	}
}

