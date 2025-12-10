import 'package:flutter/material.dart';

void main() {
  runApp(RepLogicApp());
}

class RepLogicApp extends StatelessWidget {
  const RepLogicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RepLogic",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text("Replogic Setup Complete")),
      ),
    );
  }
}
