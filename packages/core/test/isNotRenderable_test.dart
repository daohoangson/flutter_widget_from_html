import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

class _DoNotRenderSkipMe extends WidgetFactory {
  _DoNotRenderSkipMe(BuildContext context) : super(context);

  NodeMetadata collectMetadata(dom.Element e) {
    final meta = super.collectMetadata(e);

    if (e.className == 'skipMe') {
      return lazySet(meta, isNotRenderable: true);
    }

    return meta;
  }
}

class _HtmlWidget extends HtmlWidget {
  _HtmlWidget(String html) : super(html);

  WidgetFactory newWidgetFactory(BuildContext context) =>
      _DoNotRenderSkipMe(context);
}

void main() {
  testWidgets('skips via callback', (WidgetTester tester) async {
    final html = '<span class="skipMe">Foo.</span>Bar.';
    final explained1 = await explain(tester, html);
    expect(explained1, equals('[Text:Foo.Bar.]'));

    final explained2 = await explain(tester, html, hw: _HtmlWidget(html));
    expect(explained2, equals('[Text:Bar.]'));
  });
}
