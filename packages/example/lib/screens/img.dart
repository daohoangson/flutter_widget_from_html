import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ImgScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImgScreen> {
  var i = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('ImgScreen'),
        ),
        body: ListView(children: <Widget>[HtmlWidget(_html())]),
      );

  String _html() => """
<p>
  Inline:
  <img alt="alt" />
  <img title="title" />
  <img src="${_src(20, 10)}" width="20" height="10" />
  <img src="${_src(30, 10)}" width="30" height="10" />
  <img src="${_src(40, 10)}" width="40" height="10" />
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis iaculis felis, quis interdum massa. Maecenas dolor risus, semper id metus nec, rhoncus condimentum nulla.
</p>

<p>
  Inline (without dimensions):
  <img src="${_src(20, 10)}" />
  <img src="${_src(30, 10)}" />
  <img src="${_src(40, 10)}" />
  Sed nec dolor massa. Pellentesque tristique, mauris bibendum commodo sollicitudin, erat urna mattis nunc, et faucibus tortor justo vel ante.
</p>

<p>
  Inline (many images):
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  <img src="${_src(50, 10)}" width="50" height="10" />
  Nulla nec lorem in nisl vehicula tincidunt. Nam sagittis, quam sed imperdiet interdum, tellus justo facilisis risus, non vehicula eros eros eu magna.
</p>

<p>
  Block (small image):
  <img src="${_src(100, 10)}" width="100" height="10" style="display: block" />
</p>

<p>
  Block (small image, without dimensions):
  <img src="${_src(100, 10)}" style="display: block" />
</p>

<p>
  Block (big image):
  <img src="${_src(2000, 200)}" width="2000" height="200" style="display: block" />
</p>

<p>
  Block (big image, without dimensions):
  <img src="${_src(2000, 200)}" style="display: block" />
</p>

<div style="text-align: left"><img src="${_src(50, 10)}" /></div>
<center><img src="${_src(50, 10)}" /></center>
<div style="text-align: right"><img src="${_src(50, 10)}" /></div>
<div style="text-align: left"><img src="${_src(50, 10)}" style="display: block" /></div>
<center><img src="${_src(50, 10)}" style="display: block" /></center>
<div style="text-align: right"><img src="${_src(50, 10)}" style="display: block" /></div>

<p>
  Link:
  <a href="https://placeholder.com"><img src="${_src(50, 10)}" /></a>
</p>

<p>
  Images from <a href="https://placeholder.com">placeholder.com</a>,
  filler text from <a href="https://lipsum.com/feed/html">lipsum.com</a>
</p>
""";

  String _src(int width, int height) =>
      "https://via.placeholder.com/${width}x$height"
      "?cacheBuster=${DateTime.now().millisecondsSinceEpoch}-${i++}";
}
