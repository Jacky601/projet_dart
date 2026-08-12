abstract class Repository<T> {
  List<T> getAll();
  T? getById(String id);
  void add(T item);
  void update(T item);
  void remove(String id);
}
