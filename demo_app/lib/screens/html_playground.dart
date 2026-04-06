import 'package:demo_app/widgets/popup_menu.dart';
import 'package:demo_app/widgets/selection_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const _kInitialHtml = '''
<h1>Hello, HTML Playground!</h1>
<p>Edit the HTML on the <strong>left</strong> (or <em>top</em>) to see it rendered here.</p>
<ul>
  <li>Supports <strong>bold</strong> and <em>italic</em></li>
  <li>And <a href="https://flutter.dev">links</a></li>
</ul>''';

class HtmlPlaygroundScreen extends StatefulWidget {
  const HtmlPlaygroundScreen({super.key});

  @override
  State<HtmlPlaygroundScreen> createState() => _HtmlPlaygroundScreenState();
}

class _HtmlPlaygroundScreenState extends State<HtmlPlaygroundScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _kInitialHtml);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SelectionAreaScaffold(
    appBar: AppBar(
      title: const Text('HTML Playground'),
      actions: const [PopupMenu(toggleIsSelectable: true)],
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > constraints.maxHeight;

        final inputPane = _InputPane(controller: _controller);
        final previewPane = _PreviewPane(controller: _controller);

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: inputPane),
              const VerticalDivider(width: 1),
              Expanded(child: previewPane),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(child: inputPane),
              const Divider(height: 1),
              Expanded(child: previewPane),
            ],
          );
        }
      },
    ),
  );
}

class _InputPane extends StatelessWidget {
  final TextEditingController controller;

  const _InputPane({required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'HTML input',
        alignLabelWithHint: true,
      ),
    ),
  );
}

class _PreviewPane extends StatefulWidget {
  final TextEditingController controller;

  const _PreviewPane({required this.controller});

  @override
  State<_PreviewPane> createState() => _PreviewPaneState();
}

class _PreviewPaneState extends State<_PreviewPane> {
  late String _html;

  @override
  void initState() {
    super.initState();
    _html = widget.controller.text;
    widget.controller.addListener(_onHtmlChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onHtmlChanged);
    super.dispose();
  }

  void _onHtmlChanged() {
    setState(() => _html = widget.controller.text);
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(8),
    child: HtmlWidget(_html),
  );
}
