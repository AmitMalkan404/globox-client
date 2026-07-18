import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globox/config.dart';
import 'package:globox/models/classes/package.dart';
import 'package:http/http.dart' as http;

Future<List<Package>> getPackages() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User is not logged in');

    final url = Uri.parse('${AppConfig.apiUri}/packages?uid=$uid');
    var res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(
      Duration(seconds: AppConfig.isProduction ? 15 : 60),
    );

    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);
      final data = jsonResponse['data'];

      // התיקון ל-Iterable: אנחנו משתמשים ב-fromJson וחותמים ב-toList()
      if (data != null && data is List) {
        return data.map((item) => Package.fromJson(item)).toList();
      } else {
        return []; // מחזירים רשימה ריקה אם אין מידע במקום לזרוק שגיאה
      }
    } else {
      throw Exception('Failed to fetch packages: ${res.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching packages: $e');
  }
}
