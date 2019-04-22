import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

class _AFirst extends WidgetFactory {
  _AFirst(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    meta = lazySet(
      meta,
      buildOp: BuildOp(onProcess: (_, __, ___, w) => w('A'), priority: 1),
    );
    meta = lazySet(
      meta,
      buildOp: BuildOp(onProcess: (_, __, ___, w) => w('B'), priority: 2),
    );

    return super.parseElement(meta, e);
  }
}

class _BFirst extends WidgetFactory {
  _BFirst(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    meta = lazySet(
      meta,
      buildOp: BuildOp(onProcess: (_, __, ___, w) => w('A'), priority: 2),
    );
    meta = lazySet(
      meta,
      buildOp: BuildOp(onProcess: (_, __, ___, w) => w('B'), priority: 1),
    );

    return super.parseElement(meta, e);
  }
}

void main() {
  final html = '<p class="classA classB">Foo</p>';

  testWidgets('renders A first', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        wfBuilder: (context) => _AFirst(context),
      ),
    );
    expect(explained, equals('[Text:AB]'));
  });

  testWidgets('renders B first', (WidgetTester tester) async {
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        wfBuilder: (context) => _BFirst(context),
      ),
    );
    expect(explained, equals('[Text:BA]'));
  });
}
