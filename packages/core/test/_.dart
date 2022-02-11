import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/tsh_widget.dart';

export '_constants.dart';

const kColor = Color(0xFF001234);
const kColorPrimary = Color(0xFF123456);

// https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
const kDataBase64 = 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
const kDataUri = 'data:image/gif;base64,$kDataBase64';

// TODO: switch to GlobalKey<HtmlWidgetState> when backward compatibility allows
final hwKey = GlobalKey<State<HtmlWidget>>();

Widget? buildCurrentState({GlobalKey? key}) {
  final hws = (key ?? hwKey).currentState;
  if (hws == null) {
    return null;
  }

  // ignore: invalid_use_of_protected_member
  return hws.build(hws.context);
}

Future<String> explain(
  WidgetTester tester,
  String? html, {
  String? Function(Explainer, Widget)? explainer,
  Widget? hw,
  GlobalKey? key,
  bool rtl = false,
  TextStyle? textStyle,
  bool useExplainer = true,
}) async {
  assert((html == null) != (hw == null));
  key ??= hwKey;
  hw ??= HtmlWidget(
    html!,
    key: key,
    textStyle: textStyle,
  );

  final ThemeData theme = ThemeData();

  await tester.pumpWidget(
    MaterialApp(
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: kColorPrimary),
      ),
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
                child: hw!,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  return explainWithoutPumping(
    explainer: explainer,
    key: key,
    useExplainer: useExplainer,
  );
}

Future<String> explainWithoutPumping({
  String? Function(Explainer, Widget)? explainer,
  GlobalKey? key,
  bool useExplainer = true,
}) async {
  key ??= hwKey;
  if (!useExplainer) {
    final sb = StringBuffer();
    key.currentContext?.visitChildElements(
      (e) => sb.writeln(e.toDiagnosticsNode().toStringDeep()),
    );
    var str = sb.toString();
    str = str.replaceAll(RegExp(r': [A-Z][A-Za-z]+\.'), ': '); // enums
    str = str.replaceAll(RegExp(r'State#\w+'), 'State'); // states

    // dependencies
    str = str.replaceAll(RegExp(r'\[GlobalKey#[0-9a-f]+\]'), '');
    str = str.replaceAllMapped(
      RegExp(r'\[GlobalKey#[0-9a-f]+ ([^\]]+)\]'),
      (m) => '[GlobalKey ${m.group(1)!}]',
    );
    str = str.replaceAll(RegExp(r'(, )?dependencies: \[[^\]]+\]'), '');

    // image state
    str = str.replaceAll(
      RegExp(r'ImageStream#[0-9a-f]+\([^\)]+\)'),
      'ImageStream',
    );
    str = str.replaceAll(
      RegExp(r'(, )?state: _ImageState#[0-9a-f]+\([^\)]+\)'),
      '',
    );

    // simplify complicated widgets
    str = str.replaceAll(RegExp(r'Focus\(.+\)\n'), 'Focus(...)\n');
    str = str.replaceAll(RegExp(r'Listener\(.+\)\n'), 'Listener(...)\n');
    str = str.replaceAll(
      RegExp(r'RawGestureDetector\(.+\)\n'),
      'RawGestureDetector(...)\n',
    );
    str = str.replaceAll(RegExp(r'Semantics\(.+\)\n'), 'Semantics(...)\n');

    // trim boring properties
    str =
        str.replaceAll(RegExp('(, )?(this.)?excludeFromSemantics: false'), '');
    str = str.replaceAll(RegExp('(, )?clipBehavior: none'), '');
    str = str.replaceAll(RegExp('(, )?crossAxisAlignment: start'), '');
    str = str.replaceAll(RegExp('(, )?direction: vertical'), '');
    str = str.replaceAll(RegExp('(, )?filterQuality: low'), '');
    str = str.replaceAll(RegExp('(, )?frameBuilder: null'), '');
    str = str.replaceAll(RegExp('(, )?image: null'), '');
    str = str.replaceAll(RegExp('(, )?invertColors: false'), '');
    str = str.replaceAll(RegExp('(, )?loadingBuilder: null'), '');
    str = str.replaceAll(RegExp('(, )?mainAxisAlignment: start'), '');
    str = str.replaceAll(RegExp('(, )?mainAxisSize: min'), '');
    str = str.replaceAll(RegExp('(, )?maxLines: unlimited'), '');
    str = str.replaceAll(
      RegExp(r'(, )?renderObject: \w+#[a-z0-9]+( relayoutBoundary=\w+)?'),
      '',
    );
    str = str.replaceAll(RegExp(r'(, )?softWrap: [a-z\s]+'), '');
    str = str.replaceAll(RegExp('(, )?textDirection: ltr+'), '');

    // delete leading comma (because of property trimmings)
    str = str.replaceAll('(, ', '(');
    str = simplifyHashCode(str);
    return str;
  }

  final built = buildCurrentState(key: key);
  if (built == null) {
    return 'null';
  }

  return Explainer(
    key.currentContext!,
    explainer: explainer,
  ).explain(built);
}

