import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, testWidgets;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/builder.dart'
    as builder;
import 'package:html/dom.dart' as dom;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../_.dart' as helper;

void main() {
  group('BuildBit', () {
    group('buildBit', () {
      Future<String> explain(WidgetTester tester, String html) =>
          helper.explain(
            tester,
            null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _BuildBitWidgetFactory(),
              key: helper.hwKey,
            ),
          );

      testWidgets('returns String', (WidgetTester tester) async {
        const html = '1 <span class="output--String">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2foo 3)]'));
      });

      testWidgets('returns Widget', (WidgetTester tester) async {
        const html = '1 <span class="output--Widget">2</span> 3';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Column:children='
            '[RichText:(:1 2)],'
            '[Text:foo],'
            '[RichText:(:3)]'
            ']',
          ),
        );
      });
    });

    group('prev+next', () {
      final text = _text();
      final bit1 = text.addText('1');
      final text2 = text.sub();
      text.append(text2);
      final bit21 = text2.addText('(2.1)');
      final bit22 = text2.addText('(2.2)');
      final bit3 = text.addText('3');

      test('test data', () => expect(_data(text), equals('1(2.1)(2.2)3')));

      group('prev', () {
        test('returns sibling', () => expect(bit22.prev, equals(bit21)));

        test(
          'returns last of previous sub',
          () => expect(bit21.prev, equals(bit1)),
        );

        test('returns from parent', () => expect(bit3.prev, equals(bit22)));

        test('returns null', () => expect(bit1.prev, isNull));
      });

      group('next', () {
        test('returns sibling', () => expect(bit21.next, equals(bit22)));

        test(
          'returns first of next sub',
          () => expect(bit1.next, equals(bit21)),
        );

        test('returns from parent', () => expect(bit22.next, equals(bit3)));

        test('returns null', () => expect(bit3.next, isNull));
      });
    });
  });

  group('BuildTree', () {
    group('first', () {
      test('returns child', () {
        final text = _text();
        final bit1 = text.addText('1');
        text.addText('2');
        expect(_data(text), equals('12'));

        expect(text.first, equals(bit1));
      });

      test('returns from sub', () {
        final text = _text();
        final text1 = text.sub();
        text.append(text1);
        final bit11 = text1.addText('(1.1)');
        text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.first, equals(bit11));
      });
    });

    test('isEmpty', () {
      final text = _text();
      expect(text.isEmpty, isTrue);
    });

    test('isNotEmpty', () {
      final text = _text();
      text.addText('data');

      expect(text.isEmpty, isFalse);
    });

    group('last', () {
      test('returns child', () {
        final text = _text();
        text.addText('1');
        final bit2 = text.addText('2');
        expect(_data(text), equals('12'));

        expect(text.last, equals(bit2));
      });

      test('returns from sub', () {
        final text = _text();
        final text1 = text.sub();
        text.append(text1);
        text1.addText('(1.1)');
        final bit12 = text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.last, equals(bit12));
      });
    });

    test('builds', () {
      final text = _text();
      text.addText('1');

      final built = text.build();
      expect(built, isNotNull);
    });
  });

  group('copyWith', () {
    test('TextBit returns same parent', () {
      final text = _text();
      final bit = text.addText('1');

      final copied = bit.copyWith();
      expect(copied.parent, equals(text));
    });

    test('TextBit returns', () {
      final text = _text();
      final bit = text.addText('1');

      final text2 = _text();
      final copied = bit.copyWith(parent: text2);
      text2.append(copied);
      expect(_data(text2), equals('1'));
    });

    test('WidgetBit.block returns same parent', () {
      final text = _text();
      final child = WidgetPlaceholder();
      final bit = WidgetBit.block(text, child);

      final copied = bit.copyWith();
      expect(copied.parent, equals(text));
    });

    test('WidgetBit.block returns', () {
      final text = _text();
      final child = WidgetPlaceholder();
      final bit = WidgetBit.block(text, child);

      final text2 = _text();
      final copied = bit.copyWith(parent: text2);
      text2.append(copied);
      expect(text2.build(), equals(child));
    });

    test('WidgetBit.inline returns same parent', () {
      final text = _text();
      final child = WidgetPlaceholder();
      final bit = WidgetBit.inline(text, child);

      final copied = bit.copyWith();
      expect(copied.parent, equals(text));
    });

    test('BuildTree returns', () {
      final root = _text();

      final text = root.sub();
      text.addText('1');
      final text1 = text.sub();
      text.append(text1);
      text1.addText('2');
      text.addText('3');
      expect(
        helper.simplifyHashCode(text.toString()),
        equals(
          'BuildTree#0 styleBuilder#1(parent=#2):\n'
          '  "1"\n'
          '  BuildTree#3 styleBuilder#4(parent=#1):\n'
          '    "2"\n'
          '  "3"',
        ),
      );

      final copied = text.copyWith();
      expect(
        helper.simplifyHashCode('$text\n\n$copied'),
        equals(
          'BuildTree#0 styleBuilder#1(parent=#2):\n'
          '  "1"\n'
          '  BuildTree#3 styleBuilder#4(parent=#1):\n'
          '    "2"\n'
          '  "3"\n'
          '\n'
          'BuildTree#5 styleBuilder#6(parent=#2):\n'
          '  "1"\n'
          '  BuildTree#7 styleBuilder#8(parent=#6):\n'
          '    "2"\n'
          '  "3"',
        ),
      );
    });

    test('Whitespace returns same parent', () {
      final text = _text();
      text.addText('1');
      final whitespace = text.addWhitespace(' ');

      final copied = whitespace.copyWith();
      expect(copied.parent, equals(text));
    });

    test('Whitespace returns', () {
      final text = _text();
      text.addText('1');
      final whitespace = text.addWhitespace(' ');

      final text2 = _text();
      text2.addText('1');
      final copied = whitespace.copyWith(parent: text2);
      text2.append(copied);
      text2.addText('2');
      expect(_data(text2), equals('1 2'));
    });
  });

  test('toString', () {
    final text = _text();
    text.addText('1');
    text.addWhitespace(' ');
    final text2 = text.sub();
    text.append(text2);
    text2.addText('(2.1)');
    final text22 = text2.sub();
    text2.append(text22);
    text22.addText('(2.2.1)');
    text22.addText('(2.2.2)');
    text2.addText('(2.3)');
    text.append(WidgetBit.block(text, const Text('Hi')));
    text.append(WidgetBit.inline(text, const Text('Hi')));
    text.append(_CustomBit(text));
    text.append(_CircularBit(text));

    expect(
      helper.simplifyHashCode(text.toString()),
      equals(
        'BuildTree#0 styleBuilder#1:\n'
        '  "1"\n'
        '  Whitespace[32]#2\n'
        '  BuildTree#3 styleBuilder#4(parent=#1):\n'
        '    "(2.1)"\n'
        '    BuildTree#5 styleBuilder#6(parent=#4):\n'
        '      "(2.2.1)"\n'
        '      "(2.2.2)"\n'
        '    "(2.3)"\n'
        '  WidgetBit.block#7 WidgetPlaceholder\n'
        '  WidgetBit.inline#8 WidgetPlaceholder\n'
        '  _CustomBit#9\n'
        '  BuildTree#0 (circular)',
      ),
    );
  });
}

