import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globox/config.dart';
import 'package:globox/models/classes/package.dart';
import 'package:http/http.dart' as http;

Future<http.Response> addNewPackage(Package package) async {
  var data = {
    "packageId": package.packageId,
    "address": package.address,
    "description": package.description,
    "status": package.status.index,
    "coordinates": package.coordinates,
    "postOfficeCode": package.postOfficeCode,
    "pickupPointName": package.pickupPointName,
    "uid": FirebaseAuth.instance.currentUser?.uid,
  };
  try {
    return await http.post(
      Uri.parse('${AppConfig.apiUri}/api/new-package'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  } catch (e) {
    throw Exception('Failed to add new package: $e');
  }
}
