package edu.illinois.enforcemop.examples.tck;

/*
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Other contributors include Andrew Wright, Jeffrey Hayes,
 * Pat Fisher, Mike Judd.
 */

import java.util.concurrent.locks.*;
import java.util.concurrent.*;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import java.io.*;
import java.util.*;

import org.junit.Before;
import org.junit.Test;

import edu.illinois.enforcemop.examples.tck.JSR166TestCase.CheckedRunnable;


public class ReentrantReadWriteLockTest extends JSR166TestCase {
//    public static void main(String[] args) {
//        junit.textui.TestRunner.run(suite());
//    }
//    public static Test suite() {
//        return new TestSuite(ReentrantReadWriteLockTest.class);
//    }

    /**
     * A runnable calling lockInterruptibly
     */
    class InterruptibleLockRunnable extends CheckedRunnable {
        final ReentrantReadWriteLock lock;
        InterruptibleLockRunnable(ReentrantReadWriteLock l) { lock = l; }
        public void realRun() throws InterruptedException {
            lock.writeLock().lockInterruptibly();
        }
    }


    /**
     * A runnable calling lockInterruptibly that expects to be
     * interrupted
     */
    class InterruptedLockRunnable extends CheckedInterruptedRunnable {
        final ReentrantReadWriteLock lock;
        InterruptedLockRunnable(ReentrantReadWriteLock l) { lock = l; }
        public void realRun() throws InterruptedException {
            lock.writeLock().lockInterruptibly();
        }
    }

    /**
     * Subclass to expose protected methods
     */
    static class PublicReentrantReadWriteLock extends ReentrantReadWriteLock {
        PublicReentrantReadWriteLock() { super(); }
        public Collection<Thread> getQueuedThreads() {
            return super.getQueuedThreads();
        }
        public Collection<Thread> getWaitingThreads(Condition c) {
            return super.getWaitingThreads(c);
        }
    }

