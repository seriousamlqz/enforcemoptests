package edu.illinois.enforcemop.utilities;
import org.junit.runner.*;
import org.junit.runner.notification.*;

public class SingleJUnitTestRunner {
    public static void main(String... args) throws ClassNotFoundException {
        String[] classAndMethod = args[0].split("#");
        Request request = Request.method(Class.forName(classAndMethod[0]),
					 classAndMethod[1]);
	long beforeTime = System.currentTimeMillis();
        Result result = new JUnitCore().run(request);
	long afterTime = System.currentTimeMillis();
	if (result.wasSuccessful()) {
	    System.out.println("Test: " + args[0] + " passed!");
	    System.out.println("Time: " +  (afterTime - beforeTime));
	} else {
	    System.out.println("Test: " + args[0] + " failed!");
	    for (Failure f : result.getFailures()) {
		System.out.println(f.getMessage());
	    }
	}
	
	// We need to comment out this line because we want to detect deadlock
	// when there is a thread left blocking there.
        // System.exit(result.wasSuccessful() ? 0 : 1);
    }
}
