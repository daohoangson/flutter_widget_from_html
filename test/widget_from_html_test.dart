import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/widget_from_html.dart';

import '../packages/core/test/_.dart' as _coreTesting;

Future<String> explain(WidgetTester tester, String html,
        {Config config}) async =>
    _coreTesting.explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        config: config ?? const Config(),
      ),
    );

void main() {
  testWidgets('renders text with padding', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[Padding:padding=(5,10,5,10),child=[Text:Hello world]]'));
  });

  testWidgets('renders rich text with padding', (WidgetTester tester) async {
    final html = 'Hi <b>there</b>!';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Padding:padding=(5,10,5,10),' +
            'child=[RichText:(:Hi (+b:there)(:!))]]'));
  });

  testWidgets('renders A tag with color', (WidgetTester tester) async {
    final html = 'This is a <a href="href">hyperlink</a>.';
    final noTextPaddingConfig = Config(textPadding: null);
    final explained = await explain(tester, html, config: noTextPaddingConfig);
    expect(explained,
        equals('[RichText:(:This is a (#FF0000FF+u+onTap:hyperlink)(:.))]'));
  });

  testWidgets('renders IMG tag', (WidgetTester tester) async {
    final html = '<img src="http://domain.com/image.png" />';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[Padding:padding=(10,0,0,0),child=[CachedNetworkImage:]]'));
  });

  group('lists', () {
    final noTextPaddingConfig = Config(textPadding: null);

    testWidgets('renders list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two</li><ol>';
      final explained =
          await explain(tester, html, config: noTextPaddingConfig);
      expect(
          explained,
          equals('[Padding:padding=(0,0,0,20),child=' +
              '[Column:children=[Text:1. One],[Text:2. Two]]]'));
    });

    testWidgets('renders nested list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two ' +
          '<ul><li>2.1</li><li>2.2</li></ul></li><ol>';
      final explained =
          await explain(tester, html, config: noTextPaddingConfig);
      expect(
          explained,
          equals(
              '[Padding:padding=(0,0,0,20),child=[Column:children=[Text:1. One],' +
                  '[Text:2. Two],[Padding:padding=(0,0,0,20),child=' +
                  '[Column:children=[Text:• 2.1],[Text:• 2.2]]]]]'));
    });
  });
}
