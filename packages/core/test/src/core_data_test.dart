import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../_.dart';

void main() {
  group('BuildOp', () {
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
              factoryBuilder: () => _BuildOpDefaultStyles(),
              key: hwKey,
            ));
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });
    });

    group('onProcessed', () {
      testWidgets('renders additional text', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnProcessedText(),
              key: hwKey,
            ));
        expect(explained, equals('[RichText:(:Foo bar)]'));
      });

      testWidgets('renders widget', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnProcessedWidget(),
              key: hwKey,
            ),
            useExplainer: false);
        expect(
            explained,
            equals('TshWidget\n'
                '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1:\n'
                ' │  BuildTree#2 tsb#3(parent=#1):\n'
                ' │    WidgetBit.inline#4 WidgetPlaceholder(Text("hi"))\n'
                ' │)\n'
                ' └WidgetPlaceholder<Widget>(Text)\n'
                '  └Text("hi")\n'
                '   └RichText(text: "hi")\n\n'));
      });
    });

    group('onBuilt', () {
      testWidgets('renders widget', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnBuilt(),
              key: hwKey,
            ),
            useExplainer: false);
        expect(
            explained,
            equals('TshWidget\n'
                '└WidgetPlaceholder<Widget>(Text)\n'
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
              factoryBuilder: () => _BuildOpPriority(a: 1, b: 2),
              key: hwKey,
            ));
        expect(explained, equals('[RichText:(:Foo A B)]'));
      });

      testWidgets('renders B first', (tester) async {
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpPriority(a: 2, b: 1),
              key: hwKey,
            ));
        expect(explained, equals('[RichText:(:Foo B A)]'));
      });
    });
  });
}

class _BuildOpDefaultStyles extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(defaultStyles: (_) => {'color': '#f00'}));
    meta.register(BuildOp(defaultStyles: (_) => {'color': '#0f0'}));

    return super.parse(meta);
  }
}

class _BuildOpOnProcessedText extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(onProcessed: (_, tree) => tree.addText(' bar')));
    return super.parse(meta);
  }
}

class _BuildOpOnProcessedWidget extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(
        onProcessed: (_, tree) =>
            tree.replaceWith(WidgetBit.inline(tree, Text('hi')))));
    return super.parse(meta);
  }
}

class _BuildOpOnBuilt extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(onBuilt: (_, __) => [Text('Hi')]));
    return super.parse(meta);
  }
}

class _BuildOpPriority extends WidgetFactory {
  final int a;
  final int b;

  _BuildOpPriority({this.a, this.b});

  @override
  void parse(BuildMetadata meta) {
    meta
      ..register(BuildOp(
        onProcessed: (_, tree) => tree.addText(' A'),
        priority: a,
      ))
      ..register(BuildOp(
        onProcessed: (_, tree) => tree.addText(' B'),
        priority: b,
      ));

    return super.parse(meta);
  }
}
