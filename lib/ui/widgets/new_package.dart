import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. הוספנו את Riverpod
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/classes/package.dart';
// import 'package:globox/services/internal/app_state.dart'; // מחקנו את זה
import 'package:globox/providers/loading_provider.dart'; // נתיב משוער - שים את הנכון
import 'package:globox/providers/packages_provider.dart'; // נתיב משוער - איפה שה-PackagesNotifier נמצא
import 'package:globox/services/internal/messages_service.dart';
import 'package:globox/services/queries/new_package.service.dart';
import 'package:globox/ui/widgets/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 2. שינינו מ-StatefulWidget ל-ConsumerStatefulWidget
class AddNewPackage extends ConsumerStatefulWidget {
  const AddNewPackage({super.key});

  @override
  ConsumerState<AddNewPackage> createState() => _AddNewPackageState();
}

// 3. שינינו ל-ConsumerState
class _AddNewPackageState extends ConsumerState<AddNewPackage> {
  final _packageIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  MessagesService messagesService = MessagesService();

  @override
  void dispose() {
    _packageIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // מחקנו את ה-Provider.of<AppState>
    final tr = AppLocalizations.of(context)!;

    Future<void> submitPackageData() async {
      try {
        final enteredPackageId = _packageIdController.text.trim();
        final enteredDescription = _descriptionController.text.trim();
        String? errorMsg;

        // 4. שולפים את הרשימה מ-Riverpod כדי לבדוק כפילויות
        final currentPackages = ref.read(packagesProvider).valueOrNull ?? [];

        if (enteredPackageId.isEmpty) {
          errorMsg = tr.invalidPackageIDMsg;
        } else if (currentPackages
            .any((pkg) => pkg.packageId == enteredPackageId)) {
          errorMsg = tr.duplicatePackageIDMsg;
        }

        if (errorMsg != null) {
          showGenericDialog(
              context: context, title: tr.invalidInput, message: errorMsg!);
          return;
        }

        Navigator.pop(context); // closing the modal bottom sheet

        await Future.delayed(const Duration(milliseconds: 100));

        // 5. מפעילים את טעינת המסך דרך ה-LoadingProvider
        ref.read(globalLoadingProvider.notifier).state =
            LoadingType.addingPackage;

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

        // 6. קוראים לפונקציית הריענון שבנינו ב-PackagesNotifier
        await ref.read(packagesProvider.notifier).refresh();
      } catch (e) {
        showGenericDialog(
          context: context,
          title: tr.error,
          message: tr.somethingWentWrong,
        );
      } finally {
        // 7. מכבים את הטעינה בסוף דרך ה-LoadingProvider
        ref.read(globalLoadingProvider.notifier).state = LoadingType.none;
      }
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
            maxLines: 4,
            maxLength: 250,
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: tr.description,
              border: const OutlineInputBorder(),
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
