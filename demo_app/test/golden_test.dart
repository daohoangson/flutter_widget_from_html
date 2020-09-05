import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    as enhanced;
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

final _withEnhancedRegExp = RegExp(r'(^(A|HR)$|colspan|rowspan)');

class _TestApp extends StatelessWidget {
  final String html;
  final Key targetKey;
  final bool withEnhanced;

  const _TestApp(
    this.html, {
    Key key,
    this.targetKey,
    this.withEnhanced,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(html),
      Divider(),
      if (withEnhanced)
        Text(
          'flutter_widget_from_html_core:\n',
          style: Theme.of(context).textTheme.caption,
        ),
      LimitedBox(
        child: core.HtmlWidget(html),
        maxHeight: 400,
      ),
    ];

    if (withEnhanced) {
      children.addAll(<Widget>[
        Divider(),
        Text(
          'flutter_widget_from_html:\n',
          style: Theme.of(context).textTheme.caption,
        ),
        LimitedBox(
          child: enhanced.HtmlWidget(html),
          maxHeight: 400,
        ),
      ]);
    }

    return SingleChildScrollView(
      child: RepaintBoundary(
        child: Container(
          child: Padding(
            child: Column(
              children: children,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
            ),
            padding: const EdgeInsets.all(10),
          ),
          color: Colors.white,
        ),
        key: targetKey,
      ),
    );
  }
}

String _paddingTest(String style, String text) =>
    '<div style="background: red; $style">'
    '<div style="background: black; color: white">$text</div>'
    '</div>';

