import 'package:demo_app/screens/audio.dart';
import 'package:demo_app/screens/custom_styles_builder.dart';
import 'package:demo_app/screens/custom_widget_builder.dart';
import 'package:demo_app/screens/font_size.dart';
import 'package:demo_app/screens/golden.dart';
import 'package:demo_app/screens/hello_world.dart';
import 'package:demo_app/screens/hello_world_core.dart';
import 'package:demo_app/screens/huge_html.dart';
import 'package:demo_app/screens/iframe.dart';
import 'package:demo_app/screens/img.dart';
import 'package:demo_app/screens/img_file.dart';
import 'package:demo_app/screens/photo_view.dart';
import 'package:demo_app/screens/smilie.dart';
import 'package:demo_app/screens/video.dart';
import 'package:demo_app/screens/wordpress.dart';
import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static final _screens = <String, Widget Function()>{
    'Hello World': () => const HelloWorldScreen(),
    'Hello World (core)': () => const HelloWorldCoreScreen(),
    'Audio': () => const AudioScreen(),
    'Iframe': () => const IframeScreen(),
    'Images': () => const ImgScreen(),
    'Image (file://)': () => const ImgFileScreen(),
    'Video': () => const VideoScreen(),
    'customStylesBuilder': () => const CustomStylesBuilderScreen(),
    'customWidgetBuilder': () => const CustomWidgetBuilderScreen(),
    'font-size': () => const FontSizeScreen(),
    'Goldens': () => const GoldensScreen(),
    'HugeHtml': () => const HugeHtmlScreen(),
    'Photo View': () => const PhotoViewScreen(),
    'Smilie': () => const SmilieScreen(),
    'Wordpress': () => const WordpressScreen(),
  };

  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Demo app'),
          actions: const [PopupMenu()],
        ),
        body: ListView(
          children: _screens.keys
              .map(
                (title) => ListTile(
                  title: Text(title),
                  onTap: () =>
                      Navigator.pushNamed(context, _routeNameFromTitle(title)),
                ),
              )
              .toList(growable: false),
        ),
      );

  static Route onGenerateRoute(RouteSettings route) {
    for (final title in _screens.keys) {
      if (_routeNameFromTitle(title) != route.name) {
        continue;
      }

      return MaterialPageRoute(
        builder: (_) => _screens[title].call(),
        settings: RouteSettings(name: route.name),
      );
    }

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const HomeScreen(),
      settings: const RouteSettings(name: '/'),
    );
  }

  static String _routeNameFromTitle(String title) =>
      '/${title.toLowerCase().replaceAll(RegExp('[^a-z]'), '')}';
}
