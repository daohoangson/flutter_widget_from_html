import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../_.dart';

void main() {
  group('BuildOp', () {
    group('defaultStyles', () {
      testWidgets('renders inline style normally', (tester) async {
        const html = '<span style="color: #f00; color: #0f0;">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders defaultStyles in reversed', (tester) async {
        const html = '<span>Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpDefaultStyles(),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });
    });

    group('onParsed', () {
      testWidgets('renders additional text', (tester) async {
        const html = '<span class="text">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnParsedText(),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo bar)]'));
      });

      testWidgets('renders block widget', (tester) async {
        const html = '<span class="widget-block">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnParsedWidgetBlock(),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└ColumnPlaceholder(root--column)\n'
            ' └Column()\n'
            '  ├RichText(text: "Foo")\n'
            '  └Text("hi")\n'
            '   └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders block widget over div', (tester) async {
        const html = '<div class="widget-block"><div>Foo</div></div>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnParsedWidgetBlock(),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└ColumnPlaceholder(div--column)\n'
            ' └CssBlock()\n'
            '  └Column()\n'
            '   ├CssBlock()\n'
            '   │└RichText(text: "Foo")\n'
            '   └Text("hi")\n'
            '    └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders inline widget', (tester) async {
        const html = '<span class="widget-inline">bar</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnParsedWidgetInline(),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(root--text)\n'
            ' └RichText(text: "bar\u{fffc}")\n'
            '  └Semantics(...)\n'
            '   └WidgetPlaceholder(span--WidgetBit.inline)\n'
            '    └Text("hi")\n'
            '     └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders replacement', (tester) async {
        const html = '<span class="replace">foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnParsedReplace(),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(root--text)\n'
            ' └RichText(text: "hi")\n\n',
          ),
        );
      });
    });

    group('onRenderBlock', () {
      testWidgets('renders widget', (tester) async {
        const html = '<span>Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnRenderBlock(),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(span--lazy)\n'
            ' └Text("Hi")\n'
            '  └RichText(text: "Hi")\n\n',
          ),
        );
      });
    });

    group('priority', () {
      const html = '<span>Foo</span>';

      testWidgets('renders A first', (tester) async {
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpPriority(a: 1, b: 2),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo A B)]'));
      });

      testWidgets('renders B first', (tester) async {
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpPriority(a: 2, b: 1),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo B A)]'));
      });
    });
  });
}

class _BuildOpDefaultStyles extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    tree
      ..register(BuildOp(defaultStyles: (_) => {'color': '#f00'}, priority: 1))
      ..register(BuildOp(defaultStyles: (_) => {'color': '#0f0'}, priority: 2));

    return super.parse(tree);
  }
}

class _BuildOpOnParsedText extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('text')) {
      tree.register(BuildOp(onParsed: (tree) => tree..addText(' bar')));
    }

    return super.parse(tree);
  }
}

class _BuildOpOnParsedWidgetBlock extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('widget-block')) {
      tree.register(
        BuildOp(
          onParsed: (tree) =>
              tree..append(WidgetBit.block(tree, const Text('hi'))),
        ),
      );
    }

    return super.parse(tree);
  }
}

class _BuildOpOnParsedWidgetInline extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('widget-inline')) {
      tree.register(
        BuildOp(
          onParsed: (tree) =>
              tree..append(WidgetBit.inline(tree, const Text('hi'))),
        ),
      );
    }

    return super.parse(tree);
  }
}

class _BuildOpOnParsedReplace extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('replace')) {
      tree.register(
        BuildOp(
          onParsed: (tree) => tree.parent!.sub()..addText('hi'),
        ),
      );
    }

    return super.parse(tree);
  }
}

class _BuildOpOnRenderBlock extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    tree.register(BuildOp(onRenderBlock: (_, __) => const Text('Hi')));
    return super.parse(tree);
  }
}

class _BuildOpPriority extends WidgetFactory {
  final int a;
  final int b;

  _BuildOpPriority({required this.a, required this.b});

  @override
  void parse(BuildTree tree) {
    tree
      ..register(
        BuildOp(
          onParsed: (tree) => tree..addText(' A'),
          priority: a,
        ),
      )
      ..register(
        BuildOp(
          onParsed: (tree) => tree..addText(' B'),
          priority: b,
        ),
      );

    return super.parse(tree);
  }
}
