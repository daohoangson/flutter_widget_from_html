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
</p>

<p>
  Inline (without dimensions):
  <img src="${_src(20, 10)}" />
  <img src="${_src(30, 10)}" />
  <img src="${_src(40, 10)}" />
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

<p>
  Center:
  <center><img src="${_src(50, 10)}" width="50" height="10" /></center>
</p>

<p>
  Link:
  <a href="https://placeholder.com"><img src="${_src(50, 10)}" /></a>
</p>

<p>Images from <a href="https://placeholder.com">placeholder.com</a></p>
""";

  String _src(int width, int height) =>
      "https://via.placeholder.com/${width}x$height"
      "?cacheBuster=${DateTime.now().millisecondsSinceEpoch}-${i++}";
}
