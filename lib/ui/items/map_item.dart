import 'package:flutter/material.dart';
import 'package:globox/models/classes/package.dart';

class PackageDetailsWidget extends StatelessWidget {
  final Package package;

  const PackageDetailsWidget({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
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
              "Package Details",
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
                "Package ID:",
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
                "Address:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  package.address,
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
                "Description:",
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
              Icon(Icons.info, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                "Status:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                package.status
                    .toString()
                    .split('.')
                    .last, // Convert enum to string
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Coordinates
          Row(
            children: [
              Icon(Icons.map, color: Colors.purple),
              SizedBox(width: 10),
              Text(
                "Coordinates:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                "${package.coordinates[0].toStringAsFixed(2)}, ${package.coordinates[1].toStringAsFixed(2)}",
              ),
            ],
          ),

          SizedBox(height: 20),

          // Close Button
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Close"),
            ),
          ),
        ],
      ),
    );
  }
}
