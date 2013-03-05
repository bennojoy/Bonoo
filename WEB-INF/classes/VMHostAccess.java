import java.io.*;
import java.net.*;
import org.apache.log4j.Logger;

public class VMHostAccess{
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
	public String AccessAgent(String cmd, String servername ) throws IOException {
		String fresp="Failed to connect to server";
		fresp = fresp + servername;
        	Socket sock = null;
       		PrintWriter out = null;
        	BufferedReader in = null;



        try {
            sock = new Socket(servername, 8080);
            out = new PrintWriter(sock.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(
                                        sock.getInputStream()));
        } catch (UnknownHostException e) {
            logger.info("Don't know about host:." + servername);
	    return fresp;
        } catch (IOException e) {
            logger.info("Don't know about host:." + servername);
            	return fresp;
        }

        out.println(cmd);
	String res = in.readLine();
        out.close();
        in.close();
        sock.close();
	return res;
    }
}
