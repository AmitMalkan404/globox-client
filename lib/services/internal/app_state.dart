import 'package:flutter/foundation.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/models/package.dart';
import 'package:globox/services/internal/map_utils.dart';
import 'package:globox/services/queries/delete_package.dart';
import 'package:globox/services/queries/get_packages.service.dart';
import 'package:latlong2/latlong.dart';

class AppState with ChangeNotifier {
  List<Package> mainPackages = [];
  bool isLoading = false;
  LoadingType loadingType = LoadingType.none;
  LatLng? currentPosition;

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
      toggleLoading(false);
      updateLoadingType(LoadingType.deletingPackage);

      await deletePackage(packageId); // מחיקה בשרת
      await fetchPackagesFromServer(); // עדכון המערך לאחר המחיקה

      updateLoadingType(LoadingType.none);
      toggleLoading(true);
    } catch (e) {
      print('Error deleting package: $e');
    }
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
