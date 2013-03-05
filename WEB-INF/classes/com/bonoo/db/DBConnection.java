package com.bonoo.db;

import java.sql.*;
import java.util.logging.*;

public class DBConnection{
	public Logger logger;
	Connection connection = null;
	public Connection getConnection()
	{
		try {
                        BLogger blog = new BLogger();
                        logger = blog.CreateLogger();
                }catch(Exception e){}

		try {
                          Class.forName("org.postgresql.Driver");
                } catch (ClassNotFoundException e) {
                        System.out.println("Where is your PostgreSQL JDBC Driver? Include in your library path!");
                        logger.info("Postgres JDBC driver not found ... check classspath and jar files..");
                }

                try {
                         connection = DriverManager.getConnection("jdbc:postgresql://192.168.0.1:5432/canoo","postgres", "");
                } catch (SQLException e) {
                        logger.info("Connection to database failed");
                        System.out.println("Connection Failed! Check output console");
                }
		return connection;
	}
}

