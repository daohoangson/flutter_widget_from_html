import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'widgets/popup_menu.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuStateProvider(
        builder: (context) => MaterialApp(
          title: 'Flutter Widget from HTML',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          showPerformanceOverlay: context.showPerformanceOverlay,

          // let HomeScreen handle all the routings
          initialRoute: '/',
          onGenerateRoute: HomeScreen.onGenerateRoute,
        ),
      );
}
