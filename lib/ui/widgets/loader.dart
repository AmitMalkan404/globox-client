import 'package:flutter/material.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Loader extends StatelessWidget {
  final LoadingType loadingType;

  const Loader({super.key, required this.loadingType});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    String getTextByLoadingType() {
      switch (loadingType) {
        case LoadingType.addingPackage:
          return tr.addingYourPackageLoader;
        case LoadingType.gettingPackages:
          return tr.gettingUpdatedPackagesLoader;
        case LoadingType.sendingMessages:
          return tr.scanningYourMessagesLoader;
        case LoadingType.deletingPackage:
          return tr.deletingPackageLoader;
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
