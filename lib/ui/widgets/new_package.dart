import 'package:flutter/material.dart';
import 'package:globox/models/package.dart';

class NewPackage extends StatefulWidget {
  const NewPackage({
    super.key,
  });

  @override
  State<NewPackage> createState() => _NewPackageState();
}

class _NewPackageState extends State<NewPackage> {
  final _packageIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitPackageData() {
    final enteredPackageId = _packageIdController.text.trim();
    final enteredDescription = _descriptionController.text.trim();

    // ולידציה - בדיקה אם השדות מלאים
    if (enteredPackageId.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter a valid Package ID'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    // קריאה לפונקציה המועברת דרך onAddPackage

    Navigator.pop(context); // סגור את ה-modal
  }

  @override
  void dispose() {
    _packageIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _packageIdController,
            decoration: const InputDecoration(
              labelText: 'Package ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitPackageData,
                child: const Text('Save Package'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
