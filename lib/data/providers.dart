import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local/database.dart';
import 'repositories/workout_repository.dart';

final _databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(_databaseProvider);
  return WorkoutRepository(db);
});
