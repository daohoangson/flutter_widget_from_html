import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  final html = '<span class="skipMe">Foo.</span>Bar.';

  testWidgets('renders all', (WidgetTester tester) async {
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo.Bar.)]'));
  });

  testWidgets('skips via callback', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      html,
      factoryBuilder: (config) => _IsNotRenderableTest(config),
    );
    expect(explained, equals('[RichText:(:Bar.)]'));
  });
}

class _IsNotRenderableTest extends WidgetFactory {
  _IsNotRenderableTest(HtmlConfig config) : super(config);

  @override
  NodeMetadata parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    if (attributes.containsKey('class') && attributes['class'] == 'skipMe') {
      return lazySet(null, isNotRenderable: true);
    }

    return super.parseTag(meta, tag, attributes);
  }
}
