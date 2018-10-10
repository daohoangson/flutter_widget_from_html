import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:meta/meta.dart';

import '../config.dart';
import 'styling.dart';

List<dom.Node> parseDomNodes(String html) => parser.parse(html).body.nodes;

class ParsedNodeProcessor {
  final Config config;
  final ParsedNodeProcessor parent;

  final List<ParsedNode> _parsedNodes;
  int _parsedNodeIndexEnd;

  int get indexEnd => _parsedNodeIndexEnd;

  ParsedNodeProcessor(
      {@required this.config, this.parent, List<ParsedNode> parsedNodes})
      : _parsedNodes = parsedNodes ?? List(),
        _parsedNodeIndexEnd = (parsedNodes?.length ?? 0) - 1;

  List<ParsedNode> parse(List<dom.Node> nodes) {
    for (final node in nodes) {
      switch (node.nodeType) {
        case dom.Node.TEXT_NODE:
          queue(ParsedNodeText(text: node.text));
          break;
        case dom.Node.ELEMENT_NODE:
          _parseElement(node);
          break;
      }
    }

    return _parsedNodes;
  }

  int queue(ParsedNode pn) {
    if (pn == null) return -1;

    pn.processor = this;
    _parsedNodes.add(pn);
    final index = _parsedNodes.length - 1;
    _updateIndexEnd(index);

    return index;
  }

  int _parseElement(dom.Element e) {
    if (config.parseElementCallback != null &&
        !config.parseElementCallback(e)) {
      return -1;
    }

    switch (e.localName) {
      case 'img':
        return _subNp().queue(ParsedNodeImage.fromAttributes(e.attributes));
    }

    final pns = parseNodeStyle(config, e);
    final subNp = _subNp();
    if (pns != null) subNp.queue(pns);

    return subNp.parse(e.nodes).length - 1;
  }

  ParsedNodeProcessor _subNp() => ParsedNodeProcessor(
      config: config, parent: this, parsedNodes: _parsedNodes);

  void _updateIndexEnd(int i) {
    _parsedNodeIndexEnd = i;
    parent?._updateIndexEnd(i);
  }
}
