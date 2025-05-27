import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDialogButton extends StatelessWidget {
  final String message;

  const MessageDialogButton({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(Icons.message),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("הודעת משלוח"),
            content: SingleChildScrollView(
              child: Linkify(
                text: message,
                options: LinkifyOptions(humanize: false, looseUrl: true),
                onOpen: (link) => handleLinkTap(context, link),
                style: TextStyle(fontSize: 16, color: Colors.white60),
                textDirection: TextDirection.rtl,
                linkStyle: TextStyle(color: Colors.blue),
              ),
            ),
            actions: [
              TextButton(
                child: Text("סגור"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleLinkTap(BuildContext context, LinkableElement link) async {
    String rawUrl = link.url.trim();

    if (!rawUrl.startsWith("http")) {
      rawUrl = "https://$rawUrl";
    }

    final uri = Uri.tryParse(rawUrl);
    if (uri == null) {
      print("⚠️ URI לא תקין: $rawUrl");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("קישור לא תקין: $rawUrl")),
      );
      return;
    }

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, stack) {
      print("📛 Stack trace:\n$stack");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("לא ניתן לפתוח את הקישור: $rawUrl")),
      );
    }
  }
}
