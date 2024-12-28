import 'package:flutter/material.dart';
import '../../models/package.dart';

class ListItem extends StatelessWidget {
  final Package package;

  const ListItem({super.key, required Package this.package});

  @override
  Widget build(BuildContext context) {
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
                Text(package.id),
                Text(package.description),
                Text(package.address),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(package.status == 'Arrived'
                    ? Icons.check_rounded
                    : Icons.watch_later_outlined),
                Icon(Icons.delete)
              ],
            ),
          )
        ],
      )),
    );
  }
}
