import java.io.*;
import java.net.*;
import org.apache.log4j.Logger;

public class HostAccessCheck{
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
	int res;
	public int checkAccess(String host) throws IOException {
        Socket sock = null;
        PrintWriter out = null;
        BufferedReader in = null;
	String cmd="test#";
        try {
            sock = new Socket(host, 8080);
            out = new PrintWriter(sock.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(
                                        sock.getInputStream()));
	   logger.info("HostAccessCheck for server:" + host);
        } catch (Exception e) {
             logger.info("HostAccessCheck failed" + e.getMessage());
             res = 1;
             return res;
        } 

                out.println(cmd);
                out.close();
                in.close();
                sock.close();
		res = 0;
                return res;
        
    }
}
