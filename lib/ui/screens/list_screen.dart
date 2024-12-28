import 'package:flutter/material.dart';
import 'package:globox/ui/widgets/list_item.dart';
import '../../models/package.dart';

class PackagesListView extends StatelessWidget {
  final List<Package> packages = [
    Package(
      id: '1',
      address: 'Tel Aviv',
      description: 'A package to Tel Aviv.',
      coordinates: [32.0853, 34.7818],
      status: 'Arrived',
    ),
    Package(
      id: '2',
      address: 'Haifa',
      description: 'A package to Haifa.',
      coordinates: [32.7940, 34.9896],
      status: '',
    ),
    Package(
      id: '3',
      address: 'Jerusalem',
      description: 'A package to Jerusalem.',
      coordinates: [31.7683, 35.2137],
      status: '',
    ),
    Package(
      id: '4',
      address: 'Beersheba',
      description: 'A package to Beersheba.',
      coordinates: [31.2529, 34.7915],
      status: 'Arrived',
    ),
    Package(
      id: '5',
      address: 'Ra\'anana',
      description: 'A package to Ra\'anana.',
      coordinates: [32.1553, 34.898],
      status: 'Arrived',
    ),
  ];

  PackagesListView({super.key});

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
