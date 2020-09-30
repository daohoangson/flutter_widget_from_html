import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('issue324', (tester) async {
    await tester.pumpWidgetBuilder(
      Scaffold(
        appBar: AppBar(title: Text('Issue 324')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            '''<ul>
              <li>hello <span>汉字</span></li>
              <li>hello2</li>
              <li>hello3</li>
            </ul>
            <ol>
              <li>hello <span>汉字</span></li>
              <li>hello2</li>
              <li>hello3</li>
            </ol>''',
            factoryBuilder: () => _WidgetFactory(),
          ),
        ),
      ),
      wrapper: materialAppWrapper(theme: ThemeData.light()),
      surfaceSize: Size(400, 200),
    );

    await screenMatchesGolden(tester, 'others/issue324');
  });
}

class _WidgetFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'span') {
      // golden test cannot render East Asian characters
      // so we are replacing them with a big red box
      meta.register(BuildOp(
        onTree: (_, tree) => tree.replaceWith(WidgetBit.inline(
          tree,
          Container(color: Colors.red, height: 20, width: 20),
        )),
      ));
    }

    super.parse(meta);
  }
}
