import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
const kDataUri =
    'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

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
  String Function(Explainer, Widget) explainer,
  Widget hw,
  void Function(BuildContext) preTest,
  TextStyle textStyle,
}) async {
  assert((html == null) != (hw == null));
  hw ??= HtmlWidget(
    html,
    key: hwKey,
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
  if (isFutureBuilder) explained = '[FutureBuilder:$explained]';

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
        'x${html}x',
        key: hwKey,
      ),
    ),
  );
  final match = _explainMarginRegExp.firstMatch(explained);
  return match == null ? explained : match[1];
}

class Explainer {
  final BuildContext context;
  final String Function(Explainer, Widget) explainer;
  final TextStyle _defaultStyle;

  Explainer(this.context, {this.explainer})
      : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _borderSide(BorderSide s) =>
      "${s.width}@${s.style.toString().replaceFirst('BorderStyle.', '')}${_color(s.color)}";

  String _boxBorder(BoxBorder b) {
    if (b == null) return '';

    final top = _borderSide(b.top);
    final right = b is Border ? _borderSide(b.right) : '';
    final bottom = _borderSide(b.bottom);
    final left = b is Border ? _borderSide(b.left) : '';

    if (top == right && right == bottom && bottom == left) {
      return top;
    }

    return '($top,$right,$bottom,$left)';
  }

  String _boxConstraints(BoxConstraints bc) =>
      bc.toString().replaceAll('BoxConstraints', '');

  String _boxDecoration(BoxDecoration d) {
    final buffer = StringBuffer();

    if (d.color != null) buffer.write('bg=${_color(d.color)},');
    if (d.border != null) buffer.write('border=${_boxBorder(d.border)},');

    return buffer.toString();
  }

  String _color(Color c) =>
      '#${_colorHex(c.alpha)}${_colorHex(c.red)}${_colorHex(c.green)}${_colorHex(c.blue)}';

  String _colorHex(int i) {
    final h = i.toRadixString(16).toUpperCase();
    return h.length == 1 ? '0$h' : h;
  }

  String _container(Container container) {
    final buffer = StringBuffer();

    if (container.decoration != null) {
      buffer.write(_boxDecoration(container.decoration));
    }

    if (container.child != null) {
      buffer.write('child=${_widget(container.child)}');
    }

    return '[Container:$buffer]';
  }

  String _edgeInsets(EdgeInsets e) =>
      '(${e.top.truncate()},${e.right.truncate()},'
      '${e.bottom.truncate()},${e.left.truncate()})';

