import 'priority.dart';
import 'task.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.done,
  }) : super(priority: Priority.high); // une urgence, c'est toujours "high", pas le choix

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
