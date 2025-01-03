import 'package:flutter/material.dart';
import 'package:globox/app.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Globox',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const App(),
    ),
  );
}
