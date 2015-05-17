package edu.illinois.enforcemop.examples.jbosscache;

import static org.junit.Assert.*;
import org.junit.Test;
import org.junit.Before;
import org.junit.After;

import java.util.concurrent.TimeUnit;
import EDU.oswego.cs.dl.util.concurrent.Sync;
import EDU.oswego.cs.dl.util.concurrent.ReentrantWriterPreferenceReadWriteLock;

/**
 * Tests ReentrantWriterPreferenceReadWriteLock
 * 
 * @author Bela Ban
 * @version $Id: ReentrantWriterPreferenceReadWriteLockTest.java 7295 2008-12-12
 *          08:41:33Z mircea.markus $
 */

public class ReentrantWriterPreferenceReadWriteLockTest {
  ReentrantWriterPreferenceReadWriteLock lock;
  Sync rl, wl;
  Exception thread_ex = null;

  @Before
  public void setUp() throws Exception {
    lock = new ReentrantWriterPreferenceReadWriteLock();
    rl = lock.readLock();
    wl = lock.writeLock();
    thread_ex = null;
  }

  @After
  public void tearDown() throws Exception {
    lock = null;
    if (thread_ex != null)
      throw thread_ex;
  }

  public void testMultipleReadLockAcquisitions() throws InterruptedException {
    rl.acquire();
    rl.acquire();
  }

  public void testInterruptedLockAcquisition() {
    Thread.currentThread().interrupt();
    try {
      rl.acquire();
      fail("thread should be in interrupted status");
    } catch (InterruptedException e) {
    } finally {
      try {
        rl.release();
        fail("unlock() should throw an IllegalStateException");
      } catch (IllegalMonitorStateException illegalStateEx) {
        assertTrue(true);
      }
    }
  }

  public void testMultipleWriteLockAcquisitions() throws InterruptedException {
    wl.acquire();
    wl.acquire();
  }

  public void testMultipleReadLockReleases() throws InterruptedException {
    rl.acquire();
    rl.release();
    try {
      rl.release();
      fail("we should not get here, cannot lock RL once but unlock twice");
    } catch (IllegalMonitorStateException illegalState) {
      // this is as expected
    }
  }

  public void testMultipleWriteLockReleases() throws InterruptedException {
    wl.acquire();
    wl.release();
    try {
      wl.release();
      fail("expected");
    } catch (IllegalMonitorStateException e) {
    }
  }

  public void testAcquireWriteLockAfterReadLock() throws InterruptedException {
    rl.acquire();
    rl.release();
    wl.acquire();
  }


  @Test
  //@Schedule(name = "default", value = "afterLock@lockThread->beforeCheck@main")
  public void testAcquiringReadLockedLockWithRead() throws InterruptedException {
    new Thread() {
      public void run() {
        try {
          Thread.currentThread().setName("lockThread");
          rl.acquire();
        } catch (InterruptedException e) {
        }
      }
    }.start();

    Thread.sleep(500);


    // now we have a RL by another thread
    boolean flag = rl.attempt(3000);
    assertTrue(flag);
    flag = wl.attempt(3000);
    assertFalse(flag);
  }


  @Test
  //@Schedule(name = "default", value = "afterLock@lockThread->beforeCheck@main")
  public void testAcquiringReadLockedLock() throws InterruptedException {
    new Thread() {
      public void run() {
        try {
          Thread.currentThread().setName("lockThread");
          rl.acquire();
        } catch (InterruptedException e) {
        }
      }
    }.start();

    Thread.sleep(500);
    // now we have a RL by another thread
    boolean flag = wl.attempt(3000);
    assertFalse(flag);
  }

  @Test
  //WAIT@Schedule(name = "default", value = "afterLock@Writer->afterWriterStart@main, " + 
  //WAIT   "[beforeLock:afterLock]@Reader->afterReaderStart@main,afterReaderStart@main->beforeUnlock@Writer," +
  //WAIT" afterUnlock@Writer->beforeRelease@main, " + 
  //WAIT"beforeRelease@main->beforeUnlock@Reader")
  public void testWriteThenReadByDifferentTx() throws InterruptedException {
    Writer writer = new Writer("Writer");
    Reader reader = new Reader("Reader");
    writer.start();
    Thread.sleep(500);
    reader.start();
    Thread.sleep(1000);

    //OPWAIT synchronized (writer) {
    //OPWAIT   writer.notify();
    //OPWAIT }
    Thread.sleep(500);
    //OPWAIT synchronized (reader) {
    //OPWAIT   reader.notify();
    //OPWAIT }
    writer.join();
    reader.join();
  }

  @Test
  //WAIT@Schedule(name = "default", value = "afterLock@Reader->afterReaderStart@main, " + 
  //WAIT    "[beforeLock:afterLock]@Writer->afterWriterStart@main,afterWriterStart@main->beforeUnlock@Reader," +
  //WAIT    " afterUnlock@Reader->beforeRelease@main, " + 
  //WAIT    "beforeRelease@main->beforeUnlock@Writer")
  public void testReadThenWriteByDifferentTx() throws InterruptedException {
    Writer writer = new Writer("Writer");
    Reader reader = new Reader("Reader");

    reader.start();
    Thread.sleep(500);
    writer.start();
    Thread.sleep(1000);

    //OPWAIT synchronized (reader) {
    //OPWAIT   reader.notify();
    //OPWAIT }
    Thread.sleep(500);
    //OPWAIT synchronized (writer) {
    //OPWAIT   writer.notify();
    //OPWAIT }
    writer.join();
    reader.join();
  }

  class Reader extends Thread {

    public Reader(String name) {
      super(name);
    }

    public void run() {
      try {
        rl.acquire();
        //OPWAIT synchronized (this) {
        //OPWAIT   this.wait();
        //OPWAIT }
        rl.release();
      } catch (Exception e) {
      }
    }
  }

  class Writer extends Thread {

    public Writer(String name) {
      super(name);
    }

    public void run() {
      try {
        wl.acquire();
        //OPWAIT synchronized (this) {
        //OPWAIT   this.wait();
        //OPWAIT }
        wl.release();
      } catch (Exception e) {
      }
    }
  }

  class Upgrader extends Thread {
    boolean upgradeSuccessful = false;

    public Upgrader(String name) {
      super(name);
    }

    public boolean wasUpgradeSuccessful() {
      return upgradeSuccessful;
    }

    public void run() {
      try {
        rl.acquire();
        synchronized (this) {
          this.wait();
        }
        // rl.release();
        wl.acquire();
        upgradeSuccessful = true;
        wl.release();
      } catch (Exception e) {
      }
    }
  }

}
