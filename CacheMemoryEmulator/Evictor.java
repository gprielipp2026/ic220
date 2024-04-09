public interface Evictor<T>
{
  public void write(int addr, T value);
  public T read(int addr);
  public void evict(int addr, Cache cache);
}
