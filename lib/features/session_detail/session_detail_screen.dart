import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../data/providers.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/local/database.dart';
import 'widgets/add_exercise_sheet.dart';
import 'package:uuid/uuid.dart';
import 'widgets/exercise_selector_sheet.dart';

final sessionSetsProvider =
    StreamProvider.family<List<SetWithExercise>, String>((ref, sessionId) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchSetsInSession(sessionId);
    });

class SessionDetailScreen extends ConsumerWidget {
  final WorkoutSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(sessionSetsProvider(session.id));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('EEEE, d MMM').format(session.date),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: setsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          if (data.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildWorkoutList(context, ref, data);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExerciseSheet(context, ref),
        label: const Text("Add Exercise"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildWorkoutList(
    BuildContext context,
    WidgetRef ref,
    List<SetWithExercise> flatData,
  ) {
    final groupedData = groupBy(flatData, (item) => item.exercise);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final exercise = groupedData.keys.elementAt(index);
        final sets = groupedData.values.elementAt(index);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Divider(),

                const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Set", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "kg",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Reps",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "RPE",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 8),

                ...sets.mapIndexed(
                  (i, item) => _buildSetItem(ref, i + 1, item),
                ),

                TextButton.icon(
                  onPressed: () {
                    ref
                        .read(workoutRepositoryProvider)
                        .addSet(
                          sessionId: session.id,
                          exerciseId: exercise.id,
                          weight: sets.last.set.weight,
                          reps: sets.last.set.reps,
                          rpe: 8,
                          setType: 0,
                        );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Set"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSetItem(WidgetRef ref, int index, SetWithExercise item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: item.set.setType == 1
            ? Colors.orange.withOpacity(0.1)
            : null, // Warmup Highlight
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$index",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "${item.set.weight}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "${item.set.reps}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRPEColor(item.set.rpe ?? 0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${item.set.rpe ?? '-'}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                ref.read(workoutRepositoryProvider).deleteSet(item.set.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRPEColor(double rpe) {
    if (rpe >= 9) return Colors.red;
    if (rpe >= 7) return Colors.orange;
    return Colors.blue;
  }

  void _showAddExerciseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExerciseSelectorSheet(
        onSelected: (exercise) {
          ref
              .read(workoutRepositoryProvider)
              .addSet(
                sessionId: session.id,
                exerciseId: exercise.id,
                weight: 20,
                reps: 10,
                rpe: 0,
                setType: 0,
              );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "Start training!",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text("Press the + button to add movement"),
        ],
      ),
    );
  }
}
