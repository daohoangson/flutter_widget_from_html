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
      final factoryBuilder = () => _GetInlineStylesTest();
      final e = await explain(t, html, factoryBuilder: factoryBuilder);
      expect(e, equals('[RichText:(#FFFF0000:Foo)]'));
    });
  });

  group('priority', () {
    final html = '<span>Foo</span>';

    testWidgets('renders A first', (WidgetTester t) async {
      final e = await explain(t, html,
          factoryBuilder: () => _PriorityTest(a: 1, b: 2));
      expect(e, equals('[RichText:(:Foo A B)]'));
    });

    testWidgets('renders B first', (WidgetTester t) async {
      final e = await explain(t, html,
          factoryBuilder: () => _PriorityTest(a: 2, b: 1));
      expect(e, equals('[RichText:(:Foo B A)]'));
    });
  });
}

class _GetInlineStylesTest extends WidgetFactory {
  @override
  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    meta.op = BuildOp(defaultStyles: (_, __) => ['color', '#f00']);
    meta.op = BuildOp(defaultStyles: (_, __) => ['color', '#0f0']);

    return super.parseTag(meta, tag, attrs);
  }
}

class _PriorityTest extends WidgetFactory {
  final int a;
  final int b;

  _PriorityTest({this.a, this.b});

  @override
  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    meta.op = BuildOp(
      onPieces: (_, pieces) => pieces.map((p) => p..text?.addText(' A')),
      priority: a,
    );
    meta.op = BuildOp(
      onPieces: (_, pieces) => pieces.map((p) => p..text?.addText(' B')),
      priority: b,
    );

    return super.parseTag(meta, tag, attrs);
  }
}
