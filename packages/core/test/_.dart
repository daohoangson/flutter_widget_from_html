import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/tsh_widget.dart';

const kColor = Color(0xFF001234);
const kColorAccent = Color(0xFF123456);

// https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
const kDataUri =
    'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

final hwKey = GlobalKey<State<HtmlWidget>>();

const kGoldenFilePrefix = '../../../demo_app/test';

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
  bool rtl = false,
  TextStyle textStyle,
  bool useExplainer = true,
}) async {
  assert((html == null) != (hw == null));
  hw ??= HtmlWidget(
    html,
    key: hwKey,
    textStyle: textStyle,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(accentColor: kColorAccent),
      home: Scaffold(
        body: ExcludeSemantics(
          // exclude semantics for faster run but mostly because of this bug
          // https://github.com/flutter/flutter/issues/51936
          // which is failing some of our tests
          child: Builder(
            builder: (context) => DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: kColor,
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
              child: Directionality(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                child: hw,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  return explainWithoutPumping(
    buildFutureBuilderWithData: buildFutureBuilderWithData,
    explainer: explainer,
    useExplainer: useExplainer,
  );
}

Future<String> explainWithoutPumping({
  bool buildFutureBuilderWithData = true,
  String Function(Explainer, Widget) explainer,
  bool useExplainer = true,
}) async {
  if (!useExplainer) {
    final sb = StringBuffer();
    hwKey.currentContext.visitChildElements(
        (e) => sb.writeln(e.toDiagnosticsNode().toStringDeep()));
    var str = sb.toString();
    str = str.replaceAll(RegExp(r': [A-Z][A-Za-z]+\.'), ': '); // enums

    // dependencies
    str = str.replaceAll(RegExp(r'\[GlobalKey#[0-9a-f]+\]'), '');
    str = str.replaceAll(RegExp(r'(, )?dependencies: \[[^\]]+\]'), '');

    // image state
    str = str.replaceAll(
        RegExp(r'ImageStream#[0-9a-f]+\([^\)]+\)'), 'ImageStream');
    str = str.replaceAll(
        RegExp(r'(, )?state: _ImageState#[0-9a-f]+\([^\)]+\)'), '');

    // trim boring properties
    str =
        str.replaceAll(RegExp(r'(, )?(this.)?excludeFromSemantics: false'), '');
    str = str.replaceAll(RegExp(r'(, )?clipBehavior: none'), '');
    str = str.replaceAll(RegExp(r'(, )?crossAxisAlignment: start'), '');
    str = str.replaceAll(RegExp(r'(, )?direction: vertical'), '');
    str = str.replaceAll(RegExp(r'(, )?filterQuality: low'), '');
    str = str.replaceAll(RegExp(r'(, )?frameBuilder: null'), '');
    str = str.replaceAll(RegExp(r'(, )?image: null'), '');
    str = str.replaceAll(RegExp(r'(, )?invertColors: false'), '');
    str = str.replaceAll(RegExp(r'(, )?loadingBuilder: null'), '');
    str = str.replaceAll(RegExp(r'(, )?mainAxisAlignment: start'), '');
    str = str.replaceAll(RegExp(r'(, )?mainAxisSize: min'), '');
    str = str.replaceAll(RegExp(r'(, )?maxLines: unlimited'), '');
    str = str.replaceAll(
        RegExp(r'(, )?renderObject: \w+#[a-z0-9]+( relayoutBoundary=\w+)?'),
        '');
    str = str.replaceAll(RegExp(r'(, )?softWrap: [a-z\s]+'), '');
    str = str.replaceAll(RegExp(r'(, )?textDirection: ltr+'), '');

    // delete leading comma (because of property trimmings)
    str = str.replaceAllMapped(RegExp(r'(\w+\(), '), (m) => m.group(1));
    str = simplifyHashCode(str);
    return str;
  }

  var built = buildCurrentState();
  var isFutureBuilder = false;
  if (built is FutureBuilder<Widget>) {
    built = await buildFutureBuilder(
      built,
      withData: buildFutureBuilderWithData,
    );
    isFutureBuilder = true;
  }

  var explained = Explainer(
    hwKey.currentContext,
    explainer: explainer,
  ).explain(built);
  if (isFutureBuilder) explained = '[FutureBuilder:$explained]';

  return explained;
}

final _explainMarginRegExp = RegExp(r'^\[Column:(dir=rtl,)?children='
    r'\[RichText:(dir=rtl,)?\(:x\)\],'
    r'(.+),'
    r'\[RichText:(dir=rtl,)?\(:x\)\]'
    r'\]$');

Future<String> explainMargin(
  WidgetTester tester,
  String html, {
  bool rtl = false,
}) async {
  final explained = await explain(
    tester,
    null,
    hw: HtmlWidget('x${html}x', key: hwKey),
    rtl: rtl,
  );
  final match = _explainMarginRegExp.firstMatch(explained);
  return match == null ? explained : match[3];
}

String simplifyHashCode(String str) {
  final hashCodes = <String>[];
  return str.replaceAllMapped(RegExp(r'#(\d+)'), (match) {
    final hashCode = match.group(1);
    var indexOf = hashCodes.indexOf(hashCode);
    if (indexOf == -1) {
      indexOf = hashCodes.length;
      hashCodes.add(hashCode);
    }

    return '#$indexOf';
  });
}

Future<int> tapText(WidgetTester tester, String data) async {
  final candidates = find.byType(RichText).evaluate();
  var tapped = 0;
  for (final candidate in candidates) {
    final richText = candidate.widget as RichText;
    final text = richText.text;
    if (text is TextSpan) {
      if (text.text == data) {
        await tester.tap(find.byWidget(richText));
        tapped++;
      }
    }
  }

  return tapped;
}

class Explainer {
  final BuildContext context;
  final String Function(Explainer, Widget) explainer;
  final TextStyle _defaultStyle;

  Explainer(this.context, {this.explainer})
      : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _alignment(Alignment a) => a != null
      ? 'alignment=${a.toString().replaceFirst('Alignment.', '')}'
      : null;

  String _borderSide(BorderSide s) => s != BorderSide.none
      ? "${s.width}@${s.style.toString().replaceFirst('BorderStyle.', '')}${_color(s.color)}"
      : 'none';

  String _boxBorder(BoxBorder b) {
    if (b == null) return '';

    final top = _borderSide(b.top);
    final right = b is Border ? _borderSide(b.right) : 'none';
    final bottom = _borderSide(b.bottom);
    final left = b is Border ? _borderSide(b.left) : 'none';

    if (top == right && right == bottom && bottom == left) {
      return top;
    }

    return '($top,$right,$bottom,$left)';
  }

  String _boxConstraints(BoxConstraints bc) =>
      'constraints=${bc.toString().replaceAll('BoxConstraints', '')}';

  List<String> _boxDecoration(BoxDecoration d) {
    final attr = <String>[];

    if (d?.color != null) attr.add('bg=${_color(d.color)}');
    if (d?.border != null) attr.add('border=${_boxBorder(d.border)}');

    return attr;
  }

  String _color(Color c) =>
      '#${_colorHex(c.alpha)}${_colorHex(c.red)}${_colorHex(c.green)}${_colorHex(c.blue)}';

  String _colorHex(int i) {
    final h = i.toRadixString(16).toUpperCase();
    return h.length == 1 ? '0$h' : h;
  }

  List<String> _cssSizing(CssSizing w) {
    final attr = <String>[];

    if (w.minHeight != null) attr.add('height≥${w.minHeight}');
    if (w.maxHeight != null) attr.add('height≤${w.maxHeight}');
    if (w.preferredHeight != null) attr.add('height=${w.preferredHeight}');

    if (w.minWidth != null) attr.add('width≥${w.minWidth}');
    if (w.maxWidth != null) attr.add('width≤${w.maxWidth}');
    if (w.preferredWidth != null) attr.add('width=${w.preferredWidth}');

    return attr;
  }

  String _edgeInsets(EdgeInsets e) =>
      '(${e.top.truncate()},${e.right.truncate()},'
      '${e.bottom.truncate()},${e.left.truncate()})';

  String _image(Image image) {
    final buffer = StringBuffer();

    buffer.write('image=${image.image}');

    if (image.height != null) buffer.write(',height=${image.height}');
    if (image.semanticLabel != null) {
      buffer.write(',semanticLabel=${image.semanticLabel}');
    }
    if (image.width != null) buffer.write(',width=${image.width}');

    return '[Image:$buffer]';
  }

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
    final text = textSpan?.text ?? '';
    final children = textSpan?.children
            ?.map((c) => _inlineSpan(c, parentStyle: textSpan.style))
            ?.join('') ??
        '';

    final recognizerSb = StringBuffer();
    if (textSpan?.recognizer != null) {
      final recognizer = textSpan.recognizer;
      if (recognizer is TapGestureRecognizer) {
        if (recognizer.onTap != null) recognizerSb.write('+onTap');
        if (recognizer.onTapCancel != null) recognizerSb.write('+onTapCancel');
      }

      if (recognizerSb.isEmpty) {
        recognizerSb
            .write('+${textSpan.recognizer}'.replaceAll(RegExp(r'#\w+'), ''));
      }
    }

    return '($style$recognizerSb:$text$children)';
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

  String _textAlign(TextAlign textAlign) =>
      (textAlign != null && textAlign != TextAlign.start)
          ? 'align=${textAlign.toString().replaceAll('TextAlign.', '')}'
          : null;

  String _textDirection(TextDirection textDirection) =>
      (textDirection != null && textDirection != TextDirection.ltr)
          ? 'dir=${textDirection.toString().replaceAll('TextDirection.', '')}'
          : null;

  String _textOverflow(TextOverflow textOverflow) => (textOverflow != null &&
          textOverflow != TextOverflow.clip)
      ? 'overflow=${textOverflow.toString().replaceAll('TextOverflow.', '')}'
      : null;

  String _textStyle(TextStyle style, TextStyle parent) {
    var s = '';
    if (style == null) {
      return s;
    }

    if (style.background != null) {
      s += 'bg=${_color(style.background.color)}';
    }

    if (style.color != null && style.color != kColor) {
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
      s += '+height=${style.height.toStringAsFixed(1)}';
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

    if (widget is TshWidget) return _widget(widget.child);

    // ignore: invalid_use_of_protected_member
    if (widget is WidgetPlaceholder) return _widget(widget.build(context));

    if (widget is Image) return _image(widget);

    if (widget is SingleChildRenderObjectWidget) {
      switch (widget.runtimeType.toString()) {
        case '_LoosenConstraintsWidget':
          // avoid exposing internal widgets
          return _widget(widget.child);
      }
    }

    if (widget is SizedBox) return _sizedBox(widget);

    final type = '${widget.runtimeType}';
    var attr = <String>[];

    final maxLines = widget is RichText
        ? widget.maxLines
        : widget is Text
            ? widget.maxLines
            : null;
    if (maxLines != null) attr.add('maxLines=$maxLines');

    attr.add(_textAlign(widget is RichText
        ? widget.textAlign
        : (widget is Text ? widget.textAlign : null)));

    attr.add(_textDirection(widget is Column
        ? widget.textDirection
        : widget is RichText
            ? widget.textDirection
            : widget is Stack
                ? widget.textDirection
                : (widget is Text ? widget.textDirection : null)));

    attr.add(_textOverflow(widget is RichText
        ? widget.overflow
        : widget is Text
            ? widget.overflow
            : null));

    if (widget is Align && widget is! Center) {
      attr.add(_alignment(widget.alignment));
    }

    if (widget is AspectRatio) {
      attr.add('aspectRatio=${widget.aspectRatio.toStringAsFixed(1)}');
    }

    if (widget is ConstrainedBox) attr.add(_boxConstraints(widget.constraints));

    if (widget is Container) attr.addAll(_boxDecoration(widget.decoration));

    if (widget is CssSizing) attr.addAll(_cssSizing(widget));

    if (widget is DecoratedBox) attr.addAll(_boxDecoration(widget.decoration));

    if (widget is LimitedBox) attr.add(_limitBox(widget));

    if (widget is Padding) attr.add(_edgeInsets(widget.padding));

    if (widget is Positioned) {
      attr.add('(${widget.top},${widget.right},'
          '${widget.bottom},${widget.left})');
    }

    if (widget is SizedBox) {
      attr.add('${widget.width ?? 0.0}x'
          '${widget.height ?? 0.0}');
    }

    if (widget is Tooltip) attr.add('message=${widget.message}');

    // A-F
    // `RichText` is an exception, it is a `MultiChildRenderObjectWidget` so it has to be processed first
    attr.add(widget is RichText
        ? _inlineSpan(widget.text)
        : widget is Container
            ? _widgetChild(widget.child)
            : null);
    // G-M
    attr.add(widget is GestureDetector
        ? _widgetChild(widget.child)
        : widget is InkWell
            ? _widgetChild(widget.child)
            : widget is MultiChildRenderObjectWidget
                ? (widget is! RichText
                    ? _widgetChildren(widget.children)
                    : null)
                : null);
    // N-T
    attr.add(widget is ProxyWidget
        ? _widgetChild(widget.child)
        : widget is SingleChildRenderObjectWidget
            ? _widgetChild(widget.child)
            : widget is SingleChildScrollView
                ? _widgetChild(widget.child)
                : widget is Text
                    ? widget.data
                    : widget is Tooltip
                        ? _widgetChild(widget.child)
                        : null);
    // U-Z

    final attrStr = attr.where((a) => a?.isNotEmpty == true).join(',');
    return '[$type${attrStr.isNotEmpty ? ':$attrStr' : ''}]';
  }

  String _widgetChild(Widget widget) =>
      widget != null ? 'child=${_widget(widget)}' : null;

  String _widgetChildren(Iterable<Widget> widgets) =>
      widgets?.isNotEmpty == true
          ? 'children=${widgets.map(_widget).join(',')}'
          : null;
}
