import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analysis")),
      body: const Center(
        child: Text("Hello World (Analysis Screen)", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}