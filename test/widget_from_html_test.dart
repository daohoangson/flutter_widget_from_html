import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  testWidgets('renders text with padding', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(0,10,0,10),child=[Text:Hello world]]'));
  });

  testWidgets('renders rich text with padding', (WidgetTester tester) async {
    final html = 'Hi <b>there</b>!';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[Padding:(0,10,0,10),child=[RichText:(:Hi (+b:there)(:!))]]'));
  });

  group('IMG tag', () {
    final configImg = Config(
      baseUrl: Uri.parse('http://base.com/path'),
      bodyPadding: null,
      imagePadding: null,
    );

    testWidgets('renders with padding', (WidgetTester tester) async {
      final html = 'x<img src="http://domain.com/image.png" />x';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Padding:(0,10,0,10),child=[Text:x]],' +
              '[Padding:(5,0,5,0),child=[CachedNetworkImage:http://domain.com/image.png]]' +
              ',[Padding:(0,10,0,10),child=[Text:x]]]'));
    });

    testWidgets('renders full url', (WidgetTester tester) async {
      final html = '<img src="http://domain.com/image.png" />';
      final explained = await explain(tester, html, config: configImg);
      expect(
        explained,
        equals('[CachedNetworkImage:http://domain.com/image.png]'),
      );
    });

    testWidgets('renders protocol relative url', (WidgetTester tester) async {
      final html = '<img src="//protocol.relative" />';
      final explained = await explain(tester, html, config: configImg);
      expect(
        explained,
        equals('[CachedNetworkImage:http://protocol.relative]'),
      );
    });

    testWidgets('renders root relative url', (WidgetTester tester) async {
      final html = '<img src="/root.relative" />';
      final explained = await explain(tester, html, config: configImg);
      expect(
        explained,
        equals('[CachedNetworkImage:http://base.com/root.relative]'),
      );
    });

    testWidgets('renders relative url', (WidgetTester tester) async {
      final html = '<img src="relative" />';
      final explained = await explain(tester, html, config: configImg);
      expect(
        explained,
        equals('[CachedNetworkImage:http://base.com/path/relative]'),
      );
    });
  });
}
