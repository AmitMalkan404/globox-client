import 'package:flutter/material.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/services/queries/delete_package.dart';
import '../../models/package.dart';

class ListItem extends StatelessWidget {
  final Package package;

  const ListItem({super.key, required Package this.package});

  void _showDeleteDialog(BuildContext context) {
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
                await deletePackage(package.packageId);
                Navigator.of(context).pop(); // close dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Center(
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 28.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(package.packageId),
                Text(package.description),
                Text(package.address),
              ],
            ),
          ),
          Icon(getIconByShipmentStatus(package.status)),
          Padding(
            padding: const EdgeInsets.only(
              right: 28.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context),
                label: Icon(Icons.delete)),
          )
        ],
      )),
    );
  }
}
