import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rep_logic/data/repositories/workout_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../data/providers.dart';
import '../../data/local/database.dart';
import '../session_detail/session_detail_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Color _themeColor = const Color(0xFF00FF00);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<WorkoutSession> _getEventsForDay(
    DateTime day,
    List<WorkoutSession> allSessions,
  ) {
    return allSessions.where((session) {
      return isSameDay(session.date, day);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  Future<void> _addNewSchedule(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(workoutRepositoryProvider);
    final date = _selectedDay ?? DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final sessionId = await repository.createSession("Workout $dateStr", date);
    final sessionList = await repository.watchAllSessions().first;
    final newSession = sessionList.firstWhere((s) => s.id == sessionId);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SessionDetailScreen(session: newSession),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(workoutRepositoryProvider);
    final allSessionsAsync = repository.watchAllSessions();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<WorkoutSession>>(
        stream: allSessionsAsync,
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? [];
          final selectedDaySessions = _getEventsForDay(
            _selectedDay ?? DateTime.now(),
            sessions,
          );

          return Column(
            children: [
              TableCalendar<WorkoutSession>(
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                eventLoader: (day) => _getEventsForDay(day, sessions),

                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },

                  selectedBuilder: (context, day, focusedDay) {
                    if (isSameDay(day, DateTime.now())) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: _themeColor, width: 2.0),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },

                  markerBuilder: (context, day, events) {
                    if (events.isEmpty || isSameDay(day, DateTime.now())) {
                      return const SizedBox();
                    }

                    return Positioned(
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _themeColor,
                          shape: BoxShape.circle,
                        ),
                        width: 6.0,
                        height: 6.0,
                      ),
                    );
                  },
                ),

                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(color: Colors.transparent),
                  selectedDecoration: BoxDecoration(color: Colors.transparent),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false),
              ),

              const SizedBox(height: 20),
              const Divider(),

              Expanded(
                child: selectedDaySessions.isEmpty
                    ? _buildEmptyState(context)
                    : _buildSessionList(
                        context,
                        selectedDaySessions,
                        repository,
                      ),
              ),
            ],
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
          Text(
            "No training plan",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _addNewSchedule(context, ref),
            icon: const Icon(Icons.add),
            label: const Text("Add Schedule"),
            style: FilledButton.styleFrom(
              backgroundColor: _themeColor,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(
    BuildContext context,
    List<WorkoutSession> sessions,
    WorkoutRepository repo,
  ) {
    return ListView.builder(
      itemCount: sessions.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              session.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${session.date.hour}:${session.date.minute.toString().padLeft(2, '0')}",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SessionDetailScreen(session: session),
                ),
              );
            },
            onLongPress: () => repo.deleteSession(session.id),
          ),
        );
      },
    );
  }
}
