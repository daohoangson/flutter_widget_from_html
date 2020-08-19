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
    final explained = await explain(tester, null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _IsNotRenderableTest(),
          key: hwKey,
        ));
    expect(explained, equals('[RichText:(:Bar.)]'));
  });
}

class _IsNotRenderableTest extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.classes.contains('skipMe')) {
      meta.isNotRenderable = true;
    }

    return super.parse(meta);
  }
}
