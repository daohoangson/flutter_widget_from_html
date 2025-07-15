import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ImgScreen extends StatefulWidget {
  const ImgScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImgScreen> {
  var _i = 0;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
    child: Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Network'),
            Tab(text: 'Asset'),
            Tab(text: 'Data URI'),
            Tab(text: 'SVG'),
          ],
        ),
        title: const Text('ImgScreen'),
      ),
      body: TabBarView(
        children: <Widget>[
          _buildHtmlWidget(_htmlNetwork()),
          _buildHtmlWidget(_htmlAsset()),
          _buildHtmlWidget(_htmlDataUri()),
          _buildHtmlWidget(_htmlSvg()),
        ],
      ),
    ),
  );

  Widget _buildHtmlWidget(String html) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(
        '$html<hr /><pre>${const HtmlEscape().convert(html)}</pre>',
      ),
    ),
  );

  String _htmlAsset() {
    const icon = 'asset:logos/icon.png';

    return '''
<img src="$icon" />
<img src="$icon" width="48" height="48" />
<img src="$icon" width="12" height="12" />
''';
  }

  String _htmlDataUri() {
    const icon144 =
        'data:image/png;base64,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';

    return '''
<img src="$icon144" />
<img width="48" height="48" src="$icon144" />
<img width="12" height="12" src="$icon144" />
''';
  }

  String _htmlNetwork() =>
      '''
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

<p>
  Link:
  <a href="https://placeholder.com"><img src="${_src(50, 10)}" /></a>
</p>

<p>
  Images from <a href="https://placeholder.com">placeholder.com</a>,
  filler text from <a href="https://lipsum.com/feed/html">lipsum.com</a>
</p>
''';

  String _htmlSvg() {
    const network =
        'https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/0000998/demo_app/logos/icon.svg';
    const asset = 'asset:test/images/icon.svg?package=fwfh_svg';
    const dataUri =
        'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIwIiBoZWlnaHQ9IjMyMCIgdmlld0JveD0iMCAwIDMyMCAzMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIzMjAiIGhlaWdodD0iMzIwIiBmaWxsPSIjRkFGQUZBIi8+CjxwYXRoIGQ9Ik0xODguMDAyIDE2OUgyMjMuNVYyNDEuNUgyNzJWMjc3SDE4OFYxNjlIMTg4LjAwMloiIGZpbGw9ImJsYWNrIi8+CjxwYXRoIGQ9Ik00OCAxNjlIODRMMTA4LjUgMjA2LjgxMUwxMzMgMTY5SDE2OVYyNzdIMTM1VjIyMy4yNzFMMTA5IDI2MS41SDEwOEw4MiAyMjMuMjcxVjI3N0g0OFYxNjlaIiBmaWxsPSIjMDg1ODlDIi8+CjxwYXRoIGQ9Ik0yMDMuNjU5IDc3LjY4NTNMMTcyIDc3LjVWNDJIMjcyVjc3LjVIMjQwVjE1MEgyMDRWNzcuNUwyMDMuNjU5IDc3LjY4NTNaIiBmaWxsPSIjMUZCQ0ZEIi8+CjxwYXRoIGQ9Ik00OCA0Mkg4NFY3Ny41SDExN1Y0MkgxNTNWOTZWMTUwSDExN1YxMTMuNUg4NFYxNTBINDhWNDJaIiBmaWxsPSIjNDREMUZEIi8+Cjwvc3ZnPgo=';

    return '''
<p>
  Network:

  <img src="$network" />
  <img src="$network" width="48" />
  <img src="$network" width="12" />
</p>

<p>
  Asset:

  <img src="$asset" />
  <img src="$asset" width="48" />
  <img src="$asset" width="12" />
</p>

<p>
  Data URI:

  <img src="$dataUri" />
  <img src="$dataUri" width="48" />
  <img src="$dataUri" width="12" />
</p>
''';
  }

  String _src(int width, int height) =>
      'https://via.placeholder.com/${width}x$height'
      '?cacheBuster=${DateTime.now().millisecondsSinceEpoch}-${_i++}';
}
