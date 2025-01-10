import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:globox/models/enums.dart';
import 'package:globox/models/package.dart';
import 'package:globox/services/queries/get_packages.service.dart';
import 'package:globox/services/internal/messages_service.dart';
import 'package:globox/services/queries/send_messages.service.dart';
import 'package:globox/ui/screens/list_screen.dart';
import 'package:globox/ui/screens/map_screen.dart';
import 'package:globox/ui/widgets/loader.dart';
import 'package:globox/ui/widgets/new_package.dart';
import 'package:globox/ui/widgets/screen_footer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  List<Package> _packages = [];
  var _activeView = ScreenView.ListView;
  bool _isLoading = false;
  LoadingType _loadingType = LoadingType.none;
  final MessagesService messagesService = MessagesService();

  @override
  void initState() {
    super.initState();
    _initializeData(); // קריאה לפונקציה נפרדת
  }

  Future<void> _initializeData() async {
    final packages = await _loadPackages();
    setState(() {
      _isLoading = false;
      _packages = packages; // עדכון הסטייט
    });
  }

  Future<void> _loadMessages() async {
    if (_isLoading) return;
    setState(() {
      _loadingType = LoadingType.sendingMessages;
      _isLoading = true;
    });
    final messagesService = MessagesService();
    await messagesService.getMessages(); // פעולה אסינכרונית
    var messageBodies = messagesService.messages
        .map((message) => message.body)
        .where((body) => body != null) // סינון של null
        .cast<String>()
        .toList();

    await sendMessages(messageBodies);

    final packages = await _loadPackages();
    setState(() {
      _packages = packages;
      _loadingType = LoadingType.none;
      _isLoading = false;
    });
  }

  Future<List<Package>> _loadPackages() async {
    setState(() {
      _loadingType = LoadingType.gettingPackages;
      _isLoading = true;
    });
    return await getPackages();
  }

  void handleViewChange(int? index) {
    setState(() {
      _activeView = index == 0 ? ScreenView.ListView : ScreenView.MapView;
    });
  }

  void _openNewPackageModal(BuildContext context) {
    if (_isLoading) return;
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
          child: AddNewPackage(
            newPackageCallback: handleNewPackageCallback,
          ),
        );
      },
    );
  }

  /// AddNewPackage window is updating the app on each stage of adding the new
  /// package. when its waiting for adding the package it sends us
  /// "addingPackage" status and when its done it sends us "none".
  /// after its done we are getting all the packages again with the new package
  /// that we just added.
  ///
  /// @param loadingType the type of loading that the AddNewPackage is sending.
  ///
  /// @return nothing
  ///
  Future<void> handleNewPackageCallback(LoadingType loadingType) async {
    setState(() {
      _loadingType = loadingType;
      _isLoading = true;
    });
    if (_loadingType == LoadingType.none) {
      final packages = await _loadPackages();
      setState(() {
        _loadingType = LoadingType.none;
        _isLoading = false;
        _packages = packages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Widget screenWidget = PackagesListView(
      packages: this._packages,
    );

    if (_activeView == ScreenView.MapView) {
      screenWidget = PackageMapView(
        // passing the packages with coordinates exclusively
        packages: this
            ._packages
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
              child: _isLoading
                  ? Loader(
                      loadingType: _loadingType,
                    )
                  : SizedBox(
                      width: screenWidth * 0.95,
                      child: screenWidget,
                    ),
            ),
          ),
          ScreenFooter(
            onAddPackageTap: _openNewPackageModal,
            onScanSMSTap: _loadMessages,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
