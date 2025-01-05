import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

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
        count: null,
      );
      this._messages = messages;
    } else {
      await Permission.sms.request();
    }
  }
}
