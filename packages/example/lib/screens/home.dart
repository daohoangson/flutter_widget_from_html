import 'package:flutter/material.dart';

import 'compare.dart';
import 'hello_world.dart';
import 'hello_world_core.dart';
import 'iframe.dart';
import 'img.dart';
import 'smilie.dart';
import 'video.dart';

class HomeScreen extends StatelessWidget {
  final _htmls = {
    'Hello World (core)': () => HelloWorldCoreScreen(),
    'Hello World': () => HelloWorldScreen(),
    'Smilie': () => SmilieScreen(),
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
    'Alignments': """<div style="text-align: left">Left</div>
<div style="text-align: center">Center</div>
<div style="text-align: right">Right</div>
<div style="text-align: justify">${"J u s t i f y. " * 20}</div>
""",
    'Code': """PRE tag:

<pre>
// this may not show up with the correct monspace font on iOS because of a Flutter bug
// for more information, see https://github.com/flutter/flutter/issues/19280
&lt;?php
    highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;
</pre>

CODE tag:

<code><span style="color: #000000"><span style="color: #0000BB">&lt;?php phpinfo</span><span style="color: #007700">(); </span><span style="color: #0000BB">?&gt;</span></span></code>""",
    'Iframe': () => IframeScreen(),
    'Images': () => ImgScreen(),
    'Lists (LI/OL/UL)': """<ol type="I">
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
</ol>""",
    'Margin': """<div>No margin</div>
<div style="margin: 5px 10px">margin: 5px 10px</div>
<div style="margin: 3px">margin: 3px</div>
<div style="margin: 1px"><div style="margin: 2px">Margin within another</div></div>
""",
    'Table': """
<table border="1">
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
""",
    'Video': () => VideoScreen(),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Examples'),
        ),
        body: ListView.builder(
          itemBuilder: (context, i) {
            final key = _htmls.keys.toList()[i];
            final html = _htmls[key];
            return ListTile(
              title: Text(key),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => html is String
                          ? CompareScreen(html: html, title: key)
                          : (html as Function)(),
                    ),
                  ),
            );
          },
          itemCount: _htmls.length,
        ),
      );
}
