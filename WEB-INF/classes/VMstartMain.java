import java.io.*;
import java.net.*;
import org.apache.log4j.Logger;
public class VMstartMain {
	org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
  public int startVM(String hostname) {
	String guestoptions;
	int agentstatus,hoststatus;
	String servername;
	guestoptions = "vmstart#-enable-kvm#-daemonize";
	VMstart vm = new VMstart();
	servername = vm.serveroptions(hostname);
	HostAccessCheck  ha = new HostAccessCheck();
	try{
		logger.info("starting" + hostname + "in" + servername);
		hoststatus = ha.checkAccess(servername);
		if(hoststatus == 1){
			logger.info("In Main The host status check failed exiting...");
			return hoststatus;
		}	
	}catch(Exception e){
	}

	guestoptions = guestoptions + vm.driveOptions(hostname);
	guestoptions = guestoptions + vm.netNicOptions(hostname);
	guestoptions = guestoptions + vm.netTapOptions(hostname);
	guestoptions = guestoptions + vm.memOptions(hostname);
	guestoptions = guestoptions + vm.smpOptions(hostname);
	guestoptions = guestoptions + vm.monitorOptions(servername,hostname);
	guestoptions = guestoptions + "#";
	logger.info("In VMstart got options:");
	logger.info(guestoptions);
	try{
		this.callServerAgent(servername,guestoptions);
	}catch ( Exception e){
		System.out.println(e.getMessage());
	}
	VMupdateStatus nvm = new VMupdateStatus();
	nvm.updateRunning(hostname);
	return 0;
		 
  }
  public int callServerAgent(String servername,String cmd) throws IOException {

        Socket sock = null;
        PrintWriter out = null;
        BufferedReader in = null;

        try {
            sock = new Socket(servername, 8080);
            out = new PrintWriter(sock.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(
                                        sock.getInputStream()));
        } catch (Exception e) {
            logger.info("Starting of guest failed" + e.getMessage());
	    return 1;
        } finally {

            	out.println(cmd);
//           	in.readLine();
        	out.close();
       		in.close();
        	sock.close();
		return 0;
        }
    }

}

