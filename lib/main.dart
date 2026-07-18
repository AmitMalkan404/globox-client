import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/locale_provider.dart';

import 'firebase_options.dart';
import 'services/internal/app_state.dart';
import 'ui/theme.dart';
import 'app.dart';
import 'login/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // יצירת קונטיינר כדי לאתחל את השפה לפני ה-runApp
  final container = ProviderContainer();
  await container.read(localeProvider.notifier).loadLocale();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: provider.ChangeNotifierProvider(
        create: (_) => AppState(), // נשאר זמנית בשביל שאר המשתנים
        child: const GloboxAppWithLocaleListener(),
      ),
    ),
  );
}

class GloboxAppWithLocaleListener extends ConsumerWidget {
  const GloboxAppWithLocaleListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return GloboxApp(locale: locale);
  }
}

class GloboxApp extends StatelessWidget {
  final Locale locale;

  const GloboxApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('he')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Globox',
      theme: appTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const App(); // כאן נכנסת האפליקציה שלך
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
