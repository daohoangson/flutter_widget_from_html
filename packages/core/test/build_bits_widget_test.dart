import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart' as helper;

void main() {
  group('buildBit inputs', () {
    final explain =
        (WidgetTester tester, String html) => helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _WidgetFactory(),
              key: helper.hwKey,
            ));

    group('GestureRecognizer', () {
      final clazz = 'input--GestureRecognizer';

      testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
        final html = '1 <span class="$clazz">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2(no recognizer) 3)]'));
      });

      testWidgets('SPAN tag with styling + BuildBit', (tester) async {
        final html = '1 <span class="custom $clazz">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 (:2(no recognizer))(: 3))]'));
      });

      testWidgets('A tag without BuildBit', (WidgetTester tester) async {
        final html = '1 <a href="href">2</a> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 (#FF0000FF+u+onTap:2)(: 3))]'));
      });

      testWidgets('A tag with BuildBit', (WidgetTester tester) async {
        final html = '1 <a href="href" class="$clazz">2</a> 3';
        final explained = await explain(tester, html);
        expect(explained,
            equals('[RichText:(:1 (#FF0000FF+u+onTap+onTapCancel:2)(: 3))]'));
      });
    });

    group('Null', () {
      final clazz = 'input--Null';

      testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
        final html = '1 <span class="$clazz">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2(null) 3)]'));
      });
    });

    group('TextStyleHtml', () {
      final clazz = 'input--TextStyleHtml';

      testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
        final html = '1 <span class="$clazz">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2(:TextStyleHtml)(: 3))]'));
      });
    });

    group('TextStyleBuilder', () {
      final clazz = 'input--TextStyleBuilder';

      testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
        final html = '1 <span class="$clazz">2</span> 3';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children='
                '[RichText:(:1 2)],'
                '[Text:textDirection=TextDirection.ltr],'
                '[RichText:(: 3)]'
                ']'));
      });
    });
  });
}

class _WidgetFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    final classes = meta.element.classes;

    if (classes.contains('input--GestureRecognizer')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputGestureRecognizerBit(tree, tree.tsb))));
    }

    if (classes.contains('input--Null')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) => tree.add(_InputNullBit(tree, tree.tsb))));
    }

    if (classes.contains('input--TextStyleHtml')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputTextStyleHtmlBit(tree, tree.tsb))));
    }

    if (classes.contains('input--TextStyleBuilder')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputTextStyleBuilderBit(tree, tree.tsb))));
    }

    if (classes.contains('custom')) {
      meta.tsb((tsh, _) => tsh.copyWith());
    }

    super.parse(meta);
  }
}

class _InputGestureRecognizerBit extends BuildBit<GestureRecognizer> {
  _InputGestureRecognizerBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  dynamic buildBit(GestureRecognizer recognizer) {
    if (recognizer is TapGestureRecognizer) {
      recognizer.onTapCancel = () {};
      return recognizer;
    }

    return '(no recognizer)';
  }

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputGestureRecognizerBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputNullBit extends BuildBit<Null> {
  _InputNullBit(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  dynamic buildBit(Null _) => '(null)';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputNullBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputTextStyleHtmlBit extends BuildBit<TextStyleHtml> {
  _InputTextStyleHtmlBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  InlineSpan buildBit(TextStyleHtml tsh) => TextSpan(
        text: tsh.runtimeType.toString(),
        style: tsh.styleWithHeight,
      );

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputTextStyleHtmlBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputTextStyleBuilderBit extends BuildBit<TextStyleBuilder> {
  _InputTextStyleBuilderBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  dynamic buildBit(TextStyleBuilder tsb) => WidgetPlaceholder(tsb)
    ..wrapWith((context, _) =>
        Text('textDirection=${tsb.build(context).textDirection}'));

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputTextStyleBuilderBit(parent ?? this.parent, tsb ?? this.tsb);
}
