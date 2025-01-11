import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:globox/services/internal/messages_service.dart';
import 'package:globox/services/queries/send_messages.service.dart';
import 'package:globox/ui/screens/list_screen.dart';
import 'package:globox/ui/screens/map_screen.dart';
import 'package:globox/ui/widgets/loader.dart';
import 'package:globox/ui/widgets/new_package.dart';
import 'package:globox/ui/widgets/screen_footer.dart';
import 'package:provider/provider.dart';

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
  late AppState appState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState =
          Provider.of<AppState>(context, listen: false); // שמירה על האובייקט
      _initializeData();
    });
  }

  Future<void> loadPackages() async {
    appState.updateLoadingType(LoadingType.gettingPackages);
    appState.toggleLoading();

    await appState.fetchPackagesFromServer();
  }

  Future<void> _initializeData() async {
    await loadPackages();

    // after finished init the data then it can remove loader

    appState.updateLoadingType(LoadingType.none);
    appState.toggleLoading();
  }

  Future<void> loadMessages() async {
    if (appState.isLoading) return;

    appState.updateLoadingType(LoadingType.sendingMessages);
    appState.toggleLoading();

    final messagesService = MessagesService();
    await messagesService.getMessages(); // פעולה אסינכרונית
    var messageBodies = messagesService.messages
        .map((message) => message.body)
        .where((body) => body != null) // סינון של null
        .cast<String>()
        .toList();

    await sendMessages(messageBodies);

    await appState.fetchPackagesFromServer();
    appState.updateLoadingType(LoadingType.none);
    appState.toggleLoading();
  }

  void handleViewChange(int? index) {
    setState(() {
      _activeView = index == 0 ? ScreenView.ListView : ScreenView.MapView;
    });
  }

  void _openNewPackageModal(BuildContext context) {
    if (appState.isLoading) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.maybeOf(ctx)?.viewInsets.bottom ??
            0.0; // אם אין MediaQuery, השתמש ב-0
        return Padding(
          padding: EdgeInsets.only(
            bottom: bottomInset,
          ),
          child: AddNewPackage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    Widget screenWidget = PackagesListView(
      packages: appState.mainPackages,
    );

    if (_activeView == ScreenView.MapView) {
      screenWidget = PackageMapView(
        // passing the packages with coordinates exclusively
        packages: appState.mainPackages
            .where((pckg) => pckg.coordinates.isNotEmpty)
            .toList(),
      );
    }

    return Scaffold(
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
              child: appState.isLoading
                  ? Loader(
                      loadingType: appState.loadingType,
                    )
                  : SizedBox(
                      width: screenWidth * 0.95,
                      child: screenWidget,
                    ),
            ),
          ),
          ScreenFooter(
            onAddPackageTap: _openNewPackageModal,
            onScanSMSTap: loadMessages,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
