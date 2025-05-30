import 'package:intl/intl.dart';

/// Formats an ISO 8601 date string to a human-readable date and time string.
///
/// Returns a string in the format 'dd/MM/yyyy • HH:mm'.
/// If [isoDate] is null or invalid, returns an empty string.
String formatDateTime(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return "";

  try {
    final DateTime parsedDate = DateTime.parse(isoDate);
    final DateFormat formatter = DateFormat('dd/MM/yyyy • HH:mm');
    return formatter.format(parsedDate);
  } catch (_) {
    return "";
  }
}
