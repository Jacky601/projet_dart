import 'priority.dart';
import 'task.dart';

/// Tâche urgente : priorité toujours forcée à [Priority.high] et
/// affiche un avertissement si l'échéance est dépassée.
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.done,
  }) : super(priority: Priority.high);

  @override
  String get type => 'urgent';

  bool get isOverdue =>
      dueDate != null && !done && DateTime.now().isAfter(dueDate!);

  @override
  String toString() {
    final base = super.toString();
    return isOverdue ? '$base ⚠ EN RETARD' : base;
  }
}
