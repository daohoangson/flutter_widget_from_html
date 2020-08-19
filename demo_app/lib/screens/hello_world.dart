import 'package:flutter/material.dart';

import '../html_widget.dart';

const kHtml = '''
<h3>Heading</h3>
<p>
  A paragraph with <strong>strong</strong>, <em>emphasized</em>
  and <span style="color: red">colored</span> text.
  With an inline <a href="https://flutter.dev">Flutter</a> logo,
  like this: <img src="https://github.com/daohoangson/flutter_widget_from_html/raw/master/demo_app/logos/android.png" style="width: 1em" />.
</p>

<ol>
  <li>List item number one</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>2.2</li>
    </ul>
  </li>
</ol>

<p>&lt;IFRAME&gt; of YouTube:</p>
<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw" width="560" height="315"></iframe>
<br />

<table border="1" cellpadding="8">
  <tr><td colspan="2">&lt;TABLE&gt; colspan=2</td></tr>
  <tr>
    <td rowspan="3">rowspan=3</td>
    <td>&lt;SUB&gt; C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub></td>
  </tr>
  <tr><td>&lt;SUP&gt; <var>a<sup>2</sup></var> + <var>b<sup>2</sup></var> = <var>c<sup>2</sup></var></td></tr>
  <tr><td>&lt;RUBY&gt; <ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby></td></tr>
  
</table>

''';

class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('HelloWorldScreen')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(kHtml),
          ),
        ),
      );
}
