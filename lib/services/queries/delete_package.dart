import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> deletePackage(String packageId) async {
  var data = {
    "packageId": packageId,
  };
  await dotenv.load();
  return http.post(
    // Uri.parse('${dotenv.env['API_BASE_URL']}/api/archive-package'),
    Uri.parse('${dotenv.env['LOCAL_URL']}/api/archive-package'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}
