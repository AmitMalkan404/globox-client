import 'package:flutter/material.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/action_codes_map.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:globox/ui/widgets/message_dialog_button.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  final Package package;

  const ListItem({super.key, required this.package});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _showDeleteDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Package"),
        content: const Text("Are you sure you want to delete this package?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              appState.deleteItem(widget.package.packageId);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final pkg = widget.package;
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    final details = <String, dynamic>{
      "Description": pkg.description,
      "Address": pkg.address,
      "Pickup Point": pkg.pickupPointName,
      "Post Office Code": pkg.postOfficeCode,
      "Status": pkg.statusDesc,
      "Details": pkg.statusDetailedDesc,
      "Last Update": pkg.time,
      "Origin": pkg.originCountry,
      "Destination": pkg.destCountry,
      "Contact Details": pkg.contactDetails,
    };

    final detailWidgets = details.entries
        .where((entry) =>
            entry.value != null && entry.value.toString().trim().isNotEmpty)
        .map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: RichText(
                text: TextSpan(
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: entry.value.toString(),
                    ),
                  ],
                ),
              ),
            ))
        .toList();

    final actionInfo = actionCodeMap[pkg.actionCode];
    final cardColor =
        actionInfo?.backgroundColor.withAlpha((0.5 * 255).toInt()) ??
            Colors.grey.withAlpha((0.05 * 255).toInt());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    actionInfo?.icon ?? Icons.question_answer,
                    color: Colors.grey[200],
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  if (pkg.arrivalMessage != null &&
                      pkg.arrivalMessage!.trim().isNotEmpty)
                    MessageDialogButton(message: pkg.arrivalMessage!),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pkg.packageId,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (pkg.statusDetailedDesc != null &&
                            pkg.statusDetailedDesc!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              pkg.statusDetailedDesc!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (pkg.eStatus != "ERROR")
                    IconButton(
                      icon: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child:
                            const Icon(Icons.expand_more, color: Colors.blue),
                      ),
                      onPressed: _toggleExpanded,
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF00B8D9)),
                    onPressed: () {
                      if (appState.loadingType != LoadingType.deletingPackage) {
                        _showDeleteDialog(context, appState);
                      }
                    },
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: detailWidgets,
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
