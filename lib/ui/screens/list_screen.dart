import 'package:flutter/material.dart';
import 'package:globox/ui/items/list_item.dart';
import 'package:globox/ui/screens/empty_list_screen.dart';
import '../../models/classes/package.dart';

class PackagesListView extends StatelessWidget {
  final List<Package> packages;

  const PackagesListView({
    super.key,
    required this.packages,
  });

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return const EmptyListView();
    }

    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return ListItem(package: package);
      },
    );
  }
}
