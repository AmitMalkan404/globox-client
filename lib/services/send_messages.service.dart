import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> sendMessages(List<String> messages) async {
  await dotenv.load();
  return http.post(
    // Uri.parse('${dotenv.env['API_BASE_URL']}/api/new-package'),
    Uri.parse('${dotenv.env['LOCAL_URL']}/api/send-messages'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(messages),
  );
}
