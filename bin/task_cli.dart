import 'package:task_cli/src/cli/cli_runner.dart';
import 'package:task_cli/src/repository/task_repository.dart';

void main(List<String> args) {
  final repository = TaskRepository('tasks.json');
  final runner = CliRunner(repository);
  runner.run(args);
}
