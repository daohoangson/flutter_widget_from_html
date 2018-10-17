import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinhte_html_widget/config.dart';
import 'package:tinhte_html_widget/html_widget.dart';
import 'package:tinhte_html_widget/widget_factory.dart';

Future<String> explain(WidgetTester tester, String html,
    {WidgetFactory wf}) async {
  final key = new UniqueKey();

  wf = wf ??
      WidgetFactory(
        config: Config(
          baseUrl: Uri.parse('http://domain.com'),
          colorHyperlink: Color(0xFF0000FF),
          sizeHeadings: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
          widgetImagePadding: null,
          widgetTextPadding: null,
        ),
      );

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: Material(
              child: HtmlWidget(
            html: html,
            key: key,
            widgetFactory: wf,
          )),
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

  _Explainer(BuildContext context)
      : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _textAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return 'center';
      case TextAlign.end:
        return 'end';
      case TextAlign.justify:
        return 'justify';
      case TextAlign.left:
        return 'left';
      case TextAlign.right:
        return 'right';
      default:
        return '';
    }
  }

  String _textSpan(TextSpan textSpan) {
    final style = _textStyle(textSpan.style);
    final onTap = textSpan.recognizer != null ? '+onTap' : '';
    final text = textSpan.text != null ? textSpan.text : '';
    final children = textSpan.children != null
        ? textSpan.children.map(_textSpan).join('')
        : '';
    return "($style$onTap:$text$children)";
  }

  String _textStyle(TextStyle style) {
    String s = '';
    if (style == null) {
      return s;
    }

    if (style.color != _defaultStyle.color) {
      s += _textStyleColor(style.color);
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

  String _textStyleColor(Color color) =>
      "#${_textStyleColorHex(color.alpha)}${_textStyleColorHex(color.red)}${_textStyleColorHex(color.green)}${_textStyleColorHex(color.blue)}";

  String _textStyleColorHex(int i) {
    final h = i.toRadixString(16).toUpperCase();
    return h.length == 1 ? "0$h" : h;
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

    return '';
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
    final type = widget.runtimeType.toString();
    final text = widget is AspectRatio
        ? "aspectRatio=${widget.aspectRatio.toStringAsFixed(2)},"
        : widget is CachedNetworkImage
            ? "imageUrl=${widget.imageUrl}"
            : widget is GestureDetector
                ? "child=${_widget(widget.child)}"
                : widget is Image
                    ? "image=${widget.image.runtimeType}"
                    : widget is RichText
                        ? _textSpan(widget.text)
                        : widget is Text ? widget.data : '';
    final textAlign = _textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null));
    final textAlignStr = textAlign.isNotEmpty ? ",align=$textAlign" : '';
    final children = widget is Container
        ? "child=${_widget(widget.child)}"
        : widget is MultiChildRenderObjectWidget
            ? "children=${widget.children.map(_widget).join(',')}"
            : widget is SingleChildRenderObjectWidget
                ? "child=${_widget(widget.child)}"
                : '';
    return "[$type$textAlignStr:$text$children]";
  }
}
