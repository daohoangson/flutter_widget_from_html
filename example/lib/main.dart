import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Widget from HTML',
      home: HomeScreen(),
    );
  }
}
