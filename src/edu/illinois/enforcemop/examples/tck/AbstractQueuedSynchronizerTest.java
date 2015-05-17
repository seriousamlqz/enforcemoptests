package edu.illinois.enforcemop.examples.tck;

/*
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Other contributors include Andrew Wright, Jeffrey Hayes,
 * Pat Fisher, Mike Judd.
 */


import junit.framework.*;
import java.util.*;
import java.util.concurrent.*;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import java.util.concurrent.locks.*;
import java.io.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import edu.illinois.enforcemop.examples.tck.AbstractQueuedSynchronizerTest.BooleanLatch;
import edu.illinois.enforcemop.examples.tck.AbstractQueuedSynchronizerTest.InterruptedSyncRunnable;
import edu.illinois.enforcemop.examples.tck.AbstractQueuedSynchronizerTest.InterruptibleSyncRunnable;
import edu.illinois.enforcemop.examples.tck.AbstractQueuedSynchronizerTest.Mutex;
import edu.illinois.enforcemop.examples.tck.JSR166TestCase.CheckedInterruptedRunnable;
import edu.illinois.enforcemop.examples.tck.JSR166TestCase.CheckedRunnable;

/*
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Other contributors include Andrew Wright, Jeffrey Hayes,
 * Pat Fisher, Mike Judd.
 */

import junit.framework.*;
import java.util.*;
import java.util.concurrent.*;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import java.util.concurrent.locks.*;
import java.io.*;

public class AbstractQueuedSynchronizerTest extends JSR166TestCase {

  /**
   * A simple mutex class, adapted from the AbstractQueuedSynchronizer javadoc.
   * Exclusive acquire tests exercise this as a sample user extension. Other
   * methods/features of AbstractQueuedSynchronizerTest are tested via other
   * test classes, including those for ReentrantLock, ReentrantReadWriteLock,
   * and Semaphore
   */
  static class Mutex extends AbstractQueuedSynchronizer {
    public boolean isHeldExclusively() {
      return getState() == 1;
    }

    public boolean tryAcquire(int acquires) {
      assertEquals(1, acquires);
      return compareAndSetState(0, 1);
    }

    public boolean tryRelease(int releases) {
      if (getState() == 0)
        throw new IllegalMonitorStateException();
      setState(0);
      return true;
    }

    public AbstractQueuedSynchronizer.ConditionObject newCondition() {
      return new AbstractQueuedSynchronizer.ConditionObject();
    }

  }

  /**
   * A simple latch class, to test shared mode.
   */
  static class BooleanLatch extends AbstractQueuedSynchronizer {
    public boolean isSignalled() {
      return getState() != 0;
    }

    public int tryAcquireShared(int ignore) {
      return isSignalled() ? 1 : -1;
    }

    public boolean tryReleaseShared(int ignore) {
      setState(1);
      return true;
    }
  }

  /**
   * A runnable calling acquireInterruptibly that does not expect to be
   * interrupted.
   */
  class InterruptibleSyncRunnable extends CheckedRunnable {
    final Mutex sync;

    InterruptibleSyncRunnable(Mutex l) {
      sync = l;
    }

    public void realRun() throws InterruptedException {
      sync.acquireInterruptibly(1);
    }
  }

  /**
   * A runnable calling acquireInterruptibly that expects to be interrupted.
   */
  class InterruptedSyncRunnable extends CheckedInterruptedRunnable {
    final Mutex sync;

    InterruptedSyncRunnable(Mutex l) {
      sync = l;
    }

    public void realRun() throws InterruptedException {
      sync.acquireInterruptibly(1);
    }
  }

