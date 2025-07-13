import 'dart:convert';
import 'package:globox/config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> deletePackage(
    String packageId, String firestoreId) async {
  try {
    var data = {
      "packageId": packageId,
      "firestoreId": firestoreId,
    };

    return await http
        .post(
          Uri.parse('${AppConfig.apiUri}/api/archive-package'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        )
        .timeout(Duration(seconds: AppConfig.isProduction ? 15 : 600));
  } catch (e) {
    throw Exception('Error deleting package: $e');
  }
}
