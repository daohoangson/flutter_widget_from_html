import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  final html = '<span class="skipMe">Foo.</span>Bar.';

  testWidgets('renders all', (WidgetTester tester) async {
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo.Bar.)]'));
  });

  testWidgets('skips element', (WidgetTester tester) async {
    final explained = await explain(tester, html,
        factoryBuilder: () => _IsNotRenderableTest());
    expect(explained, equals('[RichText:(:Bar.)]'));
  });
}

class _IsNotRenderableTest extends WidgetFactory {
  @override
  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    if (attrs.containsKey('class') && attrs['class'] == 'skipMe') {
      meta.isNotRenderable = true;
    }

    return super.parseTag(meta, tag, attrs);
  }
}
