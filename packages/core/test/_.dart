import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

final hwKey = GlobalKey<State<HtmlWidget>>();

Widget buildCurrentState() {
  final hws = hwKey.currentState;
  if (hws == null) return null;

  // ignore: invalid_use_of_protected_member
  return hws.build(hws.context);
}

Future<Widget> buildFutureBuilder(
  FutureBuilder<Widget> fb, {
  bool withData = true,
}) async {
  final hws = hwKey.currentState;
  if (hws == null) return Future.value(null);

  final data = await fb.future;
  final snapshot = withData
      ? AsyncSnapshot.withData(ConnectionState.done, data)
      : AsyncSnapshot<Widget>.nothing();
  return fb.builder(hws.context, snapshot);
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool buildFutureBuilderWithData = true,
  String Function(Widget) explainer,
  Widget hw,
  void Function(BuildContext) preTest,
  Uri baseUrl,
  double bodyVerticalPadding = 0,
  NodeMetadataCollector builderCallback,
  WidgetFactory Function(HtmlConfig config) factoryBuilder,
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
            body: ExcludeSemantics(
              // exclude semantics for faster run but mostly because of this bug
              // https://github.com/flutter/flutter/issues/51936
              // which is failing some of our tests
              child: DefaultTextStyle(style: style, child: hw),
            ),
          ),
        );
      },
    ),
  );

  final hws = hwKey.currentState;
  expect(hws, isNotNull);

  var built = buildCurrentState();
  var isFutureBuilder = false;
  if (built is FutureBuilder<Widget>) {
    built = await buildFutureBuilder(
      built,
      withData: buildFutureBuilderWithData,
    );
    isFutureBuilder = true;
  }

  var explained = Explainer(hws.context, explainer: explainer).explain(built);
  if (isFutureBuilder) explained = "[FutureBuilder:$explained]";

  return explained;
}

final _explainMarginRegExp = RegExp(
    r'^\[Column:children=\[RichText:\(:x\)\],(.+),\[RichText:\(:x\)\]\]$');

Future<String> explainMargin(
  WidgetTester tester,
  String html, {
  bool rtl = false,
}) async {
  final explained = await explain(
    tester,
    null,
    hw: Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: HtmlWidget(
        "x${html}x",
        bodyPadding: const EdgeInsets.all(0),
        key: hwKey,
      ),
    ),
  );
  final match = _explainMarginRegExp.firstMatch(explained);
  return match == null ? explained : match[1];
}

class Explainer {
  final BuildContext context;
  final String Function(Widget) explainer;
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
    if (widget.height == null && widget.text == null && widget.width == null) {
      return _image(widget.image);
    }

    String s = "[ImageLayout:child=${_image(widget.image)}";
    if (widget.height != null) s += ",height=${widget.height}";
    if (widget.text != null) s += ",text=${widget.text}";
    if (widget.width != null) s += ",width=${widget.width}";

    return "$s]";
  }

  String _inlineSpan(InlineSpan inlineSpan, {TextStyle parentStyle}) {
    if (inlineSpan is WidgetSpan) {
      String s = _widget(inlineSpan.child);
      if (inlineSpan.alignment != PlaceholderAlignment.baseline) {
        s += inlineSpan.alignment
            .toString()
            .replaceAll('PlaceholderAlignment.', '@');
      }
      return s;
    }

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
      .toList(growable: false)
      .join(' | ');

  String _tableRows(Table table) => table.children
      .map((r) => _tableRow(r))
      .toList(growable: false)
      .join('\n');

  String _textAlign(TextAlign textAlign) =>
      (textAlign != null && textAlign != TextAlign.start)
          ? textAlign.toString().replaceAll('TextAlign.', '')
          : '';

  String _textDirection(TextDirection textDirection) =>
      textDirection.toString().replaceAll('TextDirection.', '');

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
    if (widget is WidgetPlaceholder) return _widget(widget.build(context));

    if (widget is LayoutBuilder) {
      return _widget(widget.builder(
        context,
        BoxConstraints.tightFor(width: 800, height: 600),
      ));
    }

    final type = widget.runtimeType
        .toString()
        .replaceAll('_MarginHorizontal', 'Padding');
    final text = widget is Align
        ? "${widget is Center ? '' : 'alignment=${widget.alignment},'}"
        : widget is AspectRatio
            ? "aspectRatio=${widget.aspectRatio.toStringAsFixed(2)},"
            : widget is DecoratedBox
                ? _boxDecoration(widget.decoration)
                : widget is Directionality
                    ? "${_textDirection(widget.textDirection)},"
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
