import 'dart:convert';
import 'package:globox/models/classes/package.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores and manages the local storage of packages and their last save time.
class PackagesStorage {
  static const String _key = 'packages';
  static const String _timestampKey = 'packages_last_saved';
  static const int expirationMinutes = 60;

  /// Saves a list of [Package] objects to local storage as JSON strings.
  /// Also updates the last saved timestamp.
  static Future<void> saveListToLocalStorage(List<Package> packages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = packages.map((pkg) => jsonEncode(pkg.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
    final now = DateTime.now().toIso8601String();
    await prefs.setString(_timestampKey, now);
  }

  /// Retrieves the list of [Package] objects from local storage.
  /// Returns an empty list if no data is found.
  static Future<List<Package>> getListFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];

    return jsonList
        .map((jsonStr) => Package.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Checks if the locally stored packages data is expired based on [expirationMinutes].
  /// Returns true if expired or if no save time is found.
  Future<bool> isPackagesDataExpired() async {
    final lastSaved = await getLastPackagesSaveTime();
    if (lastSaved == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSaved).inMinutes;

    return difference > expirationMinutes;
  }

  /// Gets the last time the packages list was saved to local storage.
  /// Returns a [DateTime] or null if not found or invalid.
  Future<DateTime?> getLastPackagesSaveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_timestampKey);

    if (timeStr == null) return null;

    return DateTime.tryParse(timeStr);
  }

  /// Removes the packages list from local storage.
  static Future<void> removeListFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
