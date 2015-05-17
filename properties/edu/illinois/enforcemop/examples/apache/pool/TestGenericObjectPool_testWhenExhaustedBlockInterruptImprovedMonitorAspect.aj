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

final class TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor_Set extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitorSet<TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor> {

	TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor_Set(){
		this.size = 0;
		this.elements = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor[4];
	}
	final void event_beforeborrow() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeborrow();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeborrow();
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
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
	final void event_beforeinterrupt() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeinterrupt();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeinterrupt();
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
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
	final void event_afterfinish() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_afterfinish();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_afterfinish();
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
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
	final void event_beforereturn() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				try {
					do {
						TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)monitor.clone();
						boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforereturn();
						if (!cloned_monitor_condition_fail) {
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
						}
						else {
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforereturn();
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
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

class TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitor implements Cloneable, com.runtimeverification.rvmonitor.java.rt.RVMObject {
	protected Object clone() {
		try {
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor ret = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	String borrowThread = "";

	int Prop_1_state;
	static final int Prop_1_transition_beforeborrow[] = {1, 5, 8, 8, 8, 8, 8, 6, 8};;
	static final int Prop_1_transition_beforeinterrupt[] = {8, 8, 8, 8, 8, 3, 8, 8, 8};;
	static final int Prop_1_transition_afterfinish[] = {8, 8, 8, 2, 8, 8, 8, 8, 8};;
	static final int Prop_1_transition_beforereturn[] = {8, 8, 7, 8, 8, 8, 4, 8, 8};;

	boolean Prop_1_Category_nonfail = false;

	TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() {
		Prop_1_state = 0;

	}

	@Override
	public final int getState() {
		return Prop_1_state;
	}

	final boolean Prop_1_event_beforeborrow() {
		{
			borrowThread = Thread.currentThread().getName();
		}
		RVM_lastevent = 0;

		Prop_1_state = Prop_1_transition_beforeborrow[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 8;
		return true;
	}

	final boolean Prop_1_event_beforeinterrupt() {
		RVM_lastevent = 1;

		Prop_1_state = Prop_1_transition_beforeinterrupt[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 8;
		return true;
	}

	final boolean Prop_1_event_afterfinish() {
		{
			if (!(Thread.currentThread().getName().equals(borrowThread))) {
				return false;
			}
			{
			}
		}
		RVM_lastevent = 2;

		Prop_1_state = Prop_1_transition_afterfinish[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 8;
		return true;
	}

	final boolean Prop_1_event_beforereturn() {
		RVM_lastevent = 3;

		Prop_1_state = Prop_1_transition_beforereturn[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 8;
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

	static public class TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitorDeadlockCallback implements com.runtimeverification.rvmonitor.java.rt.RVMCallBack {
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
			//beforeinterrupt
			return;
			case 2:
			//afterfinish
			return;
			case 3:
			//beforereturn
			return;
		}
		return;
	}

	public static int getNumberOfEvents() {
		return 4;
	}

	public static int getNumberOfStates() {
		return 9;
	}

}

class TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	private static com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedMapManager;
	static {
		Runtime.getRuntime().addShutdownHook( (new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor()).new TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_DummyHookThread());
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedMapManager = new com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedMapManager.start();
	}

	// Declarations for the Lock
	static final ReentrantLock TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock = new ReentrantLock();
	static final Condition TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.newCondition();

	private static boolean TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_activated = false;

	// Declarations for Indexing Trees
	private static final TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved__Map = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() ;

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

	public static final void beforeborrowEvent() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_activated = true;
		while (!TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor created = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		try {
			do {
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeborrow();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforeborrow();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.unlock();
	}

	public static final void beforeinterruptEvent() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_activated = true;
		while (!TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor created = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		try {
			do {
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforeinterrupt();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforeinterrupt();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.unlock();
	}

	public static final void afterfinishEvent() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_activated = true;
		while (!TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor created = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		try {
			do {
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_afterfinish();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_afterfinish();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.unlock();
	}

	public static final void beforereturnEvent() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_activated = true;
		while (!TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.tryLock()) {
			Thread.yield();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor created = new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		try {
			do {
				TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor clonedMonitor = (TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor)matchedEntry.clone();
				boolean cloned_monitor_condition_fail = clonedMonitor.Prop_1_event_beforereturn();
				if (!cloned_monitor_condition_fail) {
					break;
				}
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.await();
				}
				else {
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		matchedEntry.Prop_1_event_beforereturn();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
		if(matchedEntry.Prop_1_Category_nonfail) {
			matchedEntry.Prop_1_handler_nonfail();
		}

		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.unlock();
	}

	static HashSet<Thread> TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_ThreadMonitor_ThreadSet = new HashSet<Thread>();

	public static void startDeadlockDetection() {
		while (!TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.tryLock()) {
			Thread.yield();
		}
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_ThreadMonitor_ThreadSet.add(Thread.currentThread());
		if (!com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection) {
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startDeadlockDetectionThread(TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_ThreadMonitor_ThreadSet, TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock, new TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitor.TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedEnforcementMonitorDeadlockCallback());
			com.runtimeverification.rvmonitor.java.rt.RVMDeadlockDetector.startedDeadlockDetection = true;
		}
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock_cond.signalAll();
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_RVMLock.unlock();
	}

	class TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_DummyHookThread extends Thread {
		public void run(){
		}
	}
}


public aspect TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedMonitorAspect implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	public TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedMonitorAspect(){
		Runtime.getRuntime().addShutdownHook(new TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_DummyHookThread());
	}

	// Declarations for the Lock
	static ReentrantLock TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_MOPLock = new ReentrantLock();
	static Condition TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_MOPLock_cond = TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_MOPLock.newCondition();

	pointcut MOP_CommonPointCut() : !within(com.runtimeverification.rvmonitor.java.rt.RVMObject+) && !adviceexecution();
	pointcut TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforereturn() : (call(* ObjectPool+.returnObject(..))) && MOP_CommonPointCut();
	before () : TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforereturn() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.beforereturnEvent();
	}

	pointcut TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforeinterrupt() : (call(* Thread+.interrupt(..))) && MOP_CommonPointCut();
	before () : TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforeinterrupt() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.beforeinterruptEvent();
	}

	pointcut TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforeborrow() : (call(* ObjectPool+.borrowObject(..))) && MOP_CommonPointCut();
	before () : TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_beforeborrow() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.beforeborrowEvent();
	}

	pointcut TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_afterfinish() : (execution(* Runnable+.run(..))) && MOP_CommonPointCut();
	after () : TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_afterfinish() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.afterfinishEvent();
	}

	before (): (execution(void *.main(..)) ) && MOP_CommonPointCut() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.startDeadlockDetection();
	}
	after (Thread t): (call(void Thread+.start()) && target(t)) && MOP_CommonPointCut() {
		TestGenericObjectPool_testWhenExhaustedBlockInterruptImprovedRuntimeMonitor.startDeadlockDetection();
	}

	class TestGenericObjectPool_testWhenExhaustedBlockInterruptImproved_DummyHookThread extends Thread {
		public void run(){
		}
	}
}
