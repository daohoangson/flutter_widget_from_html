import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Future<String> explain(
  WidgetTester tester,
  String html, {
  _WidgetExplainer explainer,
  _HtmlWidgetBuilder hw,
  String imageUrlToPrecache,
  WidgetFactory wf,
  Uri baseUrl,
  double bodyVerticalPadding = 0,
  NodeMetadataCollector builderCallback,
  double tableCellPadding = 0,
  TextStyle textStyle,
}) async {
  final key = UniqueKey();

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        if (imageUrlToPrecache != null) {
          precacheImage(
            NetworkImage(imageUrlToPrecache),
            context,
            onError: (dynamic exception, StackTrace stackTrace) {
              // this is required to avoid http 400 error for Image.network instances
            },
          );
        }

        final defaultStyle = DefaultTextStyle.of(context).style;
        final style = defaultStyle.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
        );

        return Theme(
          child: DefaultTextStyle(key: key, style: style, child: widget0),
          data: ThemeData(
            accentColor: const Color(0xFF123456),
          ),
        );
      },
    ),
  );

  final found = find.byKey(key).evaluate().first;
  expect(found.widget, isInstanceOf<DefaultTextStyle>());

  final _ = _Explainer(found, explainer: explainer);
  final htmlWidget = hw != null
      ? hw()
      : HtmlWidget(
          html,
          baseUrl: baseUrl,
          bodyPadding: EdgeInsets.symmetric(vertical: bodyVerticalPadding),
          builderCallback: builderCallback,
          tableCellPadding: EdgeInsets.all(tableCellPadding),
          textStyle: textStyle,
          wf: wf,
        );

  return _.explain(htmlWidget.build(found));
}

final _explainMarginRegExp = RegExp(
    r'^\[Column:children=\[RichText:\(:x\)\],(.+),\[RichText:\(:x\)\]\]$');

Future<String> explainMargin(
  WidgetTester tester,
  String html, {
  String imageUrlToPrecache,
}) async {
  final explained = await explain(
    tester,
    "x${html}x",
    imageUrlToPrecache: imageUrlToPrecache,
  );
  final match = _explainMarginRegExp.firstMatch(explained);
  return match == null ? explained : match[1];
}

typedef String _WidgetExplainer(Widget widget);
typedef HtmlWidget _HtmlWidgetBuilder();

class _Explainer {
  final BuildContext context;
  final _WidgetExplainer explainer;
  final TextStyle _defaultStyle;

  _Explainer(this.context, {this.explainer})
      : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _borderSide(BorderSide s) => "${s.color},w=${s.width}";

  String _boxDecoration(BoxDecoration d) {
    String s = '';

    if (d.color != null) s += "bg=${_color(d.color)},";

    return s;
  }

  String _color(Color c) =>
      "#${_colorHex(c.alpha)}${_colorHex(c.red)}${_colorHex(c.green)}${_colorHex(c.blue)}";

  String _colorHex(int i) {
    final h = i.toRadixString(16).toUpperCase();
    return h.length == 1 ? "0$h" : h;
  }

  String _edgeInsets(EdgeInsets e) =>
      "(${e.top.truncate()},${e.right.truncate()}," +
      "${e.bottom.truncate()},${e.left.truncate()})";

  String _image(ImageProvider i) {
    final type = i.runtimeType.toString();
    final description = i is NetworkImage ? "url=${i.url}" : '';
    return "[$type:$description]";
  }

  String _limitBox(LimitedBox box) {
    String s = '';
    if (box.maxHeight != null) s += 'h=${box.maxHeight},';
    if (box.maxWidth != null) s += 'w=${box.maxWidth},';
    return s;
  }

  String _tableBorder(TableBorder b) {
    if (b == null) return '';

    final top = _borderSide(b.top);
    final right = _borderSide(b.right);
    final bottom = _borderSide(b.bottom);
    final left = _borderSide(b.left);

    if (top == right && right == bottom && bottom == left) {
      return "border=($top)";
    }

    return "borders=($top;$right;$bottom;$left)";
  }

  String _tableCell(TableCell cell) => _widget(cell.child);

  String _tableRow(TableRow row) =>
      row.children.map((c) => _tableCell(c)).toList().join(' | ');

  String _tableRows(Table table) =>
      table.children.map((r) => _tableRow(r)).toList().join('\n');

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

    if (style.background != null) {
      s += "bg=${_color(style.background.color)}";
    }

    if (style.color != null) {
      s += _color(style.color);
    }

    s += _textStyleDecoration(style, TextDecoration.lineThrough, 'l');
    s += _textStyleDecoration(style, TextDecoration.overline, 'o');
    s += _textStyleDecoration(style, TextDecoration.underline, 'u');

    if (style.fontFamily != null && style.fontFamily != parent.fontFamily) {
      s += "+font=${style.fontFamily}";
    }

    if (style.fontSize != parent.fontSize) {
      s += "@${style.fontSize.toStringAsFixed(1)}";
    }

    s += _textStyleFontStyle(style);
    s += _textStyleFontWeight(style);

    return s;
  }

  String _textStyleDecoration(TextStyle style, TextDecoration d, String str) {
    final defaultHasIt = _defaultStyle.decoration?.contains(d) == true;
    final styleHasIt = style.decoration?.contains(d) == true;
    if (defaultHasIt == styleHasIt) {
      return '';
    }

    final decorationStyle = (style.decorationStyle == null ||
            style.decorationStyle == TextDecorationStyle.solid)
        ? ''
        : "${style.decorationStyle}".replaceFirst(RegExp(r'^.+\.'), '/');

    return "${styleHasIt ? '+' : '-'}$str$decorationStyle";
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
    final explained = this.explainer?.call(widget);
    if (explained != null) return explained;

    if (widget == widget0) return '[widget0]';

    final type = widget.runtimeType.toString();
    final text = widget is Align
        ? "alignment=${widget.alignment},"
        : widget is AspectRatio
            ? "aspectRatio=${widget.aspectRatio.toStringAsFixed(2)},"
            : widget is DecoratedBox
                ? _boxDecoration(widget.decoration)
                : widget is GestureDetector
                    ? "child=${_widget(widget.child)}"
                    : widget is Image
                        ? "image=${_image(widget.image)}"
                        : widget is InkWell
                            ? "child=${_widget(widget.child)}"
                            : widget is LimitedBox
                                ? _limitBox(widget)
                                : widget is Padding
                                    ? "${_edgeInsets(widget.padding)},"
                                    : widget is RichText
                                        ? _textSpan(widget.text)
                                        : widget is Table
                                            ? _tableBorder(widget.border)
                                            : widget is Text ? widget.data : '';
    final textAlign = _textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null));
    final textAlignStr = textAlign.isNotEmpty ? ",align=$textAlign" : '';
    final children = widget is Container
        ? (widget.child != null ? "child=${_widget(widget.child)}" : '')
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
                            : widget is Table
                                ? "\n${_tableRows(widget)}\n"
                                : '';
    return "[$type$textAlignStr:$text$children]";
  }
}
