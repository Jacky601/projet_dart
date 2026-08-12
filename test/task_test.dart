import 'package:task_cli/src/exceptions/task_exceptions.dart';
import 'package:task_cli/src/models/priority.dart';
import 'package:task_cli/src/models/standard_task.dart';
import 'package:task_cli/src/models/task.dart';
import 'package:task_cli/src/models/urgent_task.dart';
import 'package:test/test.dart';

void main() {
  group('StandardTask', () {
    test('crée une tâche avec les bons attributs', () {
      final task = StandardTask(id: '1', title: 'Faire les courses', priority: Priority.low);
      expect(task.title, 'Faire les courses');
      expect(task.priority, Priority.low);
      expect(task.done, isFalse);
    });

    test('rejette un titre vide', () {
      expect(
        () => StandardTask(id: '1', title: '   ', priority: Priority.low),
        throwsA(isA<InvalidTaskException>()),
      );
    });

    test('markDone() passe done à true', () {
      final task = StandardTask(id: '1', title: 'Test', priority: Priority.medium);
      task.markDone();
      expect(task.done, isTrue);
    });

    test('toJson/fromJson round-trip', () {
      final task = StandardTask(
        id: '1',
        title: 'Test',
        priority: Priority.high,
        dueDate: DateTime(2026, 1, 1),
      );
      final restored = Task.fromJson(task.toJson());
      expect(restored.title, task.title);
      expect(restored.priority, task.priority);
      expect(restored, isA<StandardTask>());
    });
  });

  group('UrgentTask', () {
    test('force toujours la priorité high', () {
      final task = UrgentTask(id: '2', title: 'Urgence', dueDate: DateTime(2020, 1, 1));
      expect(task.priority, Priority.high);
    });

    test('isOverdue vrai si la date est dépassée et non terminée', () {
      final task = UrgentTask(id: '3', title: 'Urgence', dueDate: DateTime(2020, 1, 1));
      expect(task.isOverdue, isTrue);
    });

    test('isOverdue faux si la tâche est terminée', () {
      final task = UrgentTask(
        id: '4',
        title: 'Urgence',
        dueDate: DateTime(2020, 1, 1),
        done: true,
      );
      expect(task.isOverdue, isFalse);
    });
  });

  group('compareTo', () {
    test('trie par priorité décroissante', () {
      final low = StandardTask(id: '1', title: 'a', priority: Priority.low);
      final high = StandardTask(id: '2', title: 'b', priority: Priority.high);
      expect(high.compareTo(low), lessThan(0));
    });
  });

  group('priorityFromString', () {
    test('lève InvalidTaskException pour une valeur inconnue', () {
      expect(() => priorityFromString('urgent'), throwsA(isA<InvalidTaskException>()));
    });
  });
}
