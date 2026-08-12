import 'task.dart';

/// Tâche standard, sans comportement particulier au-delà de [Task].
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
    super.done,
  });

  @override
  String get type => 'standard';
}
