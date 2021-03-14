import 'package:flutter/material.dart';

import 'custom_styles_builder.dart';
import 'custom_widget_builder.dart';
import 'font_size.dart';
import 'golden.dart';
import 'hello_world.dart';
import 'hello_world_core.dart';
import 'iframe.dart';
import 'iframe_twitter.dart';
import 'img.dart';
import 'img_file.dart';
import 'math.dart';
import 'photo_view.dart';
import 'smilie.dart';
import 'video.dart';
import 'wordpress.dart';

class HomeScreen extends StatelessWidget {
  static final _screens = <String, Widget Function()>{
    'Hello World': () => HelloWorldScreen(),
    'Hello World (core)': () => HelloWorldCoreScreen(),
    'Iframe': () => IframeScreen(),
    'Iframe/Twitter': () => IframeTwitterScreen(),
    'Images': () => ImgScreen(),
    'Image (file://)': () => ImgFileScreen(),
    'Math': () => MathScreen(),
    'Video': () => VideoScreen(),
    'customStylesBuilder': () => CustomStylesBuilderScreen(),
    'customWidgetBuilder': () => CustomWidgetBuilderScreen(),
    'font-size': () => FontSizeScreen(),
    'Goldens': () => GoldensScreen(),
    'Photo View': () => PhotoViewScreen(),
    'Smilie': () => SmilieScreen(),
    'Wordpress': () => WordpressScreen(),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Demo app')),
        body: ListView(
          children: _screens.keys
              .map((title) => ListTile(
                    title: Text(title),
                    onTap: () => Navigator.pushNamed(
                        context, _routeNameFromTitle(title)),
                  ))
              .toList(growable: false),
        ),
      );

  static Route onGenerateRoute(RouteSettings route) {
    for (final title in _screens.keys) {
      if (_routeNameFromTitle(title) != route.name) continue;

      return MaterialPageRoute(
        builder: (_) => _screens[title].call(),
        settings: RouteSettings(name: route.name),
      );
    }

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => HomeScreen(),
      settings: RouteSettings(name: '/'),
    );
  }

  static String _routeNameFromTitle(String title) =>
      '/' + title.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
}
