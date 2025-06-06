import 'package:flutter/material.dart';
import 'package:globox/ui/items/list_item.dart';
import '../../models/classes/package.dart';

class PackagesListView extends StatelessWidget {
  final List<Package> packages;

  const PackagesListView({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          return ListItem(
            package: package,
          );
        },
      ),
    );
  }
}
