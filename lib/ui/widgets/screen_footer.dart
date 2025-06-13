import 'package:flutter/material.dart';

class ScreenFooter extends StatelessWidget {
  final void Function(BuildContext context) onAddPackageTap;
  final void Function() onScanSMSTap;

  const ScreenFooter({
    super.key,
    required this.onAddPackageTap,
    required this.onScanSMSTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          heroTag: "add_package_fab",
          onPressed: () => onAddPackageTap(context),
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 24), // Add gap between buttons
        FloatingActionButton(
          heroTag: "scan_sms_fab",
          onPressed: onScanSMSTap,
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
