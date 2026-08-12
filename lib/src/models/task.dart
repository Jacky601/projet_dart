import '../exceptions/task_exceptions.dart';
import 'json_serializable.dart';
import 'priority.dart';
import 'standard_task.dart';
import 'urgent_task.dart';

/// Classe abstraite de base pour toute tâche.
/// Implémente [JsonSerializable] (interface) et [Comparable] pour le tri par priorité.
abstract class Task implements JsonSerializable, Comparable<Task> {
  final String id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.done = false,
  }) {
    if (title.trim().isEmpty) {
      throw InvalidTaskException('Le titre ne peut pas être vide.');
    }
  }

  /// Discriminant utilisé pour la (dé)sérialisation JSON.
  String get type;

  void markDone() => done = true;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'done': done,
        'type': type,
      };

  /// Tri par priorité décroissante (high avant low).
  @override
  int compareTo(Task other) => other.priority.index.compareTo(priority.index);

  @override
  String toString() {
    final status = done ? '[x]' : '[ ]';
    final due = dueDate != null
        ? ' (échéance: ${dueDate!.toIso8601String().split('T').first})'
        : '';
    return '$status #$id [$type/${priority.name}] $title$due';
  }

  static Task fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'standard';
    final id = json['id'] as String;
    final title = json['title'] as String;
    final priority = priorityFromString(json['priority'] as String);
    final dueDateRaw = json['dueDate'] as String?;
    final dueDate = dueDateRaw != null ? DateTime.parse(dueDateRaw) : null;
    final done = json['done'] as bool? ?? false;

    switch (type) {
      case 'urgent':
        return UrgentTask(id: id, title: title, dueDate: dueDate, done: done);
      case 'standard':
        return StandardTask(
          id: id,
          title: title,
          priority: priority,
          dueDate: dueDate,
          done: done,
        );
      default:
        throw InvalidTaskException('Type de tâche inconnu: "$type".');
    }
  }
}
