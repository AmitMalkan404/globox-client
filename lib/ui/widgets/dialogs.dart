import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Shows a generic dialog with a title, message, and an OK button.
///
/// [context] - BuildContext to show the dialog.
/// [title] - Title of the dialog.
/// [message] - Content/message of the dialog.
/// [showCancelButton] - Whether to display a Cancel button alongside the OK button.
/// [onOkPressed] - Callback function to execute when the OK button is pressed.
Future<void> showGenericDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool showCancelButton = false,
  Function()? onOkPressed,
}) {
  final tr = AppLocalizations.of(context)!;
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.65),
          ),
          onPressed: () {
            if (onOkPressed != null) {
              onOkPressed();
            }
            Navigator.of(context).pop();
          },
          child: Text(
            tr.okay,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (showCancelButton)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr.cancel),
          ),
      ],
    ),
  );
}
