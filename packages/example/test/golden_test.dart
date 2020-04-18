import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    as extended;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:golden_toolkit/golden_toolkit.dart';

// https://lipsum.com/feed/html
const lipsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
    'Ut non elementum quam. Suspendisse odio diam, maximus pellentesque nunc a, pulvinar facilisis erat. '
    'Vivamus a viverra sem. Vivamus vehicula nibh mi, quis ornare orci laoreet vitae. '
    'Maecenas sagittis rutrum nisl nec dignissim. Suspendisse cursus est ut ultrices volutpat. '
    'Cras vel vestibulum arcu. Curabitur eget molestie nunc. Quisque fringilla quam vitae rhoncus lacinia. '
    'Vivamus id laoreet metus. Etiam sed mollis tellus. Vivamus facilisis faucibus libero eu interdum. '
    'Pellentesque laoreet magna porta viverra faucibus.';

const redX = '<span style="background-color:#f00;font-size:0.75em;">x</span>';

class _TestApp extends StatelessWidget {
  final String html;
  final bool withExtended;

  const _TestApp(this.html, {Key key, this.withExtended}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(html),
      Divider(),
      core.HtmlWidget(html),
    ];

    if (withExtended) {
      children.addAll(<Widget>[
        Divider(),
        extended.HtmlWidget(html),
      ]);
    }

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: children,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
      theme: ThemeData.light(),
    );
  }
}

void _test(String name, String html) => testGoldens(name, (tester) async {
      await tester.pumpWidget(_TestApp(
        html,
        withExtended: _withExtendedRegExp.hasMatch(name),
      ));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('./images/$name.png'),
      );
    });

final _withExtendedRegExp = RegExp(r'(colspan|rowspan)');

