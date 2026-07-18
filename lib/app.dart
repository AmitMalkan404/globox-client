import 'package:flutter/material.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/models/enums/loading_type.dart';
import 'package:globox/models/enums/screen_view.dart';
import 'package:globox/services/internal/messages_service.dart';
import 'package:globox/ui/screens/list_screen.dart';
import 'package:globox/ui/screens/map_screen.dart';
import 'package:globox/ui/widgets/dialogs.dart';
import 'package:globox/ui/widgets/loader.dart';
import 'package:globox/ui/widgets/new_package.dart';
import 'package:globox/ui/widgets/screen_footer.dart';
import 'package:globox/ui/widgets/side_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globox/providers/packages_provider.dart';
import 'package:globox/providers/loading_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() {
    return _AppScreenState();
  }
}

class _AppScreenState extends ConsumerState<App> {
  var _activeView = ScreenView.ListView;
  MessagesService messagesService =
      MessagesService(); // יצירת מופע של MessagesService

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> loadPackages() async {
    ref.read(globalLoadingProvider.notifier).state =
        LoadingType.gettingPackages;

    try {
      await ref.read(packagesProvider.future);
    } catch (e) {
      print('Error loading packages: $e');
    }
  }

  Future<void> _initializeData() async {
    await updatePackageStatusFromMessages(context);
    await loadPackages();

    // after finished init the data then it can remove loader

    ref.read(globalLoadingProvider.notifier).state = LoadingType.none;
  }

  Future<void> updatePackageStatusFromMessages(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;

    if (ref.read(globalLoadingProvider) != LoadingType.none) return;

    try {
      ref.read(globalLoadingProvider.notifier).state =
          LoadingType.sendingMessages;

      final activePackages = ref.read(packagesProvider).valueOrNull ?? [];

      // sendMessagesData is now Riverpod-free; it returns an SmsResult?
      // We apply the patch here in the caller, keeping the service clean.
      final result = await messagesService.sendMessagesData(
        context,
        activePackages,
      );

      if (result != null && result.syncedPackageIds.isNotEmpty) {
        await ref.read(packagesProvider.notifier).patchPackages(
          result.syncedPackageIds,
          (pkg) => Package.fromJson({
            ...pkg.toJson(),
            'lastSMSSync': result.syncedAt.toIso8601String(),
          }),
        );
      }

      await ref.read(packagesProvider.notifier).refresh();
    } catch (error) {
      showGenericDialog(
        context: context,
        title: tr.error,
        message: tr.somethingWentWrong,
      );
      print('Error updating package status: $error');
    } finally {
      ref.read(globalLoadingProvider.notifier).state = LoadingType.none;
    }
  }

  void handleViewChange(int? index) {
    setState(() {
      _activeView = index == 0 ? ScreenView.ListView : ScreenView.MapView;
    });
  }

  void _openNewPackageModal() {
    if (ref.read(globalLoadingProvider) != LoadingType.none) return;
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
    final packages = ref.watch(packagesProvider).valueOrNull ?? [];
    final loadingType = ref.watch(globalLoadingProvider);
    final isLoading = loadingType != LoadingType.none;

    double screenWidth = MediaQuery.of(context).size.width;
    Widget screenWidget = PackagesListView(
      packages: packages,
    );

    if (_activeView == ScreenView.MapView) {
      screenWidget = PackageMapView(
        // passing the packages with coordinates exclusively
        packages:
            packages.where((pckg) => pckg.coordinates.isNotEmpty).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Globox"),
      ),
      drawer: SideDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected: [
                _activeView == ScreenView.ListView,
                _activeView == ScreenView.MapView,
              ],
              onPressed: (int index) {
                setState(() {
                  _activeView =
                      (index == 0) ? ScreenView.ListView : ScreenView.MapView;
                });
              },
              children: const <Widget>[
                Icon(Icons.list),
                Icon(Icons.map),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isLoading
                  ? Loader(
                      loadingType: loadingType,
                    )
                  : SizedBox(
                      width: screenWidth * 0.95,
                      child: screenWidget,
                    ),
            ),
          ),
          ScreenFooter(
            onAddPackageTap: (ctx) => _openNewPackageModal(),
            onScanSMSTap: () {
              updatePackageStatusFromMessages(context);
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
