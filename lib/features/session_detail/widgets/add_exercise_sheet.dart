import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExerciseSheet extends ConsumerStatefulWidget {
  final Function(String name, String target) onSubmit;

  const AddExerciseSheet({super.key, required this.onSubmit});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final target = _targetController.text.trim();

    if (name.isEmpty) return;

    widget.onSubmit(name, target);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Add New Exercise",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Exercise Name (e.g., Bench Press)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _targetController,
            decoration: const InputDecoration(
              labelText: "Target Muscle (e.g., Chest)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add_circle),
            label: const Text("SAVE EXERCISE"),
          ),
        ],
      ),
    );
  }
}