  /**
   * hasQueuedThreads reports whether there are waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "HasQueuedThreads", value = "[acqBlocked:afterAcq]@hasqueuedThread1->checkHasQueued1@main,"
  //     + "[acqBlocked:afterAcq]@hasqueuedThread2->checkHasQueued2@main,"
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@hasqueuedThread1->checkHasQueued3@main,"
  //     + "afterAcq@hasqueuedThread2->checkHasQueued4@main ") })
  public void testhasQueuedThreads() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "hasqueuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "hasqueuedThread2");
    assertFalse(sync.hasQueuedThreads());
    sync.acquire(1);
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasQueuedThreads", sync.hasQueuedThreads());
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasQueuedThreads", sync.hasQueuedThreads());
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasQueuedThreads", sync.hasQueuedThreads());
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasQueuedThreads", !sync.hasQueuedThreads());
    t1.join();
    t2.join();
  }

  /**
   * isQueued reports whether a thread is queued.
   */
  @Test
  // @Schedules( { @Schedule(name = "IsQueued", value = "[acqBlocked:afterAcq]@isqueuedThread1->checkIsQueued1@main,"
  //     + "[acqBlocked:afterAcq]@isqueuedThread2->checkIsQueued2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@isqueuedThread1->checkIsQueued3@main,"
  //     + "afterAcq@isqueuedThread2->checkIsQueued4@main  ") })
  public void testIsQueued() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync), "isqueuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "isqueuedThread2");
    assertFalse(sync.isQueued(t1));
    assertFalse(sync.isQueued(t2));
    sync.acquire(1);
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("IsQueued", sync.isQueued(t1));
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("IsQueued", sync.isQueued(t1));
    assertTrue("IsQueued", sync.isQueued(t2));
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("IsQueued", sync.isQueued(t1));
    assertTrue("IsQueued", sync.isQueued(t2));
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("IsQueued", sync.isQueued(t1));
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("IsQueued", sync.isQueued(t2));
    t1.join();
    t2.join();
  }

  /**
   * getFirstQueuedThread returns first waiting thread or null if none
   */
  @Test
  // @Schedules( { @Schedule(name = "GetFirstQueued", value = "[acqBlocked:afterAcq]@firstqueuedThread1->firstQueued1@main,"
  //     + "[acqBlocked:afterAcq]@firstqueuedThread2->firstQueued2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@firstqueuedThread1->firstQueued3@main,"
  //     + "afterAcq@firstqueuedThread2->firstQueued4@main  ") })
  public void testGetFirstQueuedThread() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "firstqueuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "firstqueuedThread2");
    assertNull(sync.getFirstQueuedThread());
    sync.acquire(1);
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertEquals("GetFirstQueued", t1, sync.getFirstQueuedThread());
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertEquals("GetFirstQueued", t1, sync.getFirstQueuedThread());
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    Thread.sleep(SHORT_DELAY_MS);
    assertEquals("GetFirstQueued", t2, sync.getFirstQueuedThread());
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertNull("GetFirstQueued", sync.getFirstQueuedThread());
    t1.join();
    t2.join();
  }

  /**
   * hasContended reports false if no thread has ever blocked, else true
   */
  @Test
  // @Schedules( { @Schedule(name = "HasContended", value = "[acqBlocked:afterAcq]@hascontendedThread1->hasContended1@main,"
  //     + "[acqBlocked:afterAcq]@hascontendedThread2->hasContended2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@hascontendedThread1->hasContended3@main,"
  //     + "afterAcq@hascontendedThread2->hasContended4@main  ") })
  public void testHasContended() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "hascontendedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "hascontendedThread2");
    assertFalse(sync.hasContended());
    sync.acquire(1);
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasContended", sync.hasContended());
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasContended", sync.hasContended());
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasContended", sync.hasContended());
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("HasContended", sync.hasContended());
    t1.join();
    t2.join();
  }

  /**
   * getQueuedThreads includes waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "GetQueuedThreads", value = "[acqBlocked:afterAcq]@getqueuedThread1->getQueued1@main,"
  //     + "[acqBlocked:afterAcq]@getqueuedThread2->getQueued2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@getqueuedThread1->getQueued3@main,"
  //     + "afterAcq@getqueuedThread2->getQueued4@main  ") })
  public void testGetQueuedThreads() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "getqueuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "getqueuedThread2");
    assertTrue(sync.getQueuedThreads().isEmpty());
    sync.acquire(1);
    assertTrue(sync.getQueuedThreads().isEmpty());
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetQueuedThreads", sync.getQueuedThreads().contains(t1));
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetQueuedThreads", sync.getQueuedThreads().contains(t1));
    assertTrue("GetQueuedThreads", sync.getQueuedThreads().contains(t2));
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("GetQueuedThreads", sync.getQueuedThreads().contains(t1));
    assertTrue("GetQueuedThreads", sync.getQueuedThreads().contains(t2));
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetQueuedThreads", sync.getQueuedThreads().isEmpty());
    t1.join();
    t2.join();
  }

  /**
   * getExclusiveQueuedThreads includes waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "GetExclusiveQueuedThreads", value = "[acqBlocked:afterAcq]@getexclusivequeuedThread1->getExclusiveQueued1@main,"
  //     + "[acqBlocked:afterAcq]@getexclusivequeuedThread2->getExclusiveQueued2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@getexclusivequeuedThread1->getExclusiveQueued3@main,"
  //     + "afterAcq@getexclusivequeuedThread2->getExclusiveQueued4@main  ") })
  public void testGetExclusiveQueuedThreads() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "getexclusivequeuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "getexclusivequeuedThread2");
    assertTrue(sync.getExclusiveQueuedThreads().isEmpty());
    sync.acquire(1);
    assertTrue(sync.getExclusiveQueuedThreads().isEmpty());
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().contains(t1));
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().contains(t1));
    assertTrue("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().contains(t2));
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().contains(t1));
    assertTrue("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().contains(t2));
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetExclusiveQueuedThreads",
        sync.getExclusiveQueuedThreads().isEmpty());
    t1.join();
    t2.join();
  }

  /**
   * getSharedQueuedThreads does not include exclusively waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "GetSharedQueuedThreads", value = "[acqBlocked:afterAcq]@getsharedqueuedThread1->getSharedQueued1@main,"
  //     + "[acqBlocked:afterAcq]@getsharedqueuedThread2->getSharedQueued2@main, "
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@getsharedqueuedThread1->getSharedQueued3@main,"
  //     + "afterAcq@getsharedqueuedThread2->getSharedQueued4@main  ") })
  public void testGetSharedQueuedThreads() throws InterruptedException {
    final Mutex sync = new Mutex();
    Thread t1 = new Thread(new InterruptedSyncRunnable(sync),
        "getsharedqueuedThread1");
    Thread t2 = new Thread(new InterruptibleSyncRunnable(sync),
        "getsharedqueuedThread2");
    assertTrue(sync.getSharedQueuedThreads().isEmpty());
    sync.acquire(1);
    assertTrue(sync.getSharedQueuedThreads().isEmpty());
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetSharedQueuedThreads",
        sync.getSharedQueuedThreads().isEmpty());
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetSharedQueuedThreads",
        sync.getSharedQueuedThreads().isEmpty());
    t1.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetSharedQueuedThreads",
        sync.getSharedQueuedThreads().isEmpty());
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetSharedQueuedThreads",
        sync.getSharedQueuedThreads().isEmpty());
    t1.join();
    t2.join();
  }

  /**
   * tryAcquireNanos is interruptible.
   */
  @Test
  //@Schedules( { @Schedule(name = "InterruptedException2", value = "[tryacqBlocked:blocked]@blockedthreadThread1->interrupting@main") })
  public void testInterruptedException2() throws InterruptedException {
    final Mutex sync = new Mutex();
    sync.acquire(1);
    Thread t = new Thread(new CheckedInterruptedRunnable() {
      public void realRun() throws InterruptedException {
        sync.tryAcquireNanos(1, MILLISECONDS.toNanos(MEDIUM_DELAY_MS));
      }
    }, "blockedthreadThread1");

    t.start();
    // Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    t.join();
  }

  /**
   * getState is true when acquired and false when not
   */
  @Test
  // @Schedules( { @Schedule(name = "GetState", value = "afterAcquire@acqthread->beforeCheck@main,"
  //     + "afterCheck@main->beforeRelease@acqthread") })
  public void testGetState() throws InterruptedException {
    final Mutex sync = new Mutex();
    sync.acquire(1);
    assertTrue("GetState", sync.isHeldExclusively());
    sync.release(1);
    assertFalse("GetState", sync.isHeldExclusively());
    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        Thread.sleep(SMALL_DELAY_MS);
        sync.release(1);
      }
    }, "acqthread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertTrue("GetState", sync.isHeldExclusively());
    t.join();
    assertFalse("GetState", sync.isHeldExclusively());
  }

  /**
   * acquireInterruptibly is interruptible.
   */
  @Test
  // @Schedules( { @Schedule(name = "AcquireInterruptibly1", value = "[acqBlocked:afterAcq]@acqthread->beforeInterrupt@main,"
  //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@acqthread->beforeRelease@main") })
  public void testAcquireInterruptibly1() throws InterruptedException {
    final Mutex sync = new Mutex();
    sync.acquire(1);
    Thread t = new Thread(new InterruptedSyncRunnable(sync), "acqthread");
    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    Thread.sleep(SHORT_DELAY_MS);
    sync.release(1);
    t.join();
  }

  /**
   * acquireInterruptibly succeeds when released, else is interruptible
   */
  @Test
  //@Schedules( { @Schedule(name = "AcquireInterruptibly2", value = "[acqBlocked:afterAcq]@acqthread->beforeInterrupt@main") })
  public void testAcquireInterruptibly2() throws InterruptedException {
    final Mutex sync = new Mutex();
    sync.acquireInterruptibly(1);
    Thread t = new Thread(new InterruptedSyncRunnable(sync), "acqthread");
    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    assertTrue(sync.isHeldExclusively());
    t.join();
  }

  /**
   * await returns when signalled
   */
  @Test
  //@Schedules( { @Schedule(name = "Await", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeAcquire@main") })
  public void testAwait() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        c.await();
        sync.release(1);
      }
    }, "awaitThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    c.signal();
    sync.release(1);
    t.join();
    assertFalse("Await", t.isAlive());
  }

  /**
   * hasWaiters returns true when a thread is waiting, else false
   */
  @Test
  // @Schedules( { @Schedule(name = "HasWaiters", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeAcquire@main,"
  //     + "afterRelease@awaitThread->beforeSecondAcquire@main") })
  public void testHasWaiters() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        assertFalse("HasWaiters", sync.hasWaiters(c));
        assertEquals("HasWaiters", 0, sync.getWaitQueueLength(c));
        c.await();
        sync.release(1);
      }
    }, "awaitThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertTrue("HasWaiters", sync.hasWaiters(c));
    assertEquals("HasWaiters", 1, sync.getWaitQueueLength(c));
    c.signal();
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertFalse("HasWaiters", sync.hasWaiters(c));
    assertEquals("HasWaiters", 0, sync.getWaitQueueLength(c));
    sync.release(1);
    t.join();
    assertFalse("HasWaiters", t.isAlive());
  }

  /**
   * getWaitQueueLength returns number of waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "GetWaitQueueLength", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread1->beforeAcquire@awaitThread2,"
  //     + "[awaitBlocked:afterAwaitBlocked]@awaitThread2->beforeAcquire@main,"
  //     + "afterRelease@awaitThread1->beforeSecondAcquire@main,"
  //     + "afterRelease@awaitThread2->beforeSecondAcquire@main") })
  public void testGetWaitQueueLength() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t1 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        assertFalse("GetWaitQueueLength", sync.hasWaiters(c));
        assertEquals("GetWaitQueueLength", 0, sync.getWaitQueueLength(c));
        c.await();
        sync.release(1);
      }
    }, "awaitThread1");

    Thread t2 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        assertTrue("GetWaitQueueLength", sync.hasWaiters(c));
        assertEquals("GetWaitQueueLength", 1, sync.getWaitQueueLength(c));
        c.await();
        sync.release(1);
      }
    }, "awaitThread2");

    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertTrue("GetWaitQueueLength", sync.hasWaiters(c));
    assertEquals("GetWaitQueueLength", 2, sync.getWaitQueueLength(c));
    c.signalAll();
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertFalse("GetWaitQueueLength", sync.hasWaiters(c));
    assertEquals("GetWaitQueueLength", 0, sync.getWaitQueueLength(c));
    sync.release(1);
    t1.join();
    t2.join();
    assertFalse("GetWaitQueueLength", t1.isAlive());
    assertFalse("GetWaitQueueLength", t2.isAlive());
  }

  /**
   * getWaitingThreads returns only and all waiting threads
   */
  @Test
  // @Schedules( { @Schedule(name = "GetWaitingThreads", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread1->beforeAcquire@awaitThread2,"
  //     + "[awaitBlocked:afterAwaitBlocked]@awaitThread2->beforeAcquire@main,"
  //     + "afterRelease@awaitThread1->beforeSecondAcquire@main,"
  //     + "afterRelease@awaitThread2->beforeSecondAcquire@main") })
  public void testGetWaitingThreads() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t1 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        assertTrue("GetWaitingThreads", sync.getWaitingThreads(c).isEmpty());
        c.await();
        sync.release(1);
      }
    }, "awaitThread1");

    Thread t2 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        assertFalse("GetWaitingThreads", sync.getWaitingThreads(c).isEmpty());
        c.await();
        sync.release(1);
      }
    }, "awaitThread2");

    sync.acquire(1);
    assertTrue(sync.getWaitingThreads(c).isEmpty());
    sync.release(1);
    t1.start();
    Thread.sleep(SHORT_DELAY_MS);
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertTrue("GetWaitingThreads", sync.hasWaiters(c));
    assertTrue("GetWaitingThreads", sync.getWaitingThreads(c).contains(t1));
    assertTrue("GetWaitingThreads", sync.getWaitingThreads(c).contains(t2));
    c.signalAll();
    sync.release(1);
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    assertFalse("GetWaitingThreads", sync.hasWaiters(c));
    assertTrue("GetWaitingThreads", sync.getWaitingThreads(c).isEmpty());
    sync.release(1);
    t1.join();
    t2.join();
    assertFalse("GetWaitingThreads", t1.isAlive());
    assertFalse("GetWaitingThreads", t2.isAlive());
  }

  /**
   * awaitUninterruptibly doesn't abort on interrupt
   */
  @Test
  //@Schedules( { @Schedule(name = "AwaitUninterruptibly", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeInterrupt@main") })
  public void testAwaitUninterruptibly() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() {
        sync.acquire(1);
        c.awaitUninterruptibly();
        sync.release(1);
      }
    }, "awaitThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    sync.acquire(1);
    c.signal();
    sync.release(1);
    t.join();
    assertFalse("AwaitUninterruptibly", t.isAlive());
  }

  /**
   * await is interruptible
   */
  @Test
  //@Schedules( { @Schedule(name = "AwaitInterrupt", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeInterrupt@main") })
  public void testAwaitInterrupt() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t = new Thread(new CheckedInterruptedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        c.await();
      }
    }, "awaitThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    t.join();
    assertFalse("AwaitInterrupt", t.isAlive());
  }

  /**
   * awaitUntil is interruptible
   */
  public void testAwaitUntilInterrupt() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t = new Thread(new CheckedInterruptedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        java.util.Date d = new java.util.Date();
        c.awaitUntil(new java.util.Date(d.getTime() + 10000));
      }
    }, "awaitThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    t.interrupt();
    t.join();
    assertFalse("AwaitUntilInterrupt", t.isAlive());
  }

  /**
   * signalAll wakes up all threads
   */
  @Test
  // @Schedules( { @Schedule(name = "SignalAll", value = "[awaitBlocked:afterAwaitBlocked]@awaitThread1->beforeAcquire@main,"
  //     + "[awaitBlocked:afterAwaitBlocked]@awaitThread2->beforeAcquire@main") })
  public void testSignalAll() throws InterruptedException {
    final Mutex sync = new Mutex();
    final AbstractQueuedSynchronizer.ConditionObject c = sync.newCondition();
    Thread t1 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        c.await();
        sync.release(1);
      }
    }, "awaitThread1");

    Thread t2 = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        sync.acquire(1);
        c.await();
        sync.release(1);
      }
    }, "awaitThread2");

    t1.start();
    t2.start();
    Thread.sleep(SHORT_DELAY_MS);
    sync.acquire(1);
    c.signalAll();
    sync.release(1);
    t1.join();
    t2.join();
    assertFalse("SignalAll", t1.isAlive());
    assertFalse("SignalAll", t2.isAlive());
  }

  /**
   * acquireSharedInterruptibly returns after release, but not before
   */
  @Test
  //@Schedules( { @Schedule(name = "AcquireSharedInterruptibly", value = "[acqBlocked:afteracqBlocked]@acqBlockedThread->beforeRelease@main") })
  public void testAcquireSharedInterruptibly() throws InterruptedException {
    final BooleanLatch l = new BooleanLatch();

    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        assertFalse(l.isSignalled());
        l.acquireSharedInterruptibly(0);
        assertTrue("AcquireSharedInterruptibly", l.isSignalled());
      }
    }, "acqBlockedThread");

    t.start();
    assertFalse("AcquireSharedInterruptibly", l.isSignalled());
    Thread.sleep(SHORT_DELAY_MS);
    l.releaseShared(0);
    assertTrue("AcquireSharedInterruptibly", l.isSignalled());
    t.join();
  }

  /**
   * acquireSharedInterruptibly throws IE if interrupted before released
   */
  @Test
  //@Schedules( { @Schedule(name = "default", value = "[acqBlocked:afteracqBlocked]@acqBlockedThread->beforeInterrupt@main") })
  public void testAcquireSharedInterruptiblyInterruptedException()
      throws InterruptedException {
    final BooleanLatch l = new BooleanLatch();
    Thread t = new Thread(new CheckedInterruptedRunnable() {
      public void realRun() throws InterruptedException {
        assertFalse("AcquireSharedInterruptiblyInterruptedException",
            l.isSignalled());
        l.acquireSharedInterruptibly(0);
      }
    }, "acqBlockedThread");

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("AcquireSharedInterruptiblyInterruptedException",
        l.isSignalled());
    t.interrupt();
    t.join();
  }

  /**
   * acquireSharedTimed returns after release
   */
  public void testAcquireSharedTimed() throws InterruptedException {
    final BooleanLatch l = new BooleanLatch();

    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        assertFalse(l.isSignalled());
        long nanos = MILLISECONDS.toNanos(MEDIUM_DELAY_MS);
        assertTrue(l.tryAcquireSharedNanos(0, nanos));
        assertTrue(l.isSignalled());
      }
    }, "acqBlockedThread");

    t.start();
    assertFalse(l.isSignalled());
    Thread.sleep(SHORT_DELAY_MS);
    l.releaseShared(0);
    assertTrue("AcquireSharedTimed", l.isSignalled());
    t.join();
  }

  /**
   * acquireSharedTimed throws IE if interrupted before released
   */
  public void testAcquireSharedNanos_InterruptedException()
      throws InterruptedException {
    final BooleanLatch l = new BooleanLatch();
    Thread t = new Thread(new CheckedInterruptedRunnable() {
      public void realRun() throws InterruptedException {
        assertFalse(l.isSignalled());
        long nanos = MILLISECONDS.toNanos(SMALL_DELAY_MS);
        l.tryAcquireSharedNanos(0, nanos);
      }
    });

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse("AcquireSharedNanos_InterruptedException", l.isSignalled());
    t.interrupt();
    t.join();
  }

  /**
   * acquireSharedTimed times out if not released before timeout
   */
  public void testAcquireSharedNanos_Timeout() throws InterruptedException {
    final BooleanLatch l = new BooleanLatch();
    Thread t = new Thread(new CheckedRunnable() {
      public void realRun() throws InterruptedException {
        assertFalse(l.isSignalled());
        long nanos = MILLISECONDS.toNanos(SMALL_DELAY_MS);
        assertFalse(l.tryAcquireSharedNanos(0, nanos));
      }
    });

    t.start();
    Thread.sleep(SHORT_DELAY_MS);
    assertFalse(l.isSignalled());
    t.join();
  }

}
