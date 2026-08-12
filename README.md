# task_cli — Gestionnaire de tâches en ligne de commande (Dart)

Application CLI en Dart pur (sans Flutter) pour gérer une liste de tâches,
avec persistance dans un fichier JSON local.

## Fonctionnalités

- Ajouter une tâche (titre, priorité `low`/`medium`/`high`, date limite optionnelle)
- Lister les tâches, avec tri par priorité ou par date
- Marquer une tâche comme terminée
- Supprimer une tâche
- Persistance automatique dans `tasks.json`

## Choix techniques

- **Classes abstraites + héritage** : `Task` (abstraite) → `StandardTask` et `UrgentTask`.
  `UrgentTask` force toujours la priorité `high` et signale les échéances dépassées.
- **Interface** : `JsonSerializable` (méthode `toJson()`), implémentée par `Task`.
  `Task` implémente aussi `Comparable<Task>` pour le tri par priorité.
- **Génériques** : `Repository<T>` (contrat CRUD générique), implémenté par
  `TaskRepository implements Repository<Task>`.
- **Exceptions personnalisées** : `TaskNotFoundException`, `InvalidTaskException`,
  `StorageException` (dans `lib/src/exceptions/task_exceptions.dart`).
- **Tests unitaires** : package `test`, voir `test/`.

## Structure du projet

```
bin/task_cli.dart              point d'entrée CLI
lib/src/models/                Task, StandardTask, UrgentTask, Priority, JsonSerializable
lib/src/exceptions/            exceptions personnalisées
lib/src/repository/            Repository<T> générique + TaskRepository (JSON)
lib/src/cli/                   parsing des commandes et affichage
test/                          tests unitaires
```

## Prérequis

- [Dart SDK](https://dart.dev/get-dart) ≥ 3.0

## Installation

```bash
dart pub get
```

## Lancer l'application

```bash
dart run bin/task_cli.dart <commande> [options]
```

### Commandes

```bash
# Ajouter une tâche
dart run bin/task_cli.dart add "Rendre le projet Dart" --priority=high --due=2026-08-20

# Ajouter une tâche urgente (priorité forcée à high)
dart run bin/task_cli.dart add "Corriger un bug critique" --urgent --due=2026-08-13

# Lister les tâches
dart run bin/task_cli.dart list

# Lister triées par priorité ou par date
dart run bin/task_cli.dart list --sort=priority
dart run bin/task_cli.dart list --sort=date

# Marquer une tâche comme terminée (par id)
dart run bin/task_cli.dart done 1

# Supprimer une tâche (par id)
dart run bin/task_cli.dart delete 1

# Aide
dart run bin/task_cli.dart help
```

Les tâches sont sauvegardées dans `tasks.json` à la racine du projet
(fichier créé automatiquement, ignoré par git).

## Lancer les tests

```bash
dart test
```

11 tests unitaires couvrent les modèles (`Task`, `StandardTask`, `UrgentTask`)
et le dépôt (`TaskRepository` : ajout, suppression, persistance, tri, erreurs).

## Analyse statique

```bash
dart analyze
```
