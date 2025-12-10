import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rep_logic/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: RepLogicApp()));
}

class RepLogicApp extends StatelessWidget {
  const RepLogicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RepLogic",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
