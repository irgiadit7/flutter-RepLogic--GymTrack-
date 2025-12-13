import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rep_logic/features/session_detail/session_detail_screen.dart';
import '../../data/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _startWorkout(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(workoutRepositoryProvider);
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);

    final sessionId = await repository.createSession("Workout $dateStr", now);

    final sessionList = await repository.watchAllSessions().first;
    final newSession = sessionList.firstWhere((s) => s.id == sessionId);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SessionDetailScreen(session: newSession),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "RepLogic",
                style: GoogleFonts.oswald(
                  fontSize: 26,
                  letterSpacing: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const Text(
                "BUILD YOUR LEGACY",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1.5,
                  fontSize: 15,
                ),
              ),

              const Spacer(),

              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flash_on,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "READY?",
                          style: GoogleFonts.oswald(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _startWorkout(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "MULAI LATIHAN",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
