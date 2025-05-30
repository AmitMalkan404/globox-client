import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globox/config.dart';
import 'package:globox/models/classes/package.dart';
import 'package:http/http.dart' as http;

Future<List<Package>> getPackages() async {
  try {
    var res = await http.post(Uri.parse('${AppConfig.apiUri}/api/get-packages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(FirebaseAuth.instance.currentUser?.uid));

    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);

      if (jsonResponse['data'] != null) {
        return (jsonResponse['data'] as List).map((pckg) {
          return Package(
            packageId: pckg['packageId'],
            address: pckg['address'],
            description: pckg['description'],
            postOfficeCode: pckg['postOfficeCode'] ?? '',
            pickupPointName: pckg['pickupPointName'] ?? '',
            coordinates: (pckg['coordinates'] as List)
                .map((coord) => coord as double)
                .toList(),
            createdAt: DateTime.parse(pckg['createdAt']),
            eStatus: pckg['eStatus'],
            statusDesc: pckg['statusDesc'],
            statusDetailedDesc: pckg['statusDetailedDesc'],
            time: DateTime.fromMillisecondsSinceEpoch(pckg['time'])
                .toIso8601String(),
            actionCode: pckg['actionCode'] ?? '',
            contact: pckg['contact'] ?? '',
            contactDetails: pckg['contactDetails'] ?? '',
            originCountry: pckg['originCountry'] ?? '',
            destCountry: pckg['destCountry'] ?? '',
            arrivalMessage: pckg['arrivalMsg'] ?? '',
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
