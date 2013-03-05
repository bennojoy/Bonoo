import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import org.apache.log4j.Logger;

public class VMdbSync extends HttpServlet{

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		java.io.PrintWriter out = response.getWriter();
		out.println("<html><body>");
		String getstring = "Got a request from client:";
		getstring =  getstring + request.getQueryString();
		logger.info("VmSyncdb:" + getstring);
		logger.info("VmsyncServlet: Syncing database");
		VMstatus vm = new VMstatus();
		vm.getstatus();
		response.sendRedirect("/bonoo/listguests.jsp");
			
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
	 	doGet(request, response);
	}
}

