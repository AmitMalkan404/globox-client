import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:globox/services/queries/send_messages.service.dart';
import 'package:globox/ui/widgets/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:globox/models/classes/package.dart';

/// The result returned from [MessagesService.sendMessagesData].
/// The caller is responsible for applying [syncedPackageIds] to the
/// packages store — keeping the service free of any Riverpod dependency.
class SmsResult {
  /// Package IDs that were found in new SMS messages and sent to the server.
  final List<String> syncedPackageIds;

  /// The timestamp that should be recorded as the last successful sync.
  final DateTime syncedAt;

  SmsResult({required this.syncedPackageIds, required this.syncedAt});
}

class MessagesService {
  static final MessagesService _instance = MessagesService._internal();
  final Telephony telephony = Telephony.instance;

  MessagesService._internal();

  factory MessagesService() {
    return _instance;
  }

  // The SharedPreferences key used to persist the last sync timestamp.
  static const String _lastSyncKey = 'lastSmsSyncDate';

  /// Scans the SMS inbox for messages matching [activePackages], sends
  /// matched data to the server, and returns an [SmsResult] if any packages
  /// were synced, or `null` if nothing needed syncing.
  ///
  /// The caller is responsible for calling [PackagesNotifier.patchPackages]
  /// with the result — this service never touches Riverpod directly.
  Future<SmsResult?> sendMessagesData(
    BuildContext context,
    List<Package> activePackages,
  ) async {
    final tr = AppLocalizations.of(context)!;

    try {
      // 1. Request SMS permissions.
      var permission = await Permission.sms.status;
      if (!permission.isGranted) {
        permission = await Permission.sms.request();
        if (!permission.isGranted) {
          return null;
        }
      }

      final prefs = await SharedPreferences.getInstance();

      // 2. Load the last sync date. Default to 30 days ago on first run.
      final lastSyncStr = prefs.getString(_lastSyncKey);
      final lastSyncDate = lastSyncStr != null
          ? DateTime.parse(lastSyncStr)
          : DateTime.now().subtract(const Duration(days: 30));

      final String minDate = lastSyncDate.millisecondsSinceEpoch.toString();
      print('Searching for SMS newer than: $lastSyncDate');

      // 3. Native-level filter: only fetch messages newer than lastSyncDate.
      List<SmsMessage> newMessages = await telephony.getInboxSms(
        columns: [SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE).greaterThan(minDate),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      if (newMessages.isEmpty) {
        print('No new messages since last check.');
        await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
        return null;
      }

      // 4. Client-side filter: match only messages containing a known package ID.
      final messageBodies = newMessages
          .map((m) => m.body)
          .where((b) => b != null)
          .cast<String>()
          .toList();

      final matchedPackagesData = _filterRelevantMessages(
        messageBodies,
        activePackages.map((p) => p.packageId).toList(),
      );

      if (matchedPackagesData.isEmpty) {
        print('No active packages found in ${newMessages.length} new messages.');
        await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
        return null;
      }

      // 5. Send only the matched pairs to the server.
      final response = await sendMessages(matchedPackagesData);
      final data = jsonDecode(response!.body);
      final trackingNumberChanges = data['trackingNumberChanges'];

      // 6. Notify the user of any package ID changes reported by the server.
      if (data != null &&
          trackingNumberChanges != null &&
          trackingNumberChanges.isNotEmpty) {
        print('Messages sent successfully: ${response.statusCode}');
        for (final change in trackingNumberChanges) {
          if (!context.mounted) break;
          showGenericDialog(
            context: context,
            title: tr.packageIdChanged,
            message:
                '${tr.packageIdChangedFrom} ${change['oldPackageId']} ${tr.to} ${change['newPackageId']}',
          );
        }
      }

      // 7. Persist the sync timestamp so the next run only looks forward.
      final now = DateTime.now();
      await prefs.setString(_lastSyncKey, now.toIso8601String());

      // 8. Return the result to the caller — let it apply the patch.
      return SmsResult(
        syncedPackageIds: matchedPackagesData.map((m) => m['packageId']!).toList(),
        syncedAt: lastSyncDate,
      );
    } catch (e) {
      print('Error sending messages: $e');
      if (context.mounted) {
        showGenericDialog(
          context: context,
          title: tr.error,
          message: tr.failedToSendMessages,
        );
      }
      return null;
    }
  }

  // Matches message bodies against known package IDs.
  List<Map<String, String>> _filterRelevantMessages(
      List<String> messageBodies, List<String> activePackageIds) {
    final List<Map<String, String>> matchedPackagesData = [];
    for (final body in messageBodies) {
      for (final id in activePackageIds) {
        if (body.contains(id)) {
          matchedPackagesData.add({'packageId': id, 'message': body});
          break;
        }
      }
    }
    return matchedPackagesData;
  }

  /// Resets the sync date so the next run fetches the last 30 days of SMS.
  /// Call this after adding a new package.
  Future<void> resetSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSyncKey);
    print('Sync date reset. Next run will fetch last 30 days of SMS.');
  }
}
