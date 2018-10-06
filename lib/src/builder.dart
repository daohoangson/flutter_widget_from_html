import 'package:flutter/widgets.dart';

import '../config.dart';
import '../widget_factory.dart';
import 'parsed_node.dart';
import 'styling.dart';

class Builder {
  final BuildContext context;
  final List<ParsedNode> parsedNodes;
  final WidgetFactory wf;

  Builder(
      {@required this.context,
      @required this.parsedNodes,
      @required WidgetFactory widgetFactory})
      : wf = widgetFactory;

  List<Widget> build({
    ParsedNode pn,
    @required int from,
    @required int to,
  }) {
    if (pn is ParsedNodeImage) {
      return [wf.buildImageWidget(pn.src)];
    }

    if (pn is ParsedNodeUrl) {
      return [
        wf.buildColumn(
          children: build(from: from, to: to),
          url: pn.href,
        ),
      ];
    }

    final tp = TextProcessor(
      builder: this,
      pn: pn,
      textStyleParent: DefaultTextStyle.of(context).style,
    );
    return tp.buildTextWidgets(from, to);
  }

  List<Widget> buildAll() => build(from: 0, to: parsedNodes.length - 1);
}

class TextProcessor {
  final Builder b;
  final TextProcessor parent;
  final ParsedNode pn;

  final TextStyle _textStyle;

  bool get hasTextStyle => pn is ParsedNodeStyle;

  TextProcessor(
      {@required Builder builder,
      this.parent,
      @required this.pn,
      @required TextStyle textStyleParent})
      : b = builder,
        _textStyle = buildTextStyle(pn, textStyleParent);

  List<Widget> buildTextWidgets(final int from, final int to) {
    final List<Widget> widgets = List();
    final addWidget = (Widget w) => w != null ? widgets.add(w) : null;

    final results = process(from, to);
    for (final result in results) {
      if (result.hasStyling) {
        addWidget(b.wf.buildTextWidgetWithStyling(
          text: result._buildTextSpan(b.wf),
          textAlign: pn?.textAlign,
        ));
      } else if (result.hasText) {
        addWidget(b.wf.buildTextWidgetSimple(
          text: result.text,
          textAlign: pn?.textAlign,
        ));
      }

      if (result.hasWidgets) {
        widgets.addAll(result.widgets);
      }
    }

    return List.unmodifiable(widgets);
  }

  List<_TextProcessorResult> process(final int from, final int to) {
    var i = from;
    final List<_TextProcessorResult> results = List();

    _TextProcessorResult inProcess;
    final setUpProcessing = ({bool init = false}) {
      inProcess = _TextProcessorResult(
        style: hasTextStyle ? _textStyle : null,
        texts: true,
      );
      if (init && pn is ParsedNodeText)
        inProcess._write((pn as ParsedNodeText).text, b.wf);
    };
    setUpProcessing(init: true);

    final wrapUpProcessing = () {
      if (inProcess.hasStyling || inProcess.textLength > 0) {
        results.add(inProcess);
      }

      setUpProcessing();
    };

    while (true) {
      if (i > to) {
        break;
      }

      final pn = b.parsedNodes[i];
      final indexEnd = (pn.processor as ParsedNodeProcessor)?.indexEnd ?? i;

      if (pn.isBlockElement) {
        wrapUpProcessing();

        final subWidgets = b.build(pn: pn, from: i + 1, to: indexEnd);
        results.add(_TextProcessorResult(widgets: subWidgets));
      } else {
        final subProcessor = TextProcessor(
          builder: b,
          parent: this,
          pn: pn,
          textStyleParent: _textStyle,
        );
        final subResults = subProcessor.process(i + 1, indexEnd);
        for (final subResult in subResults) {
          if (subResult.hasStyling) {
            inProcess._addSpan(subResult._buildTextSpan(b.wf));
          } else if (subResult.hasText) {
            inProcess._write(subResult.text, b.wf);
          }

          if (subResult.hasWidgets) {
            wrapUpProcessing();
            results.add(subResult);
          }
        }
      }

      i = indexEnd + 1;
    }

    wrapUpProcessing();

    return List.unmodifiable(results);
  }
}

class _TextProcessorResult {
  final TextStyle style;
  final List<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;

  _TextProcessorResult({this.style, bool texts = false, this.widgets})
      : _texts = texts ? StringBuffer() : null,
        assert(((texts ? 1 : 0) + (widgets != null ? 1 : 0)) == 1);

  bool get hasChildren => _spans != null;
  bool get hasStyling => style != null || hasChildren;
  bool get hasText => _texts != null;
  bool get hasWidgets => widgets != null;
  String get text => _texts.toString();
  int get textLength => _texts.length;

  void _addSpan(TextSpan span) {
    if (span == null) return;
    if (hasWidgets) throw ('Cannot add spans into result with widgets');
    if (_spans == null) _spans = List();

    if (span.style != null || span.text?.isNotEmpty != false) {
      _spans.add(span);
    } else {
      for (final subSpan in span.children) {
        _spans.add(subSpan);
      }
    }
  }

  TextSpan _buildTextSpan(WidgetFactory wf) {
    if (style == null && textLength == 0 && _spans.length == 1) {
      return _spans[0];
    }

    return wf.buildTextSpan(
      children: _spans,
      style: style,
      text: text,
    );
  }

  void _write(String text, WidgetFactory wf) => !hasChildren
      ? _texts.write(text)
      : _addSpan(wf.buildTextSpan(text: text));
}
