import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../_.dart';

void main() {
  group('onRoot', () {
    testWidgets('renders custom font', (tester) async {
      final html = '<span>Foo</span>';
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _OnRoot(),
            key: hwKey,
          ));
      expect(explained, equals('[RichText:(+font=Custom:Foo)]'));
    });
  });
}

class _OnRoot extends WidgetFactory {
  @override
  void onRoot(TextStyleBuilder rootTsb) {
    super.onRoot(rootTsb);

    rootTsb.enqueue((tsh, _) =>
        tsh.copyWith(style: tsh.style.copyWith(fontFamily: 'Custom')));
  }
}
