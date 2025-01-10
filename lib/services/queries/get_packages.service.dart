import 'dart:convert';
import 'package:globox/models/enums.dart';
import 'package:globox/models/package.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Package>> getPackages() async {
  await dotenv.load();

  try {
    var res = await http.get(
      Uri.parse('${dotenv.env['LOCAL_URL']}/api/get-packages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // בדוק אם הבקשה הצליחה
    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);

      // בדוק אם יש נתונים בתשובה
      if (jsonResponse['data'] != null) {
        return (jsonResponse['data'] as List).map((pckg) {
          return Package(
            packageId: pckg['packageId'],
            address: pckg['address'],
            description: pckg['description'],
            status:
                intToShipmentStatus(pckg['status'] as int), // המרה מ-int ל-enum
            coordinates: (pckg['coordinates'] as List)
                .map((coord) => coord as double)
                .toList(),
            createdAt: DateTime.parse(pckg['createdAt']), // המרה נכונה
          );
        }).toList();
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Failed to fetch packages: ${res.statusCode}');
    }
  } catch (e) {
    print('Error fetching packages: $e');
    return [];
  }
}

ShipmentStatus intToShipmentStatus(int value) {
  // וודא שהערך נמצא בטווח הערכים של enum
  if (value < 0 || value >= ShipmentStatus.values.length) {
    return ShipmentStatus.noStatus; // ערך ברירת מחדל
  }
  return ShipmentStatus.values[value];
}
