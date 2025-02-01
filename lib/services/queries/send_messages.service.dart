import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response?> sendMessages(List<String> messages) async {
  await dotenv.load();

  try {
    final response = await http.post(
      // Uri.parse('${dotenv.env['API_BASE_URL']}/api/send-messages'),
      Uri.parse('${dotenv.env['LOCAL_URL']}/api/send-messages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(messages),
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
