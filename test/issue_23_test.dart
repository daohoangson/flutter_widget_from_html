import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

const html = 'Above\n<blockquote>Foo</blockquote>\nBelow';

class BlockquoteWebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('BlockquoteWebViewScreen'),
        ),
        body: ListView(children: <Widget>[
          HtmlWidget(
            html,
            factoryBuilder: (c, hw) => _BlockquoteWebViewWf(c, hw),
          ),
        ]),
      );
}

class _BlockquoteWebViewWf extends WidgetFactory {
  final buildOp = BuildOp(
    onWidgets: (meta, _) => [
      WebView(
        Uri.dataFromString(
          meta.domElement.innerHtml,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        aspectRatio: 16 / 9,
        getDimensions: true,
      )
    ],
  );

  _BlockquoteWebViewWf(BuildContext context, HtmlWidget htmlWidget)
      : super(context, htmlWidget);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    switch (e.localName) {
      case 'blockquote':
        return lazySet(null, buildOp: buildOp);
    }

    return super.parseElement(meta, e);
  }
}

void main() {
  testWidgets('renders BLOCKQUOTE as web view', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        bodyPadding: const EdgeInsets.all(0),
        factoryBuilder: (c, hw) => _BlockquoteWebViewWf(c, hw),
      ),
    );
    expect(
        explained,
        equals('[Column:children=[RichText:(:Above)],'
            '[WebView:url=data:text/html;charset=utf-8,Foo,aspectRatio=1.78,getDimensions=1,js=1],'
            '[RichText:(:Below)]]'));
  });
}
