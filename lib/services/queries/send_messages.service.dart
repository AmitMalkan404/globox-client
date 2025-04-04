import 'dart:convert';
import 'package:globox/config.dart';
import 'package:http/http.dart' as http;

Future<http.Response?> sendMessages(List<String> messages) async {
  try {
    final response = await http
        .post(
          Uri.parse('${AppConfig.apiUri}/api/send-messages'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(messages),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    // Checking if the call was successful
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response; // החזרה אם הקריאה הצליחה
    } else {
      throw Exception(
          'Failed to send messages. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    // Error handling
    print('Error occurred while sending messages: $e');
    return null; // Or return a custom error object
  }
}
