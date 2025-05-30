import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final appState = AppState();
  await appState.loadLocale();

  runApp(
    ChangeNotifierProvider(
      create: (_) => appState,
      child: const GloboxAppWithLocaleListener(),
    ),
  );
}

class GloboxAppWithLocaleListener extends StatelessWidget {
  const GloboxAppWithLocaleListener({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return GloboxApp(locale: appState.locale);
      },
    );
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
