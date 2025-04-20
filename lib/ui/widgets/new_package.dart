import 'package:flutter/material.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/enums/shipment_status.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:globox/services/queries/new_package.service.dart';
import 'package:provider/provider.dart';

class AddNewPackage extends StatefulWidget {
  const AddNewPackage({
    super.key,
  });

  @override
  State<AddNewPackage> createState() => _AddNewPackageState();
}

class _AddNewPackageState extends State<AddNewPackage> {
  // uses for disabling the input/buttons when submitting the package
  bool _isSubmitting = false;
  final _packageIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _packageIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Future<void> submitPackageData() async {
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
      appState.toggleLoading(true);
      appState.updateLoadingType(LoadingType.addingPackage);

      // קריאה לפונקציה המועברת דרך onAddPackage
      await addNewPackage(
        Package(
          packageId: enteredPackageId,
          description: enteredDescription,
          address: '',
          status: ShipmentStatus.noStatus,
          postOfficeCode: '',
          coordinates: [],
        ),
      );

      appState.updateLoadingType(LoadingType.gettingPackages);

      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context); // סוגר את ה-modal

      // setting the loader to be off as it finished adding the package
      await appState.fetchPackagesFromServer();
      appState.updateLoadingType(LoadingType.none);
      appState.toggleLoading(false);
    }

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
                onPressed: _isSubmitting ? () {} : submitPackageData,
                child: const Text('Save Package'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
