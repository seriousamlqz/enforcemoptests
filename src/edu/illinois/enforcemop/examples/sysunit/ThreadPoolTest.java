package edu.illinois.enforcemop.examples.sysunit;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.sysunit.util.ThreadPool;
import org.sysunit.util.UtilTestBase;

public class ThreadPoolTest extends UtilTestBase {
  private List touches;

  public void setUp() {
    this.touches = new ArrayList();
  }

  public void tearDown() {
    this.touches = null;
  }

  public void testStartStop() throws Exception {
    ThreadPool pool = new ThreadPool(2);

    pool.start();
    pool.stop();
  }

  @Test
  // @Schedule(name = "multipleTasks", value = "afterTouch@t1->beforeCheck@main," + 
  //     "afterTouch@t2->beforeCheck@main")
  public void testMultipleTasks() throws Exception {
    this.setUp();
    ThreadPool pool = new ThreadPool(2);

    pool.start();

    pool.addTask(new Runnable() {
      public void run() {
        try {
          Thread.sleep(3000);
        } catch (Exception e) {
          fail(e.getMessage());
        }
        Thread.currentThread().setName("t1");
        touch(Thread.currentThread());
        
      }
    });

    pool.addTask(new Runnable() {
      public void run() {
        try {
          Thread.sleep(3000);
        } catch (Exception e) {
          fail(e.getMessage());
        }
        
        Thread.currentThread().setName("t2");
        touch(Thread.currentThread());
      }
    });

    Thread.sleep(5000);

    pool.stop();

    assertEquals("no tasks left in queue", 0, pool.getQueueSize());

    Object[] touches = getTouches();

    assertLength("two touches", 2, touches);

    assertNotEquals("different threads", touches[0], touches[1]);
    this.tearDown();
  }

  void touch(Object touch) {
    this.touches.add(touch);
  }

  Object[] getTouches() {
    return this.touches.toArray();
  }
}
