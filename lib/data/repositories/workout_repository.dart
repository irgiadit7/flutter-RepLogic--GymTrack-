import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../local/database.dart';

class WorkoutRepository {
  final AppDatabase _db;

  WorkoutRepository(this._db);

  Stream<List<WorkoutSession>> watchAllSessions() {
    return (_db.select(_db.workoutSessions)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<void> addSession(String name, DateTime date) async {
    final newSession = WorkoutSessionsCompanion(
      id: Value(const Uuid().v4()),
      name: Value(name),
      date: Value(date),
    );

    await _db.into(_db.workoutSessions).insert(newSession);
  }

  Future<void> deleteSession(String id) async {
    await (_db.delete(_db.workoutSessions)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Exercise>> watchExercisesInSession(String sessionId) {
    return _db.select(_db.exercises).watch();
  }

  Future<void> addExercise(String name, String targetMuscle) async {
    final newExercise = ExercisesCompanion(
      id: Value(const Uuid().v4()),
      name: Value(name),
      targetMuscle: Value(targetMuscle),
    );

    await _db.into(_db.exercises).insert(newExercise);
  }
}
