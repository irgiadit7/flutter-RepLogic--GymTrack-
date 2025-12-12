import 'package:drift/drift.dart';
import 'package:flutter/rendering.dart';
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

  Future<String> createSession(String name) async {
    final id = const Uuid().v4();
    await _db
        .into(_db.workoutSessions)
        .insert(
          WorkoutSessionsCompanion(
            id: Value(id),
            name: Value(name),
            date: Value(DateTime.now()),
          ),
        );
    return id;
  }

  Future<void> deleteSession(String id) async {
    await (_db.delete(_db.workoutSessions)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Exercise>> watchAllExercises() {
    return _db.select(_db.exercises).watch();
  }

  Future<void> addExerciseMaster(
    String name,
    String targetMuscle,
    String category,
  ) async {
    await _db
        .into(_db.exercises)
        .insert(
          ExercisesCompanion(
            id: Value(const Uuid().v4()),
            name: Value(name),
            targetMuscle: Value(targetMuscle),
            category: Value(category),
          ),
        );
  }

  Stream<List<SetWithExercise>> watchSetsInSession(String sessionId) {
    final query =
        _db.select(_db.workoutSets).join([
            innerJoin(
              _db.exercises,
              _db.exercises.id.equalsExp(_db.workoutSets.exerciseId),
            ),
          ])
          ..where(_db.workoutSets.sessionId.equals(sessionId))
          ..orderBy([OrderingTerm(expression: _db.workoutSets.id)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return SetWithExercise(
          set: row.readTable(_db.workoutSets),
          exercise: row.readTable(_db.exercises),
        );
      }).toList();
    });
  }

  Future<void> addSet({
    required String sessionId,
    required String exerciseId,
    required double weight,
    required int reps,
    required double rpe,
    required int setType,
  }) async {
    await _db
        .into(_db.workoutSets)
        .insert(
          WorkoutSetsCompanion(
            id: Value(const Uuid().v4()),
            sessionId: Value(sessionId),
            exerciseId: Value(exerciseId),
            weight: Value(weight),
            reps: Value(reps),
            rpe: Value(rpe),
            setType: Value(setType),
          ),
        );
  }

  Future<void> deleteSet(String setId) async {
    await (_db.delete(_db.workoutSets)..where((t) => t.id.equals(setId))).go();
  }

  Future<void> seedDefaultExercises() async {
    final allExercises = await _db.select(_db.exercises).get();
    if (allExercises.isNotEmpty) return;

    final defaults = [
      const ExercisesCompanion(
        name: Value('Bench Press (Barbell)'),
        targetMuscle: Value('Middle Chest'),
        bodyPart: Value('Chest'),
        category: Value('barbell'),
        youtubeUrl: Value('https://www.youtube.com/watch?v=rT7DgCr-3pg'),
        instructions: Value(
          'Lie on the bench, lower the bar to your chest, and push up.',
        ),
        isCustom: Value(false),
      ),
      const ExercisesCompanion(
        name: Value('Incline Bench Press (Dumbbell)'),
        targetMuscle: Value('Upper Chest'),
        bodyPart: Value('Chest'),
        category: Value('dumbbell'),
        isCustom: Value(false),
      ),

      // LEGS
      const ExercisesCompanion(
        name: Value('Squat (Barbell)'),
        targetMuscle: Value('Quadriceps'),
        bodyPart: Value('Legs'),
        category: Value('barbell'),
        youtubeUrl: Value('https://www.youtube.com/watch?v=ultWZbGWL5c'),
        isCustom: Value(false),
      ),

      // BACK
      const ExercisesCompanion(
        name: Value('Deadlift'),
        targetMuscle: Value('Lower Back'),
        bodyPart: Value('Back'),
        category: Value('barbell'),
        isCustom: Value(false),
      ),
      const ExercisesCompanion(
        name: Value('Lat Pulldown'),
        targetMuscle: Value('Lats'),
        bodyPart: Value('Back'),
        category: Value('machine'),
        isCustom: Value(false),
      ),

      const ExercisesCompanion(
        name: Value('Bicep Curl (Dumbbell)'),
        targetMuscle: Value('Biceps'),
        bodyPart: Value('Arms'),
        category: Value('dumbbell'),
        isCustom: Value(false),
      ),
    ];

    for (final ex in defaults) {
      await _db
          .into(_db.exercises)
          .insert(ex.copyWith(id: Value(const Uuid().v4())));
    }
    debugPrint("✅ Database Seeded with Rich Data (v3)!");
  }

  Future<void> updateSet({
    required String setId,
    required double weight,
    required int reps,
    required double rpe,
  }) async {
    await (_db.update(_db.workoutSets)..where((t) => t.id.equals(setId))).write(
      WorkoutSetsCompanion(
        weight: Value(weight),
        reps: Value(reps),
        rpe: Value(rpe),
      ),
    );
  }

  Future<WorkoutSet?> getLastSetForExercise(String exerciseId) async {
    final query =
        _db.select(_db.workoutSets).join([
            innerJoin(
              _db.workoutSessions,
              _db.workoutSessions.id.equalsExp(_db.workoutSets.sessionId),
            ),
          ])
          ..where(_db.workoutSets.exerciseId.equals(exerciseId))
          ..orderBy([
            OrderingTerm(
              expression: _db.workoutSessions.date,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1);

    final result = await query.getSingleOrNull();

    return result?.readTable(_db.workoutSets);
  }
}

class SetWithExercise {
  final WorkoutSet set;
  final Exercise exercise;

  SetWithExercise({required this.set, required this.exercise});
}
