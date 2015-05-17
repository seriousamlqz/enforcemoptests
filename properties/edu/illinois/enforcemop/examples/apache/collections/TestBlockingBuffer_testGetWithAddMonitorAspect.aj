import java.util.*;
import java.util.concurrent.*;
import org.apache.commons.collections.Buffer;
import org.apache.commons.collections.buffer.BlockingBuffer;
import java.util.concurrent.locks.*;
import java.lang.ref.*;
import com.runtimeverification.rvmonitor.java.rt.*;
import com.runtimeverification.rvmonitor.java.rt.ref.*;
import com.runtimeverification.rvmonitor.java.rt.table.*;
import com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractIndexingTree;
import com.runtimeverification.rvmonitor.java.rt.tablebase.SetEventDelegator;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TableAdopter.Tuple2;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TableAdopter.Tuple3;
import com.runtimeverification.rvmonitor.java.rt.tablebase.IDisableHolder;
import com.runtimeverification.rvmonitor.java.rt.tablebase.IMonitor;
import com.runtimeverification.rvmonitor.java.rt.tablebase.DisableHolder;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TerminatedMonitorCleaner;
import org.aspectj.lang.*;


final class TestBlockingBuffer_testGetWithAddEnforcementMonitor_Set extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitorSet<TestBlockingBuffer_testGetWithAddEnforcementMonitor> {

