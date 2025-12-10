import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers.dart';
import '../../data/local/database.dart';
import 'widgets/add_exercise_sheet.dart'; 

class SessionDetailScreen extends ConsumerWidget {
  final WorkoutSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.name),
            Text(
              DateFormat('EEEE, d MMM y').format(session.date),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "Exercise list is empty!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text("No heavy exercise today."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddExerciseSheet(
              onSubmit: (name, target) {
                final repository = ref.read(workoutRepositoryProvider);
                repository.addExercise(name, target);
              },
            ),
          );
        },
        label: const Text("Add Exercise"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}