void _test(String name, String html) => testGoldens(name, (tester) async {
      final key = UniqueKey();

      await tester.pumpWidgetBuilder(
        _TestApp(
          html,
          targetKey: key,
          withEnhanced: _withEnhancedRegExp.hasMatch(name),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: Size(400, 1200),
      );

      await screenMatchesGolden(tester, name, finder: find.byKey(key));
    });

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
    'RUBY/colored_rt':
        '<ruby>x <rt>l<span style="color: red">oooo</span>ng</rt></ruby>',
    'RUBY/colored_ruby':
        '<ruby>l<span style="color: red">oooo</span>ng <rt>x</rt></ruby>',
    'RUBY/long_rt': '<ruby>x <rt>loooong</rt></ruby>',
    'RUBY/long_ruby': '<ruby>loooong <rt>x</rt></ruby>',
    'ARTICLE': '<article>First.</article><article>Second one.</article>',
    'ASIDE': '<aside>First.</aside><aside>Second one.</aside>',
    'BLOCKQUOTE': '<blockquote>Foo</blockquote>',
    'DIV': '<div>First.</div><div>Second one.</div>',
    'FIGURE,FIGCAPTION': '''<figure>
  <img src="asset:logos/android.png" width="192" height="192" />
  <figcaption><i>fig. 1</i> Flutter logo (Android version)</figcaption>
</figure>''',
    'HEADER,FOOTER': '<header>First.</header><footer>Second one.</footer>',
    'MAIN,NAV': '<main>First.</main><nav>Second one.</nav>',
    'P': '<p>First.</p><p>Second one.</p>',
    'SECTION': '<section>First.</section><section>Second one.</section>',
    'IFRAME': '<iframe src="iframe.html">Something</iframe>Bye iframe.',
    'SCRIPT': '<script>foo = bar</script>Bye script.',
    'STYLE': '<style>body { background: #fff; }</style>Bye style.',
    'CODE':
        '<code><span style="color: #000000"><span style="color: #0000BB">&lt;?php phpinfo</span><span style="color: #007700">(); </span><span style="color: #0000BB">?&gt;</span></span></code>',
    'KBD': '<kbd>ESC</kbd> = exit',
    'PRE': """<pre>&lt;?php
  highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;</pre>""",
    'SAMP': '<samp>Disk fault</samp>',
    'TT': '<tt>Teletype</tt>',
    'H1': '<h1>Heading 1</h1>',
    'H2': '<h2>Heading 2</h2>',
    'H3': '<h3>Heading 3</h3>',
    'H4': '<h4>Heading 4</h4>',
    'H5': '<h5>Heading 5</h5>',
    'H6': '<h6>Heading 6</h6>',
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
    'inline/color': '''
<span style="color: #F00">red</span>
<span style="color: #0F08">red 53%</span>
<span style="color: #00FF00">green</span>
<span style="color: #00FF0080">green 50%</span>
''',
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
    'FONT/face': '<font face="Courier">Foo</font>',
    'FONT/size': '''
<font size="7">Size 7</font>
<font size="6">Size 6</font>
<font size="5">Size 5</font>
<font size="4">Size 4</font>
<font size="3">Size 3</font>
<font size="2">Size 2</font>
<font size="1">Size 1</font>
''',
    'inline/font-family': '<span style="font-family: Courier">Foo</span>',
    'BIG': '<big>Foo</big>',
    'SMALL': '<small>Foo</small>',
    'inline/font-size': '''
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
''',
    'CITE': 'This is a <cite>citation</cite>.',
    'DFN': 'This is a <dfn>definition</dfn>.',
    'I': 'This is an <i>italic</i> text.',
    'EM': 'This is an <em>emphasized</em> text.',
    'VAR': '<var>x</var> = 1',
    'inline/font-style/italic':
        '<span style="font-style: italic">Italic text</span>',
    'B': 'This is a <b>bold</b> text.',
    'STRONG': 'This is a <strong>strong</strong> text.',
    'inline/font-weight': '''
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
''',
    'inline/line-height': '''
<p>Normal</p>
<p style="line-height: 1.5">Line height x1.5</p>
<p>Normal</p>
<p style="line-height: 300%">Line height x3</p>
<p>Normal</p>
''',
    'DEL': 'This is some <del>deleted</del> text.',
    'INS': 'This is some <ins>inserted</ins> text.',
    'S': '<s>Foo</s>',
    'STRIKE': '<strike>Foo</strike>',
    'U': 'This is an <u>underline</u> text.',
    'inline/text-decoration/line-through':
        '<span style="text-decoration: line-through">line</span>',
    'inline/text-decoration/overline':
        '<span style="text-decoration: overline">over</span>',
    'inline/text-decoration/underline':
        '<span style="text-decoration: underline">under</span>',
    'inline/text-decoration/none': '''
<span style="text-decoration: line-through">
<span style="text-decoration: overline">
<span style="text-decoration: underline">
foo <span style="text-decoration: none">bar</span></span></span></span>
''',
    'inline/text-overflow/ellipsis':
        '<div style="max-lines: 2; text-overflow: ellipsis">${"hello world " * 50}</div>',
    'inline/margin/4_values': '''
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
''',
    'inline/margin/2_values': '''
----
<div style="margin: 5px 10px">both</div>
----
<div style="margin: 5px 0">vertical only</div>
----
<div style="margin: 0 10px">horizontal only</div>
----
''',
    'inline/margin/1_value': '----<div style="margin: 3px">Foo</div>----',
    'inline/margin/margin-top':
        '----<div style="margin-top: 3px">Foo</div>----',
    'inline/margin/margin-right':
        '----<div style="margin-right: 3px">Foo</div>----',
    'inline/margin/margin-bottom':
        '----<div style="margin-top: 3px">Foo</div>----',
    'inline/margin/margin-left':
        '----<div style="margin-left: 3px">Foo</div>----',
    'inline/padding/4_values': '''
----
${_paddingTest('padding: 5px 10px 15px 20px', 'all')}
----
${_paddingTest('padding: 5px 0 0 0', 'top only')}
----
${_paddingTest('padding: 0 10px 0 0', 'right only')}
----
${_paddingTest('padding: 0 0 15px 0', 'bottom only')}
----
${_paddingTest('padding: 0 0 0 20px', 'left only')}
----
''',
    'inline/padding/2_values': '''
----
${_paddingTest('padding: 5px 10px', 'both')}
----
${_paddingTest('padding: 5px 0', 'vertical only')}
----
${_paddingTest('padding: 0 10px', 'horizontal only')}
----
''',
    'inline/padding/1_value': '----${_paddingTest('padding: 5px', 'Foo')}----',
    'inline/padding/padding-top':
        '----${_paddingTest('padding-top: 5px', 'Foo')}----',
    'inline/padding/padding-right':
        '----${_paddingTest('padding-right: 5px', 'Foo')}----',
    'inline/padding/padding-bottom':
        '----${_paddingTest('padding-bottom: 5px', 'Foo')}----',
    'inline/padding/padding-left':
        '----${_paddingTest('padding-left: 5px', 'Foo')}----',
    'inline/sizing/height':
        '<div style="background-color: red; height: 100px">Foo</div>',
    'inline/sizing/height/huge':
        '<div style="background-color: red; height: 10000px">Foo</div>',
    'inline/sizing/height_and_width':
        '<div style="background-color: red; height: 100px; width: 100px">Foo</div>',
    'inline/sizing/height_and_width/max-height':
        '<div style="background-color: red; max-height: 50px; height: 100px; width: 100px">Foo</div>',
    'inline/sizing/height_and_width/max-width':
        '<div style="background-color: red; max-width: 50px; height: 100px; width: 100px">Foo</div>',
    'inline/sizing/height_and_width/min-height':
        '<div style="background-color: red; min-height: 200px; height: 100px; width: 100px">Foo</div>',
    'inline/sizing/height_and_width/min-width':
        '<div style="background-color: red; min-width: 200px; height: 100px; width: 100px">Foo</div>',
    'inline/sizing/height_and_width/huge_height':
        '<div style="background-color: red; height: 10000px; width: 1000px">Foo</div>',
    'inline/sizing/height_and_width/huge_width':
        '<div style="background-color: red; height: 1000px; width: 10000px">Foo</div>',
    'inline/sizing/max-height':
        '<div style="background-color: red; max-height: 10px">Foo</div>',
    'inline/sizing/max-width':
        '<div style="background-color: red; max-width: 10px">Foo</div>',
    'inline/sizing/max-height_and_max-width':
        '<div style="background-color: red; max-height: 10px; max-width: 10px">Foo</div>',
    'inline/sizing/min-height':
        '<div style="background-color: red; min-height: 200px">Foo</div>',
    'inline/sizing/min-height/huge':
        '<div style="background-color: red; min-height: 10000px">Foo</div>',
    'inline/sizing/min-width':
        '<div style="background-color: red; min-width: 200px">Foo</div>',
    'inline/sizing/min-width/huge':
        '<div style="background-color: red; min-width: 10000px">Foo</div>',
    'inline/sizing/min-height_and_min-width':
        '<div style="background-color: red; min-height: 200px; min-width: 200px">Foo</div>',
    'inline/sizing/width':
        '<div style="background-color: red; width: 100px">Foo</div>',
    'inline/sizing/width/huge':
        '<div style="background-color: red; width: 10000px">Foo</div>',
    'inline/sizing/complicated_box': '''
<div style="background-color: red; color: white; padding: 20px;">
  <div style="background-color: green;">
    <div style="background-color: blue; height: 100px; margin: 15px; padding: 5px; width: 100px;">
      Foo
    </div>
  </div>
</div>
''',
    'CENTER': '<center>Foo</center>',
    'attribute/align/center': '<div align="center">$lipsum</div>',
    'attribute/align/left': '<div align="left">$lipsum</div>',
    'attribute/align/right': '<div align="right">$lipsum</div>',
    'inline/text-align/center': '<div style="text-align: center">$lipsum</div>',
    'inline/text-align/end': '<div style="text-align: end">$lipsum</div>',
    'inline/text-align/end/rtl':
        '<div dir="rtl"><div style="text-align: end">$lipsum</div></div>',
    'inline/text-align/img/center_inline':
        '<div style="text-align: center">Foo <img src="asset:images/100x10.png" /> bar</div>',
    'inline/text-align/img/center_block':
        '<div style="text-align: center">Foo <img src="asset:images/100x10.png" style="display: block" /> bar</div>',
    'inline/text-align/img/center_tag_inline':
        '<center>Foo <img src="asset:images/100x10.png" /> bar</center>',
    'inline/text-align/img/center_tag_block':
        '<center>Foo <img src="asset:images/100x10.png" style="display: block" /> bar</center>',
    'inline/text-align/img/left_inline':
        '<div style="text-align: left">Foo <img src="asset:images/100x10.png" /> bar</div>',
    'inline/text-align/img/left_block':
        '<div style="text-align: left">Foo <img src="asset:images/100x10.png" style="display: block" /> bar</div>',
    'inline/text-align/img/right_inline':
        '<div style="text-align: right">Foo <img src="asset:images/100x10.png" /> bar</div>',
    'inline/text-align/img/right_block':
        '<div style="text-align: right">Foo <img src="asset:images/100x10.png" style="display: block" /> bar</div>',
    'inline/text-align/justify':
        '<div style="text-align: justify">$lipsum</div>',
    'inline/text-align/left': '<div style="text-align: left">$lipsum</div>',
    'inline/text-align/-moz-center':
        '<div style="text-align: -moz-center">$lipsum</div>',
    'inline/text-align/right': '<div style="text-align: right">$lipsum</div>',
    'inline/text-align/start': '<div style="text-align: start">$lipsum</div>',
    'inline/text-align/start/rtl':
        '<div dir="rtl"><div style="text-align: start">$lipsum</div></div>',
    'inline/text-align/-webkit-center':
        '<div style="text-align: -webkit-center">$lipsum</div>',
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub
    'SUB': '<p>Almost every developer\'s favorite molecule is '
        'C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>, also known as "caffeine."</p>',
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup
    'SUP': '''
<p>The <b>Pythagorean theorem</b> is often expressed as the following equation:</p>
<p><var>a<sup>2</sup></var> + <var>b<sup>2</sup></var> = <var>c<sup>2</sup></var></p>
''',
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
    'A': '<a href="https://flutter.dev">Flutter</a>',
    'IMG':
        'Flutter <img src="asset:logos/android.png" width="12" height="12" /> is awesome.',
    'IMG/inline_big': 'Foo <img src="asset:images/2000x200.png" /> bar.',
    'IMG/inline_big_dimensions':
        'Foo <img src="asset:images/2000x200.png" width="2000" height="200" /> bar.',
    'IMG/inline_height_only':
        'Foo <img src="asset:images/100x10.png" height="5" /> bar.',
    'IMG/inline_small': 'Foo <img src="asset:images/100x10.png" /> bar.',
    'IMG/inline_small_dimensions':
        'Foo <img src="asset:images/100x10.png" width="100" height="10" /> bar.',
    'IMG/inline_width_only':
        'Foo <img src="asset:images/100x10.png" width="50" /> bar.',
    'IMG/block_big':
        'Foo <img src="asset:images/2000x200.png" style="display: block" /> bar.',
    'IMG/block_big_dimensions':
        'Foo <img src="asset:images/2000x200.png" width="2000" height="200" style="display: block" /> bar.',
    'IMG/block_height_only':
        'Foo <img src="asset:images/100x10.png" height="5" style="display: block" /> bar.',
    'IMG/block_small':
        'Foo <img src="asset:images/100x10.png" style="display: block" /> bar.',
    'IMG/block_small_dimensions':
        'Foo <img src="asset:images/100x10.png" width="100" height="10" style="display: block" /> bar.',
    'IMG/block_width_only':
        'Foo <img src="asset:images/100x10.png" width="50" style="display: block" /> bar.',
    'LI,OL': '''
<ol>
  <li>One</li>
  <li>Two</li>
  <li>Three</li>
</ol>''',
    'OL/reversed': '<ol reversed><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/reversed_start':
        '<ol reversed start="99"><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/start': '<ol start="99"><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/type/lower-alpha':
        '<ol type="a"><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/type/upper-alpha':
        '<ol type="A"><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/type/lower-roman':
        '<ol type="i"><li>One</li><li>Two</li><li>Three</li><ol>',
    'OL/type/upper-roman':
        '<ol type="I"><li>One</li><li>Two</li><li>Three</li><ol>',
    'inline/list-style-type/disc':
        '<ol style="list-style-type: disc"><li>Foo</li></ol>',
    'inline/list-style-type/circle':
        '<ul style="list-style-type: circle"><li>Foo</li></ul>',
    'inline/list-style-type/square':
        '<ul style="list-style-type: square"><li>Foo</li></ul>',
    'inline/LI_padding-inline-start': '''
<ul style="padding-inline-start: 9px">
  <li style="padding-inline-start: 19px">19px</li>
  <li style="padding-inline-start: 29px">29px</li>
  <li>9px</li>
<ul>
''',
    'OL/rtl':
        '<div dir="rtl"><ol><li>One</li><li>Two</li><li>Three</li><ol></div>',
    'UL': '''
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
          <li>2.2.3</li>
        </ul>
      </li>
      <li>2.3</li>
    </ul>
  </li>
  <li>Three</li>
</ul>''',
    'TABLE,CAPTION,TBODY,THEAD,TFOOT,TR,TH,TD': '''<table border="1">
      <caption>Caption</caption>
      <tfoot><tr><td>Footer 1</td><td>Footer 2</td></tr></tfoot>
      <tbody><tr><td>Value 1</td><td>Value 2</td></tr></tbody>
      <thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>
    </table>''',
    'inline/display/table': '''
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
</div>''',
    'TABLE/colspan': '''
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
</table>''',
    'TABLE/rowspan': '''
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
</table>''',
  }).entries.forEach((entry) => _test(entry.key, entry.value));
}
