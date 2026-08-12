import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/task.dart';
import 'repository.dart';

/// Dépôt de tâches persistées dans un fichier JSON local.
class TaskRepository implements Repository<Task> {
  final File _file;
  final List<Task> _tasks = [];

  TaskRepository(String path) : _file = File(path) {
    _load();
  }

  void _load() {
    if (!_file.existsSync()) return;
    try {
      final content = _file.readAsStringSync();
      if (content.trim().isEmpty) return;
      final data = jsonDecode(content) as List<dynamic>;
      _tasks
        ..clear()
        ..addAll(data.map((e) => Task.fromJson(e as Map<String, dynamic>)));
    } on FormatException catch (e) {
      throw StorageException('Fichier JSON corrompu (${_file.path}): ${e.message}');
    } on IOException catch (e) {
      throw StorageException('Impossible de lire ${_file.path}: $e');
    }
  }

  void _save() {
    try {
      final data = _tasks.map((t) => t.toJson()).toList();
      _file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
    } on IOException catch (e) {
      throw StorageException("Impossible d'écrire ${_file.path}: $e");
    }
  }

  @override
  List<Task> getAll() => List.unmodifiable(_tasks);

  @override
  Task? getById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Comme [getById] mais lève [TaskNotFoundException] si absent.
  Task requireById(String id) {
    final task = getById(id);
    if (task == null) {
      throw TaskNotFoundException('Aucune tâche trouvée avec l\'id "$id".');
    }
    return task;
  }

  @override
  void add(Task item) {
    if (getById(item.id) != null) {
      throw InvalidTaskException('Une tâche avec l\'id "${item.id}" existe déjà.');
    }
    _tasks.add(item);
    _save();
  }

  @override
  void update(Task item) {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) {
      throw TaskNotFoundException('Aucune tâche trouvée avec l\'id "${item.id}".');
    }
    _tasks[index] = item;
    _save();
  }

  @override
  void remove(String id) {
    final existing = requireById(id);
    _tasks.remove(existing);
    _save();
  }

  /// Calcule le prochain id disponible (entier incrémental sous forme de chaîne).
  String nextId() {
    var max = 0;
    for (final t in _tasks) {
      final n = int.tryParse(t.id);
      if (n != null && n > max) max = n;
    }
    return (max + 1).toString();
  }

  List<Task> sortedByPriority() {
    final copy = [..._tasks];
    copy.sort();
    return copy;
  }

  List<Task> sortedByDueDate() {
    final copy = [..._tasks];
    copy.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return copy;
  }
}
