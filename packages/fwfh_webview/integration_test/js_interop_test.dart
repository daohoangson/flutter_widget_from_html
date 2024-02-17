import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/web.dart' as web;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('IFRAME app', (WidgetTester tester) async {
    runApp(const IframeApp());
    await tester.pumpAndSettle();

    final elements = web.document.getElementsByTagName('iframe');
    expect(elements.length, 1);

    for (var i = 0; i < elements.length; i++) {
      final element = elements.item(i);
      expect(element, isA<web.HTMLIFrameElement>());

      final iframe = element! as web.HTMLIFrameElement;
      expect(iframe.src, 'https://www.youtube.com/embed/jNQXAC9IVRw');
    }
  });
}

class IframeApp extends StatelessWidget {
  const IframeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: HtmlWidget(
            '<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw"></iframe>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {}
