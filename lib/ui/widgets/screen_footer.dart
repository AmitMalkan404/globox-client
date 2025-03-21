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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 48.0, top: 16.0, bottom: 10.0),
          child: FloatingActionButton(
            heroTag: "add_package_fab",
            onPressed: () => this.onAddPackageTap(context),
            child: const Icon(Icons.add),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 48.0, top: 16.0, bottom: 10.0),
          child: FloatingActionButton(
            heroTag: "scan_sms_fab",
            onPressed: onScanSMSTap,
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
