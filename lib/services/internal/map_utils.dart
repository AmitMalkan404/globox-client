// פונקציה לקבלת המיקום הנוכחי
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

Future<LatLng> getCurrentLocation() async {
  // בדיקת שירותי מיקום
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('שירות המיקום כבוי. אנא הפעילו אותו בהגדרות המכשיר.');
  }

  // בדיקת הרשאות
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('הרשאות המיקום נדחו.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('הרשאות המיקום נדחו לתמיד, אין גישה למיקום.');
  }

  // קבלת המיקום הנוכחי עם דיוק גבוה
  Position position = await Geolocator.getCurrentPosition(
    // ignore: deprecated_member_use
    desiredAccuracy: LocationAccuracy.high,
  );

  return LatLng(position.latitude, position.longitude);
}
