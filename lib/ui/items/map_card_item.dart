import 'package:flutter/material.dart';
import 'package:globox/models/action_codes_map.dart';
import 'package:globox/models/classes/package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapCardItem extends StatelessWidget {
  final Package package;

  const MapCardItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              "${tr.packageDetails}:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Package ID
          Row(
            children: [
              Icon(Icons.tag, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                "${tr.packageId}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(package.packageId),
            ],
          ),

          SizedBox(height: 10),

          // Address
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 10),
              Text(
                "${tr.address}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${package.pickupPointName}, ${package.address}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Description
          Row(
            children: [
              Icon(Icons.description, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "${tr.description}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  package.description,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Status
          Row(
            children: [
              Icon(Icons.code, color: const Color.fromARGB(255, 22, 111, 212)),
              SizedBox(width: 10),
              Text(
                "${tr.status}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                actionCodeMap[package.actionCode]!.status(context),
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),

          SizedBox(height: 10),

          // postOfficeCode
          Row(
            children: [
              Icon(Icons.code, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                "${tr.postOfficeCode}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                package.postOfficeCode,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
