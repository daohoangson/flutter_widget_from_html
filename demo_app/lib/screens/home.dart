import 'package:flutter/material.dart';

import 'compare.dart';
import 'custom_styles_builder.dart';
import 'custom_widget_builder.dart';
import 'font_size.dart';
import 'hello_world.dart';
import 'hello_world_core.dart';
import 'iframe.dart';
import 'iframe_twitter.dart';
import 'img.dart';
import 'smilie.dart';
import 'video.dart';
import 'wordpress.dart';

class HomeScreen extends StatelessWidget {
  static final _htmls = {
    'Hello World': () => HelloWorldScreen(),
    'Hello World (core)': () => HelloWorldCoreScreen(),
    'Alignments': """<div style="text-align: left">Left</div>
<div style="text-align: center">Center</div>
<div style="text-align: right">Right</div>
<div style="text-align: justify">${"J u s t i f y. " * 20}</div>
""",
    'Code': """PRE tag:

<pre>
&lt;?php
    highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;
</pre>

CODE tag:

<code><span style="color: #000000"><span style="color: #0000BB">&lt;?php phpinfo</span><span style="color: #007700">(); </span><span style="color: #0000BB">?&gt;</span></span></code>""",
    'Iframe': () => IframeScreen(),
    'Iframe/Twitter': () => IframeTwitterScreen(),
    'Images': () => ImgScreen(),
    'Lists': '''<ol type="I">
  <li>One</li>
  <li>
    Two
    <ol reversed type="A">
      <li>2.C (reversed)</li>
      <li>
        2.B
        <ol start="5">
          <li>2.B.5 (start="5")</li>
          <li>2.B.6</li>
          <li>2.B.7</li>
        </ol>
      </li>
      <li>2.A</li>
    </ol>
  </li>
  <li>Three</li>
  <li><ul><li>3.1</li></ul></li>
  <li>
    Four<br />
    <a href="https://gph.is/QFgPA0"><img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" /></a>
  </li>
  <li>Five</li>
  <li>Six</li>
  <li>Seven</li>
  <li>Eight</li>
  <li>Nine</li>
  <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh quam, sodales in sollicitudin ut, scelerisque non sapien. Nam nec mi malesuada libero euismod tincidunt sit amet mattis ipsum. Etiam dapibus sem ac accumsan elementum. Vivamus mattis at diam ac pellentesque. Sed id eros condimentum, dignissim risus id, semper enim. Etiam tempor mauris id lorem fringilla, dapibus feugiat enim placerat. In hac habitasse platea dictumst. Nam est felis, accumsan et sapien ac, molestie convallis sapien. Vivamus ligula sapien, ultrices quis nisl ac, blandit hendrerit massa. Maecenas eleifend, nisi eget commodo mollis, elit magna pellentesque odio, sit amet auctor quam nibh vel purus. Integer ultricies lacinia ipsum, in tincidunt erat finibus eget.</li>
</ol>''',
    'Margin': '''<div>No margin</div>
<div style="margin: 5px 10px">margin: 5px 10px</div>
<div style="margin: 3px">margin: 3px</div>
<div style="margin: 1px"><div style="margin: 2px">Margin within another</div></div>
''',
    'SVG': '''
<a href="https://raw.githubusercontent.com/dnfield/flutter_svg/master/example/assets/flutter_logo.svg">flutter_logo.svg</a>:<br />
<br />
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 166 202">
    <defs>
        <linearGradient id="triangleGradient">
            <stop offset="20%" stop-color="#000000" stop-opacity=".55" />
            <stop offset="85%" stop-color="#616161" stop-opacity=".01" />
        </linearGradient>
        <linearGradient id="rectangleGradient" x1="0%" x2="0%" y1="0%" y2="100%">
            <stop offset="20%" stop-color="#000000" stop-opacity=".15" />
            <stop offset="85%" stop-color="#616161" stop-opacity=".01" />
        </linearGradient>
    </defs>
    <path fill="#42A5F5" fill-opacity=".8" d="M37.7 128.9 9.8 101 100.4 10.4 156.2 10.4"/>
    <path fill="#42A5F5" fill-opacity=".8" d="M156.2 94 100.4 94 79.5 114.9 107.4 142.8"/>
    <path fill="#0D47A1" d="M79.5 170.7 100.4 191.6 156.2 191.6 156.2 191.6 107.4 142.8"/>
    <g transform="matrix(0.7071, -0.7071, 0.7071, 0.7071, -77.667, 98.057)">
        <rect width="39.4" height="39.4" x="59.8" y="123.1" fill="#42A5F5" />
        <rect width="39.4" height="5.5" x="59.8" y="162.5" fill="url(#rectangleGradient)" />
    </g>
    <path d="M79.5 170.7 120.9 156.4 107.4 142.8" fill="url(#triangleGradient)" />
</svg>
''',
    'Styling': """
<p><abbr>ABBR</abbr>, <acronym>ACRONYM</acronym> or <span style="border-bottom: 1px dotted">inline style</span></p>
<p><b>B</b>, <strong>STRONG</strong> or <span style="font-weight: bold">inline style</span></p>
<p><em>EM</em>, <i>I</i> or <span style="font-style: italic">inline style</span></p>
<p><u>U</u> or <span style="text-decoration: underline">inline</span> <span style="border-bottom: 1px">style</span></p>
<p><span style="color: #ff0000">Red</span>, <span style="color: #00ff00">green</span>, <span style="color: #0000ff">blue</span></p>

<p>
  <span style="text-decoration: line-through">
    <span style="text-decoration: overline">
      <span style="text-decoration: underline">
        All decorations...
        <span style="text-decoration: none">and none</span>
      </span>
    </span>
  </span>
</p>

<!-- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub -->
<p>Almost every developer's favorite molecule is
C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>, also known as "caffeine."</p>

<!-- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup -->
<p>The <b>Pythagorean theorem</b> is often expressed as the following equation:</p>
<p><var>a<sup>2</sup></var> + <var>b<sup>2</sup></var> = <var>c<sup>2</sup></var></p>

<!-- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby -->
<ruby style="font-size: 2em">
明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp>
</ruby>
""",
    'Table': '''
<table border="1" cellpadding="4">
  <caption>Source: <a href="https://www.w3schools.com/html/html_tables.asp">w3schools</a></caption>
  <tr>
    <th>Firstname</th>
    <th>Lastname</th> 
    <th>Age</th>
  </tr>
  <tr>
    <td>Jill</td>
    <td>Smith</td> 
    <td>50</td>
  </tr>
  <tr>
    <td>Eve</td>
    <td>Jackson</td> 
    <td>94</td>
  </tr>
</table>

<br />

<table border="1" cellpadding="4">
  <caption>colspan (<a href="https://www.w3schools.com/tags/att_td_colspan.asp">w3schools</a>)</caption>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>\$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>\$80</td>
  </tr>
  <tr>
    <td colspan="2">Sum: \$180</td>
  </tr>
</table>

<br />

<table border="1" cellpadding="4">
  <caption>rowspan (<a href="https://www.w3schools.com/tags/att_td_colspan.asp">w3schools</a>)</caption>
  <tr>
    <th>Month</th>
    <th>Savings</th>
    <th>Savings for holiday!</th>
  </tr>
  <tr>
    <td>January</td>
    <td>\$100</td>
    <td rowspan="2">\$50</td>
  </tr>
  <tr>
    <td>February</td>
    <td>\$80</td>
  </tr>
</table>
''',
    'Video': () => VideoScreen(),
    'customStylesBuilder': () => CustomStylesBuilderScreen(),
    'customWidgetBuilder': () => CustomWidgetBuilderScreen(),
    'font-size': () => FontSizeScreen(),
    'Smilie': () => SmilieScreen(),
    'Wordpress': () => WordpressScreen(),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Demo app')),
        body: ListView(
          children: _htmls.keys
              .map((title) => ListTile(
                    title: Text(title),
                    onTap: () => Navigator.pushNamed(
                        context, _routeNameFromTitle(title)),
                  ))
              .toList(growable: false),
        ),
      );

  static Route onGenerateRoute(RouteSettings route) {
    for (final title in _htmls.keys) {
      if (_routeNameFromTitle(title) != route.name) continue;

      final value = _htmls[title];
      if (value is String) {
        return MaterialPageRoute(
          builder: (_) => CompareScreen(html: value, title: title),
          settings: RouteSettings(name: route.name),
        );
      } else if (value is Function) {
        return MaterialPageRoute(
          builder: (_) => value(),
          settings: RouteSettings(name: route.name),
        );
      }
    }

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => HomeScreen(),
      settings: RouteSettings(name: '/'),
    );
  }

  static String _routeNameFromTitle(String title) =>
      '/' + title.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
}
