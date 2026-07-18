import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/providers/loading_provider.dart';
import 'package:globox/services/internal/package_local_storage.dart';
import 'package:globox/services/queries/delete_package.dart';
import 'package:globox/services/queries/get_packages.service.dart';

class PackagesNotifier extends AsyncNotifier<List<Package>> {
  @override
  Future<List<Package>> build() async {
    final localPackages = await _fetchPackagesFromLocalStorage();
    if (localPackages.isNotEmpty) {
      return localPackages;
    }
    return _fetchPackagesFromServer();
  }

  Future<List<Package>> _fetchPackagesFromLocalStorage() async {
    final storage = PackagesStorage();
    if (await storage.isPackagesDataExpired()) {
      return [];
    }
    return PackagesStorage.getListFromLocalStorage();
  }

  Future<List<Package>> _fetchPackagesFromServer() async {
    try {
      final serverPackages = await getPackages();
      await PackagesStorage.saveListToLocalStorage(serverPackages);
      return serverPackages;
    } catch (e, st) {
      log('Error fetching packages from server', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> deleteItem(String packageId, String firestoreId) async {
    final previousPackages = state.valueOrNull ?? [];
    ref.read(globalLoadingProvider.notifier).state =
        LoadingType.deletingPackage;

    state = await AsyncValue.guard(() async {
      // Await the backend deletion first.
      await deletePackage(packageId, firestoreId);

      // On success, mutate the local state instead of re-fetching.
      final newPackages = previousPackages
          .where((pkg) =>
              pkg.packageId != packageId || pkg.firestoreId != firestoreId)
          .toList();

      // Sync the updated list to local storage.
      await PackagesStorage.saveListToLocalStorage(newPackages);

      // Return the new list to update the UI.
      return newPackages;
    });

    ref.read(globalLoadingProvider.notifier).state = LoadingType.none;
  }

  // A method to force refresh from the server
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return _fetchPackagesFromServer();
    });
  }

  // הפונקציה הגנרית לעדכון כל שדה בחבילה!
  Future<void> patchPackages(
    List<String> packageIdsToUpdate,
    Package Function(Package currentPackage) updater,
  ) async {
    final currentPackages = state.valueOrNull ?? [];

    final updatedPackages = currentPackages.map((pkg) {
      // אם מצאנו את החבילה ברשימה שצריך לעדכן - נפעיל עליה את ה-updater
      if (packageIdsToUpdate.contains(pkg.packageId)) {
        return updater(pkg);
      }
      return pkg; // אם לא, מחזירים אותה כמו שהיא
    }).toList();

    // שומרים לוקאלית
    await PackagesStorage.saveListToLocalStorage(updatedPackages);

    // מעדכנים את הסטייט של Riverpod כדי שה-UI יתעדכן
    state = AsyncData(updatedPackages);
  }
}

final packagesProvider = AsyncNotifierProvider<PackagesNotifier, List<Package>>(
    PackagesNotifier.new);
