import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../data/local/database.dart';
import 'package:intl/intl.dart';

class SessionDetailScreen extends ConsumerWidget {
  final WorkoutSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(workoutRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.name,
        ), 
        subtitle: Text(DateFormat('EEE, d MMM y').format(session,date)), 
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
    );
  }
}
