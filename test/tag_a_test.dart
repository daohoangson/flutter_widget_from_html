import 'package:flutter_test/flutter_test.dart';

import '_.dart';

const kColor = '#FF0000FF';
const kHref = 'http://domain.com/href';

void main() {
  testWidgets('renders underline', (WidgetTester tester) async {
    final html = '<a href="$kHref">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:($kColor+u+onTap:Foo)]'));
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref" style="color: #f00">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FFFF0000+u+onTap:Foo)]'));
  });

  testWidgets('renders inner stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref"><b><i>Foo</i></b></a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:($kColor+u+i+b+onTap:Foo)]'));
  });

  testWidgets('renders DIV tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child=[RichText:($kColor+u:Foo)]]'),
    );
  });
}
