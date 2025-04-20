import 'package:flutter/material.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/enums/shipment_status.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:provider/provider.dart';

class ListItem extends StatelessWidget {
  final Package package;

  const ListItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    IconData getIconByShipmentStatus(ShipmentStatus status) {
      switch (status) {
        case ShipmentStatus.arrived:
          return Icons.check;
        case ShipmentStatus.noStatus:
          return Icons.question_mark_rounded;
        case ShipmentStatus.delivery:
          return Icons.local_shipping;
      }
    }

    void showDeleteDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Package"),
            content: Text("Are you sure you want to delete this package?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  appState.deleteItem(package.packageId);
                  Navigator.of(context).pop(); // close dialog
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    return Center(
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 250,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(package.packageId),
                  Text(package.description),
                  Text(package.address),
                ],
              ),
            ),
          ),
          Icon(getIconByShipmentStatus(package.status)),
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: TextButton.icon(
                onPressed: () {
                  if (appState.loadingType != LoadingType.deletingPackage) {
                    showDeleteDialog(context);
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFF00B8D9),
                  size: 25,
                ),
                label: Text(
                  '',
                  style: TextStyle(color: Color(0xFF00B8D9)),
                )),
          )
        ],
      )),
    );
  }
}
