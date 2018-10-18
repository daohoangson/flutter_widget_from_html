import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

class _WhiteText extends WidgetFactory {
  _WhiteText(BuildContext context) : super(context);

  NodeMetadata collectMetadata(dom.Element e) {
    final meta = super.collectMetadata(e);

    if (e.className == 'x') return lazyAddNode(meta, text: 'white');

    return meta;
  }
}

void main() {
  testWidgets('skips via callback', (WidgetTester tester) async {
    final html = 'This is <span class="x">black</span> text.';
    final explained1 = await explain(tester, html);
    expect(explained1, equals('[Text:This is black text.]'));

    final explained2 = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        wfBuilder: (context) => _WhiteText(context),
      ),
    );
    expect(explained2, equals('[Text:This is white text.]'));
  });
}
