package edu.illinois.enforcemop.examples.apache.pool;
import java.util.*;
import java.util.concurrent.*;
import static org.junit.Assert.*;
import org.junit.Assert;
import org.apache.commons.pool.*;
import org.apache.commons.pool.impl.*;
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

final class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor_Set extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitorSet<TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor> {

	TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor_Set(){
		this.size = 0;
		this.elements = new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor[4];
	}
	final void event_beforeborrow() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_beforeborrow();
				TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
	final void event_beforemainborrow() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor clonedMonitor = (TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforemainborrow();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforemainborrow();
				TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
}

class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitor implements Cloneable, com.runtimeverification.rvmonitor.java.rt.RVMObject {
	protected Object clone() {
		try {
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor ret = (TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	String borrowThread = "borrowThread";

	int Prop_1_state;
	static final int Prop_1_transition_beforeborrow[] = {1, 3, 3, 3};;
	static final int Prop_1_transition_beforemainborrow[] = {3, 2, 3, 3};;

	boolean Prop_1_Category_nonfail = false;

	TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor() {
		Prop_1_state = 0;

	}

	@Override
	public final int getState() {
		return Prop_1_state;
	}

	final boolean Prop_1_event_beforeborrow() {
		{
			if (!(Thread.currentThread().getName().equals(borrowThread))) {
				return false;
			}
			{
				System.out.println("beforeborrow");
			}
		}
		RVM_lastevent = 0;

		Prop_1_state = Prop_1_transition_beforeborrow[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 3;
		return true;
	}

	final boolean Prop_1_event_beforemainborrow() {
		{
			if (!(Thread.currentThread().getName().equals("main"))) {
				return false;
			}
			{
				System.out.println("beforemainborrow");
			}
		}
		RVM_lastevent = 1;

		Prop_1_state = Prop_1_transition_beforemainborrow[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 3;
		return true;
	}

	final void Prop_1_handler_nonfail (){
		{
			System.out.println("validate.");
		}

	}

	final void reset() {
		RVM_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_nonfail = false;
	}

	static public class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitorDeadlockCallback implements com.runtimeverification.rvmonitor.java.rt.RVMCallBack {
		public void apply() {
			{
				System.out.println("Deadlock happened! Please restart!");
			}
		}
	}

	@Override
	protected final void terminateInternal(int idnum) {
		switch(idnum){
		}
		switch(RVM_lastevent) {
			case -1:
			return;
			case 0:
			//beforeborrow
			return;
			case 1:
			//beforemainborrow
			return;
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

class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	private static com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedMapManager;
	static {
		Runtime.getRuntime().addShutdownHook( (new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor()).new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_DummyHookThread());
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedMapManager = new com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager();
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedMapManager.start();
	}

	// Declarations for the Lock
	static final ReentrantLock TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock = new ReentrantLock();
	static final Condition TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond = TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.newCondition();

	private static boolean TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_activated = false;

	// Declarations for Indexing Trees
	private static final TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved__Map = new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor() ;

	public static int cleanUp() {
		int collected = 0;
		// indexing trees
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

	public static void beforeborrowBlockingEvent() {
		com.runtimeverification.rvmonitor.java.rt.concurrent.BlockingEventThread beforeborrowBlockingEvent_thread = new com.runtimeverification.rvmonitor.java.rt.concurrent.BlockingEventThread("beforeborrow") {
			public void execEvent() {
				beforeborrowEvent();
			}
		};
		beforeborrowBlockingEvent_thread.start();
	}

	private static final void beforeborrowEvent() {
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_activated = true;
		while (!TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor created = new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		matchedEntry.Prop_1_event_beforeborrow();
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.unlock();
	}

	public static final void beforemainborrowEvent() {
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_activated = true;
		while (!TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor created = new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		try {
			do {
				TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor clonedMonitor = (TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforemainborrow();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforemainborrow();
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.unlock();
	}

	static HashSet<Thread> TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_ThreadMonitor_ThreadSet = new HashSet<Thread>();

	public static void startDeadlockDetection() {
		while (!TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.tryLock()) {
			Thread.yield();
		}
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_ThreadMonitor_ThreadSet.add(Thread.currentThread());
		if (!com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection) {
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startDeadlockDetectionThread(TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_ThreadMonitor_ThreadSet, TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock, new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitor.TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedEnforcementMonitorDeadlockCallback());
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection = true;
		}
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock_cond.signalAll();
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_RVMLock.unlock();
	}

	class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_DummyHookThread extends Thread {
		public void run(){
		}
	}
}


public aspect TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedMonitorAspect implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	public TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedMonitorAspect(){
		Runtime.getRuntime().addShutdownHook(new TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_DummyHookThread());
	}

	// Declarations for the Lock
	static ReentrantLock TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_MOPLock = new ReentrantLock();
	static Condition TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_MOPLock_cond = TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_MOPLock.newCondition();

	pointcut MOP_CommonPointCut() : !within(com.runtimeverification.rvmonitor.java.rt.RVMObject+) && !adviceexecution();
	pointcut TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow() : (call(* KeyedObjectPool+.borrowObject(..))) && MOP_CommonPointCut();
	before () : TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow() {
		//TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforemainborrow
		++TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow_count;
		if (TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow_count > 1) {
			TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.beforemainborrowEvent();
		}
		//TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.beforeborrowBlockingEvent();
	}

	// Declaration of the count variable for above pointcut
	static int TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_beforeborrow_count = 0;

	before (): (execution(void *.main(..)) ) && MOP_CommonPointCut() {
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.startDeadlockDetection();
	}
	after (Thread t): (call(void Thread+.start()) && target(t)) && MOP_CommonPointCut() {
		TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImprovedRuntimeMonitor.startDeadlockDetection();
	}

	class TestGenericKeyedObjectPool_testBlockedKeyDoesNotBlockPoolImproved_DummyHookThread extends Thread {
		public void run(){
		}
	}
}
