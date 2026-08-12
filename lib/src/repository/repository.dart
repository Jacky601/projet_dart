/// Contrat générique de dépôt (CRUD) pour un type [T].
abstract class Repository<T> {
  List<T> getAll();
  T? getById(String id);
  void add(T item);
  void update(T item);
  void remove(String id);
}
