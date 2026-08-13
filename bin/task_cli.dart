import 'dart:io';

import 'package:task_cli/src/cli/cli_runner.dart';
import 'package:task_cli/src/exceptions/task_exceptions.dart';
import 'package:task_cli/src/repository/task_repository.dart';

void main(List<String> args) {
  try {
    final repository = TaskRepository('tasks.json');
    final runner = CliRunner(repository);
    runner.run(args);
  } on StorageException catch (e) {
    stderr.writeln('Erreur de stockage: ${e.message}');
    exitCode = 74;
  } catch (e) {
    stderr.writeln('Erreur inattendue: $e');
    exitCode = 1;
  }
}
