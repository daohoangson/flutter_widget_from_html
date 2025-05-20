import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders basic form', (tester) async {
    const html = '<form>'
        '<input placeholder="foo">'
        '<textarea>bar</textarea>'
        '<input type="submit" value="Send">'
        '</form>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[Form,[TextFormField],[TextFormField],[ElevatedButton]]'),
    );
  });
}
