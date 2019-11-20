import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

final hwKey = GlobalKey<HtmlWidgetState>();

Future<String> explain(
  WidgetTester tester,
  String html, {
  WidgetExplainer explainer,
  Widget hw,
  PreTest preTest,
  Uri baseUrl,
  double bodyVerticalPadding = 0,
  NodeMetadataCollector builderCallback,
  FactoryBuilder factoryBuilder,
  double tableCellPadding = 0,
  TextStyle textStyle,
}) async {
  assert((html == null) != (hw == null));
  hw ??= HtmlWidget(
    html,
    baseUrl: baseUrl,
    bodyPadding: EdgeInsets.symmetric(vertical: bodyVerticalPadding),
    builderCallback: builderCallback,
    factoryBuilder: factoryBuilder,
    key: hwKey,
    tableCellPadding: EdgeInsets.all(tableCellPadding),
    textStyle: textStyle,
  );

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (context, _) {
        if (preTest != null) preTest(context);

        final defaultStyle = DefaultTextStyle.of(context).style;
        final style = defaultStyle.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
        );

        return MaterialApp(
          theme: ThemeData(
            accentColor: const Color(0xFF123456),
          ),
          home: Scaffold(
            body: DefaultTextStyle(style: style, child: hw),
          ),
        );
      },
    ),
  );

  final hws = hwKey.currentState;
  expect(hws, isNotNull);

  return Explainer(hws.context, explainer: explainer)
      .explain(hws.build(hws.context));
}

final _explainMarginRegExp = RegExp(
    r'^\[Column:children=\[RichText:\(:x\)\],(.+),\[RichText:\(:x\)\]\]$');

Future<String> explainMargin(WidgetTester tester, String html) async {
  final explained = await explain(
    tester,
    "x${html}x",
  );
  final match = _explainMarginRegExp.firstMatch(explained);
  return match == null ? explained : match[1];
}

typedef String WidgetExplainer(Widget widget);
typedef void PreTest(BuildContext context);

class Explainer {
  final BuildContext context;
  final WidgetExplainer explainer;
  final TextStyle _defaultStyle;

  Explainer(this.context, {this.explainer})
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

  String _image(ImageProvider provider) {
    final type = provider.runtimeType.toString();
    final description = provider is AssetImage
        ? "assetName=${provider.assetName}" +
            (provider.package != null ? ",package=${provider.package}" : '')
        : provider is NetworkImage ? "url=${provider.url}" : '';
    return "[$type:$description]";
  }

  String _imageLayout(ImageLayout widget) {
    if (widget.height == null && widget.text == null && widget.width == null)
      return _image(widget.image);

    String s = "[ImageLayout:child=${_image(widget.image)}";
    if (widget.height != null) s += ",height=${widget.height}";
    if (widget.text != null) s += ",text=${widget.text}";
    if (widget.width != null) s += ",width=${widget.width}";

    return "$s]";
  }

  String _inlineSpan(InlineSpan inlineSpan, {TextStyle parentStyle}) {
    if (inlineSpan is WidgetSpan) return _widget(inlineSpan.child);

    final style = _textStyle(inlineSpan.style, parentStyle ?? _defaultStyle);
    final textSpan = inlineSpan is TextSpan ? inlineSpan : null;
    final onTap = textSpan?.recognizer != null ? '+onTap' : '';
    final text = textSpan?.text ?? '';
    final children = textSpan?.children
            ?.map((c) => _inlineSpan(c, parentStyle: textSpan.style))
            ?.join('') ??
        '';
    return "($style$onTap:$text$children)";
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

  String _tableRow(TableRow row) => row.children
      .map((c) => _widget(c is TableCell ? c.child : c))
      .toList()
      .join(' | ');

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
    if (widget is Image) return _image(widget.image);
    if (widget is ImageLayout) return _imageLayout(widget);

    // ignore: invalid_use_of_protected_member
    if (widget is SimpleColumn) return _widget(widget.build(context));

    // ignore: invalid_use_of_protected_member
    if (widget is IWidgetPlaceholder) return _widget(widget.build(context));

    final type = widget.runtimeType.toString();
    final text = widget is Align
        ? "alignment=${widget.alignment},"
        : widget is AspectRatio
            ? "aspectRatio=${widget.aspectRatio.toStringAsFixed(2)},"
            : widget is DecoratedBox
                ? _boxDecoration(widget.decoration)
                : widget is GestureDetector
                    ? "child=${_widget(widget.child)}"
                    : widget is InkWell
                        ? "child=${_widget(widget.child)}"
                        : widget is LimitedBox
                            ? _limitBox(widget)
                            : widget is Padding
                                ? "${_edgeInsets(widget.padding)},"
                                : widget is RichText
                                    ? _inlineSpan(widget.text)
                                    : widget is SizedBox
                                        ? "${widget.width?.toStringAsFixed(1) ?? 0.0}x${widget.height?.toStringAsFixed(1) ?? 0.0}"
                                        : widget is Table
                                            ? _tableBorder(widget.border)
                                            : widget is Text
                                                ? widget.data
                                                : widget is Wrap
                                                    ? _wrap(widget)
                                                    : '';
    final textAlign = _textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null));
    final textAlignStr = textAlign.isNotEmpty ? ",align=$textAlign" : '';
    final children = widget is MultiChildRenderObjectWidget
        ? (widget.children?.isNotEmpty == true && !(widget is RichText))
            ? "children=${widget.children.map(_widget).join(',')}"
            : ''
        : widget is ProxyWidget
            ? "child=${_widget(widget.child)}"
            : widget is SingleChildRenderObjectWidget
                ? (widget.child != null ? "child=${_widget(widget.child)}" : '')
                : widget is SingleChildScrollView
                    ? "child=${_widget(widget.child)}"
                    : widget is Table ? "\n${_tableRows(widget)}\n" : '';
    return "[$type$textAlignStr:$text$children]";
  }

  String _wrap(Wrap wrap) {
    String s = '';
    if (wrap.spacing != 0.0) s += 'spacing=${wrap.spacing},';
    if (wrap.runSpacing != 0.0) s += 'runSpacing=${wrap.runSpacing},';
    return s;
  }
}