final _explainMarginRegExp = RegExp(
  r'^\[Column:(dir=rtl,)?children='
  r'\[RichText:(dir=rtl,)?\(:x\)\],'
  '(.+),'
  r'\[RichText:(dir=rtl,)?\(:x\)\]'
  r'\]$',
);

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
  return match == null ? explained : match[3]!;
}

String simplifyHashCode(String str) {
  final hashCodes = <String>[];
  return str.replaceAllMapped(RegExp(r'#(\d+)'), (match) {
    final hashCode = match[1]!;
    var indexOf = hashCodes.indexOf(hashCode);
    if (indexOf == -1) {
      indexOf = hashCodes.length;
      hashCodes.add(hashCode);
    }

    return '#$indexOf';
  });
}

Finder findText(String data) => _TextFinder(data);

Future<int> tapText(WidgetTester tester, String data) async {
  var tapped = 0;

  for (final candidate in findText(data).evaluate()) {
    await tester.tap(find.byWidget(candidate.widget));
    tapped++;
  }

  return tapped;
}

class Explainer {
  final BuildContext context;
  final String? Function(Explainer, Widget)? explainer;
  final TextStyle _defaultStyle;

  Explainer(this.context, {this.explainer})
      : _defaultStyle = DefaultTextStyle.of(context).style;

  String explain(Widget widget) => _widget(widget);

  String _alignment(AlignmentGeometry? a) => a != null
      ? 'alignment=${a.toString().replaceFirst('Alignment.', '')}'
      : '';

  String _borderRadius(BorderRadius r) {
    final values = <double>[
      r.topLeft.x,
      r.topLeft.y,
      r.topRight.x,
      r.topRight.y,
      r.bottomRight.x,
      r.bottomRight.y,
      r.bottomLeft.x,
      r.bottomLeft.y,
    ];
    return '$values';
  }

  String _borderSide(BorderSide s) => s != BorderSide.none
      ? '${s.width}'
          '@${s.style.toString().replaceFirst('BorderStyle.', '')}'
          '${_color(s.color)}'
      : 'none';

