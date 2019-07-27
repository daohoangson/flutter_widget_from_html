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
      builderCallback: (meta, e) => e.classes.contains('skipMe')
          ? lazySet(null, isNotRenderable: true)
          : meta,
    );
    expect(explained, equals('[RichText:(:Bar.)]'));
  });
}
