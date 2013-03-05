package com.bonoo;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.FileHandler;

public class BLogger{
        FileHandler handler;
	Logger logger;
	public Logger CreateLogger(){
		try { 
			boolean append = true; 
			handler = new FileHandler("/var/log/bonooweb.log", append); 
			logger = Logger.getLogger("bonoo"); 
			logger.addHandler(handler); 
		}catch(IOException e){
			System.out.println(e.getMessage());
		 } 
		return logger;
	}

        protected void finalize() throws Throwable {
             if (handler != null && logger != null) {
		 logger.removeHandler(handler);
		 handler.close();
             }
        }
}
