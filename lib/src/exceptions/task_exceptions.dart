/// Exceptions personnalisées de l'application.
class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);

  @override
  String toString() => 'TaskNotFoundException: $message';
}

class InvalidTaskException implements Exception {
  final String message;
  InvalidTaskException(this.message);

  @override
  String toString() => 'InvalidTaskException: $message';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
