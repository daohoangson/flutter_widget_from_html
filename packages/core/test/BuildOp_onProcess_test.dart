import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

class _BlockText extends WidgetFactory {
  _BlockText(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) => e.className == 'x'
      ? lazySet(
          null,
          buildOp: BuildOp(
            onProcess: (_, __, addWidgets, ___) =>
                addWidgets(<Widget>[Text('block')]),
          ),
        )
      : super.parseElement(meta, e);
}

class _WhiteText extends WidgetFactory {
  _WhiteText(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) => e.className == 'x'
      ? lazySet(
          null,
          buildOp: BuildOp(
            onProcess: (_, __, ___, write) => write('white'),
          ),
        )
      : super.parseElement(meta, e);
}

void main() {
  final html = 'This is <span class="x">black</span> text.';

  testWidgets('renders normally', (WidgetTester tester) async {
    final explained = await explain(tester, html);
    expect(explained, equals('[Text:This is black text.]'));
  });

  testWidgets('renders block', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        wfBuilder: (context) => _BlockText(context),
      ),
    );
    expect(explained,
        equals('[Column:children=[Text:This is],[Text:block],[Text:text.]]'));
  });

  testWidgets('renders white', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        wfBuilder: (context) => _WhiteText(context),
      ),
    );
    expect(explained, equals('[Text:This is white text.]'));
  });
}
