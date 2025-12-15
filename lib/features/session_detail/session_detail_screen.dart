import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rep_logic/data/repositories/workout_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import 'widgets/exercise_selector_sheet.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  final WorkoutSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;

  void _showExerciseSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) => ExerciseSelectorSheet(
        onSelected: (exercise) async {
          final repo = ref.read(workoutRepositoryProvider);
          await repo.addSet(
            sessionId: widget.session.id,
            exerciseId: exercise.id,
            weight: 0,
            reps: 0,
            rpe: 0,
            setType: 0,
          );
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(workoutRepositoryProvider);
    final sessionSetsAsync = repository.watchSetsInSession(widget.session.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOG LATIHAN",
          style: GoogleFonts.bebasNeue(letterSpacing: 2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: widget.session.date,
            calendarFormat: _calendarFormat,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(widget.session.date, day),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey),
              weekendStyle: TextStyle(color: Colors.grey),
            ),
          ),

          const Divider(height: 30),

          Expanded(
            child: StreamBuilder<List<SetWithExercise>>(
              stream: sessionSetsAsync,
              builder: (context, snapshot) {
                final sets = snapshot.data ?? [];

                if (sets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum ada latihan",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _showExerciseSelector,
                          icon: const Icon(Icons.add),
                          label: const Text("TAMBAH LATIHAN"),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    final data = sets[index];
                    return ListTile(
                      title: Text(data.exercise.name),
                      subtitle: Text(
                        "${data.set.reps} reps • ${data.set.weight} kg",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
