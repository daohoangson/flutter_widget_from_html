import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

class PlaygroundScreen extends StatefulWidget {
  PlaygroundScreen();

  @override
  _PlaygroundScreenState createState() =>
      _PlaygroundScreenState('Hello World!');
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final TextEditingController controller;
  String html;

  _PlaygroundScreenState(String html)
      : controller = TextEditingController(text: html) {
    this.html = html;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() => html = controller.value.text));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Core'),
                Tab(text: 'Enhanced'),
              ],
            ),
            title: Text('Playground'),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    ListView(children: <Widget>[core.HtmlWidget(html)]),
                    ListView(children: <Widget>[HtmlWidget(html)]),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: controller,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
