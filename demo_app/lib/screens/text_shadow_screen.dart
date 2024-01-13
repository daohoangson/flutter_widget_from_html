import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const _kHtml = '''
  <h3>text-shadow: 1px 1px 2px #FC0;</h3>
  <p style="text-shadow: 1px 1px 2px #FC0;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>

  <h3>text-shadow: #FC0 1px 0 10px;</h3>
  <p style="text-shadow: #FC0 1px 0 10px;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>

  <h3>text-shadow: 5px 5px #558ABB;</h3>
  <p style="text-shadow: 5px 5px #558ABB;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>

  <h3>text-shadow: red 2px 5px;</h3>
  <p style="text-shadow: red 2px 5px;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>

  <h3>text-shadow: 5px 10px;</h3>
  <p style="text-shadow: 5px 10px;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>

  <h3>text-shadow: 1px 1px 2px #558ABB, 0 0 1em #FC0, 0 0 0.2em #FC0;</h3>
  <p style="text-shadow:  1px 1px 2px #558ABB, 0 0 1em #FC0, 0 0 0.2em #FC0;">Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy called X ...</p>
''';

class TextShadowScreen extends StatefulWidget {
  const TextShadowScreen({super.key});

  @override
  State<TextShadowScreen> createState() => _TextShadowScreenState();
}

class _TextShadowScreenState extends State<TextShadowScreen> {
  final ValueNotifier<String> _customShadowInput = ValueNotifier<String>('');
  final TextEditingController _textEditingController = TextEditingController();

  String _buildCustomShadowHtml(String customShadow) {
    return '<p style="text-shadow: $customShadow; font-size: 16px">Custom text: Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy ...</p>';
  }

  @override
  void initState() {
    super.initState();
    _customShadowInput.value = _buildCustomShadowHtml('');
    _textEditingController.addListener(() {
      _customShadowInput.value = _buildCustomShadowHtml(
        _textEditingController.text,
      );
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Try custom shadow',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Custom shadow',
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: _customShadowInput,
                builder: (context, newValue, child) {
                  return HtmlWidget(newValue);
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Example',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: SingleChildScrollView(
                  child: HtmlWidget(_kHtml),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
