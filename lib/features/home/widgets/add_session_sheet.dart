import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers.dart';

class AddSessionSheet extends ConsumerStatefulWidget {
  const AddSessionSheet({super.key});

  @override
  ConsumerState<AddSessionSheet> createState() => _AddSessionSheetState();
}

class _AddSessionSheetState extends ConsumerState<AddSessionSheet> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final repository = ref.read(workoutRepositoryProvider);

    repository.addSesion(name, DateTime.now());

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
            "start a new workout",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 15),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Session Name (Example: Push Day)",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _submit,
            label: const Text("start training!"),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