void main() {
  ({
    'ABBR': '<abbr>ABBR</abbr>',
    'ACRONYM': '<acronym>ACRONYM</acronym>',
    'ADDRESS': 'This is an <address>ADDRESS</address>',
    'BR': '1<br />2',
    'DD,DT,DD': '<dl><dt>Foo</dt><dd>Bar</dd></dt>',
    'HR': '<hr/>',
    'Q': 'Someone said <q>Foo</q>.',
    'RUBY,RP,RT': '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>',
    'ARTICLE': '<article>First.</article><article>Second one.</article>',
    'ASIDE': '<aside>First.</aside><aside>Second one.</aside>',
    'BLOCKQUOTE': '<blockquote>Foo</blockquote>',
    'DIV': '<div>First.</div><div>Second one.</div>',
    'FIGURE,FIGCAPTION':
        '<figure><figcaption><i>fig. 1</i> Foo</figcaption></figure>',
    'HEADER,FOOTER': '<header>First.</header><footer>Second one.</footer>',
    'MAIN,NAV': '<main>First.</main><nav>Second one.</nav>',
    'P': '<p>First.</p><p>Second one.</p>',
    'SECTION': '<section>First.</section><section>Second one.</section>',
    'IFRAME': '<iframe src="iframe.html">Something</iframe>Bye iframe.',
    'SCRIPT': '<script>foo = bar</script>Bye script.',
    'STYLE': '<style>body { background: #fff; }</style>Bye style.',
    'CODE':
        """<code><span style="color: #000000"><span style="color: #0000BB">&lt;?php phpinfo</span><span style="color: #007700">(); </span><span style="color: #0000BB">?&gt;</span></span></code>""",
    'KBD': '<kbd>ESC</kbd> = exit',
    'PRE': """<pre>&lt;?php
highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;</pre>""",
    'SAMP': '<samp>Disk fault</samp>',
    'TT': '<tt>Teletype</tt>',
    'H1,H2,H3,H4,H5,H6': """
<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
""",
    'MARK': '<mark>Foo</mark>',
    'inline/background-color/block':
        '<div style="background-color: #f00"><div>Foo</div></div>',
    'inline/background-color/inline':
        'Foo <span style="background-color: #f00">bar</span>',
    'inline/border/border-top': '<span style="border-top: 1px">Foo</span>',
    'inline/border/border-bottom':
        '<span style="border-bottom: 1px">Foo</span>',
    'inline/border/dashed': '<span style="border-top: 1px dashed">Foo</span>',
    'inline/border/dotted': '<span style="border-top: 1px dotted">Foo</span>',
    'inline/border/double':
        '<span style="border-bottom: 1px double">Foo</span>',
    'inline/border/solid': '<span style="border-bottom: 1px solid">Foo</span>',
    'inline/color': """
<span style="color: #F00">red</span>
<span style="color: #0F08">red 53%</span>
<span style="color: #00FF00">green</span>
<span style="color: #00FF0080">green 50%</span>
""",
    'inline/display/span': '<div>1 <span>2</span></div>',
    'inline/display/block':
        '<div>1 <span style="display: block">2</span></div>',
    'inline/display/div': '<div>1 <div>2</div></div>',
    'inline/display/inline':
        '<div>1 <div style="display: inline">2</div></div>',
    'inline/display/inline-block':
        '<div>1 <div style="display: inline-block">2</div></div>',
    'inline/display/none': '<div>1 <div style="display: none">2</div></div>',
    'FONT/color': '<font color="#F00">Foo</font>',
    'FONT/face': '<font face="Monospace">Foo</font>',
    'FONT/size': """
<font size="7">Size 7</font>
<font size="6">Size 6</font>
<font size="5">Size 5</font>
<font size="4">Size 4</font>
<font size="3">Size 3</font>
<font size="2">Size 2</font>
<font size="1">Size 1</font>
""",
    'inline/font-family': '<span style="font-family: Monospace">Foo</span>',
    'BIG': '<big>Foo</big>',
    'SMALL': '<small>Foo</small>',
    'inline/font-size': """
<span style="font-size: 100px">100px</span>
<span style="font-size: xx-large">xx-large</span>
<span style="font-size: x-large">x-large</span>
<span style="font-size: large">large</span>
<span style="font-size: medium">medium</span>
<span style="font-size: small">small</span>
<span style="font-size: x-small">x-small</span>
<span style="font-size: xx-small">xx-small</span>
<span style="font-size: larger">larger</span>
<span style="font-size: smaller">smaller</span>
<span style="font-size: 2em">2em</span>
""",
    'CITE': 'This is a <cite>citation</cite>.',
    'DFN': 'This is a <dfn>definition</dfn>.',
    'I': 'This is an <i>italic</i> text.',
    'EM': 'This is an <em>emphasized</em> text.',
    'VAR': '<var>x</var> = 1',
    'inline/font-style/italic':
        '<span style="font-style: italic">Italic text</span>',
    'B': 'This is a <b>bold</b> text.',
    'STRONG': 'This is a <strong>strong</strong> text.',
    'inline/font-weight': """
<span style="font-weight: bold">bold</span>
<span style="font-weight: 100">one</span>
<span style="font-weight: 200">two</span>
<span style="font-weight: 300">three</span>
<span style="font-weight: 400">four</span>
<span style="font-weight: 500">five</span>
<span style="font-weight: 600">six</span>
<span style="font-weight: 700">seven</span>
<span style="font-weight: 800">eight</span>
<span style="font-weight: 900">nine</span>
""",
    'DEL': 'This is some <del>deleted</del> text.',
    'INS': 'This is some <ins>inserted</ins> text.',
    'S,STRIKE': '<s>Foo</s> <strike>bar</strike>',
    'U': 'This is an <u>underline</u> text.',
    'inline/text-decoration/line-through':
        '<span style="text-decoration: line-through">line</span>',
    'inline/text-decoration/overline':
        '<span style="text-decoration: overline">over</span>',
    'inline/text-decoration/underline':
        '<span style="text-decoration: underline">under</span>',
    'inline/text-decoration/none': """
<span style="text-decoration: line-through">
<span style="text-decoration: overline">
<span style="text-decoration: underline">
foo <span style="text-decoration: none">bar</span></span></span></span>
""",
    'inline/margin/4_values': """
----
<div style="margin: 1px 2px 3px 4px">all</div>
----
<div style="margin: 1px 0 0 0">top only</div>
----
<div style="margin: 0 2px 0 0">right only</div>
----
<div style="margin: 0 0 3px 0">bottom only</div>
----
<div style="margin: 0 0 3px 0">left only</div>
---
""",
    'inline/margin/2_values': """
----
<div style="margin: 5px 10px">both</div>
----
<div style="margin: 5px 0">vertical only</div>
----
<div style="margin: 0 10px">horizontal only</div>
----
""",
    'inline/margin/1_value': '----<div style="margin: 3px">Foo</div>----',
    'inline/margin/margin-top':
        '----<div style="margin-top: 3px">Foo</div>----',
    'inline/margin/margin-right':
        '----<div style="margin-right: 3px">Foo</div>----',
    'inline/margin/margin-bottom':
        '----<div style="margin-top: 3px">Foo</div>----',
    'inline/margin/margin-left':
        '----<div style="margin-left: 3px">Foo</div>----',
    'inline/padding/4_values': """
----
<div style="padding: 1px 2px 3px 4px">all</div>
----
<div style="padding: 1px 0 0 0">top only</div>
----
<div style="padding: 0 2px 0 0">right only</div>
----
<div style="padding: 0 0 3px 0">bottom only</div>
----
<div style="padding: 0 0 3px 0">left only</div>
---
""",
    'inline/padding/2_values': """
----
<div style="padding: 5px 10px">both</div>
----
<div style="padding: 5px 0">vertical only</div>
----
<div style="padding: 0 10px">horizontal only</div>
----
""",
    'inline/padding/1_value': '----<div style="padding: 3px">Foo</div>----',
    'inline/padding/padding-top':
        '----<div style="padding-top: 3px">Foo</div>----',
    'inline/padding/padding-right':
        '----<div style="padding-right: 3px">Foo</div>----',
    'inline/padding/padding-bottom':
        '----<div style="padding-top: 3px">Foo</div>----',
    'inline/padding/padding-left':
        '----<div style="padding-left: 3px">Foo</div>----',
    'CENTER': '<center>Foo</center>',
    'inline/text-align/center': '<div style="text-align: center">$lipsum</div>',
    'inline/text-align/justify':
        '<div style="text-align: justify">$lipsum</div>',
    'inline/text-align/left': '<div style="text-align: left">$lipsum</div>',
    'inline/text-align/right': '<div style="text-align: right">$lipsum</div>',
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub
    'SUB': '<p>Almost every developer\'s favorite molecule is '
        'C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>, also known as "caffeine."</p>',
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup
    'SUP': """
<p>The <b>Pythagorean theorem</b> is often expressed as the following equation:</p>
<p><var>a<sup>2</sup></var> + <var>b<sup>2</sup></var> = <var>c<sup>2</sup></var></p>
""",
    'inline/vertical-align/top':
        'Foo<span style="vertical-align: top">$redX</span>',
    'inline/vertical-align/bottom':
        'Foo<span style="vertical-align: bottom">$redX</span>',
    'inline/vertical-align/middle':
        'Foo<span style="vertical-align: middle">$redX</span>',
    'inline/vertical-align/sub':
        'Foo<span style="vertical-align: sub">$redX</span>',
    'inline/vertical-align/super':
        'Foo<span style="vertical-align: super">$redX</span>',
    'LI/OL': '<ol><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/UL': '<ul><li>One</li><li>Two</li><li>Three</li><ul>',
    'LI/nested': """
<ul>
  <li>One</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>
        2.2
        <ul>
          <li>2.2.1</li>
          <li>2.2.2</li>
        </ul>
      </li>
      <li>2.3</li>
    </ul>
  </li>
  <li>Three</li>
</ul>""",
    'LI/OL/reversed': '<ol reversed><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/reversed_start_99':
        '<ol reversed start="99"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/start_99':
        '<ol start="99"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/type_lower-alpha':
        '<ol type="a"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/type_upper-alpha':
        '<ol type="A"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/type_lower-roman':
        '<ol type="i"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/OL/type_upper-roman':
        '<ol type="I"><li>One</li><li>Two</li><li>Three</li><ol>',
    'LI/list-style-type/disc':
        '<ol style="list-style-type: disc"><li>Foo</li></ol>',
    'LI/list-style-type/circle':
        '<ul style="list-style-type: circle"><li>Foo</li></ul>',
    'LI/list-style-type/square':
        '<ul style="list-style-type: square"><li>Foo</li></ul>',
    'LI/padding-inline-start': """
<ul style="padding-inline-start: 99px">
  <li style="padding-inline-start: 199px">199px</li>
  <li style="padding-inline-start: 299px">299px</li>
  <li>99px</li>
<ul>
""",
    'LI/rtl':
        '<div dir="rtl"><ol><li>One</li><li>Two</li><li>Three</li><ol></div>',
    'TABLE/border_0': """
<table>
  <caption>Caption</caption>
  <tr><th>Header 1</th><th>Header 2</th></tr>
  <tr><td>Value 1</td><td>Value 2</td></tr>
</table>""",
    'TABLE/border_1': """
<table border="1">
  <caption>Caption</caption>
  <tr><th>Header 1</th><th>Header 2</th></tr>
  <tr><td>Value 1</td><td>Value 2</td></tr>
</table>""",
    'TABLE/display_table': """
<div style="display: table">
  <div style="display: table-caption; text-align: center">Caption</div>
  <div style="display: table-row; font-weight: bold">
    <span style="display: table-cell">Header 1</span>
    <span style="display: table-cell">Header 2</span>
  </div>
  <div style="display: table-row">
    <span style="display: table-cell">Value 1</span>
    <span style="display: table-cell">Value 2</span>
  </div>
</div>""",
    'TABLE/colspan': """
<table border="1">
  <caption>Source: <a href="https://www.w3schools.com/tags/att_td_colspan.asp">w3schools</a></caption>
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
</table>""",
    'TABLE/rowspan': """
<table border="1">
  <caption>Source: <a href="https://www.w3schools.com/tags/att_td_colspan.asp">w3schools</a></caption>
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
</table>""",
  }).entries.forEach((entry) => _test(entry.key, entry.value));
}
