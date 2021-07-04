import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';

import '../../core/test/_.dart' as helper;

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool webView = true,
}) async =>
    helper.explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
    );

class _WidgetFactory extends WidgetFactory with CachedNetworkImageFactory {}

void main() {
  testWidgets('renders IMG tag', (WidgetTester tester) async {
    const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
    const src = 'http://domain.com/image.png';
    const html = '<img src="$src" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[Image:image=CachedNetworkImageProvider("$src", scale: 1.0)]'
          ']'),
    );
  });
}
