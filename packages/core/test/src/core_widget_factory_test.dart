import 'package:flutter_widget_from_html_core/src/core_widget_factory.dart';
import 'package:test/test.dart';

void main() {
  group('WidgetFactory', () {
    group('gestureTapCallback', () {
      test('calls onTapUrl', () {
        final wf = _WidgetFactoryGestureTapCallback();
        const url = 'https://domain.com';

        // ignore: deprecated_member_use_from_same_package
        final onTap = wf.gestureTapCallback(url);

        onTap?.call();
        expect(wf.urls, equals([url]));
      });
    });
  });
}

class _WidgetFactoryGestureTapCallback extends WidgetFactory {
  final urls = <String>[];

  @override
  Future<bool> onTapUrl(String url) async {
    urls.add(url);
    return true;
  }
}
