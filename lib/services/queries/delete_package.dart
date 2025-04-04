import 'dart:convert';
import 'package:globox/config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> deletePackage(String packageId) async {
  var data = {
    "packageId": packageId,
  };

  return http.post(
    Uri.parse('${AppConfig.apiUri}/api/archive-package'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
}
