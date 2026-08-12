# task_cli

Petite app CLI en Dart pour gérer une liste de tâches (ajout, liste, terminé, suppression), avec sauvegarde dans un fichier JSON.

Projet fait pour valider le module Dart (classes abstraites, héritage, interface, génériques, exceptions, tests).

## Installer

```bash
dart pub get
```

## Utiliser

```bash
dart run bin/task_cli.dart add "Rendre le projet" --priority=high --due=2026-08-20
dart run bin/task_cli.dart add "Truc urgent" --urgent
dart run bin/task_cli.dart list
dart run bin/task_cli.dart list --sort=priority
dart run bin/task_cli.dart list --sort=date
dart run bin/task_cli.dart done 1
dart run bin/task_cli.dart delete 1
dart run bin/task_cli.dart help
```

Les tâches sont sauvegardées dans `tasks.json` (créé automatiquement au premier `add`).

## Tests

```bash
dart test
```

## Où est quoi

- `bin/task_cli.dart` — point d'entrée
- `lib/src/models/` — `Task` (abstraite) → `StandardTask` / `UrgentTask`, `Priority`, interface `JsonSerializable`
- `lib/src/repository/` — `Repository<T>` (générique) + `TaskRepository` (impl JSON)
- `lib/src/exceptions/` — `TaskNotFoundException`, `InvalidTaskException`, `StorageException`
- `lib/src/cli/` — parsing des commandes
- `test/` — tests unitaires
