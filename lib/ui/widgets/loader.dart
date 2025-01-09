import 'package:flutter/material.dart';
import 'package:globox/models/enums.dart';

class Loader extends StatelessWidget {
  final LoadingType loadingType;

  const Loader({super.key, required this.loadingType});

  @override
  Widget build(BuildContext context) {
    String getTextByLoadingType() {
      switch (loadingType) {
        case LoadingType.addingPackage:
          return "Adding your package...";
        case LoadingType.gettingPackages:
          return "Getting updated packages...";
        case LoadingType.sendingMessages:
          return "Scanning your messages...";
        case LoadingType.none:
          return '';
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16), // מרווח בין ה-Loader לטקסט
          Text(
            getTextByLoadingType(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
