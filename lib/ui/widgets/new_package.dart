import 'dart:math';

import 'package:flutter/material.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:globox/services/internal/messages_service.dart';
import 'package:globox/services/queries/new_package.service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewPackage extends StatefulWidget {
  const AddNewPackage({
    super.key,
  });

  @override
  State<AddNewPackage> createState() => _AddNewPackageState();
}

class _AddNewPackageState extends State<AddNewPackage> {
  final _packageIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  MessagesService messagesService =
      MessagesService(); // יצירת מופע של MessagesService

  @override
  void dispose() {
    _packageIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final tr = AppLocalizations.of(context)!;

    Future<void> submitPackageData() async {
      final enteredPackageId = _packageIdController.text.trim();
      final enteredDescription = _descriptionController.text.trim();
      String? errorMsg;
      if (enteredPackageId.isEmpty) {
        errorMsg = tr.invalidPackageIDMsg;
      } else if (appState.mainPackages
          .any((pkg) => pkg.packageId == enteredPackageId)) {
        errorMsg = tr.duplicatePackageIDMsg;
      }

      if (errorMsg != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(tr.invalidInput),
            content: Text(errorMsg!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(tr.okay),
              ),
            ],
          ),
        );
        return;
      }

      Navigator.pop(context); // closing the modal bottom sheet

      // adding a small delay to allow the modal to close before showing the loader
      await Future.delayed(Duration(milliseconds: 100));

      // setting the loader to be on adding package loading view
      appState.toggleLoading(true);
      appState.updateLoadingType(LoadingType.addingPackage);

      // קריאה לפונקציה המועברת דרך onAddPackage
      await addNewPackage(
        Package(
          packageId: enteredPackageId,
          description: enteredDescription,
          address: '',
          postOfficeCode: '',
          pickupPointName: '',
          coordinates: [],
          firestoreId: '',
        ),
      );

      appState.updateLoadingType(LoadingType.gettingPackages);

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
            controller: _packageIdController,
            decoration: InputDecoration(
              labelText: tr.packageId,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: tr.description,
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
                child: Text(tr.cancel),
              ),
              ElevatedButton(
                onPressed: submitPackageData,
                child: Text(tr.savePackage),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
