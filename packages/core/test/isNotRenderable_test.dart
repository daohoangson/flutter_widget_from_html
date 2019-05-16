import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  testWidgets('skips via callback', (WidgetTester tester) async {
    final html = '<span class="skipMe">Foo.</span>Bar.';
    final explained1 = await explain(tester, html);
    expect(explained1, equals('[RichText:(:Foo.Bar.)]'));

    final explained2 = await explain(
      tester,
      html,
      builderCallback: (meta, e) => e.classes.contains('skipMe')
          ? lazySet(null, isNotRenderable: true)
          : meta,
    );
    expect(explained2, equals('[RichText:(:Bar.)]'));
  });
}
