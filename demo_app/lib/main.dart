import 'package:flutter/material.dart';

import 'model/show_perf_overlay.dart';
import 'screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: showPerfOverlayListenable,
        builder: (_, __) => MaterialApp(
          title: 'Flutter Widget from HTML',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          showPerformanceOverlay: showPerfOverlayValue(),

          // let HomeScreen handle all the routings
          initialRoute: '/',
          onGenerateRoute: HomeScreen.onGenerateRoute,
        ),
      );
}
