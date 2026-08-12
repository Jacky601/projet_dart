import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/priority.dart';
import '../models/standard_task.dart';
import '../models/urgent_task.dart';
import '../repository/task_repository.dart';

class CliRunner {
  final TaskRepository repository;

  CliRunner(this.repository);

  void run(List<String> args) {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final command = args.first;
    final rest = args.skip(1).toList();

    try {
      switch (command) {
        case 'add':
          _add(rest);
        case 'list':
          _list(rest);
        case 'done':
          _done(rest);
        case 'delete':
          _delete(rest);
        case 'help':
        case '--help':
        case '-h':
          _printHelp();
        default:
          stderr.writeln('Commande inconnue: "$command". Tape "help" pour la liste des commandes.');
          exitCode = 64;
      }
    } on InvalidTaskException catch (e) {
      stderr.writeln('Erreur: ${e.message}');
      exitCode = 65;
    } on TaskNotFoundException catch (e) {
      stderr.writeln('Erreur: ${e.message}');
      exitCode = 66;
    } on StorageException catch (e) {
      stderr.writeln('Erreur de stockage: ${e.message}');
      exitCode = 74;
    }
  }

  Map<String, String> _parseOptions(List<String> args) {
    final options = <String, String>{};
    for (final arg in args) {
      if (arg.startsWith('--') && arg.contains('=')) {
        final idx = arg.indexOf('=');
        options[arg.substring(2, idx)] = arg.substring(idx + 1);
      }
    }
    return options;
  }

  void _add(List<String> args) {
    final positional = args.where((a) => !a.startsWith('--')).toList();
    if (positional.isEmpty) {
      throw InvalidTaskException(
        'Usage: add "<titre>" [--priority=low|medium|high] [--due=YYYY-MM-DD] [--urgent]',
      );
    }
    final title = positional.first;
    final options = _parseOptions(args);
    final priority = options.containsKey('priority')
        ? priorityFromString(options['priority']!)
        : Priority.medium;

    DateTime? due;
    if (options.containsKey('due')) {
      try {
        due = DateTime.parse(options['due']!);
      } on FormatException {
        throw InvalidTaskException(
          'Date invalide: "${options['due']}". Format attendu: YYYY-MM-DD.',
        );
      }
    }

    final urgent = args.contains('--urgent');
    final id = repository.nextId();
    final task = urgent
        ? UrgentTask(id: id, title: title, dueDate: due)
        : StandardTask(id: id, title: title, priority: priority, dueDate: due);

    repository.add(task);
    print('Tâche ajoutée: $task');
  }

  void _list(List<String> args) {
    final options = _parseOptions(args);
    final tasks = switch (options['sort']) {
      'priority' => repository.sortedByPriority(),
      'date' => repository.sortedByDueDate(),
      _ => repository.getAll(),
    };

    if (tasks.isEmpty) {
      print('Aucune tâche.');
      return;
    }
    for (final t in tasks) {
      print(t);
    }
  }

  void _done(List<String> args) {
    if (args.isEmpty) {
      throw InvalidTaskException('Usage: done <id>');
    }
    final task = repository.requireById(args.first);
    task.markDone();
    repository.update(task);
    print('Tâche #${task.id} marquée comme terminée.');
  }

  void _delete(List<String> args) {
    if (args.isEmpty) {
      throw InvalidTaskException('Usage: delete <id>');
    }
    repository.remove(args.first);
    print('Tâche #${args.first} supprimée.');
  }

  void _printHelp() {
    print('''
Gestionnaire de tâches — CLI Dart

Usage:
  dart run bin/task_cli.dart add "<titre>" [--priority=low|medium|high] [--due=YYYY-MM-DD] [--urgent]
  dart run bin/task_cli.dart list [--sort=priority|date]
  dart run bin/task_cli.dart done <id>
  dart run bin/task_cli.dart delete <id>
  dart run bin/task_cli.dart help
''');
  }
}
