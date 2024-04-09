public class Memory<T>
{
  private Entry<T>[] memory;
  private int size = 1024;
  public Memory()
  {
    memory = new Entry<T>[size];
  }

  public T read(int addr) throws Exception
  {
    if(addr >= size || addr < 0) throw new Exception("Maximum memory size is '" + size + "'\nYou requested '" + addr + "'");
    return memory[addr].getValue();
  }

  public void write(int addr, T value) throws Exception
  {
    if(addr >= size || addr < 0) throw new Exception("Maximum memory size is '" + size + "'\nYou requested '" + addr + "'");
    memory[addr].setValue(value);
  }
}
