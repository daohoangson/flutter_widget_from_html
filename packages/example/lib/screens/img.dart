import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ImgScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImgScreen> {
  var i = 0;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Network'),
                Tab(text: 'Asset'),
                Tab(text: 'Data URI'),
                Tab(text: 'SVG'),
              ],
            ),
            title: Text('ImgScreen'),
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
            '$html<hr /><pre>${HtmlEscape().convert(html)}</pre>',
          ),
        ),
      );

  String _htmlAsset() {
    final android = 'asset:logos/android.png';
    final ios = 'asset:logos/ios.png';

    return '''
<p>
  Android:

  <img src="$android" />
  <img src="$android" width="48" height="48" />
  <img src="$android" width="12" height="12" />
</p>

<p>
  iOS:

  <img src="$ios" />
  <img src="$ios" width="48" height="48" />
  <img src="$ios" width="12" height="12" />
</p>
''';
  }

  String _htmlDataUri() {
    final android =
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAMAAABlApw1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAdpQTFRFAAAAVMX4VMX4AUN3AVGRAVaaAVebKbb2VMX4FmOXVMX4VMX4Kbb2AUuGAUuHAVWXAVebFmyWKbb2LLf2VMX4AClIACxOACxPAC1QAC5RAC5SAC9TAC9UADBWADFWADFXADNaADVeADZgADdgADtpADxsASZCASZDASpJATFXATRbATRcATRdATVfATZgAThjAThkATlmATpnATpoATtpATxqAT1sAT1tAT5tAT5uAT5vAT9vAT9wAUByAUFzAUF0AUJ1AUJ2AUR5AUR6AUV6AUV7AUZ8AUd+AUd/AUiAAUiBAUmCAUmDAUqDAUqEAUqFAUuEAUuFAUuGAUuHAUyHAUyIAUyJAU2IAU2JAU2KAU6KAU6LAU6MAU+MAU+NAVCOAVCPAVCQAVGPAVGQAVGRAVKRAVKSAVOSAVOTAVOUAVOVAVSUAVSVAVSWAVWWAVWXAVWYAVWZAVaYAVaZAVaaAVeaAVebAi5PAjFWAjRbAjdgAjpkAjxoAj5rAkBuAkFxAkJzAkN1AkR2AkV4AkZ5AkZ6Akd6FmiPFmmQF22WF3CbGHOfGXajGXmnGXuqGn2tGn+wGoCyG4K0G4O2G4S3G4W4G4W5G4a6HIa7H4vAKbb2LLf2TML4VMX4KQGaCAAAABV0Uk5TABAgMDAwMDAwQEDP3+/v7+/v7+/v7Yl3rQAAAz5JREFUeNrt1AdTE1EUhmFEQKygYi9YsTewYcOAEBBRg6KIkASBmKhhkazXLnbsvUb8r2bNMASy2b33zmzmnJnv+wF7nnd2dgsKMAzL60or/uqtohR++OGHH3744Ycffvjhhx9++OGHH3744Ycffvjhhx9++OGHH3744Ycffvjhhx9++OGHH3744Ycffvjhhx9++OGHH3744Ycffvjhhx9++Gn7C2dprpCGX/uhs6fBDz/88HPxa9+i4te9Rsevd4+SX+ciLb/6TWp+1av0/Gp3KfpVLtP0y9+m6pe9Ttcvd5+yX0ZA2+9uoO53U9D3Ozuc/DMWjpHwOxU4+hck/4yR8OcucPEntQo88OcqcPXrFHjity+Q8KsXeOS3K5DyqxZ45s8ukPSrFXjon1og7Vcp8NQ/uUDBL1/gsT+zQMkvW+C5f6JA0S9XkAf/eIGyX6YgL/50gYbfvSBPfqtAy+9WkDd/qkDP71yQR7/THP1OBTz8uQu4+HMV8PHbF3Dy2xXw8mcXcPNPLeDnn1zA0Z9ZwNM/UcDVP17A158u4Oy3Coj4C+Yk9fZ7Jg2/7hv49XJuEeeCny/a+8qK+RZY/kGzvIRrwY/n7b3xhBBcC74/O5vy3xJcC749bQvFb5pWAMuCr09ag9eHzHQAw4Ivj1u6o0YiFcCz4POIv6s/PjwRwKzg06OmjiuxwcwAVgUfH9YHgpGYYWQGMCr48MDX2hWOxuLGsDn+FXMqeH//qP9cT+/VrAAmBe/uHWw4dSHYF8kOYFHw9u5eX/OZzmA4ErthTPqKeRS8ubPrSENLoLMnPGAXQL7g9e3t++oaTwY6u8MDUbsA4gWvNm/ZXetrbDl9sTvUH72W/o8KwaZgdNOSbdWHrICOy6E+6z9qiuzRLRitWrRyR83h4yea285bAUZC2I5qQcq/ePXOmtq6Bn8qIDIkco5mgeVfVrmu+sCxen9X1BROo1jw37+8cu2e/c2hhHAbvYK0f8WqDW1DQmbUCtL+9U0RITtaBZZ/jU9eT61gtGrpxkumUBydgvlbG/sNZT+hgunztPyECorKtPyECorLBfOCEhSgAAUoQAEKUIACFKAABShAAZkCDKO1f/OiyBBYvwCtAAAAAElFTkSuQmCC';
    final ios =
        'data:image/png;base64,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';

    return '''
<p>
  Android:

  <img src="$android" />

  <img width="48" height="48" src="$android" />
  <img width="12" height="12" src="$android" />
</p>

<p>
  iOS:

  <img src="$ios" />
  <img width="48" height="48" src="$ios" />
  <img width="12" height="12" src="$ios" />
</p>
''';
  }

  String _htmlNetwork() => '''
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
''';

  String _htmlSvg() => '''
<p>
  Network:

  <img src="https://raw.githubusercontent.com/dnfield/flutter_svg/master/example/assets/flutter_logo.svg" />
</p>

<p>
  Asset:

  <img src="asset:test/images/logo.svg?package=flutter_widget_from_html" />
</p>

<p>
  Data URI:

  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgdmlld0JveD0iMCAwIDE2NiAyMDIiPgogICAgPGRlZnM+CiAgICAgICAgPGxpbmVhckdyYWRpZW50IGlkPSJ0cmlhbmdsZUdyYWRpZW50Ij4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIyMCUiIHN0b3AtY29sb3I9IiMwMDAwMDAiIHN0b3Atb3BhY2l0eT0iLjU1IiAvPgogICAgICAgICAgICA8c3RvcCBvZmZzZXQ9Ijg1JSIgc3RvcC1jb2xvcj0iIzYxNjE2MSIgc3RvcC1vcGFjaXR5PSIuMDEiIC8+CiAgICAgICAgPC9saW5lYXJHcmFkaWVudD4KICAgICAgICA8bGluZWFyR3JhZGllbnQgaWQ9InJlY3RhbmdsZUdyYWRpZW50IiB4MT0iMCUiIHgyPSIwJSIgeTE9IjAlIiB5Mj0iMTAwJSI+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iMjAlIiBzdG9wLWNvbG9yPSIjMDAwMDAwIiBzdG9wLW9wYWNpdHk9Ii4xNSIgLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSI4NSUiIHN0b3AtY29sb3I9IiM2MTYxNjEiIHN0b3Atb3BhY2l0eT0iLjAxIiAvPgogICAgICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgICA8L2RlZnM+CiAgICA8cGF0aCBmaWxsPSIjNDJBNUY1IiBmaWxsLW9wYWNpdHk9Ii44IiBkPSJNMzcuNyAxMjguOSA5LjggMTAxIDEwMC40IDEwLjQgMTU2LjIgMTAuNCIvPgogICAgPHBhdGggZmlsbD0iIzQyQTVGNSIgZmlsbC1vcGFjaXR5PSIuOCIgZD0iTTE1Ni4yIDk0IDEwMC40IDk0IDc5LjUgMTE0LjkgMTA3LjQgMTQyLjgiLz4KICAgIDxwYXRoIGZpbGw9IiMwRDQ3QTEiIGQ9Ik03OS41IDE3MC43IDEwMC40IDE5MS42IDE1Ni4yIDE5MS42IDE1Ni4yIDE5MS42IDEwNy40IDE0Mi44Ii8+CiAgICA8ZyB0cmFuc2Zvcm09Im1hdHJpeCgwLjcwNzEsIC0wLjcwNzEsIDAuNzA3MSwgMC43MDcxLCAtNzcuNjY3LCA5OC4wNTcpIj4KICAgICAgICA8cmVjdCB3aWR0aD0iMzkuNCIgaGVpZ2h0PSIzOS40IiB4PSI1OS44IiB5PSIxMjMuMSIgZmlsbD0iIzQyQTVGNSIgLz4KICAgICAgICA8cmVjdCB3aWR0aD0iMzkuNCIgaGVpZ2h0PSI1LjUiIHg9IjU5LjgiIHk9IjE2Mi41IiBmaWxsPSJ1cmwoI3JlY3RhbmdsZUdyYWRpZW50KSIgLz4KICAgIDwvZz4KICAgIDxwYXRoIGQ9Ik03OS41IDE3MC43IDEyMC45IDE1Ni40IDEwNy40IDE0Mi44IiBmaWxsPSJ1cmwoI3RyaWFuZ2xlR3JhZGllbnQpIiAvPgo8L3N2Zz4=" />
</p>
''';

  String _src(int width, int height) =>
      'https://via.placeholder.com/${width}x$height'
      '?cacheBuster=${DateTime.now().millisecondsSinceEpoch}-${i++}';
}
