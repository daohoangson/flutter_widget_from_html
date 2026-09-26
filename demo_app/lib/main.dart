import 'package:demo_app/screens/home.dart';
import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen(_onLogRecord);

  runApp(const MyApp());
}

void _onLogRecord(LogRecord record) {
  final prefix =
      '${record.time.toIso8601String().substring(11)} '
      '${record.loggerName}@${record.level.name} ';
  debugPrint('$prefix${record.message}');

  final error = record.error;
  final stackTrace = record.stackTrace;
  if (error != null || stackTrace != null) {
    debugPrint('$prefix$error\n$stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => PopupMenuStateProvider(
    builder: (context) => MaterialApp(
      title: 'Flutter Widget from HTML',
      theme: FlexThemeData.light(scheme: FlexScheme.blueM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueM3),
      showPerformanceOverlay: context.showPerformanceOverlay,

      // let HomeScreen handle all the routings
      initialRoute: '/',
      onGenerateRoute: HomeScreen.onGenerateRoute,
    ),
  );
}
