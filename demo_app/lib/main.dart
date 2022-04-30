import 'package:demo_app/screens/home.dart';
import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

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
