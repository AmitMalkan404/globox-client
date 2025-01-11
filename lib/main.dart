import 'package:flutter/material.dart';
import 'package:globox/app.dart';
import 'package:provider/provider.dart';
import './services/internal/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Globox',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const App(),
      ),
    ),
  );
}
