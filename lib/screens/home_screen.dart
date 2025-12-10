import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../data/providers.dart';
import '../data/local/database.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("RepLogic")),
      body: StreamBuilder<List<WorkoutSession>>(
        stream: database.select(database.workoutSessions).watch(),
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                "There is no workout schedule yet, please add one first.",
              ),
            );
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];

              return ListTile(
                title: Text(session.name),
                subtitle: Text(session.date.toString()),
                leading: const Icon(Icons.fitness_center),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSession = WorkoutSessionsCompanion(
            id: drift.Value(const Uuid().v4()),
            name: const drift.Value("Push Day(Chest)"),
            date: drift.Value(DateTime.now()),
          );

          await database.into(database.workoutSessions).insert(newSession);
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
