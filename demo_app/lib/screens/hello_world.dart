import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const kHtml = '''
<body>
<pre><code>void showAlertDialog(BuildContext context) {
	showDialog(
		context: context,
		builder: (BuildContext context) {
			return CustomAlertDialog(
				content: Container(
					width: MediaQuery.of(context).size.width / 1.3,
					height: MediaQuery.of(context).size.height / 2.5,
					decoration: new BoxDecoration(
						shape: BoxShape.rectangle,
						color: const Color(0xFFFFFF),
						borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
					),
					child: //Contents here
				),
			);
		},
	);
}
</code></pre>
</body>
''';

class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('HelloWorldScreen')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(kHtml, webView: true),
          ),
        ),
      );
}
