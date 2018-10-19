import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

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
              ListView(children: <Widget>[Text(html)]),
              ListView(children: <Widget>[core.HtmlWidget(html)]),
              ListView(children: <Widget>[HtmlWidget(html)]),
            ],
          ),
        ),
      );
}
