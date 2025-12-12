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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF00),
          secondary: Color(0xFF00FF00),
          surface: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: "Roboto",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1E1E1E),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
