import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import org.apache.log4j.Logger;

public class VmConfServlet extends HttpServlet{

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
		org.apache.log4j.Logger logger = Logger.getLogger("bonoo");
		java.io.PrintWriter out = response.getWriter();
		String getstring = "Got a request from client for VM update:";
		out.println("<html> </body>");
		getstring =  getstring + request.getQueryString();
		String action =  request.getParameter("action");
		VMupdateStatus vm = new VMupdateStatus();
		if (action.equals("nicupdate")){
			vm.updateVMnic(request.getParameter("vmname"),request.getParameter("action"),request.getParameter("radio"),request.getParameter("nicmodelselect"),request.getParameter("bridgeselect"));
		}else if(action.equals("nicdelete")){
			vm.deleteVMnic(request.getParameter("vmname"),request.getParameter("radio"));
		}else if(action.equals("updatemem")){
			vm.updateMem(request.getParameter("vmname"),request.getParameter("vmmemory"));
			logger.info("Called update mem");
		}else if(action.equals("updatesmp")){
			vm.updateSmp(request.getParameter("vmname"),request.getParameter("vmsmp"));
			logger.info("Called update SMP");
		}
		logger.info("Conf:" + getstring);
		out.println(getstring);
		out.println("</body></html>");
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException
	{
	 	doGet(request, response);
	}
}

