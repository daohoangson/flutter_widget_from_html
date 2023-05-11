import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const html = '''
<h1>Introducing Flutter</h1>
<h3>Google Developers</h3>
<p>Get started at <a href="https://flutter.io">https://flutter.io</a> today.</p>

<p>Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/fq4N0hgOWzU"></iframe>

<h1>Filler text below</h1>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque nibh, interdum bibendum enim ut, varius pretium lacus. Sed ut hendrerit eros, blandit lacinia risus. Maecenas sit amet ullamcorper arcu, vitae bibendum eros. Morbi ipsum urna, elementum non dui eu, tristique hendrerit ipsum. Donec ullamcorper neque libero, eu fermentum purus ultrices ac. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam dictum justo vel urna viverra maximus.</p>
<p>Donec porttitor vulputate diam, eu accumsan diam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc egestas pellentesque molestie. Donec vitae vestibulum turpis. Mauris sodales lacus ac porttitor placerat. Nunc feugiat lorem et ultrices tincidunt. Nam vehicula efficitur leo eget dapibus. Sed id enim est.</p>
<p>Nam velit enim, elementum in egestas ac, faucibus non elit. Curabitur ac ultrices sem. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin mattis quis felis a maximus. Nulla diam ligula, tincidunt id viverra ut, consectetur eu odio. Quisque id nunc sed dui interdum tristique. Curabitur faucibus, lorem sit amet tempus porttitor, justo felis mollis justo, sit amet tempus massa nulla et mauris. Nulla viverra tortor sed velit malesuada, sed bibendum justo elementum. Quisque id nisl tristique, venenatis eros vitae, fermentum elit. Ut nec faucibus lacus. Proin nisl quam, ullamcorper id tellus at, mattis convallis orci. Maecenas viverra mollis ullamcorper. Donec tincidunt, elit id placerat consequat, nisi purus tincidunt erat, sed aliquet justo leo a felis.</p>
<p>Quisque sodales dui nec dictum bibendum. Aenean pellentesque efficitur elit, ut tincidunt leo laoreet ut. Aenean ac molestie dui, at fringilla mi. Vivamus mollis, ipsum ut suscipit molestie, augue nisl maximus lectus, id condimentum dui leo ac lectus. Donec arcu velit, pellentesque ut rutrum pharetra, convallis at ligula. Cras vel justo a nulla gravida porta. Sed vestibulum eget ipsum a scelerisque.</p>
<p>Ut venenatis et mauris at venenatis. Proin vitae lacus sagittis, ultrices lorem non, tincidunt enim. Mauris sit amet odio et sapien tristique sollicitudin vel ut nisl. Nulla mauris diam, commodo quis ex porta, ornare auctor eros. Aliquam egestas felis non libero sodales condimentum ac sed magna. Morbi vitae ante in ligula faucibus aliquam. Vivamus nec gravida odio. Duis pharetra diam a malesuada gravida. Curabitur sit amet tincidunt dui. In sagittis augue at nibh fringilla fringilla. Curabitur volutpat in leo id fringilla.</p>
''';

class IframeScreen extends StatefulWidget {
  const IframeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<IframeScreen> {
  bool webView = true;
  bool webViewJs = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('IframeScreen'),
        ),
        body: ListView(
          children: <Widget>[
            CheckboxListTile(
              value: webView,
              onChanged: (v) => setState(() => webView = v == true),
              title: const HtmlWidget('<var>.webView</var>'),
              subtitle: const Text('Renders web view, default ❌'),
            ),
            CheckboxListTile(
              value: webViewJs,
              onChanged: (v0) => setState(() {
                final v = v0 == true;
                if (v) {
                  webView = true;
                }
                webViewJs = v;
              }),
              title: const HtmlWidget('<var>.webViewJs</var>'),
              subtitle: const Text('Allows JavaScript execution, default ✅'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                html,
                factoryBuilder: () => _WidgetFactory(
                  webView: webView,
                  webViewJs: webViewJs,
                ),
                rebuildTriggers: RebuildTriggers([webView, webViewJs]),
              ),
            ),
          ],
        ),
      );
}

class _WidgetFactory extends WidgetFactory {
  @override
  final bool webView;

  @override
  final bool webViewJs;

  _WidgetFactory({
    required this.webView,
    required this.webViewJs,
  });
}
