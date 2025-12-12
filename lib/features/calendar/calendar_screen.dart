import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rep_logic/features/home/widgets/add_session_sheet.dart';
import 'package:rep_logic/features/session_detail/session_detail_screen.dart';
import '../../data/providers.dart';
import '../../data/local/database.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(workoutRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("History Log")),
      body: StreamBuilder<List<WorkoutSession>>(
        stream: repository.watchAllSessions(),
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(child: Text("No workout history yet"));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];

              return ListTile(
                title: Text(session.name),
                subtitle: Text(session.date.toString()),
                leading: const Icon(Icons.fitness_center),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SessionDetailScreen(session: session),
                    ),
                  );
                },
                onLongPress: () {
                  repository.deleteSession(session.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