	TestBlockingBuffer_testGetWithAddEnforcementMonitor_Set(){
		this.size = 0;
		this.elements = new TestBlockingBuffer_testGetWithAddEnforcementMonitor[4];
	}
	final void event_beforeadd() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestBlockingBuffer_testGetWithAddEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestBlockingBuffer_testGetWithAddEnforcementMonitor clonedMonitor = (TestBlockingBuffer_testGetWithAddEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeadd();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_validation) {
							TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeadd();
				TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.signalAll();
				if(monitor.Prop_1_Category_validation) {
					monitor.Prop_1_handler_validation();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
	final void event_beforeget() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestBlockingBuffer_testGetWithAddEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestBlockingBuffer_testGetWithAddEnforcementMonitor clonedMonitor = (TestBlockingBuffer_testGetWithAddEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeget();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_validation) {
							TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeget();
				TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.signalAll();
				if(monitor.Prop_1_Category_validation) {
					monitor.Prop_1_handler_validation();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
}

class TestBlockingBuffer_testGetWithAddEnforcementMonitor extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitor implements Cloneable, com.runtimeverification.rvmonitor.java.rt.RVMObject {
	protected Object clone() {
		try {
			TestBlockingBuffer_testGetWithAddEnforcementMonitor ret = (TestBlockingBuffer_testGetWithAddEnforcementMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	String getThread = "";

	int Prop_1_state;
	static final int Prop_1_transition_beforeadd[] = {2, 1, 2, 3};;
	static final int Prop_1_transition_beforeget[] = {1, 1, 1, 3};;

	boolean Prop_1_Category_validation = false;

	TestBlockingBuffer_testGetWithAddEnforcementMonitor() {
		Prop_1_state = 0;

	}

	@Override
	public final int getState() {
		return Prop_1_state;
	}

	final boolean Prop_1_event_beforeadd() {
		RVM_lastevent = 0;

		Prop_1_state = Prop_1_transition_beforeadd[Prop_1_state];
		Prop_1_Category_validation = Prop_1_state == 1|| Prop_1_state == 0;
		return true;
	}

	final boolean Prop_1_event_beforeget() {
		{
			getThread = Thread.currentThread().getName();
		}
		RVM_lastevent = 1;

		Prop_1_state = Prop_1_transition_beforeget[Prop_1_state];
		Prop_1_Category_validation = Prop_1_state == 1|| Prop_1_state == 0;
		return true;
	}

	final void Prop_1_handler_validation (){
		{
			System.out.println("validate.");
		}

	}

	final void reset() {
		RVM_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_validation = false;
	}

	static public class TestBlockingBuffer_testGetWithAddEnforcementMonitorDeadlockCallback implements com.runtimeverification.rvmonitor.java.rt.RVMCallBack {
		public void apply() {
			{
				System.out.println("Deadlock happened! Please restart!");
			}
		}
	}

	// RVMRef_b was suppressed to reduce memory overhead

	//alive_parameters_0 = [BlockingBuffer b]
	boolean alive_parameters_0 = true;

	@Override
	protected final void terminateInternal(int idnum) {
		switch(idnum){
			case 0:
			alive_parameters_0 = false;
			break;
		}
		switch(RVM_lastevent) {
			case -1:
			return;
			case 0:
			//beforeadd
			//alive_b
			if(!(alive_parameters_0)){
				RVM_terminated = true;
				return;
			}
			break;

			case 1:
			//beforeget
			//alive_b
			if(!(alive_parameters_0)){
				RVM_terminated = true;
				return;
			}
			break;

		}
		return;
	}

	public static int getNumberOfEvents() {
		return 2;
	}

	public static int getNumberOfStates() {
		return 4;
	}

}

class TestBlockingBuffer_testGetWithAddRuntimeMonitor implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	private static com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager TestBlockingBuffer_testGetWithAddMapManager;
	static {
		Runtime.getRuntime().addShutdownHook( (new TestBlockingBuffer_testGetWithAddRuntimeMonitor()).new TestBlockingBuffer_testGetWithAdd_DummyHookThread());
		TestBlockingBuffer_testGetWithAddMapManager = new com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager();
		TestBlockingBuffer_testGetWithAddMapManager.start();
	}

	// Declarations for the Lock
	static final ReentrantLock TestBlockingBuffer_testGetWithAdd_RVMLock = new ReentrantLock();
	static final Condition TestBlockingBuffer_testGetWithAdd_RVMLock_cond = TestBlockingBuffer_testGetWithAdd_RVMLock.newCondition();

	private static boolean TestBlockingBuffer_testGetWithAdd_activated = false;

	// Declarations for Indexing Trees
	private static Object TestBlockingBuffer_testGetWithAdd_b_Map_cachekey_b;
	private static TestBlockingBuffer_testGetWithAddEnforcementMonitor TestBlockingBuffer_testGetWithAdd_b_Map_cachevalue;
	private static final MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor> TestBlockingBuffer_testGetWithAdd_b_Map = new MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor>(0) ;

	public static int cleanUp() {
		int collected = 0;
		// indexing trees
		collected += TestBlockingBuffer_testGetWithAdd_b_Map.cleanUpUnnecessaryMappings();
		return collected;
	}

	// Removing terminated monitors from partitioned sets
	static {
		TerminatedMonitorCleaner.start() ;
	}
	// Setting the behavior of the runtime library according to the compile-time option
	static {
		RuntimeOption.enableFineGrainedLock(false) ;
	}

	public static final void beforeaddEvent(BlockingBuffer b) {
		TestBlockingBuffer_testGetWithAdd_activated = true;
		while (!TestBlockingBuffer_testGetWithAdd_RVMLock.tryLock()) {
			Thread.yield();
		}

		CachedWeakReference wr_b = null;
		MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor> matchedLastMap = null;
		TestBlockingBuffer_testGetWithAddEnforcementMonitor matchedEntry = null;
		boolean cachehit = false;
		if ((b == TestBlockingBuffer_testGetWithAdd_b_Map_cachekey_b) ) {
			matchedEntry = TestBlockingBuffer_testGetWithAdd_b_Map_cachevalue;
			cachehit = true;
		}
		else {
			wr_b = new CachedWeakReference(b) ;
			{
				// FindOrCreateEntry
				MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor> itmdMap = TestBlockingBuffer_testGetWithAdd_b_Map;
				matchedLastMap = itmdMap;
				TestBlockingBuffer_testGetWithAddEnforcementMonitor node_b = TestBlockingBuffer_testGetWithAdd_b_Map.getNodeEquivalent(wr_b) ;
				matchedEntry = node_b;
			}
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			if ((wr_b == null) ) {
				wr_b = new CachedWeakReference(b) ;
			}
			// D(X) main:4
			TestBlockingBuffer_testGetWithAddEnforcementMonitor created = new TestBlockingBuffer_testGetWithAddEnforcementMonitor() ;
			matchedEntry = created;
			matchedLastMap.putNode(wr_b, created) ;
		}
		// D(X) main:8--9
		try {
			do {
				TestBlockingBuffer_testGetWithAddEnforcementMonitor clonedMonitor = (TestBlockingBuffer_testGetWithAddEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeadd();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_validation) {
					TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforeadd();
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_validation) {
			matchedEntry.Prop_1_handler_validation();
		}

		if ((cachehit == false) ) {
			TestBlockingBuffer_testGetWithAdd_b_Map_cachekey_b = b;
			TestBlockingBuffer_testGetWithAdd_b_Map_cachevalue = matchedEntry;
		}

		TestBlockingBuffer_testGetWithAdd_RVMLock.unlock();
	}

	public static final void beforegetEvent(BlockingBuffer b) {
		TestBlockingBuffer_testGetWithAdd_activated = true;
		while (!TestBlockingBuffer_testGetWithAdd_RVMLock.tryLock()) {
			Thread.yield();
		}

		CachedWeakReference wr_b = null;
		MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor> matchedLastMap = null;
		TestBlockingBuffer_testGetWithAddEnforcementMonitor matchedEntry = null;
		boolean cachehit = false;
		if ((b == TestBlockingBuffer_testGetWithAdd_b_Map_cachekey_b) ) {
			matchedEntry = TestBlockingBuffer_testGetWithAdd_b_Map_cachevalue;
			cachehit = true;
		}
		else {
			wr_b = new CachedWeakReference(b) ;
			{
				// FindOrCreateEntry
				MapOfMonitor<TestBlockingBuffer_testGetWithAddEnforcementMonitor> itmdMap = TestBlockingBuffer_testGetWithAdd_b_Map;
				matchedLastMap = itmdMap;
				TestBlockingBuffer_testGetWithAddEnforcementMonitor node_b = TestBlockingBuffer_testGetWithAdd_b_Map.getNodeEquivalent(wr_b) ;
				matchedEntry = node_b;
			}
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			if ((wr_b == null) ) {
				wr_b = new CachedWeakReference(b) ;
			}
			// D(X) main:4
			TestBlockingBuffer_testGetWithAddEnforcementMonitor created = new TestBlockingBuffer_testGetWithAddEnforcementMonitor() ;
			matchedEntry = created;
			matchedLastMap.putNode(wr_b, created) ;
		}
		// D(X) main:8--9
		try {
			do {
				TestBlockingBuffer_testGetWithAddEnforcementMonitor clonedMonitor = (TestBlockingBuffer_testGetWithAddEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeget();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_validation) {
					TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforeget();
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.TestBlockingBuffer_testGetWithAdd_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_validation) {
			matchedEntry.Prop_1_handler_validation();
		}

		if ((cachehit == false) ) {
			TestBlockingBuffer_testGetWithAdd_b_Map_cachekey_b = b;
			TestBlockingBuffer_testGetWithAdd_b_Map_cachevalue = matchedEntry;
		}

		TestBlockingBuffer_testGetWithAdd_RVMLock.unlock();
	}

	static HashSet<Thread> TestBlockingBuffer_testGetWithAdd_ThreadMonitor_ThreadSet = new HashSet<Thread>();

	public static void startDeadlockDetection() {
		while (!TestBlockingBuffer_testGetWithAdd_RVMLock.tryLock()) {
			Thread.yield();
		}
		TestBlockingBuffer_testGetWithAdd_ThreadMonitor_ThreadSet.add(Thread.currentThread());
		if (!com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection) {
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startDeadlockDetectionThread(TestBlockingBuffer_testGetWithAdd_ThreadMonitor_ThreadSet, TestBlockingBuffer_testGetWithAdd_RVMLock, new TestBlockingBuffer_testGetWithAddEnforcementMonitor.TestBlockingBuffer_testGetWithAddEnforcementMonitorDeadlockCallback());
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection = true;
		}
		TestBlockingBuffer_testGetWithAdd_RVMLock_cond.signalAll();
		TestBlockingBuffer_testGetWithAdd_RVMLock.unlock();
	}

	class TestBlockingBuffer_testGetWithAdd_DummyHookThread extends Thread {
		public void run(){
		}
	}
}



public aspect TestBlockingBuffer_testGetWithAddMonitorAspect implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	public TestBlockingBuffer_testGetWithAddMonitorAspect(){
		Runtime.getRuntime().addShutdownHook(new TestBlockingBuffer_testGetWithAdd_DummyHookThread());
	}

	// Declarations for the Lock
	static ReentrantLock TestBlockingBuffer_testGetWithAdd_MOPLock = new ReentrantLock();
	static Condition TestBlockingBuffer_testGetWithAdd_MOPLock_cond = TestBlockingBuffer_testGetWithAdd_MOPLock.newCondition();

	pointcut MOP_CommonPointCut() : !within(com.runtimeverification.rvmonitor.java.rt.RVMObject+) && !adviceexecution();
	pointcut TestBlockingBuffer_testGetWithAdd_beforeget(BlockingBuffer b) : (call(* Buffer+.get(..)) && target(b)) && MOP_CommonPointCut();
	before (BlockingBuffer b) : TestBlockingBuffer_testGetWithAdd_beforeget(b) {
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.beforegetEvent(b);
	}

	pointcut TestBlockingBuffer_testGetWithAdd_beforeadd(BlockingBuffer b) : (call(* Buffer+.add(..)) && target(b)) && MOP_CommonPointCut();
	before (BlockingBuffer b) : TestBlockingBuffer_testGetWithAdd_beforeadd(b) {
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.beforeaddEvent(b);
	}

	before (): (execution(void *.main(..)) ) && MOP_CommonPointCut() {
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.startDeadlockDetection();
	}
	after (Thread t): (call(void Thread+.start()) && target(t)) && MOP_CommonPointCut() {
		TestBlockingBuffer_testGetWithAddRuntimeMonitor.startDeadlockDetection();
	}

	class TestBlockingBuffer_testGetWithAdd_DummyHookThread extends Thread {
		public void run(){
		}
	}
}
