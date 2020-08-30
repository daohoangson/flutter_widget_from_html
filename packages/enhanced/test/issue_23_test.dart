import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

const html = 'Above\n<blockquote>Foo</blockquote>\nBelow';

class _BlockquoteWebView extends WidgetFactory {
  final blockquoteOp = BuildOp(
    onBuilt: (meta, _) => [
      WebView(
        Uri.dataFromString(
          meta.element.innerHtml,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        aspectRatio: 16 / 9,
        autoResize: true,
      )
    ],
  );

  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'blockquote') {
      meta.register(blockquoteOp);
      return;
    }

    return super.parse(meta);
  }
}

void main() {
  testWidgets('renders BLOCKQUOTE as web view', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        factoryBuilder: () => _BlockquoteWebView(),
        key: hwKey,
      ),
    );
    expect(
        explained,
        equals('[Column:children=[RichText:(:Above)],'
            '[CssBlock:child=[WebView:url=data:text/html;charset=utf-8,Foo,aspectRatio=1.78,autoResize=true]],'
            '[RichText:(:Below)]]'));
  });
}
