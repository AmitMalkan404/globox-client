import 'package:flutter/material.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/models/package.dart';
import 'package:globox/services/new_package.service.dart';

class AddNewPackage extends StatefulWidget {
  final void Function(LoadingType) newPackageCallback;

  const AddNewPackage({
    super.key,
    required this.newPackageCallback,
  });

  @override
  State<AddNewPackage> createState() => _AddNewPackageState();
}

class _AddNewPackageState extends State<AddNewPackage> {
  bool _isSubmitting = false;
  final _packageIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitPackageData() async {
    setState(() {
      _isSubmitting = true;
    });
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

    // setting the loader to be on adding package loading view
    widget.newPackageCallback(LoadingType.addingPackage);

    // קריאה לפונקציה המועברת דרך onAddPackage
    await addNewPackage(
      Package(
        packageId: enteredPackageId,
        description: enteredDescription,
        address: '',
        status: ShipmentStatus.noStatus,
        coordinates: [],
      ),
    );

    Navigator.pop(context); // סוגר את ה-modal

    // setting the loader to be off as it finished adding the package
    widget.newPackageCallback(LoadingType.none);
    setState(() {
      _isSubmitting = false;
    });
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
            readOnly: _isSubmitting,
            controller: _packageIdController,
            decoration: const InputDecoration(
              labelText: 'Package ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            readOnly: _isSubmitting,
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
                  if (_isSubmitting) return;
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? () {} : _submitPackageData,
                child: const Text('Save Package'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