    /**
     * write-lockInterruptibly is interruptible
     */
    @Test
    // @Schedule(name = "writeLockInterruptiblyInterrupted", sequence = "[beforeBlockLock:afterBlockLock]@lockThread->beforeInterrupt@main"
    //   + ",edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread->beforeUnlock@main")
    public void testWriteLockInterruptiblyInterrupted() throws Exception {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lockInterruptibly();
                lock.writeLock().unlock();
                lock.writeLock().lockInterruptibly();
                lock.writeLock().unlock();
            }}, "lockThread");

        lock.writeLock().lock();
        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().unlock();
        t.join();
    }

    /**
     * timed write-tryLock is interruptible
     */
    public void testWriteTryLockInterrupted() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().tryLock(SMALL_DELAY_MS, MILLISECONDS);
            }});

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        lock.writeLock().unlock();
        t.join();
    }

    /**
     * read-lockInterruptibly is interruptible
     */
    @Test
    // @Schedule(name = "readLockInterruptiblyInterrupted", sequence = "[beforeBlockLock:afterBlockLock]@lockThread->beforeInterrupt@main"
    //   + ",edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread->beforeUnlock@main")
    public void testReadLockInterruptiblyInterrupted() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.readLock().lockInterruptibly();
            }}, "lockThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().unlock();
        t.join();
    }

    /**
     * timed read-tryLock is interruptible
     */
    public void testReadTryLock_Interrupted() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.readLock().tryLock(LONG_DELAY_MS, MILLISECONDS);
            }});

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        t.join();
    }

    /**
     * A writelock succeeds after reading threads unlock
     */
    @Test
    // @Schedule(name = "writeAfterMultipleReadLocks", sequence = "[beforeWriteLock:afterWriteLock]@lockThread2->beforeUnlock@main"
    //   + ",afterUnlock@lockThread1->beforeUnlock@main")
    public void testWriteAfterMultipleReadLocks() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.readLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.readLock().unlock();
        t1.join();
        t2.join();
        assertTrue("writeAfterMultipleReadLocks", !t1.isAlive());
        assertTrue("writeAfterMultipleReadLocks", !t2.isAlive());
    }

    /**
     * Readlocks succeed after a writing thread unlocks
     */
    @Test
    // @Schedule(name = "readAfterWriteLock", sequence = "[beforeReadLock:afterReadLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeReadLock:afterReadLock]@lockThread2->beforeUnlock@main")
    public void testReadAfterWriteLock() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("readAfterWriteLock", !t1.isAlive());
        assertTrue("readAfterWriteLock", !t2.isAlive());
    }

    /**
     * Read lock succeeds if write locked by current thread even if
     * other threads are waiting for readlock
     */
    @Test
    // @Schedule(name = "readHoldingWriteLock2", sequence = "[beforeReadLock:afterReadLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeReadLock:afterReadLock]@lockThread2->beforeUnlock@main")
    public void testReadHoldingWriteLock2() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        lock.readLock().lock();
        lock.readLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.readLock().lock();
        lock.readLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("readHoldingWriteLock2", !t1.isAlive());
        assertTrue("readHoldingWriteLock2", !t2.isAlive());
    }

    /**
     * Read lock succeeds if write locked by current thread even if
     * other threads are waiting for writelock
     */
    @Test
    // @Schedule(name = "readHoldingWriteLock3", sequence = "[beforeWriteLock:afterWriteLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeWriteLock:afterWriteLock]@lockThread2->beforeUnlock@main")
    public void testReadHoldingWriteLock3() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        lock.readLock().lock();
        lock.readLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.readLock().lock();
        lock.readLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("readHoldingWriteLock3", !t1.isAlive());
        assertTrue("readHoldingWriteLock3", !t2.isAlive());
    }


    /**
     * Write lock succeeds if write locked by current thread even if
     * other threads are waiting for writelock
     */
    @Test
    // @Schedule(name = "writeHoldingWriteLock4", sequence = "[beforeWriteLock:afterWriteLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeWriteLock:afterWriteLock]@lockThread2->beforeUnlock@main")
    public void testWriteHoldingWriteLock4() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        lock.writeLock().lock();
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        lock.writeLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("writeHoldingWriteLock4", !t1.isAlive());
        assertTrue("writeHoldingWriteLock4", !t2.isAlive());
    }


    /**
     * Fair Read lock succeeds if write locked by current thread even if
     * other threads are waiting for readlock
     */
    @Test
    // @Schedule(name = "readHoldingWriteLockFair2", sequence = "[beforeReadLock:afterReadLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeReadLock:afterReadLock]@lockThread2->beforeUnlock@main")
    public void testReadHoldingWriteLockFair2() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true);
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.readLock().lock();
                lock.readLock().unlock();
            }}, "lockThread2");

        t1.start();
        t2.start();
        lock.readLock().lock();
        lock.readLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.readLock().lock();
        lock.readLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("readHoldingWriteLockFair2", !t1.isAlive());
        assertTrue("readHoldingWriteLockFair2", !t2.isAlive());
    }


    /**
     * Fair Read lock succeeds if write locked by current thread even if
     * other threads are waiting for writelock
     */
    @Test
    // @Schedule(name = "readHoldingWriteLockFair3", sequence = "[beforeWriteLock:afterWriteLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeWriteLock:afterWriteLock]@lockThread2->beforeUnlock@main")
    public void testReadHoldingWriteLockFair3() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true);
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
          public void realRun() {
              lock.writeLock().lock();
              lock.writeLock().unlock();
          }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
          }}, "lockThread2");

        t1.start();
        t2.start();
        lock.readLock().lock();
        lock.readLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.readLock().lock();
        lock.readLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("readHoldingWriteLockFair3", !t1.isAlive());
        assertTrue("readHoldingWriteLockFair3", !t2.isAlive());
    }


    /**
     * Fair Write lock succeeds if write locked by current thread even if
     * other threads are waiting for writelock
     */
    @Test
    // @Schedule(name = "writeHoldingWriteLockFair4", sequence = "[beforeWriteLock:afterWriteLock]@lockThread1->beforeUnlock@main"
    //   + ", [beforeWriteLock:afterWriteLock]@lockThread2->beforeUnlock@main")
    public void testWriteHoldingWriteLockFair4() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true);
        lock.writeLock().lock();
        Thread t1 = new Thread(new CheckedRunnable() {
          public void realRun() {
              lock.writeLock().lock();
              lock.writeLock().unlock();
          }}, "lockThread1");
        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() {
                lock.writeLock().lock();
                lock.writeLock().unlock();
          }}, "lockThread2");

        t1.start();
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("writeHoldingWriteLockFair4", lock.isWriteLockedByCurrentThread());
        assertEquals("writeHoldingWriteLockFair4", 1, lock.getWriteHoldCount());
        lock.writeLock().lock();
        assertEquals("writeHoldingWriteLockFair4", 2, lock.getWriteHoldCount());
        lock.writeLock().unlock();
        lock.writeLock().lock();
        lock.writeLock().unlock();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertTrue("writeHoldingWriteLockFair4", !t1.isAlive());
        assertTrue("writeHoldingWriteLockFair4", !t2.isAlive());
    }

    /**
     * write timed tryLock times out if locked
     */
    public void testWriteTryLock_Timeout() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                assertFalse(lock.writeLock().tryLock(1, MILLISECONDS));
            }});

        t.start();
        t.join();
        assertTrue(lock.writeLock().isHeldByCurrentThread());
        lock.writeLock().unlock();
    }

    /**
     * read timed tryLock times out if write-locked
     */
    public void testReadTryLock_Timeout() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lock();
        Thread t = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                assertFalse(lock.readLock().tryLock(1, MILLISECONDS));
            }});

        t.start();
        t.join();
        assertTrue(lock.writeLock().isHeldByCurrentThread());
        lock.writeLock().unlock();
    }


    /**
     * write lockInterruptibly succeeds if lock free else is interruptible
     */
    @Test
    // @Schedule(name = "writeLockInterruptibly", sequence = "[beforeBlockLock:afterBlockLock]@lockThread->beforeInterrupt@main"
    //   + ",edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread->beforeUnlock@main")
    public void testWriteLockInterruptibly() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lockInterruptibly();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lockInterruptibly();
            }}, "lockThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        t.join();
        lock.writeLock().unlock();
    }

    /**
     * read lockInterruptibly succeeds if lock free else is interruptible
     */
    @Test
    // @Schedule(name = "readLockInterruptibly", sequence = "[beforeBlockLock:afterBlockLock]@lockThread->beforeInterrupt@main"
    //   + ",edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread->beforeUnlock@main")
    public void testReadLockInterruptibly() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        lock.writeLock().lockInterruptibly();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lockInterruptibly();
            }}, "lockThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        t.join();
        lock.writeLock().unlock();
    }

    /**
     * await returns when signalled
     */
    @Test
    //@Schedules( { @Schedule(name = "Await", sequence = "[beforeAwait:afterAwait]@awaitThread->beforeLock@main") })
    public void testAwait() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                c.await();
                lock.writeLock().unlock();
            }}, "awaitThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        c.signal();
        lock.writeLock().unlock();
        t.join();
        //t.join();
        assertFalse("Await", t.isAlive());
    }

    /** A helper class for uninterruptible wait tests */
    class UninterruptableThread extends Thread {
        private Lock lock;
        private Condition c;

        public volatile boolean canAwake = false;
        public volatile boolean interrupted = false;
        public volatile boolean lockStarted = false;

        public UninterruptableThread(Lock lock, Condition c) {
            this.lock = lock;
            this.c = c;
        }

        public synchronized void run() {
            lock.lock();
            lockStarted = true;
            while (!canAwake) {
                c.awaitUninterruptibly();
            }

            interrupted = isInterrupted();
            lock.unlock();
        }
    }

    /**
     * awaitUninterruptibly doesn't abort on interrupt
     */
    @Test
    //@Schedules( { @Schedule(name = "awaitUninterruptibly", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeLock@main") })
    public void testAwaitUninterruptibly() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        UninterruptableThread thread = new UninterruptableThread(lock.writeLock(), c);
        thread.setName("awaitThread");
        thread.start();

        //while (!thread.lockStarted) {
        //    Thread.sleep(100);
        //}
        
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        try {
            thread.interrupt();
            thread.canAwake = true;
            c.signal();
        } finally {
            lock.writeLock().unlock();
        }

        thread.join();
        assertTrue("awaitUninterruptibly", thread.interrupted);
        assertFalse("awaitUninterruptibly", thread.isAlive());
    }

    /**
     * await is interruptible
     */
    @Test
    //@Schedules( { @Schedule(name = "AwaitInterrupt", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeInterrupt@main") })
    public void testAwaitInterrupt() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                c.await();
                lock.writeLock().unlock();
            }}, "awaitThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        t.join();
        assertFalse("AwaitInterrupt", t.isAlive());
    }

    /**
     * awaitNanos is interruptible
     */
    public void testAwaitNanos_Interrupt() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                c.awaitNanos(MILLISECONDS.toNanos(LONG_DELAY_MS));
                lock.writeLock().unlock();
            }});

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        t.join();
        assertFalse(t.isAlive());
    }

    /**
     * awaitUntil is interruptible
     */
    @Test
