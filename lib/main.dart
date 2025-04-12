import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globox/app.dart';
import 'package:globox/login/auth.dart';
import 'package:globox/firebase_options.dart';
import 'package:globox/ui/theme.dart';
import 'package:provider/provider.dart';
import './services/internal/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Globox',
        theme: appTheme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {}
            if (snapshot.hasData) {
              return const App();
            }
            return const AuthScreen();
          },
        ),
      ),
    ),
  );
}
