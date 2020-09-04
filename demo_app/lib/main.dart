import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Widget from HTML',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),

        // let HomeScreen handle all the routings
        initialRoute: '/',
        onGenerateRoute: HomeScreen.onGenerateRoute,
      );
}
