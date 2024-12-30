import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/services/messages_service.dart';
import 'package:globox/ui/screens/list_screen.dart';
import 'package:globox/ui/screens/map_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  var _activeView = ScreenView.ListView;
  final MessagesService messagesService = MessagesService();

  @override
  void initState() {
    super.initState();
    _loadMessages(); // קריאה לפונקציה נפרדת
  }

  Future<void> _loadMessages() async {
    final messagesService = MessagesService();
    await messagesService.getMessages(); // פעולה אסינכרונית
    var messageBodies = messagesService.messages
        .map((message) => message.body)
        .where((body) => body != null) // סינון של null
        .cast<String>()
        .toList();
    setState(() {});
  }

  void handleViewChange(int? index) {
    setState(() {
      _activeView = index == 0 ? ScreenView.ListView : ScreenView.MapView;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                child: FlutterToggleTab(
                  width: 50,
                  height: 60,
                  borderRadius: 15,
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  icons: [Icons.list, Icons.map],
                  iconSize: 30.0,
                  selectedLabelIndex: (index) {
                    handleViewChange(index);
                  },
                  labels: ['', ''],
                  selectedIndex: _activeView.index,
                )),
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: screenWidth * 0.95,
                  child: screenWidget,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