  String _boxBorder(BoxBorder? b) {
    if (b == null) {
      return '';
    }

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

  List<String> _boxDecoration(Decoration? d) {
    final attr = <String>[];

    if (d is BoxDecoration) {
      final color = d.color;
      if (color != null) {
        attr.add('bg=${_color(color)}');
      }

      final border = d.border;
      if (border != null) {
        attr.add('border=${_boxBorder(border)}');
      }

      final borderRadius = d.borderRadius;
      if (borderRadius != null && borderRadius is BorderRadius) {
        attr.add('radius=${_borderRadius(borderRadius)}');
      }
    }

    return attr;
  }

  String _color(Color c) => '#${_colorHex(c.alpha)}'
      '${_colorHex(c.red)}'
      '${_colorHex(c.green)}'
      '${_colorHex(c.blue)}';

  String _colorHex(int i) {
    final h = i.toRadixString(16).toUpperCase();
    return h.length == 1 ? '0$h' : h;
  }

  List<String> _cssSizing(CssSizing w) {
    final attr = <String>[];

    if (w.minHeight != null) {
      attr.add('height≥${w.minHeight}');
    }
    if (w.maxHeight != null) {
      attr.add('height≤${w.maxHeight}');
    }
    if (w.preferredHeight != null) {
      attr.add('height=${w.preferredHeight}');
    }

    if (w.minWidth != null) {
      attr.add('width≥${w.minWidth}');
    }
    if (w.maxWidth != null) {
      attr.add('width≤${w.maxWidth}');
    }
    if (w.preferredWidth != null) {
      attr.add('width=${w.preferredWidth}');
    }

    return attr;
  }

  String _edgeInsets(EdgeInsetsGeometry e) => e is EdgeInsets
      ? '(${e.top.truncate()},${e.right.truncate()},'
          '${e.bottom.truncate()},${e.left.truncate()})'
      : e.toString();

  String _image(Image image) {
    final buffer = StringBuffer();

    buffer.write('image=${image.image}');

    if (image.height != null) {
      buffer.write(',height=${image.height}');
    }
    if (image.semanticLabel != null) {
      buffer.write(',semanticLabel=${image.semanticLabel}');
    }
    if (image.width != null) {
      buffer.write(',width=${image.width}');
    }

    return '[Image:$buffer]';
  }

  String _inlineSpan(InlineSpan inlineSpan, {TextStyle? parentStyle}) {
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
            .join() ??
        '';

    final recognizerSb = StringBuffer();
    if (textSpan?.recognizer != null) {
      final recognizer = textSpan!.recognizer;
      if (recognizer is TapGestureRecognizer) {
        if (recognizer.onTap != null) {
          recognizerSb.write('+onTap');
        }
        if (recognizer.onTapCancel != null) {
          recognizerSb.write('+onTapCancel');
        }
      }

      if (recognizerSb.isEmpty) {
        recognizerSb
            .write('+${textSpan.recognizer}'.replaceAll(RegExp(r'#\w+'), ''));
      }
    }

    return '($style$recognizerSb:$text$children)';
  }

  String _key(Key key) {
    final matches =
        RegExp(r'^\[GlobalKey#[^ ]+ (.+)\]$').firstMatch(key.toString());
    if (matches == null) {
      return '';
    }

    return '#${matches.group(1)}';
  }

  String _limitBox(LimitedBox box) => 'h=${box.maxHeight},w=${box.maxWidth}';

  String _sizedBox(SizedBox box) {
    var clazz = box.runtimeType.toString();
    var size = '${box.width?.toStringAsFixed(1) ?? 0.0}x'
        '${box.height?.toStringAsFixed(1) ?? 0.0}';
    switch (size) {
      case '0.0x0.0':
        if (box.width == 0.0 && box.height == 0.0) {
          clazz = 'SizedBox.shrink';
        }
        size = '';
        break;
      case 'InfinityxInfinity':
        clazz = 'SizedBox.expand';
        size = '';
        break;
    }

    final key = box.key != null ? _key(box.key!) : '';
    final child = box.child != null ? 'child=${_widget(box.child!)}' : '';
    final comma = size.isNotEmpty && child.isNotEmpty ? ',' : '';
    return '[$clazz$key:$size$comma$child]';
  }

  String _textAlign(TextAlign? textAlign) =>
      (textAlign != null && textAlign != TextAlign.start)
          ? 'align=${textAlign.toString().replaceAll('TextAlign.', '')}'
          : '';

  String _textDirection(TextDirection? textDirection) =>
      (textDirection != null && textDirection != TextDirection.ltr)
          ? 'dir=${textDirection.toString().replaceAll('TextDirection.', '')}'
          : '';

  String _textOverflow(TextOverflow? textOverflow) => (textOverflow != null &&
          textOverflow != TextOverflow.clip)
      ? 'overflow=${textOverflow.toString().replaceAll('TextOverflow.', '')}'
      : '';

  String _textStyle(TextStyle? style, TextStyle parent) {
    var s = '';
    if (style == null) {
      return s;
    }

    final bg = style.background;
    if (bg != null) {
      s += 'bg=${_color(bg.color)}';
    }

    final color = style.color;
    if (color != null && color != kColor) {
      s += _color(color);
    }

    s += _textStyleDecoration(style, TextDecoration.lineThrough, 'l');
    s += _textStyleDecoration(style, TextDecoration.overline, 'o');
    s += _textStyleDecoration(style, TextDecoration.underline, 'u');

    if (style.fontFamily != null && style.fontFamily != parent.fontFamily) {
      s += '+font=${style.fontFamily}';
    }

    final fontFamilyFallback = style.fontFamilyFallback;
    if (fontFamilyFallback != null &&
        fontFamilyFallback.isNotEmpty &&
        fontFamilyFallback != parent.fontFamilyFallback) {
      s += "+fonts=${fontFamilyFallback.join(', ')}";
    }

    final height = style.height;
    if (height != null) {
      s += '+height=${height.toStringAsFixed(1)}';
    }

    final fontSize = style.fontSize;
    if (fontSize != null && fontSize != parent.fontSize) {
      s += '@${fontSize.toStringAsFixed(1)}';
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

    final decorationColor =
        (style.decorationColor == null || style.decorationColor == style.color)
            ? ''
            : '/${_color(style.decorationColor!)}';

    final decorationThickness = style.decorationThickness == null
        ? ''
        : '/${style.decorationThickness}';

    return '${styleHasIt ? '+' : '-'}$str'
        '$decorationColor$decorationStyle$decorationThickness';
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
      case null:
        return '';
    }
  }

  String _textStyleFontWeight(TextStyle style) {
    final fontWeight = style.fontWeight;
    if (fontWeight == null || style.fontWeight == _defaultStyle.fontWeight) {
      return '';
    }

    if (fontWeight == FontWeight.bold) {
      return '+b';
    }
    return '+w${FontWeight.values.indexOf(fontWeight)}';
  }

  String _widget(Widget widget) {
    final explained = explainer?.call(this, widget);
    if (explained != null) {
      return explained;
    }

    if (widget == widget0) {
      return '[widget0]';
    }

    if (widget.runtimeType.toString() == 'HtmlListMarker') {
      return widget.toStringShort();
    }

    if (widget is TshWidget) {
      return _widget(widget.child);
    }

    if (widget is WidgetPlaceholder) {
      return _widget(widget.build(context));
    }

    if (widget is Image) {
      return _image(widget);
    }

    if (widget is SizedBox) {
      return _sizedBox(widget);
    }

    final type = '${widget.runtimeType}';
    final attr = <String>[];

    final maxLines = widget is RichText
        ? widget.maxLines
        : widget is Text
            ? widget.maxLines
            : null;
    if (maxLines != null) {
      attr.add('maxLines=$maxLines');
    }

    attr.add(
      _textAlign(
        widget is RichText
            ? widget.textAlign
            : (widget is Text ? widget.textAlign : null),
      ),
    );

    attr.add(
      _textDirection(
        widget is Column
            ? widget.textDirection
            : widget is RichText
                ? widget.textDirection
                : (widget is Text ? widget.textDirection : null),
      ),
    );

    attr.add(
      _textOverflow(
        widget is RichText
            ? widget.overflow
            : widget is Text
                ? widget.overflow
                : null,
      ),
    );

    if (widget is Align && widget is! Center) {
      attr.add(_alignment(widget.alignment));
    }

    if (widget is AspectRatio) {
      attr.add('aspectRatio=${widget.aspectRatio.toStringAsFixed(1)}');
    }

    if (widget is ConstrainedBox) {
      attr.add(_boxConstraints(widget.constraints));
    }

    if (widget is Container) {
      attr.addAll(_boxDecoration(widget.decoration));
    }

    if (widget is CssSizing) {
      attr.addAll(_cssSizing(widget));
    }

    if (widget is DecoratedBox) {
      attr.addAll(_boxDecoration(widget.decoration));
    }

    if (widget is LimitedBox) {
      attr.add(_limitBox(widget));
    }

    if (widget is Padding) {
      attr.add(_edgeInsets(widget.padding));
    }

    if (widget is Positioned) {
      attr.add(
        '(${widget.top},${widget.right},'
        '${widget.bottom},${widget.left})',
      );
    }

    if (widget is SelectableText) {
      if (widget.onSelectionChanged != null) {
        attr.add('+onSelectionChanged');
      }
    }

    if (widget is Tooltip) {
      attr.add('message=${widget.message}');
    }

    // A-F
    // `RichText` is an exception, it is a `MultiChildRenderObjectWidget`
    // so it has to be processed first
    attr.add(
      widget is RichText
          ? _inlineSpan(widget.text)
          : widget is Container
              ? _widgetChild(widget.child)
              : '',
    );
    // G-M
    attr.add(
      widget is GestureDetector
          ? _widgetChild(widget.child)
          : widget is MouseRegion
              ? _widgetChild(widget.child)
              : widget is MultiChildRenderObjectWidget
                  ? (widget is! RichText
                      ? _widgetChildren(widget.children)
                      : '')
                  : '',
    );

    // N-T
    attr.add(
      widget is ProxyWidget
          ? _widgetChild(widget.child)
          : widget is SingleChildRenderObjectWidget
              ? _widgetChild(widget.child)
              : widget is SingleChildScrollView
                  ? _widgetChild(widget.child)
                  : widget is SelectableText
                      ? _inlineSpan(widget.textSpan!)
                      : widget is Text
                          ? widget.data!
                          : widget is Tooltip
                              ? _widgetChild(widget.child)
                              : '',
    );
    // U-Z

    final attrStr = attr.where((a) => a.isNotEmpty).join(',');
    return '[$type${attrStr.isNotEmpty ? ':$attrStr' : ''}]';
  }

  String _widgetChild(Widget? widget) =>
      widget != null ? 'child=${_widget(widget)}' : '';

  String _widgetChildren(Iterable<Widget> widgets) =>
      widgets.isNotEmpty ? 'children=${widgets.map(_widget).join(',')}' : '';
}

class HitTestApp extends StatelessWidget {
  final String html;
  final List<String> list;

  const HitTestApp({required this.html, Key? key, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            html,
            onTapUrl: (url) {
              list.add(url);
              return true;
            },
          ),
        ),
      );
}

class _TextFinder extends MatchFinder {
  final String data;

  _TextFinder(this.data) : super(skipOffstage: true);

  @override
  String get description => '_TextFinder "$data"';

  @override
  bool matches(Element candidate) {
    final Widget widget = candidate.widget;

    if (widget is RichText) {
      final text = widget.text;
      if (text is TextSpan) {
        if (text.toPlainText() == data) {
          return true;
        }
      }
    } else if (widget is SelectableText) {
      final text = widget.data;
      if (text != null && text == data) {
        return true;
      }

      final span = widget.textSpan;
      if (span != null && span.toPlainText() == data) {
        return true;
      }
    }

    return false;
  }
}
