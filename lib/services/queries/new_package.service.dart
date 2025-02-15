import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globox/models/package.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> addNewPackage(Package package) async {
  var data = {
    "packageId": package.packageId,
    "address": package.address,
    "description": package.description,
    "status": package.status.index,
    "coordinates": package.coordinates,
    "uid": FirebaseAuth.instance.currentUser?.uid,
  };
  await dotenv.load();
  return await http.post(
    // Uri.parse('${dotenv.env['API_BASE_URL']}/api/new-package'),
    Uri.parse('${dotenv.env['LOCAL_URL']}/api/new-package'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}
