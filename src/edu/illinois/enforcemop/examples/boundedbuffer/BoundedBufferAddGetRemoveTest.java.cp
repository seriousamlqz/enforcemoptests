package edu.illinois.imunit.examples.boundedbuffer;

import org.apache.commons.collections.Buffer;
import org.apache.commons.collections.buffer.BoundedBuffer;
import org.apache.commons.collections.buffer.UnboundedFifoBuffer;

import org.junit.Test;

import edu.illinois.imunit.Schedule;
import edu.illinois.imunit.Schedules;
import static edu.illinois.imunit.asserts.ScheduleAssert.*;



public class BoundedBufferAddGetRemoveTest{

  private Buffer boundedBuffer;
  private Object getResultOne;
  private Object getResultTwo;
  private Object addedOne;
  private Object addedTwo;

  public BoundedBufferAddGetRemoveTest(){
    boundedBuffer = BoundedBuffer.decorate(new UnboundedFifoBuffer(), 1);
  }
  
  @Test
  @Schedules( { 
    @Schedule(name = "TestTwoStagedAdd", sequence = "afterAddOne@addThread->beforeGetOne@getThread," +
    		"afterGetOne@getThread->beforeRemoveOne@removeThread," +
    		"afterRemoveOne@removeThread->beforeAddTwo@addThread," +
    		"afterAddTwo@addThread->beforeGetTwo@getThread")})
  public void testTwoStagedAdd(){
    
    
    Thread getThread = new Thread(new Runnable() {
      @Override
      public void run() {
        /* @Event("beforeGetOne") */
        getResultOne = boundedBuffer.get();
        /* @Event("afterGetOne") */
        /* @Event("beforeGetTwo") */
        getResultTwo = boundedBuffer.get();
      }
    }, "getThread");
    
    Thread addThread = new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("add");
        Object obj = new Object();
        if (boundedBuffer.add(obj)) {
          addedOne = obj;
        } else {
          fail("Should be able to add to buffer");
        }
        /* @Event("afterAddOne") */
        /* @Event("beforeAddTwo") */
        obj = new Object();
        if (boundedBuffer.add(obj)) {
          addedTwo = obj;
        } else {
          fail("Should be able to add to buffer");
        }
        /* @Event("afterAddTwo") */
      }
    }, "addThread");
    
    Thread removeThread = new Thread(new Runnable() {
      @Override
      public void run() {
        /* @Event("beforeRemoveOne") */
        boundedBuffer.remove();
        /* @Event("afterRemoveOne") */
      }
    }, "removeThread");
    getThread.start();
    addThread.start();
    removeThread.start();
    try {
      getThread.join();
      addThread.join();
      removeThread.join();
    } catch (InterruptedException ex) {
    }
    assertTrue("TestTwoStagedAdd", addedOne == getResultOne);
    assertTrue("TestTwoStagedAdd", addedTwo == getResultTwo);
    assertTrue("TestTwoStagedAdd", boundedBuffer.size() == 1);
  }
  


}
