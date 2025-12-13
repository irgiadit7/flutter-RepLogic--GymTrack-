import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local/database.dart';
import 'repositories/workout_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WorkoutRepository(db);
});
