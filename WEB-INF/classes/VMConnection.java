import java.io.*;
import java.net.*;
public class VMConnection {
    public static void main(String[] args) throws IOException {

        Socket sock = null;
        PrintWriter out = null;
        BufferedReader in = null;

        try {
            sock = new Socket("benpc", 8080);
            out = new PrintWriter(sock.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(
                                        sock.getInputStream()));
        } catch (UnknownHostException e) {
            System.err.println("Don't know about host:.");
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Couldn't get I/O for "
                               + "the connection to: .");
            System.exit(1);
        }

	    out.println("hello");
//	     in.readLine();

	out.close();
	in.close();
	sock.close();
    }
}

