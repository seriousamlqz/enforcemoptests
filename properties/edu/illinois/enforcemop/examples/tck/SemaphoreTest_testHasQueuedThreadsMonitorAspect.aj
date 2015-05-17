package edu.illinois.enforcemop.examples.tck;
import java.util.*;
import java.util.concurrent.*;
import edu.illinois.enforcemop.examples.tck.*;
import java.util.concurrent.locks.*;
import javamoprt.*;
import java.lang.ref.*;
import org.aspectj.lang.*;

class SemaphoreTest_testHasQueuedThreadsEnforcementMonitor_Set extends javamoprt.MOPSet {
	protected SemaphoreTest_testHasQueuedThreadsEnforcementMonitor[] elementData;

	public SemaphoreTest_testHasQueuedThreadsEnforcementMonitor_Set(){
		this.size = 0;
		this.elementData = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor[4];
	}

	public final int size(){
		while(size > 0 && elementData[size-1].MOP_terminated) {
			elementData[--size] = null;
		}
		return size;
	}

	public final boolean add(MOPMonitor e){
		ensureCapacity();
		elementData[size++] = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)e;
		return true;
	}

	public final void endObject(int idnum){
		int numAlive = 0;
		for(int i = 0; i < size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = elementData[i];
			if(!monitor.MOP_terminated){
				monitor.endObject(idnum);
			}
			if(!monitor.MOP_terminated){
				elementData[numAlive++] = monitor;
			}
		}
		for(int i = numAlive; i < size; i++){
			elementData[i] = null;
		}
		size = numAlive;
	}

	public final boolean alive(){
		for(int i = 0; i < size; i++){
			MOPMonitor monitor = elementData[i];
			if(!monitor.MOP_terminated){
				return true;
			}
		}
		return false;
	}

	public final void endObjectAndClean(int idnum){
		int size = this.size;
		this.size = 0;
		for(int i = size - 1; i >= 0; i--){
			MOPMonitor monitor = elementData[i];
			if(monitor != null && !monitor.MOP_terminated){
				monitor.endObject(idnum);
			}
			elementData[i] = null;
		}
		elementData = null;
	}

	public final void ensureCapacity() {
		int oldCapacity = elementData.length;
		if (size + 1 > oldCapacity) {
			cleanup();
		}
		if (size + 1 > oldCapacity) {
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor[] oldData = elementData;
			int newCapacity = (oldCapacity * 3) / 2 + 1;
			if (newCapacity < size + 1){
				newCapacity = size + 1;
			}
			elementData = Arrays.copyOf(oldData, newCapacity);
		}
	}

	public final void cleanup() {
		int numAlive = 0 ;
		for(int i = 0; i < size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;
			}
		}
		for(int i = numAlive; i < size; i++){
			elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_beforeinterruptedacq() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_beforeinterruptedacq();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeinterruptedacq();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_beforeinterruptibleacq() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_beforeinterruptibleacq();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_beforeinterruptibleacq();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_afterinterruptiblefinish() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					boolean cloned_monitor_condition_fail = false;
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_afterinterruptiblefinish();
						if (clonedMonitor.MOP_conditionFail) {
							clonedMonitor = null;
							cloned_monitor_condition_fail = true;
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_afterinterruptiblefinish();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_nonfail) {
						monitor.Prop_1_handler_nonfail();
					}
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_afterinterruptedfinish() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					boolean cloned_monitor_condition_fail = false;
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_afterinterruptedfinish();
						if (clonedMonitor.MOP_conditionFail) {
							clonedMonitor = null;
							cloned_monitor_condition_fail = true;
							break;
						}
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_afterinterruptedfinish();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_nonfail) {
						monitor.Prop_1_handler_nonfail();
					}
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_checkone() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_checkone();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

					while (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsBlockedThread(monitor.interruptedThread)) {
						if (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsThread(monitor.interruptedThread)) {
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await(50L, TimeUnit.MILLISECONDS);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_checkone();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_checktwo() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_checktwo();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

					while (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsBlockedThread(monitor.interruptibleThread)) {
						if (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsThread(monitor.interruptibleThread)) {
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await(50L, TimeUnit.MILLISECONDS);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_checktwo();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_check() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor monitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)monitor.clone();
						clonedMonitor.Prop_1_event_check();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				monitor.Prop_1_event_check();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(monitor.Prop_1_Category_nonfail) {
					monitor.Prop_1_handler_nonfail();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}
}

class SemaphoreTest_testHasQueuedThreadsEnforcementMonitor extends javamoprt.MOPMonitor implements Cloneable, javamoprt.MOPObject {
	public Object clone() {
		try {
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor ret = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	String interruptibleThread = "";
	String interruptedThread = "";

	boolean MOP_conditionFail = false;
	int Prop_1_state;
	static final int Prop_1_transition_beforeinterruptedacq[] = {10, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10};;
	static final int Prop_1_transition_beforeinterruptibleacq[] = {10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10};;
	static final int Prop_1_transition_afterinterruptiblefinish[] = {10, 10, 7, 10, 10, 10, 10, 10, 10, 10, 10};;
	static final int Prop_1_transition_afterinterruptedfinish[] = {10, 10, 10, 6, 10, 10, 10, 10, 10, 10, 10};;
	static final int Prop_1_transition_checkone[] = {10, 10, 10, 10, 10, 10, 10, 10, 10, 8, 10};;
	static final int Prop_1_transition_checktwo[] = {10, 10, 10, 10, 10, 3, 10, 10, 10, 10, 10};;
	static final int Prop_1_transition_check[] = {1, 10, 10, 10, 10, 10, 2, 4, 10, 10, 10};;

	boolean Prop_1_Category_nonfail = false;

	public SemaphoreTest_testHasQueuedThreadsEnforcementMonitor () {
		Prop_1_state = 0;

	}

	public final void Prop_1_event_beforeinterruptedacq() {
		MOP_lastevent = 0;

		Prop_1_state = Prop_1_transition_beforeinterruptedacq[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
		{
			if (interruptedThread.equals("")) {
				interruptedThread = Thread.currentThread().getName();
			}
		}
	}

	public final void Prop_1_event_beforeinterruptibleacq() {
		MOP_lastevent = 1;

		Prop_1_state = Prop_1_transition_beforeinterruptibleacq[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
		{
			if (interruptibleThread.equals("")) {
				interruptibleThread = Thread.currentThread().getName();
			}
		}
	}

	public final void Prop_1_event_afterinterruptiblefinish() {
		if (!(Thread.currentThread().getName().equals(interruptibleThread)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 2;

		Prop_1_state = Prop_1_transition_afterinterruptiblefinish[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
	}

	public final void Prop_1_event_afterinterruptedfinish() {
		if (!(Thread.currentThread().getName().equals(interruptedThread)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 3;

		Prop_1_state = Prop_1_transition_afterinterruptedfinish[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
	}

	public final void Prop_1_event_checkone() {
		MOP_lastevent = 4;

		Prop_1_state = Prop_1_transition_checkone[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
	}

	public final void Prop_1_event_checktwo() {
		MOP_lastevent = 5;

		Prop_1_state = Prop_1_transition_checktwo[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
	}

	public final void Prop_1_event_check() {
		MOP_lastevent = 6;

		Prop_1_state = Prop_1_transition_check[Prop_1_state];
		Prop_1_Category_nonfail = Prop_1_state != 10;
	}

	public final void Prop_1_handler_nonfail (){
		{
			System.out.println("validate.");
		}

	}

	public final void reset() {
		MOP_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_nonfail = false;
	}

	static public class SemaphoreTest_testHasQueuedThreadsEnforcementMonitorDeadlockCallback implements javamoprt.MOPCallBack {
		public void apply() {
			{
				System.out.println("Deadlock happened! Please restart!");
			}
		}
	}

	public final void endObject(int idnum){
		switch(idnum){
		}
		switch(MOP_lastevent) {
			case -1:
			return;
			case 0:
			//beforeinterruptedacq
			return;
			case 1:
			//beforeinterruptibleacq
			return;
			case 2:
			//afterinterruptiblefinish
			return;
			case 3:
			//afterinterruptedfinish
			return;
			case 4:
			//checkone
			return;
			case 5:
			//checktwo
			return;
			case 6:
			//check
			return;
		}
		return;
	}

}

public aspect SemaphoreTest_testHasQueuedThreadsMonitorAspect implements javamoprt.MOPObject {
	javamoprt.map.MOPMapManager SemaphoreTest_testHasQueuedThreadsMapManager;
	public SemaphoreTest_testHasQueuedThreadsMonitorAspect(){
		Runtime.getRuntime().addShutdownHook(new SemaphoreTest_testHasQueuedThreads_DummyHookThread());
		SemaphoreTest_testHasQueuedThreadsMapManager = new javamoprt.map.MOPMapManager();
		SemaphoreTest_testHasQueuedThreadsMapManager.start();
	}

	// Declarations for the Lock
	static ReentrantLock SemaphoreTest_testHasQueuedThreads_MOPLock = new ReentrantLock();
	static Condition SemaphoreTest_testHasQueuedThreads_MOPLock_cond = SemaphoreTest_testHasQueuedThreads_MOPLock.newCondition();

	static boolean SemaphoreTest_testHasQueuedThreads_activated = false;

	// Declarations for Indexing Trees
	static SemaphoreTest_testHasQueuedThreadsEnforcementMonitor SemaphoreTest_testHasQueuedThreads_Monitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

	// Trees for References

	pointcut MOP_CommonPointCut() : !within(javamoprt.MOPObject+) && !adviceexecution();
	pointcut SemaphoreTest_testHasQueuedThreads_checkone() : (call(* Semaphore+.hasQueuedThreads(..))) && MOP_CommonPointCut();
	before () : SemaphoreTest_testHasQueuedThreads_checkone() {
		SemaphoreTest_testHasQueuedThreads_activated = true;
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		++SemaphoreTest_testHasQueuedThreads_checkone_count;
		//SemaphoreTest_testHasQueuedThreads_check
		{
			if (SemaphoreTest_testHasQueuedThreads_checkone_count >= 4 || SemaphoreTest_testHasQueuedThreads_checkone_count == 1) {
				SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

				mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

				if (mainMonitor == null) {
					mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

					SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
				}

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
						clonedMonitor.Prop_1_event_check();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

				} catch (Exception e) {
					e.printStackTrace();
				}
				mainMonitor.Prop_1_event_check();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(mainMonitor.Prop_1_Category_nonfail) {
					mainMonitor.Prop_1_handler_nonfail();
				}
			}
		}
		//SemaphoreTest_testHasQueuedThreads_checktwo
		{
			if (SemaphoreTest_testHasQueuedThreads_checkone_count == 3) {
				SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

				mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

				if (mainMonitor == null) {
					mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

					SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
				}

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
						clonedMonitor.Prop_1_event_checktwo();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

					while (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsBlockedThread(mainMonitor.interruptibleThread)) {
						if (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsThread(mainMonitor.interruptibleThread)) {
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await(50L, TimeUnit.MILLISECONDS);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				mainMonitor.Prop_1_event_checktwo();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(mainMonitor.Prop_1_Category_nonfail) {
					mainMonitor.Prop_1_handler_nonfail();
				}
			}
		}
		//SemaphoreTest_testHasQueuedThreads_checkone
		{
			if (SemaphoreTest_testHasQueuedThreads_checkone_count == 2) {
				SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

				mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

				if (mainMonitor == null) {
					mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

					SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
				}

				try {
					do {
						SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
						clonedMonitor.Prop_1_event_checkone();
						if (!clonedMonitor.Prop_1_Category_nonfail) {
							clonedMonitor = null;
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						else {
							clonedMonitor = null;
							break;
						}
					} while (true);

					while (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsBlockedThread(mainMonitor.interruptedThread)) {
						if (!SemaphoreTest_testHasQueuedThreadsMonitorAspect.containsThread(mainMonitor.interruptedThread)) {
							SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
						}
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await(50L, TimeUnit.MILLISECONDS);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				mainMonitor.Prop_1_event_checkone();
				SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
				if(mainMonitor.Prop_1_Category_nonfail) {
					mainMonitor.Prop_1_handler_nonfail();
				}
			}
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	// Declaration of the count variable for above pointcut
	static int SemaphoreTest_testHasQueuedThreads_checkone_count = 0;

	pointcut SemaphoreTest_testHasQueuedThreads_beforeinterruptibleacq() : (call(* Semaphore+.acquire(..)) && within(SemaphoreTest.InterruptibleLockRunnable+)) && MOP_CommonPointCut();
	before () : SemaphoreTest_testHasQueuedThreads_beforeinterruptibleacq() {
		SemaphoreTest_testHasQueuedThreads_activated = true;
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

		mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

		if (mainMonitor == null) {
			mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

			SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
		}

		try {
			do {
				SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
				clonedMonitor.Prop_1_event_beforeinterruptibleacq();
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					clonedMonitor = null;
					SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
				}
				else {
					clonedMonitor = null;
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		mainMonitor.Prop_1_event_beforeinterruptibleacq();
		SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
		if(mainMonitor.Prop_1_Category_nonfail) {
			mainMonitor.Prop_1_handler_nonfail();
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	pointcut SemaphoreTest_testHasQueuedThreads_beforeinterruptedacq() : (call(* Semaphore+.acquire(..)) && within(SemaphoreTest.InterruptedLockRunnable+)) && MOP_CommonPointCut();
	before () : SemaphoreTest_testHasQueuedThreads_beforeinterruptedacq() {
		SemaphoreTest_testHasQueuedThreads_activated = true;
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

		mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

		if (mainMonitor == null) {
			mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

			SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
		}

		try {
			do {
				SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
				clonedMonitor.Prop_1_event_beforeinterruptedacq();
				if (!clonedMonitor.Prop_1_Category_nonfail) {
					clonedMonitor = null;
					SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
				}
				else {
					clonedMonitor = null;
					break;
				}
			} while (true);

		} catch (Exception e) {
			e.printStackTrace();
		}
		mainMonitor.Prop_1_event_beforeinterruptedacq();
		SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
		if(mainMonitor.Prop_1_Category_nonfail) {
			mainMonitor.Prop_1_handler_nonfail();
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	pointcut SemaphoreTest_testHasQueuedThreads_afterinterruptiblefinish() : (execution(* Runnable+.run(..))) && MOP_CommonPointCut();
	after () : SemaphoreTest_testHasQueuedThreads_afterinterruptiblefinish() {
		SemaphoreTest_testHasQueuedThreads_activated = true;
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		//SemaphoreTest_testHasQueuedThreads_afterinterruptiblefinish
		{
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

			mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

			if (mainMonitor == null) {
				mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

				SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
			}

			try {
				boolean cloned_monitor_condition_fail = false;
				do {
					SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
					clonedMonitor.Prop_1_event_afterinterruptiblefinish();
					if (clonedMonitor.MOP_conditionFail) {
						clonedMonitor = null;
						cloned_monitor_condition_fail = true;
						break;
					}
					if (!clonedMonitor.Prop_1_Category_nonfail) {
						clonedMonitor = null;
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
					}
					else {
						clonedMonitor = null;
						break;
					}
				} while (true);

			} catch (Exception e) {
				e.printStackTrace();
			}
			mainMonitor.Prop_1_event_afterinterruptiblefinish();
			SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
			if(mainMonitor.MOP_conditionFail){
				mainMonitor.MOP_conditionFail = false;
			} else {
				if(mainMonitor.Prop_1_Category_nonfail) {
					mainMonitor.Prop_1_handler_nonfail();
				}
			}
		}
		//SemaphoreTest_testHasQueuedThreads_afterinterruptedfinish
		{
			SemaphoreTest_testHasQueuedThreadsEnforcementMonitor mainMonitor = null;

			mainMonitor = SemaphoreTest_testHasQueuedThreads_Monitor;

			if (mainMonitor == null) {
				mainMonitor = new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor();

				SemaphoreTest_testHasQueuedThreads_Monitor = mainMonitor;
			}

			try {
				boolean cloned_monitor_condition_fail = false;
				do {
					SemaphoreTest_testHasQueuedThreadsEnforcementMonitor clonedMonitor = (SemaphoreTest_testHasQueuedThreadsEnforcementMonitor)mainMonitor.clone();
					clonedMonitor.Prop_1_event_afterinterruptedfinish();
					if (clonedMonitor.MOP_conditionFail) {
						clonedMonitor = null;
						cloned_monitor_condition_fail = true;
						break;
					}
					if (!clonedMonitor.Prop_1_Category_nonfail) {
						clonedMonitor = null;
						SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.await();
					}
					else {
						clonedMonitor = null;
						break;
					}
				} while (true);

			} catch (Exception e) {
				e.printStackTrace();
			}
			mainMonitor.Prop_1_event_afterinterruptedfinish();
			SemaphoreTest_testHasQueuedThreadsMonitorAspect.SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
			if(mainMonitor.MOP_conditionFail){
				mainMonitor.MOP_conditionFail = false;
			} else {
				if(mainMonitor.Prop_1_Category_nonfail) {
					mainMonitor.Prop_1_handler_nonfail();
				}
			}
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	static HashMap<Thread, Runnable> SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadToRunnable = new HashMap<Thread, Runnable>();
	static Thread SemaphoreTest_testHasQueuedThreads_ThreadMonitor_MainThread = null;
	static HashSet<Thread> SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet = new HashSet<Thread>();

	static boolean containsBlockedThread(String name) {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		for (Thread t : SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet) {
			if (t.getName().equals(name)) {
				if (t.getState() == Thread.State.BLOCKED || t.getState() == Thread.State.WAITING) {
					SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
					return true;
				}
			}
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
		return false;
	}

	static boolean containsThread(String name) {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		for (Thread t : SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet) {
			if (t.getName().equals(name)) {
				SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
				return true;
			}
		}
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
		return false;
	}

	after (Runnable r) returning (Thread t): ((call(Thread+.new(Runnable+,..)) && args(r,..))|| (initialization(Thread+.new(ThreadGroup+, Runnable+,..)) && args(ThreadGroup, r,..))) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadToRunnable.put(t, r);
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	after (Thread t): ( execution(void Thread+.run()) && target(t) ) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet.remove(Thread.currentThread());
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	after (Runnable r): ( execution(void Runnable+.run()) && !execution(void Thread+.run()) && target(r) ) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet.remove(Thread.currentThread());
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	before (): (execution(void *.main(..)) ) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		if(SemaphoreTest_testHasQueuedThreads_ThreadMonitor_MainThread == null){
			SemaphoreTest_testHasQueuedThreads_ThreadMonitor_MainThread = Thread.currentThread();
			SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet.add(Thread.currentThread());
			SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
		}
		javamoprt.MOPDeadlockDetector.startDeadlockDetectionThread(SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet, SemaphoreTest_testHasQueuedThreads_ThreadMonitor_MainThread, SemaphoreTest_testHasQueuedThreads_MOPLock, new SemaphoreTest_testHasQueuedThreadsEnforcementMonitor.SemaphoreTest_testHasQueuedThreadsEnforcementMonitorDeadlockCallback());
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	after (): (execution(void *.main(..)) ) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet.remove(Thread.currentThread());
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	after (Thread t): (call(void Thread+.start()) && target(t)) && MOP_CommonPointCut() {
		while (!SemaphoreTest_testHasQueuedThreads_MOPLock.tryLock()) {
			Thread.yield();
		}
		SemaphoreTest_testHasQueuedThreads_ThreadMonitor_ThreadSet.add(t);
		SemaphoreTest_testHasQueuedThreads_MOPLock_cond.signalAll();
		SemaphoreTest_testHasQueuedThreads_MOPLock.unlock();
	}

	class SemaphoreTest_testHasQueuedThreads_DummyHookThread extends Thread {
		public void run(){
		}
	}
}
