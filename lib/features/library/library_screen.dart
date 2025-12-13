import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/providers.dart';
import '../../data/local/database.dart';
import 'widgets/exercise_detail_modal.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _searchQuery = "";
  String _selectedFilter = "All";

  final List<String> _filters = [
    "All",
    "Favorites",
    "Chest",
    "Back",
    "Legs",
    "Shoulders",
    "Arms",
    "Core",
  ];

  Future<void> _sendRequestEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'solvionfoundation@gmail.com',
      query:
          'subject=Request New Exercise&body=Hi RepLogic, please add this exercise: ',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final streamExercises = ref
        .watch(workoutRepositoryProvider)
        .watchAllExercises();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Library",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendRequestEmail,
        backgroundColor: const Color(0xFF00FF00),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_reaction_outlined),
        label: const Text("Request"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search exercise...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                final isFavoriteFilter = filter == "Favorites";

                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isFavoriteFilter)
                        Icon(
                          Icons.bookmark,
                          size: 16,
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF00FF00),
                        ),
                      if (isFavoriteFilter) const SizedBox(width: 4),
                      Text(filter),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                  selectedColor: const Color(0xFF00FF00),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.white10,
                  side: BorderSide.none,
                  showCheckmark: false,
                );
              },
            ),
          ),

          const Divider(height: 20, color: Colors.white10),

          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: streamExercises,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                var exercises = snapshot.data!;

                if (_searchQuery.isNotEmpty) {
                  exercises = exercises
                      .where(
                        (e) => e.name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                if (_selectedFilter != "All") {
                  if (_selectedFilter == "Favorites") {
                    exercises = exercises.where((e) => e.isFavorite).toList();
                  } else {
                    exercises = exercises
                        .where((e) => e.bodyPart == _selectedFilter)
                        .toList();
                  }
                }

                if (exercises.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No $_selectedFilter exercises found",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        child: Text(
                          exercise.name[0],
                          style: const TextStyle(color: Color(0xFF00FF00)),
                        ),
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${exercise.targetMuscle} • ${exercise.category}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          exercise.isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: exercise.isFavorite
                              ? const Color(0xFF00FF00)
                              : Colors.grey,
                        ),
                        onPressed: () {
                          ref
                              .read(workoutRepositoryProvider)
                              .toggleExerciseFavorite(
                                exercise.id,
                                exercise.isFavorite,
                              );
                        },
                      ),
                 onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseDetailScreen(exercise: exercise),
                          ));
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
