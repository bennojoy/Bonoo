import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import org.apache.log4j.Logger;
public class CanooServlet extends HttpServlet{

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		java.io.PrintWriter out = response.getWriter();
		out.println("<html><body>");
		String getstring = "Got a request from client:";
		getstring =  getstring + request.getQueryString();
		logger.info("CanooServelet:" + getstring);
		String action = request.getParameter("action");
		String hostname = request.getParameter("radio");
		hostname = hostname.substring(0, hostname.indexOf('|'));
		out.println(hostname);
		if( action.equals("start")){
			logger.info("CannoServelet:Going to start VM" + hostname);
			VMstartMain vm = new VMstartMain();
			int res = vm.startVM(hostname);
			if (res == 1){
				logger.info("CanooServlet:Start failed probably server agent is not running:" + hostname);
			}else
			logger.info("CanooServlet:Start Success for host" + hostname);
		}
		if( action.equals("stop")){
			logger.info("CanooServlet: Going to Stop VM" + hostname);
			VMShutdown vm = new VMShutdown();
			int res = vm.callVMshutdown(hostname);
			if (res == 1){
				logger.info("CanooServlet:Stop failed probably server Monitor is not running:" + hostname);
			}else 
			logger.info("CanooServlet:Stop Success for host" + hostname);
			
		}
		if( action.equals("deletevm")){
			logger.info("CanooServlet: Going to Delete VM" + hostname);
			VMDelete vm = new VMDelete();
			vm.callVMDelete(hostname);
		}
		if( action.equals("sync")){
			logger.info("CanooServlet: Syncing database");
			VMstatus vm = new VMstatus();
			vm.getstatus();
		}
			
		out.println("Bonoo");
		out.println("</body></html>");
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
	 	doGet(request, response);
	}
}

