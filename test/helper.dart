import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinhte_html_widget/html_widget.dart';

Future<String> pumpWidgetThenExplain(WidgetTester tester, String html) async {
  final key = new UniqueKey();

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: Material(
            child: HtmlWidget(
              colorHyperlink: const Color(0xFF0000FF),
              html: html,
              key: key,
              sizeHeadings: const [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
            )
          ),
        );
      },
    ),
  );

  final found = find.byKey(key).evaluate().first;
  expect(found.widget, isInstanceOf<HtmlWidget>());

  final explainer = _Explainer(found);
  final htmlWidget = found.widget as HtmlWidget;

  return explainer.explain(htmlWidget.build(found));
}

class _Explainer {
  final TextStyle _defaultStyle;

  _Explainer(BuildContext context):
    _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) {
    if (widget is Column) {
      return widget.children.map(_widget).join('');
    }

    return _widget(widget);
  }

  String _textSpan(TextSpan textSpan) {
    final style = _textStyle(textSpan.style);
    final text = textSpan.text != null ? textSpan.text : '';
    final children = textSpan.children != null ? textSpan.children.map(_textSpan).join('') : '';
    return "($style:$text$children)";
  }

  String _textStyle(TextStyle style) {
    String s = '';
    if (style == null) {
      return s;
    }

    if (style.color != _defaultStyle.color) {
      s += "(${style.color.red},${style.color.green},${style.color.blue},${style.color.alpha})";
    }

    s += _textStyleDecoration(style, TextDecoration.lineThrough, 'l');
    s += _textStyleDecoration(style, TextDecoration.overline, 'o');
    s += _textStyleDecoration(style, TextDecoration.underline, 'u');

    if (style.fontSize != _defaultStyle.fontSize) {
      s += "@${style.fontSize}";
    }

    s += _textStyleFontStyle(style);
    s += _textStyleFontWeight(style);

    return s;
  }

  String _textStyleDecoration(TextStyle style, TextDecoration d, String str) {
    final defaultHasIt = _defaultStyle.decoration.contains(d);
    final styleHasIt = style.decoration.contains(d);
    if (defaultHasIt == styleHasIt) {
      return '';
    }

    return (styleHasIt ? '+' : '-') + str;
  }

  String _textStyleFontStyle(TextStyle style) {
    if (style.fontStyle == _defaultStyle.fontStyle) {
      return '';
    }

    switch (style.fontStyle) {
      case FontStyle.italic:
        return '+i';
      case FontStyle.normal:
        return '-i';
    }
  }

  String _textStyleFontWeight(TextStyle style) {
    if (style.fontWeight == _defaultStyle.fontWeight) {
      return '';
    }

    if (style.fontWeight == FontWeight.bold) {
      return '+b';
    }

    return '+w' + FontWeight.values.indexOf(style.fontWeight).toString();
  }

  String _widget(Widget widget) {
    final String type = widget.runtimeType.toString();
    final String textSpan = (widget is RichText ? _textSpan(widget.text) : '');
    final String children = (widget is MultiChildRenderObjectWidget ? widget.children.map(_widget).join('') : '');
    return "[$type:$textSpan$children]";
  }
}