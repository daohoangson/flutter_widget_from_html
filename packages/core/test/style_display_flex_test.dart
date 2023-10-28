import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders text', (WidgetTester tester) async {
    const html = '<div style="display: flex">Foo</div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Flex:direction=horizontal,mainAxisAlignment=start,'
        'crossAxisAlignment=start,children=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('renders blocks', (WidgetTester tester) async {
    const html =
        '<div style="display: flex"><div>Foo</div><div>Bar</div></div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children='
        '[CssBlock:child=[RichText:(:Foo)]],'
        '[CssBlock:child=[RichText:(:Bar)]]'
        ']',
      ),
    );
  });
}