class _BuildBitWidgetFactory extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    final classes = tree.element.classes;

    if (classes.contains('output--String')) {
      tree.register(
        BuildOp(
          onTree: (tree) => tree.append(_OutputStringBit(tree)),
        ),
      );
    }

    if (classes.contains('output--Widget')) {
      tree.register(
        BuildOp(onTree: (tree) => tree.append(_OutputWidgetBit(tree))),
      );
    }

    if (classes.contains('custom')) {
      tree.apply((style, _) => style.copyWith(), null);
    }

    super.parse(tree);
  }
}

class _CircularBit extends Mock implements BuildTree {
  @override
  final BuildTree parent;

  _CircularBit(this.parent);

  @override
  String toString() => parent.toString();
}

class _CustomBit extends BuildBit {
  const _CustomBit(BuildTree? parent) : super(parent);

  @override
  void flatten(Flattened _) => throw UnimplementedError();

  @override
  BuildBit copyWith({BuildTree? parent, HtmlStyleBuilder? styleBuilder}) =>
      throw UnimplementedError();
}

class _OutputStringBit extends BuildBit {
  const _OutputStringBit(BuildTree? parent) : super(parent);

  @override
  void flatten(Flattened f) => f.write(text: 'foo');

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      _OutputStringBit(parent ?? this.parent);
}

class _OutputWidgetBit extends BuildBit {
  const _OutputWidgetBit(BuildTree? parent) : super(parent);

  @override
  bool get isInline => false;

  @override
  void flatten(Flattened f) =>
      f.widget(WidgetPlaceholder(child: const Text('foo')));

  @override
  BuildBit copyWith({BuildTree? parent, HtmlStyleBuilder? styleBuilder}) =>
      _OutputWidgetBit(parent ?? this.parent);
}

String _data(BuildTree text) => text.bits
    .map(
      (bit) => bit is TextBit
          ? bit.data
          : bit is WhitespaceBit
              ? bit.data
              : '[$bit]'.replaceAll(RegExp(r'#\w+'), ''),
    )
    .join();

BuildTree _text() => builder.Builder(
      customStylesBuilder: null,
      customWidgetBuilder: null,
      element: dom.Element.tag('root'),
      styleBuilder: HtmlStyleBuilder(),
      wf: WidgetFactory(),
    );
