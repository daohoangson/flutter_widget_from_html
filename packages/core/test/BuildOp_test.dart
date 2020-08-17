import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  group('defaultStyles', () {
    testWidgets('renders inline style normally', (tester) async {
      final html = '<span style="color: #f00; color: #0f0;">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
    });

    testWidgets('renders defaultStyles in reversed', (tester) async {
      final html = '<span>Foo</span>';
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _DefaultStylesTest(),
            key: hwKey,
          ));
      expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
    });
  });

  group('onPieces', () {
    testWidgets('renders additional text', (tester) async {
      final html = '<span>Foo</span>';
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _OnPiecesTestText(),
            key: hwKey,
          ));
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders widget', (tester) async {
      final html = '<span>Foo</span>';
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _OnPiecesTestWidget(),
            key: hwKey,
          ),
          useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<Widget>\n'
              ' └Text("Hi")\n'
              '  └RichText(text: "Hi")\n\n'));
    });
  });

  group('onWidgets', () {
    testWidgets('renders widget', (tester) async {
      final html = '<span>Foo</span>';
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _OnWidgetsTest(),
            key: hwKey,
          ),
          useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<NodeMetadata>\n'
              ' └CssBlock()\n'
              '  └Text("Hi")\n'
              '   └RichText(text: "Hi")\n\n'));
    });
  });

  group('priority', () {
    final html = '<span>Foo</span>';

    testWidgets('renders A first', (tester) async {
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _PriorityTest(a: 1, b: 2),
            key: hwKey,
          ));
      expect(explained, equals('[RichText:(:Foo A B)]'));
    });

    testWidgets('renders B first', (tester) async {
      final explained = await explain(tester, null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _PriorityTest(a: 2, b: 1),
            key: hwKey,
          ));
      expect(explained, equals('[RichText:(:Foo B A)]'));
    });
  });
}

class _DefaultStylesTest extends WidgetFactory {
  @override
  void parse(NodeMetadata meta) {
    meta.register(BuildOp(defaultStyles: (_) => {'color': '#f00'}));
    meta.register(BuildOp(defaultStyles: (_) => {'color': '#0f0'}));

    return super.parse(meta);
  }
}

class _OnPiecesTestText extends WidgetFactory {
  @override
  void parse(NodeMetadata meta) {
    meta.register(BuildOp(onPieces: (_, pieces) {
      for (final piece in pieces) {
        piece.text?.addText(' bar');
      }

      return pieces;
    }));
    return super.parse(meta);
  }
}

class _OnPiecesTestWidget extends WidgetFactory {
  @override
  void parse(NodeMetadata meta) {
    meta.register(BuildOp(onPieces: (_, pieces) {
      for (final piece in pieces) {
        if (piece.text == null) continue;
        for (final bit in List<TextBit>.unmodifiable(piece.text.bits)) {
          bit.detach();
        }
      }

      return [
        BuiltPiece.widgets([Text('Hi')])
      ];
    }));
    return super.parse(meta);
  }
}

class _OnWidgetsTest extends WidgetFactory {
  @override
  void parse(NodeMetadata meta) {
    meta.register(BuildOp(onWidgets: (_, __) => [Text('Hi')]));
    return super.parse(meta);
  }
}

class _PriorityTest extends WidgetFactory {
  final int a;
  final int b;

  _PriorityTest({this.a, this.b});

  @override
  void parse(NodeMetadata meta) {
    meta
      ..register(BuildOp(
        onPieces: (_, pieces) => pieces.map((p) => p..text?.addText(' A')),
        priority: a,
      ))
      ..register(BuildOp(
        onPieces: (_, pieces) => pieces.map((p) => p..text?.addText(' B')),
        priority: b,
      ));

    return super.parse(meta);
  }
}
