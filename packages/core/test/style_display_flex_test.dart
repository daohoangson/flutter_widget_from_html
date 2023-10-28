import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('basic usage', (WidgetTester tester) async {
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
}
