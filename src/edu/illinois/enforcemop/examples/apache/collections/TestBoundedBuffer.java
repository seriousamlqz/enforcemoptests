/*
 *  Copyright 2005-2006 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package edu.illinois.enforcemop.examples.apache.collections;

import org.junit.Test;
import org.apache.commons.collections.BoundedCollection;
import org.apache.commons.collections.Buffer;
import org.apache.commons.collections.BufferOverflowException;
import org.apache.commons.collections.buffer.*;

import java.util.Iterator;
import java.util.Collections;
import java.util.Arrays;

import junit.framework.TestSuite;

public class TestBoundedBuffer extends AbstractTestObject {

  public TestBoundedBuffer() {
    super("TestBoundedBuffer");
  }

  //    public static Test suite() {
  //        return new TestSuite(TestBoundedBuffer.class);
  //    }
  //
  //    public static void main(String args[]) {
  //        String[] testCaseName = { TestBoundedBuffer.class.getName() };
  //        junit.textui.TestRunner.main(testCaseName);
  //    }

  public String getCompatibilityVersion() {
    return "3.2";
  }

  public boolean isEqualsCheckable() {
    return false;
  }

  public Object makeObject() {
    return BoundedBuffer.decorate(new UnboundedFifoBuffer(), 1);
  }

  //-----------------------------------------------------------------------

  /**@TO-DO How do we handle timed events? */
  @Test
  //  @Schedule(name = "addToFullBufferRemoveViaIterator", sequence = "[beforeAdd:afterAdd]@main->beforeRemove@removeThread")
  public void testAddToFullBufferRemoveViaIterator() {
    final Buffer bounded = BoundedBuffer.decorate(new UnboundedFifoBuffer(), 1, 500);
    bounded.add( "Hello" );
    new NonDelayedIteratorRemove( bounded, 100, "removeThread" ).start();
    /* @Event("beforeAdd")*/
    bounded.add( "World" );
    /* @Event("afterAdd")*/
    assertEquals( 1, bounded.size() );
    assertEquals( "World", bounded.get() );

  }

  @Test
  //  @Schedule(name = "default", sequence = "[beforeAdd:afterAdd]@main->beforeRemove@removeThread")
  public void testAddAllToFullBufferRemoveViaIterator() {
    final Buffer bounded = BoundedBuffer.decorate(new UnboundedFifoBuffer(), 2, 500);
    bounded.add( "Hello" );
    bounded.add( "World" );
    new NonDelayedIteratorRemove( bounded, 100, 2, "removeThread" ).start();
    /* @Event("beforeAdd")*/
    bounded.addAll( Arrays.asList( new String[] { "Foo", "Bar" } ) );
    /* @Event("afterAdd")*/
    assertEquals( 2, bounded.size() );
    assertEquals( "Foo", bounded.remove() );
    assertEquals( "Bar", bounded.remove() );
  }

  @Test
  // @Schedule(name = "addToFullBufferWithTimeout", sequence = "[beforeAdd:afterAdd]@main->beforeRemove@removeThread,afterRemove@removeThread->afterAdd@main")
  public void testAddToFullBufferWithTimeout() {
    final Buffer bounded = BoundedBuffer.decorate(new UnboundedFifoBuffer(), 1, 500);
    bounded.add( "Hello" );
    new NonDelayedRemove( bounded, 100, "removeThread" ).start();
    /* @Event("beforeAdd")*/
    bounded.add( "World" );
    /* @Event("afterAdd")*/
    assertEquals( 1, bounded.size() );
    assertEquals( "World", bounded.get() );
    try {
      bounded.add( "!" );
      fail();
    }
    catch( BufferOverflowException e ) {
    }
  }

  private class NonDelayedIteratorRemove extends Thread {

    private final Buffer buffer;

    private final long delay;
    
    private final int nToRemove;

    public NonDelayedIteratorRemove(Buffer buffer, long delay, int nToRemove, String name) {
      this.buffer = buffer;
      this.nToRemove = nToRemove;
      this.delay = delay;
      this.setName(name);
    }

    public NonDelayedIteratorRemove(Buffer buffer, long delay, String name) {
      this(buffer, delay, 1, name);
    }
    

    public void run() {
      try {
//        Thread.sleep(delay);
        /* @Event("beforeRemove")*/
        Iterator iter = buffer.iterator();
        for (int i = 0; i < nToRemove; ++i) {
          iter.next();
          iter.remove();
        }
        /* @Event("afterRemove")*/
      } catch (Exception e) {
      }
    }
  }

  private class NonDelayedRemove extends Thread {

    private final Buffer buffer;

    private final int nToRemove;

    private final long delay;
    
    public NonDelayedRemove(Buffer buffer, long delay, int nToRemove, String name) {
      this.buffer = buffer;
      this.nToRemove = nToRemove;
      this.delay = delay;
      this.setName(name);
    }

    public NonDelayedRemove(Buffer buffer, long delay, String name) {
      this(buffer, delay, 1, name);
    }

    public void run() {
      try {
        //Thread.sleep(delay);
        /* @Event("beforeRemove")*/
        for (int i = 0; i < nToRemove; ++i) {
          buffer.remove();
        }
        /* @Event("afterRemove")*/
      } catch (Exception e) {
      }
    }
  }
}