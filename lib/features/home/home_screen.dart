import 'package:flutter/material.dart';
import 'package:rep_logic/features/home/widgets/add_session_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello World (Home Screen)", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                 showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const AddSessionSheet(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("START WORKOUT"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF00),
                foregroundColor: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}