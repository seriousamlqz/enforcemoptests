package edu.illinois.enforcemop.examples.boundedbuffer;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class BoundedBufferTest {

  public static class Box<T> {
    public T val;
  }
  
  private Box<Integer> box;
  private BoundedBuffer<Integer> bb;
  
  @Before
  public void setUp() {
    bb = new BoundedBuffer<Integer>(1);
    box = new Box<Integer>();
  }

  @Test
  // @Schedules({
  //     @Schedule(name = "GetBeforePut", sequence = "afterGet->put"),
  //     @Schedule(name = "PutBeforeGet", sequence = "afterPut@putThread->get@getThread") })
  public void testGetAndPut() {
    Thread getThread = new Thread(new Runnable() {
      @Override
      public void run() {
        box.val = bb.get();
	System.out.println(box.val);
      }
    }, "getThread");

    Thread putThread = new Thread(new Runnable() {
      @Override
      public void run() {
        boolean ret;
        ret = bb.put(3);
        assertTrue(ret);
      }
    }, "putThread");

    getThread.start();
    putThread.start();
    try {
      getThread.join();
      putThread.join();
    } catch (InterruptedException ex) {
    }

  }

    public static void main (String args[]) {
	BoundedBufferTest bbt = new BoundedBufferTest();
	bbt.setUp();
	bbt.testGetAndPut();
    }
  
}
