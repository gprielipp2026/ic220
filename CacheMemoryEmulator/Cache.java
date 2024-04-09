import java.util.*;

public class Cache<T> implements Iterable<T>
{
  private int cacheSize; // N
  private int blockSize; // B
  private int rowsPerInd;// k
  private Evictor<T> evictor;
  private Entry<T>[][][] memory;

  public Cache(int N, int B, int k, String evictionProtocol)
  {
    // check to make sure N, B, k are powers of 2
    // && k <= B <= N

    cacheSize = N;
    blockSize = B;
    rowsPerInd= k;

    evictor = EvictorCollection.newEvictor(evictionProtocol);

    memory = new T[cacheSize / (blockSize * rowsPerInd)][rowsPerInd][blockSize];
  }

  private int offset(int addr)
  {
    return addr % blockSize;
  }

  private int localAddr(int addr)
  {
    return Math.floor(addr / blockSize) % (cacheSize / (rowsPerInd * blockSize));
  }

  public T get(int addr)
  {
    int id = localAddr(addr);
    int off = offset(addr);
    
    // find an empty row
    int row;
    for(row = 0; row < rowsPerInd; row++)
    {
      if(memory[id][row][off].getAddr() == addr)
        return memory[id][row][off].getValue();
    }
  }

  public Iterator iterator()
  {
    return new Iterator();
  }
  // -----------------------
  public class Iterator
  {
    int addr;

    public Iterator()
    {
      addr = 0;
    }

    public boolean hasNext()
    {
      return addr < cacheSize;      
    }

    public T next()
    {
      return get(addr++);
    }
  }
}
