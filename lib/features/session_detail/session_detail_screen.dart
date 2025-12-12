import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../data/providers.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/local/database.dart';
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
        label: const Text(
          "Add Exercise",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildWorkoutList(
    BuildContext context,
    WidgetRef ref,
    List<SetWithExercise> flatData,
  ) {
    final groupedData = groupBy(flatData, (item) => item.exercise);

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: groupedData.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.white24, thickness: 1),
      itemBuilder: (context, index) {
        final exercise = groupedData.keys.elementAt(index);
        final sets = groupedData.values.elementAt(index);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exercise.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF00FF00),
                      letterSpacing: 1.2,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "SET",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "KG",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "REPS",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "RPE",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ...sets.mapIndexed(
                    (i, item) => _buildSetItem(context, ref, i + 1, item),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
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
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white70,
                      ),
                      label: const Text(
                        "ADD SET",
                        style: TextStyle(color: Colors.white70),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    SetWithExercise item,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showEditSetDialog(context, ref, item),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: item.set.setType == 1
                ? Colors.orange.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
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
                      color: Colors.white,
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
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
        ),
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
        onSelected: (exercise) async {
          try {
            final lastSet = await ref
                .read(workoutRepositoryProvider)
                .getLastSetForExercise(exercise.id);
            final defaultWeight = lastSet?.weight ?? 20.0;
            final defaultReps = lastSet?.reps ?? 10;
            ref
                .read(workoutRepositoryProvider)
                .addSet(
                  sessionId: session.id,
                  exerciseId: exercise.id,
                  weight: defaultWeight,
                  reps: defaultReps,
                  rpe: 0,
                  setType: 0,
                );
          } catch (e) {
            debugPrint("ERROR ADD SET: $e");
          }
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

  void _showEditSetDialog(
    BuildContext context,
    WidgetRef ref,
    SetWithExercise item,
  ) {
    final weightController = TextEditingController(
      text: item.set.weight.toString(),
    );
    final repsController = TextEditingController(
      text: item.set.reps.toString(),
    );
    final rpeController = TextEditingController(
      text: (item.set.rpe ?? 0).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Set"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
            ),

            TextField(
              controller: repsController,
              decoration: const InputDecoration(labelText: "Reps"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: rpeController,
              decoration: InputDecoration(labelText: "RPE (1-10)"),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              final newWeight =
                  double.tryParse(weightController.text) ?? item.set.weight;

              final newReps =
                  int.tryParse(repsController.text) ?? item.set.reps;

              final newRpe = double.tryParse(rpeController.text) ?? 0;

              ref
                  .read(workoutRepositoryProvider)
                  .updateSet(
                    setId: item.set.id,
                    weight: newWeight,
                    reps: newReps,
                    rpe: newRpe,
                  );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
