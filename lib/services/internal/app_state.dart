import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/services/internal/map_utils.dart';
import 'package:globox/services/queries/delete_package.dart';
import 'package:globox/services/queries/get_packages.service.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (mainPackages.isEmpty) {
      await fetchPackagesFromServer();
    }
    currentPosition = await getCurrentLocation();
    notifyListeners();
  }

  Locale get locale => _locale;

  Future<void> fetchPackagesFromServer() async {
    try {
      mainPackages = await getPackages(); // קריאה לשרת
      notifyListeners(); // עדכון כל המאזינים
    } catch (e) {
      print('Error fetching array: $e');
    }
  }

  Future<void> deleteItem(String packageId) async {
    try {
      toggleLoading(true);
      updateLoadingType(LoadingType.deletingPackage);

      await deletePackage(packageId); // מחיקה בשרת
      await fetchPackagesFromServer(); // עדכון המערך לאחר המחיקה

      updateLoadingType(LoadingType.none);
      toggleLoading(false);
    } catch (e) {
      print('Error deleting package: $e');
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
}
