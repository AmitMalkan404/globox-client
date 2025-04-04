import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const bool isProduction = true;

  static String get apiUri {
    final url =
        isProduction ? dotenv.env['PROD_API_URL'] : dotenv.env['DEV_API_URL'];

    if (url == null) throw Exception('API URL is missing from .env');
    return url;
  }
}
