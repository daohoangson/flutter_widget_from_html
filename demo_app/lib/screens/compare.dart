import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import '../html_widget.dart';

class CompareScreen extends StatelessWidget {
  final String html;
  final String title;

  CompareScreen({this.html, this.title});

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'HTML'),
                Tab(text: 'Core'),
                Tab(text: 'Enhanced'),
              ],
            ),
            title: Text(title),
          ),
          body: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(html),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: core.HtmlWidget(html),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(html),
                ),
              ),
            ],
          ),
        ),
      );
}
