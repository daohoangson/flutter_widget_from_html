import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = '''
<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
<p>A paragraph with <strong>strong</strong> <em>emphasized</em> text.</p>

<p>And of course, cat image:</p>
<figure>
  <img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" width="250" height="171" />
  <figcaption>Source: <a href="https://gph.is/QFgPA0">https://gph.is/QFgPA0</a></figcaption>
</figure>
''';

class HelloWorldCoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('HelloWorldCoreScreen')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              kHtml,
              onTapUrl: (url) => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('onTapUrl'),
                  content: Text(url),
                ),
              ),
            ),
          ),
        ),
      );
}
