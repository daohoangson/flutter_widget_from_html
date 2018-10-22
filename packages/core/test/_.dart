import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class _WidgetFactory extends WidgetFactory {
  _WidgetFactory(BuildContext context) : super(context);

  @override
  Widget buildImageWidgetFromUrl(String url) => Text("imageUrl=$url");
}

Future<String> explain(WidgetTester tester, String html,
    {HtmlWidget hw}) async {
  final key = new UniqueKey();

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          theme: ThemeData(
            accentColor: Color(0xFF0000FF),
          ),
          home: Material(
            child: DefaultTextStyle(
              key: key,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
              child: hw ??
                  HtmlWidget(
                    html,
                    wfBuilder: (context) => _WidgetFactory(context),
                  ),
            ),
          ),
        );
      },
    ),
  );

  final found = find.byKey(key).evaluate().first;
  expect(found.widget, isInstanceOf<DefaultTextStyle>());

  final explainer = _Explainer(found);
  final htmlWidget = (found.widget as DefaultTextStyle).child as HtmlWidget;

  return explainer.explain(htmlWidget.build(found));
}

class _Explainer {
  final BuildContext context;
  final TextStyle _defaultStyle;

  _Explainer(this.context) : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _edgeInsets(EdgeInsets e) =>
      "(${e.top.truncate()},${e.right.truncate()}," +
      "${e.bottom.truncate()},${e.left.truncate()})";

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

  String _textSpan(TextSpan textSpan, {TextStyle parentStyle}) {
    final style = _textStyle(textSpan.style, parentStyle ?? _defaultStyle);
    final onTap = textSpan.recognizer != null ? '+onTap' : '';
    final text = textSpan.text != null ? textSpan.text : '';
    final children = textSpan.children != null
        ? textSpan.children
            .map((c) => _textSpan(c, parentStyle: textSpan.style))
            .join('')
        : '';
    return "($style$onTap:$text$children)";
  }

  String _textStyle(TextStyle style, TextStyle parent) {
    String s = '';
    if (style == null) {
      return s;
    }

    if (style.color != parent.color) {
      s += _textStyleColor(style.color);
    }

    s += _textStyleDecoration(style, TextDecoration.lineThrough, 'l');
    s += _textStyleDecoration(style, TextDecoration.overline, 'o');
    s += _textStyleDecoration(style, TextDecoration.underline, 'u');

    if (style.fontFamily != parent.fontFamily) {
      s += "+font=${style.fontFamily}";
    }

    if (style.fontSize != parent.fontSize) {
      s += "@${style.fontSize.toStringAsFixed(1)}";
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
    final defaultHasIt = _defaultStyle.decoration?.contains(d) == true;
    final styleHasIt = style.decoration?.contains(d) == true;
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
        : widget is GestureDetector
            ? "child=${_widget(widget.child)}"
            : widget is Image
                ? "image=${widget.image.runtimeType}"
                : widget is Padding
                    ? "${_edgeInsets(widget.padding)},"
                    : widget is RichText
                        ? _textSpan(widget.text)
                        : widget is Text ? widget.data : '';
    final textAlign = _textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null));
    final textAlignStr = textAlign.isNotEmpty ? ",align=$textAlign" : '';
    final children = widget is Container
        ? "child=${_widget(widget.child)}"
        : widget is LayoutBuilder
            ? "built=${_widget(widget.builder(context, BoxConstraints()))}"
            : widget is MultiChildRenderObjectWidget
                ? "children=${widget.children.map(_widget).join(',')}"
                : widget is ProxyWidget
                    ? "child=${_widget(widget.child)}"
                    : widget is SingleChildRenderObjectWidget
                        ? "child=${_widget(widget.child)}"
                        : widget is SingleChildScrollView
                            ? "child=${_widget(widget.child)}"
                            : '';
    return "[$type$textAlignStr:$text$children]";
  }
}
