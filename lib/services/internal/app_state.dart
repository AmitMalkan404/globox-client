import 'package:flutter/material.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/services/internal/map_utils.dart';
import 'package:globox/services/internal/package_local_storage.dart';
import 'package:globox/services/queries/delete_package.dart';
import 'package:globox/services/queries/get_packages.service.dart';
import 'package:globox/ui/widgets/dialogs.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppState with ChangeNotifier {
  List<Package> mainPackages = [];
  bool isLoading = false;
  LoadingType loadingType = LoadingType.none;
  LatLng? currentPosition;
  Locale _locale = const Locale('en');

  AppState() {
    _initialize(); // קריאה לשרת בעת יצירת ה-AppState
  }

  void _initialize() async {
    currentPosition = await getCurrentLocation();
    notifyListeners();
  }

  Locale get locale => _locale;

  Future<void> fetchPackagesFromServer() async {
    try {
      mainPackages = await getPackages(); // קריאה לשרת
      await PackagesStorage.saveListToLocalStorage(mainPackages);
      notifyListeners(); // עדכון כל המאזינים
    } catch (e) {
      print('Error fetching array: $e');
    }
  }

  Future<void> fetchPackagesFromLocalStorage() async {
    try {
      final packagesStorage = PackagesStorage();
      if (await packagesStorage.isPackagesDataExpired()) {
        mainPackages = [];
      } else {
        mainPackages = await PackagesStorage.getListFromLocalStorage();
      }
      notifyListeners(); // עדכון כל המאזינים
    } catch (e) {
      print('Error fetching packages from local storage: $e');
    }
  }

  Future<void> deleteItem(String packageId, String firestoreId) async {
    try {
      startLoading(LoadingType.deletingPackage);
      await deletePackage(packageId, firestoreId); // מחיקה בשרת
      await fetchPackagesFromServer(); // עדכון המערך לאחר המחיקה
    } catch (e) {
      showGenericDialog(
        context: navigatorKey.currentContext!,
        title: 'Error',
        message: 'Failed to delete package. Please try again later.',
      );
      print('Error deleting package: $e');
    } finally {
      stopLoading();
    }
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  void toggleLoading(value) async {
    try {
      isLoading = value;
      notifyListeners(); // עדכון מקומי
    } catch (e) {
      print('Error toggling loading: $e');
    }
  }

  void updateLoadingType(LoadingType newValue) async {
    try {
      loadingType = newValue;
      notifyListeners(); // עדכון מקומי
    } catch (e) {
      print('Error updating Loading Type: $e');
    }
  }

  void startLoading(LoadingType type) {
    updateLoadingType(type);
    toggleLoading(true);
  }

  void stopLoading() {
    updateLoadingType(LoadingType.none);
    toggleLoading(false);
  }
}