//    @NSchedules( { @NSchedule(name = "AwaitUntilInterrupt", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeInterrupt@main") })
    public void testAwaitUntilInterrupt() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedInterruptedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                java.util.Date d = new java.util.Date();
                c.awaitUntil(new java.util.Date(d.getTime() + 10000));
                lock.writeLock().unlock();
            }}, "awaitThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        t.interrupt();
        t.join();
        //t.join();
        assertFalse("AwaitUntilInterrupt", t.isAlive());
    }

    /**
     * signalAll wakes up all threads
     */
    @Test
    // @Schedules( { @Schedule(name = "SignalAll", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread1->beforeLock@main,"
    //     + "[awaitBlocked:afterAwaitBlocked]@awaitThread2->beforeLock@main") })
    public void testSignalAll() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t1 = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                c.await();
                lock.writeLock().unlock();
            }}, "awaitThread1");

        Thread t2 = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                c.await();
                lock.writeLock().unlock();
            }}, "awaitThread2");

        t1.start();
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        c.signalAll();
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertFalse("SignalAll", t1.isAlive());
        assertFalse("SignalAll", t2.isAlive());
    }

    /**
     * hasQueuedThreads reports whether there are waiting threads
     */
    @Test
    // @Schedules( { @Schedule(name = "HasQueuedThreads", sequence = "[beforeLock:afterLock]@lockThread1->checkHasQueued1@main,"
    //     + "[beforeLock:afterLock]@lockThread2->checkHasQueued2@main,"
    //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread1->checkHasQueued3@main,"
    //     + "afterLock@lockThread2->checkHasQueued4@main ") })
    public void testhasQueuedThreads() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        Thread t1 = new Thread(new InterruptedLockRunnable(lock));
        Thread t2 = new Thread(new InterruptibleLockRunnable(lock));
        t1.setName("lockThread1");
        t2.setName("lockThread2");
        assertFalse("HasQueuedThreads", lock.hasQueuedThreads());
        lock.writeLock().lock();
        t1.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("HasQueuedThreads", lock.hasQueuedThreads());
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("HasQueuedThreads", lock.hasQueuedThreads());
        t1.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("HasQueuedThreads", lock.hasQueuedThreads());
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        assertFalse("HasQueuedThreads", lock.hasQueuedThreads());
        t1.join();
        t2.join();
    }

    /**
     * hasQueuedThread reports whether a thread is queued.
     */
    @Test
    // @Schedules( { @Schedule(name = "HasQueuedThread", sequence = "[beforeLock:afterLock]@lockThread1->checkHasQueued1@main,"
    //     + "[beforeLock:afterLock]@lockThread2->checkHasQueued2@main,"
    //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread1->checkHasQueued3@main,"
    //     + "afterLock@lockThread2->checkHasQueued4@main ") })
    public void testHasQueuedThread() throws InterruptedException {
        final ReentrantReadWriteLock sync = new ReentrantReadWriteLock();
        Thread t1 = new Thread(new InterruptedLockRunnable(sync));
        Thread t2 = new Thread(new InterruptibleLockRunnable(sync));
        t1.setName("lockThread1");
        t2.setName("lockThread2");
        assertFalse("HasQueuedThread", sync.hasQueuedThread(t1));
        assertFalse("HasQueuedThread", sync.hasQueuedThread(t2));
        sync.writeLock().lock();
        t1.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("HasQueuedThread", sync.hasQueuedThread(t1));
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("HasQueuedThread", sync.hasQueuedThread(t1));
        assertTrue("HasQueuedThread", sync.hasQueuedThread(t2));
        t1.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        assertFalse("HasQueuedThread", sync.hasQueuedThread(t1));
        assertTrue("HasQueuedThread", sync.hasQueuedThread(t2));
        sync.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        assertFalse("HasQueuedThread", sync.hasQueuedThread(t1));
        Thread.sleep(SHORT_DELAY_MS);
        assertFalse("HasQueuedThread", sync.hasQueuedThread(t2));
        t1.join();
        t2.join();
    }


    /**
     * getQueueLength reports number of waiting threads
     */
    @Test
    // @Schedules( { @Schedule(name = "GetQueueLength", sequence = "[beforeLock:afterLock]@lockThread1->checkLength1@main,"
    //     + "[beforeLock:afterLock]@lockThread2->checkLength2@main,"
    //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread1->checkLength3@main,"
    //     + "afterLock@lockThread2->checkLength4@main ") })
    public void testGetQueueLength() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        Thread t1 = new Thread(new InterruptedLockRunnable(lock));
        Thread t2 = new Thread(new InterruptibleLockRunnable(lock));
        t1.setName("lockThread1");
        t2.setName("lockThread2");
        assertEquals("GetQueueLength", 0, lock.getQueueLength());
        lock.writeLock().lock();
        t1.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertEquals("GetQueueLength", 1, lock.getQueueLength());
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertEquals("GetQueueLength", 2, lock.getQueueLength());
        t1.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        assertEquals("GetQueueLength", 1, lock.getQueueLength());
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        assertEquals("GetQueueLength", 0, lock.getQueueLength());
        t1.join();
        t2.join();
    }

    /**
     * getQueuedThreads includes waiting threads
     */
    @Test
    // @Schedules( { @Schedule(name = "GetQueuedThreads", sequence = "[beforeLock:afterLock]@lockThread1->chekcGetThreads1@main,"
    //     + "[beforeLock:afterLock]@lockThread2->chekcGetThreads2@main,"
    //     + "edu.illinois.imunit.examples.tck.JSR166TestCase.interruptedException@lockThread1->chekcGetThreads3@main,"
    //     + "afterLock@lockThread2->chekcGetThreads4@main ") })
    public void testGetQueuedThreads() throws InterruptedException {
        final PublicReentrantReadWriteLock lock = new PublicReentrantReadWriteLock();
        Thread t1 = new Thread(new InterruptedLockRunnable(lock));
        Thread t2 = new Thread(new InterruptibleLockRunnable(lock));
        t1.setName("lockThread1");
        t2.setName("lockThread2");
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().isEmpty());
        lock.writeLock().lock();
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().isEmpty());
        t1.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().contains(t1));
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().contains(t1));
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().contains(t2));
        t1.interrupt();
        Thread.sleep(SHORT_DELAY_MS);
        assertFalse("GetQueuedThreads", lock.getQueuedThreads().contains(t1));
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().contains(t2));
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        assertTrue("GetQueuedThreads", lock.getQueuedThreads().isEmpty());
        t1.join();
        t2.join();
    }

    /**
     * hasWaiters returns true when a thread is waiting, else false
     */
    @Test
    // @Schedules( { @Schedule(name = "HasWaiters", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeLock@main,"
    //     + "afterUnlock@awaitThread->beforeSecondLock@main") })
    public void testHasWaiters() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
              lock.writeLock().lock();
              assertFalse("HasWaiters", lock.hasWaiters(c));
              assertEquals("HasWaiters", 0, lock.getWaitQueueLength(c));
              c.await();
              lock.writeLock().unlock();
            }}, "awaitThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertTrue("HasWaiters", lock.hasWaiters(c));
        assertEquals("HasWaiters", 1, lock.getWaitQueueLength(c));
        c.signal();
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertFalse("HasWaiters", lock.hasWaiters(c));
        assertEquals("HasWaiters", 0, lock.getWaitQueueLength(c));
        lock.writeLock().unlock();
        t.join();
        assertFalse("HasWaiters", t.isAlive());
    }

    /**
     * getWaitQueueLength returns number of waiting threads
     */
    @Test
    // @Schedules( { @Schedule(name = "GetWaitQueueLength", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread->beforeLock@main,"
    //     + "afterUnlock@awaitThread->beforeSecondLock@main") })
    public void testGetWaitQueueLength() throws InterruptedException {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t = new Thread(new CheckedRunnable() {
            public void realRun() throws InterruptedException {
                lock.writeLock().lock();
                assertFalse("GetWaitQueueLength", lock.hasWaiters(c));
                assertEquals("GetWaitQueueLength", 0, lock.getWaitQueueLength(c));
                c.await();
                lock.writeLock().unlock();
            }}, "awaitThread");

        t.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertTrue("GetWaitQueueLength", lock.hasWaiters(c));
        assertEquals("GetWaitQueueLength", 1, lock.getWaitQueueLength(c));
        c.signal();
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertFalse("GetWaitQueueLength", lock.hasWaiters(c));
        assertEquals("GetWaitQueueLength", 0, lock.getWaitQueueLength(c));
        lock.writeLock().unlock();
        t.join();
        assertFalse("GetWaitQueueLength", t.isAlive());
    }


    /**
     * getWaitingThreads returns only and all waiting threads
     */
    @Test
    // @Schedules( { @Schedule(name = "GetWaitingThreads", sequence = "[awaitBlocked:afterAwaitBlocked]@awaitThread1->beforeCheck@awaitThread2,"
    //     + "[awaitBlocked:afterAwaitBlocked]@awaitThread2->beforeLock@main,"
    //     + "afterUnlock@awaitThread1->beforeSecondLock@main,"
    //     + "afterUnlock@awaitThread2->beforeSecondLock@main") })
    public void testGetWaitingThreads() throws InterruptedException {
        final PublicReentrantReadWriteLock lock = new PublicReentrantReadWriteLock();
        final Condition c = lock.writeLock().newCondition();
        Thread t1 = new Thread(new CheckedRunnable() {
          public void realRun() throws InterruptedException {
            lock.writeLock().lock();
            assertTrue("GetWaitingThreads", lock.getWaitingThreads(c).isEmpty());
            c.await();
            lock.writeLock().unlock();
          }
        }, "awaitThread1");

        Thread t2 = new Thread(new CheckedRunnable() {
          public void realRun() throws InterruptedException {
            lock.writeLock().lock();
            assertFalse("GetWaitingThreads", lock.getWaitingThreads(c).isEmpty());
            c.await();
            lock.writeLock().unlock();
          }
        }, "awaitThread2");

        lock.writeLock().lock();
        assertTrue("GetWaitingThreads", lock.getWaitingThreads(c).isEmpty());
        lock.writeLock().unlock();
        t1.start();
        Thread.sleep(SHORT_DELAY_MS);
        t2.start();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertTrue("GetWaitingThreads", lock.hasWaiters(c));
        assertTrue("GetWaitingThreads", lock.getWaitingThreads(c).contains(t1));
        assertTrue("GetWaitingThreads", lock.getWaitingThreads(c).contains(t2));
        c.signalAll();
        lock.writeLock().unlock();
        Thread.sleep(SHORT_DELAY_MS);
        lock.writeLock().lock();
        assertFalse("GetWaitingThreads", lock.hasWaiters(c));
        assertTrue("GetWaitingThreads", lock.getWaitingThreads(c).isEmpty());
        lock.writeLock().unlock();
        t1.join();
        t2.join();
        assertFalse("GetWaitingThreads", t1.isAlive());
        assertFalse("GetWaitingThreads", t2.isAlive());
    }


}
