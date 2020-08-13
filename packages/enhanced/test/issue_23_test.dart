import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
            factoryBuilder: () => _BlockquoteWebViewWf(),
            key: hwKey,
          ),
        ]),
      );
}

class _BlockquoteWebViewWf extends WidgetFactory {
  final blockquoteOp = BuildOp(
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

  @override
  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    if (tag == 'blockquote') {
      meta.register(blockquoteOp);
      return;
    }

    return super.parseTag(meta, tag, attrs);
  }
}

void main() {
  testWidgets('renders BLOCKQUOTE as web view', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        factoryBuilder: () => _BlockquoteWebViewWf(),
        key: hwKey,
      ),
    );
    expect(
        explained,
        equals('[Column:children=[RichText:(:Above)],'
            '[CssBlock:child=[WebView:url=data:text/html;charset=utf-8,Foo,aspectRatio=1.78,getDimensions=true]],'
            '[RichText:(:Below)]]'));
  });
}
