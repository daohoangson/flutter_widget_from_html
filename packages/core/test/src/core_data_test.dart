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

    group('onTree', () {
      testWidgets('renders additional text', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnTreeText(),
              key: hwKey,
            ));
        expect(explained, equals('[RichText:(:Foo bar)]'));
      });

      testWidgets('renders widget', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnTreeWidget(),
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

    group('onWidgets', () {
      testWidgets('renders widget', (tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpOnWidgets(),
              key: hwKey,
            ),
            useExplainer: false);
        expect(
            explained,
            equals('TshWidget\n'
                '└WidgetPlaceholder<Widget>(Text)\n'
                ' └Text("Hi")\n'
                '  └RichText(text: "Hi")\n\n'));
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
    meta
      ..register(BuildOp(defaultStyles: (_) => {'color': '#f00'}, priority: 1))
      ..register(BuildOp(defaultStyles: (_) => {'color': '#0f0'}, priority: 2));

    return super.parse(meta);
  }
}

class _BuildOpOnTreeText extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(onTree: (_, tree) => tree.addText(' bar')));
    return super.parse(meta);
  }
}

class _BuildOpOnTreeWidget extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(
        onTree: (_, tree) =>
            tree.replaceWith(WidgetBit.inline(tree, Text('hi')))));
    return super.parse(meta);
  }
}

class _BuildOpOnWidgets extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    meta.register(BuildOp(onWidgets: (_, __) => [Text('Hi')]));
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
        onTree: (_, tree) => tree.addText(' A'),
        priority: a,
      ))
      ..register(BuildOp(
        onTree: (_, tree) => tree.addText(' B'),
        priority: b,
      ));

    return super.parse(meta);
  }
}
