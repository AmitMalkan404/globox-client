import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:globox/services/queries/send_messages.service.dart';
import 'package:http/src/response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesService {
  static final MessagesService _instance = MessagesService._internal();

  // ignore: prefer_typing_uninitialized_variables
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  // Inner constructor in order to prevent other instances
  MessagesService._internal();

  factory MessagesService() {
    return _instance;
  }

  List<SmsMessage> get messages => _messages;

  Future<void> getMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        address: null,
        count: 2000,
      );
      _messages = messages;
    } else {
      await Permission.sms.request();
    }
  }

  Future<void> sendMessagesData(
      BuildContext context, bool shouldRetrive) async {
    final tr = AppLocalizations.of(context)!;
    if (this.messages.isEmpty || shouldRetrive) {
      await this.getMessages();
    }
    var messageBodies = _messages
        .map((message) => message.body)
        .where((body) => body != null)
        .cast<String>()
        .toList();

    var response = await sendMessages(messageBodies);
    var data = await jsonDecode(response!.body);
    var trackingNumberChanges = data['trackingNumberChanges'];
    if (data != null && trackingNumberChanges.isNotEmpty) {
      // Handle the response if needed
      print('Messages sent successfully: ${response.statusCode}');
      for (final change in trackingNumberChanges) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(tr.packageIdChanged),
              content: Text(
                '${tr.packageIdChangedFrom} ${change['oldPackageId']} ${tr.to} ${change['newPackageId']}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
