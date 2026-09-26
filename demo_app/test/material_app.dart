import 'package:demo_app/widgets/material_compatibility.dart';
import 'package:material_ui/material_ui.dart';

Widget materialUiAppWrapper(Widget child) => MaterialApp(
  theme: ThemeData.light().copyWith(platform: TargetPlatform.android),
  debugShowCheckedModeBanner: false,
  builder: (context, child) => MaterialCompatibility(child: child!),
  home: Material(child: child),
);
