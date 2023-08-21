import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // Other theme properties you may want to customize
      ),
      home: MainScreen(),
    );
  }
}
