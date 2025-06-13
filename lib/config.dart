import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static bool _isProduction = true; // Set to true for production

  static bool get isProduction => _isProduction;

  static String get apiUri {
    final url =
        _isProduction ? dotenv.env['PROD_API_URL'] : dotenv.env['DEV_API_URL'];

    if (url == null) throw Exception('API URL is missing from .env');
    return url;
  }
}
