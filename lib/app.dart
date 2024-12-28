import 'package:flutter/material.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/ui/screens/list_screen.dart';
import 'package:globox/ui/screens/map_screen.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  var _activeView = ScreenView.ListView;

  void handleViewChange(bool state) {
    setState(() {
      _activeView = state ? ScreenView.ListView : ScreenView.MapView;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = PackagesListView();

    if (_activeView == ScreenView.MapView) {
      screenWidget = PackageMapView(
        packages: [],
      );
    }

    return MaterialApp(
      title: 'Globox',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LiteRollingSwitch(
                value: true,
                width: 150,
                textOn: '',
                textOff: '',
                colorOn: Colors.lightBlue,
                colorOff: Colors.greenAccent,
                iconOn: Icons.list,
                iconOff: Icons.map,
                animationDuration: const Duration(milliseconds: 300),
                onChanged: handleViewChange,
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: screenWidget,
            ),
          ],
        ),
      ),
    );
  }
}
