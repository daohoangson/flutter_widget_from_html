import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  group('getInlineStyles', () {
    testWidgets('renders inline style normally', (WidgetTester t) async {
      final html = '<span style="color: #f00; color: #0f0;">Foo</span>';
      final e = await explain(t, html);
      expect(e, equals('[RichText:(#FF00FF00:Foo)]'));
    });

    testWidgets('renders getInlineStyles in reversed', (WidgetTester t) async {
      final html = '<span>Foo</span>';
      final e = await explain(t, html,
          factoryBuilder: (_, hw) => _GetInlineStylesTest(hw));
      expect(e, equals('[RichText:(#FFFF0000:Foo)]'));
    });
  });

  group('priority', () {
    final html = '<span>Foo</span>';

    testWidgets('renders A first', (WidgetTester t) async {
      final e = await explain(t, html,
          factoryBuilder: (_, hw) => _PriorityTest(hw, a: 1, b: 2));
      expect(e, equals('[RichText:(:Foo A B)]'));
    });

    testWidgets('renders B first', (WidgetTester t) async {
      final e = await explain(t, html,
          factoryBuilder: (_, hw) => _PriorityTest(hw, a: 2, b: 1));
      expect(e, equals('[RichText:(:Foo B A)]'));
    });
  });
}

class _GetInlineStylesTest extends WidgetFactory {
  _GetInlineStylesTest(HtmlWidget hw) : super(hw);

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    meta = lazySet(meta,
        buildOp: BuildOp(defaultStyles: (_, __) => [kCssColor, '#f00']));
    meta = lazySet(meta,
        buildOp: BuildOp(defaultStyles: (_, __) => [kCssColor, '#0f0']));

    return super.parseLocalName(meta, localName);
  }
}

class _PriorityTest extends WidgetFactory {
  final int a;
  final int b;

  _PriorityTest(HtmlWidget hw, {this.a, this.b}) : super(hw);

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    meta = lazySet(meta,
        buildOp: BuildOp(
          onPieces: (_, pieces) => pieces.map((p) => p..block?.addText(' A')),
          priority: a,
        ));
    meta = lazySet(meta,
        buildOp: BuildOp(
          onPieces: (_, pieces) => pieces.map((p) => p..block?.addText(' B')),
          priority: b,
        ));

    return super.parseLocalName(meta, localName);
  }
}
