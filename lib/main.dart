import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rep_logic/features/home/home_screen.dart';
import 'data/providers.dart';

void main() {
  runApp(const ProviderScope(child: RepLogicApp()));
}

class RepLogicApp extends ConsumerStatefulWidget {
  const RepLogicApp({super.key});

  @override
  ConsumerState<RepLogicApp> createState() => _RepLogicAppState();
}

class _RepLogicAppState extends ConsumerState<RepLogicApp> {
  @override
  void initState() {
    super.initState();

    ref.read(workoutRepositoryProvider).seedDefaultExercises();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rep Logic",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: "Roboto",
      ),

      home: const HomeScreen(),
    );
  }
}
