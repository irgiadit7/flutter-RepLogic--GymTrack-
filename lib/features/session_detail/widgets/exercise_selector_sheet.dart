import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers.dart';
import '../../../data/local/database.dart';

class ExerciseSelectorSheet extends ConsumerWidget {
  final Function(Exercise) onSelected;

  const ExerciseSelectorSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref
        .watch(workoutRepositoryProvider)
        .watchAllExercises();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Select Exercise",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search exercise...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: exerciseAsync,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final exercises = snapshot.data!;

                return ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      title: Text(
                        exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "${exercise.targetMuscle} • ${exercise.category}",
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: Text(
                          exercise.name[0],
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      onTap: () {
                        onSelected(exercise);
                        Navigator.pop(context);
                      },
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
