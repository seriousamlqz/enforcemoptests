package edu.illinois.enforcemop.examples.boundedbuffer;

import java.util.LinkedList;

public class BoundedBuffer<T> {

  private LinkedList<T> buffer;

  private int max;

  public BoundedBuffer(int max) {
    this.max = max;
    buffer = new LinkedList<T>();
  }

  public synchronized boolean put(T e) {
    if (buffer.size() < max) {
      buffer.addLast(e);
      return true;
    }
    return false;
  }

  public synchronized T get() {
    if (!buffer.isEmpty()) {
      return buffer.removeFirst();
    }
    else {
      return null;
    }
  }

}
