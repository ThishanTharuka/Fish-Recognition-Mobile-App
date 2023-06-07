import 'package:flutter/material.dart';
import 'package:fish_recognition_mobile_app/opening_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishDetective',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpeningPage(), // Set OpeningPage as the main widget
    );
  }
}
