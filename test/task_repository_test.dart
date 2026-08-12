import 'dart:io';

import 'package:task_cli/src/exceptions/task_exceptions.dart';
import 'package:task_cli/src/models/priority.dart';
import 'package:task_cli/src/models/standard_task.dart';
import 'package:task_cli/src/repository/task_repository.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late String path;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('task_cli_test_');
    path = '${tempDir.path}/tasks.json';
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('add() puis getAll() retrouve la tâche', () {
    final repo = TaskRepository(path);
    repo.add(StandardTask(id: '1', title: 'Test', priority: Priority.medium));
    expect(repo.getAll(), hasLength(1));
    expect(repo.getAll().first.title, 'Test');
  });

  test('persiste les tâches dans le fichier JSON', () {
    final repo = TaskRepository(path);
    repo.add(StandardTask(id: '1', title: 'Persisté', priority: Priority.high));

    final reloaded = TaskRepository(path);
    expect(reloaded.getAll(), hasLength(1));
    expect(reloaded.getAll().first.title, 'Persisté');
  });

  test('remove() supprime une tâche existante', () {
    final repo = TaskRepository(path);
    repo.add(StandardTask(id: '1', title: 'À supprimer', priority: Priority.low));
    repo.remove('1');
    expect(repo.getAll(), isEmpty);
  });

  test('remove() lève TaskNotFoundException si id inconnu', () {
    final repo = TaskRepository(path);
    expect(() => repo.remove('inconnu'), throwsA(isA<TaskNotFoundException>()));
  });

  test('add() lève InvalidTaskException si id déjà utilisé', () {
    final repo = TaskRepository(path);
    repo.add(StandardTask(id: '1', title: 'Original', priority: Priority.low));
    expect(
      () => repo.add(StandardTask(id: '1', title: 'Doublon', priority: Priority.low)),
      throwsA(isA<InvalidTaskException>()),
    );
  });

  test('sortedByPriority() trie high -> low', () {
    final repo = TaskRepository(path);
    repo.add(StandardTask(id: '1', title: 'basse', priority: Priority.low));
    repo.add(StandardTask(id: '2', title: 'haute', priority: Priority.high));
    final sorted = repo.sortedByPriority();
    expect(sorted.first.priority, Priority.high);
  });
}