  String _inlineSpan(InlineSpan inlineSpan, {TextStyle parentStyle}) {
    if (inlineSpan is WidgetSpan) {
      var s = _widget(inlineSpan.child);
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
    return '($style$onTap:$text$children)';
  }

  String _limitBox(LimitedBox box) {
    var s = '';
    if (box.maxHeight != null) s += 'h=${box.maxHeight},';
    if (box.maxWidth != null) s += 'w=${box.maxWidth},';
    return s;
  }

  String _sizedBox(SizedBox box) {
    var clazz = box.runtimeType.toString();
    var size = '${box.width?.toStringAsFixed(1) ?? 0.0}x'
        '${box.height?.toStringAsFixed(1) ?? 0.0}';
    if (size == 'InfinityxInfinity') {
      clazz = 'SizedBox.expand';
      size = '';
    }

    final child = box.child != null ? 'child=${_widget(box.child)}' : '';
    final comma = size.isNotEmpty && child.isNotEmpty ? ',' : '';
    return '[$clazz:$size$comma$child]';
  }

  String _tableBorder(TableBorder b) {
    if (b == null) return '';

    final top = _borderSide(b.top);
    final right = _borderSide(b.right);
    final bottom = _borderSide(b.bottom);
    final left = _borderSide(b.left);

    if (top == right && right == bottom && bottom == left) {
      return 'border=$top';
    }

    return 'borders=($top;$right;$bottom;$left)';
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

  String _textOverflow(TextOverflow textOverflow) =>
      (textOverflow != null && textOverflow != TextOverflow.clip)
          ? textOverflow.toString().replaceAll('TextOverflow.', '')
          : '';

  String _textStyle(TextStyle style, TextStyle parent) {
    var s = '';
    if (style == null) {
      return s;
    }

    if (style.background != null) {
      s += 'bg=${_color(style.background.color)}';
    }

    if (style.color != null) {
      s += _color(style.color);
    }

    s += _textStyleDecoration(style, TextDecoration.lineThrough, 'l');
    s += _textStyleDecoration(style, TextDecoration.overline, 'o');
    s += _textStyleDecoration(style, TextDecoration.underline, 'u');

    if (style.fontFamily != null && style.fontFamily != parent.fontFamily) {
      s += '+font=${style.fontFamily}';
    }

    if (style.fontFamilyFallback?.isNotEmpty == true &&
        style.fontFamilyFallback != parent.fontFamilyFallback) {
      s += "+fonts=${style.fontFamilyFallback.join(', ')}";
    }

    if (style.height != null) {
      s += '+height=${style.height}';
    }

    if (style.fontSize != parent.fontSize) {
      s += '@${style.fontSize.toStringAsFixed(1)}';
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
        : '${style.decorationStyle}'.replaceFirst(RegExp(r'^.+\.'), '/');

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
    final explained = explainer?.call(this, widget);
    if (explained != null) return explained;

    if (widget == widget0) return '[widget0]';
    if (widget is ImageLayout) return '[$widget]';

    // ignore: invalid_use_of_protected_member
    if (widget is WidgetPlaceholder) return _widget(widget.build(context));

    if (widget is Container) return _container(widget);

    if (widget is LayoutBuilder) {
      return _widget(widget.builder(
        context,
        BoxConstraints.tightFor(width: 800, height: 600),
      ));
    }

    if (widget is SizedBox) return _sizedBox(widget);

    final type = widget.runtimeType
        .toString()
        .replaceAll('_MarginHorizontal', 'Padding');
    final text = widget is Align
        ? "${widget is Center ? '' : 'alignment=${widget.alignment},'}"
        : widget is AspectRatio
            ? 'aspectRatio=${widget.aspectRatio.toStringAsFixed(2)},'
            : widget is ConstrainedBox
                ? 'constraints=${_boxConstraints(widget.constraints)},'
                : widget is DecoratedBox
                    ? _boxDecoration(widget.decoration)
                    : widget is Directionality
                        ? '${_textDirection(widget.textDirection)},'
                        : widget is GestureDetector
                            ? 'child=${_widget(widget.child)}'
                            : widget is InkWell
                                ? 'child=${_widget(widget.child)}'
                                : widget is LimitedBox
                                    ? _limitBox(widget)
                                    : widget is Padding
                                        ? '${_edgeInsets(widget.padding)},'
                                        : widget is Positioned
                                            ? '(${widget.top},${widget.right},${widget.bottom},${widget.left}),'
                                            : widget is RichText
                                                ? _inlineSpan(widget.text)
                                                : widget is SizedBox
                                                    ? '${widget.width?.toStringAsFixed(1) ?? 0.0}x${widget.height?.toStringAsFixed(1) ?? 0.0}'
                                                    : widget is Table
                                                        ? _tableBorder(
                                                            widget.border)
                                                        : widget is Text
                                                            ? widget.data
                                                            : widget is Wrap
                                                                ? _wrap(widget)
                                                                : '';

    var attrStr = '';
    final textAlign = _textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null));
    attrStr += textAlign.isNotEmpty ? ',align=$textAlign' : '';
    final maxLines = widget is RichText
        ? widget.maxLines
        : widget is Text ? widget.maxLines : null;
    if (maxLines != null) attrStr += ',maxLines=$maxLines';
    final textOverflow = _textOverflow(widget is RichText
        ? widget.overflow
        : widget is Text ? widget.overflow : null);
    attrStr += textOverflow.isNotEmpty ? ',overflow=$textOverflow' : '';

    final children = widget is MultiChildRenderObjectWidget
        ? (widget.children?.isNotEmpty == true && !(widget is RichText))
            ? "children=${widget.children.map(_widget).join(',')}"
            : ''
        : widget is ProxyWidget
            ? 'child=${_widget(widget.child)}'
            : widget is SingleChildRenderObjectWidget
                ? (widget.child != null ? 'child=${_widget(widget.child)}' : '')
                : widget is SingleChildScrollView
                    ? 'child=${_widget(widget.child)}'
                    : widget is Table ? '\n${_tableRows(widget)}\n' : '';
    return '[$type$attrStr:$text$children]';
  }

  String _wrap(Wrap wrap) {
    var s = '';
    if (wrap.spacing != 0.0) s += 'spacing=${wrap.spacing},';
    if (wrap.runSpacing != 0.0) s += 'runSpacing=${wrap.runSpacing},';
    return s;
  }
}
