import 'package:flutter/material.dart';

import 'compare.dart';
import 'hello_world.dart';
import 'hello_world_core.dart';
import 'smilie.dart';

class HomeScreen extends StatelessWidget {
  final _htmls = {
    'Hello World (core)': '',
    'Hello World': '',
    'Smilie': '',
    'Styling':
        """<p><b>B</b>, <strong>strong</strong> or <span style="font-weight: bold">inline style</span></p>
<p><em>EM</em>, <i>I</i> or <span style="font-style: italic">inline style</span></p>
<p><u>U</u> or <span style="text-decoration: underline">inline style</span></p>
<p><span style="color: #ff0000">Red</span>, <span style="color: #00ff00">green</span>, <span style="color: #0000ff">blue</span></p>
""",
    'Alignments': """<div style="text-align: left">Left</div>
<div style="text-align: center">Center</div>
<div style="text-align: right">Right</div>
<div style="text-align: justify">${"J u s t i f y. " * 20}</div>
""",
    'List ordered': """<ol>
  <li>One</li>
  <li>Two</li>
  <li>Three</li>
</ol>""",
    'List unordered': """<ul>
  <li>One</li>
  <li>Two</li>
  <li>Three</li>
</ul>""",
    'List nested': """<ol>
  <li>One</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>2.2</li>
    </ul>
  </li>
  <li>Three</li>
  <li>
    <a href="https://gph.is/QFgPA0"><img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" /></a>
  </li>
  <li>Five</li>
  <li>Six</li>
  <li>Seven</li>
  <li>Eight</li>
  <li>Nine</li>
  <li>Ten</li>
  <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh quam, sodales in sollicitudin ut, scelerisque non sapien. Nam nec mi malesuada libero euismod tincidunt sit amet mattis ipsum. Etiam dapibus sem ac accumsan elementum. Vivamus mattis at diam ac pellentesque. Sed id eros condimentum, dignissim risus id, semper enim. Etiam tempor mauris id lorem fringilla, dapibus feugiat enim placerat. In hac habitasse platea dictumst. Nam est felis, accumsan et sapien ac, molestie convallis sapien. Vivamus ligula sapien, ultrices quis nisl ac, blandit hendrerit massa. Maecenas eleifend, nisi eget commodo mollis, elit magna pellentesque odio, sit amet auctor quam nibh vel purus. Integer ultricies lacinia ipsum, in tincidunt erat finibus eget.</li>
</ol>""",
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
                        builder: (context) => key == 'Hello World (core)'
                            ? HelloWorldCoreScreen()
                            : key == 'Hello World'
                                ? HelloWorldScreen()
                                : key == 'Smilie'
                                    ? SmilieScreen()
                                    : CompareScreen(
                                        html: html,
                                        title: key,
                                      )),
                  ),
            );
          },
          itemCount: _htmls.length,
        ),
      );
}
