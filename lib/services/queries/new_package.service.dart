import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globox/config.dart';
import 'package:globox/models/classes/package.dart';
import 'package:http/http.dart' as http;

Future<http.Response> addNewPackage(Package package) async {
  var data = {
    "packageId": package.packageId,
    "fireStoreId": package.firestoreId,
    "address": package.address,
    "description": package.description,
    "coordinates": package.coordinates,
    "postOfficeCode": package.postOfficeCode,
    "pickupPointName": package.pickupPointName,
    "uid": FirebaseAuth.instance.currentUser?.uid,
  };
  try {
    return await http
        .post(
          Uri.parse('${AppConfig.apiUri}/api/new-package'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        )
        .timeout(
          Duration(seconds: 3000),
        );
  } catch (e) {
    throw Exception('Failed to add new package: $e');
  }
}
