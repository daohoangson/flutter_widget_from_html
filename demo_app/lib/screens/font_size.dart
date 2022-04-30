import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FontSizeScreen extends StatelessWidget {
  const FontSizeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('FontSizeScreen'),
          actions: const [
            PopupMenu(
              toggleIsSelectable: true,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  child: _Panel(),
                ),
                Container(
                  color: Colors.red,
                  child: _Slider(),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Panel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _Values(),
              Table(
                children: [
                  _row(context, null, 10),
                  _row(context, '2em', 20),
                  _row(context, '200%', 20),
                  _row(context, '20pt', 20 * 96 / 72),
                  _row(context, '20px', 20),
                ],
              ),
              const Divider(),
              HtmlWidget(
                '<p style="font-size: 1em">Almost every developer\'s favorite '
                'molecule is C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>, '
                'also known as "caffeine."</p>',
                isSelectable: context.isSelectable,
              ),
            ],
          ),
        ),
      );

  TableRow _row(BuildContext context, String data, double fontSize) => TableRow(
        children: [
          Text(
            data ?? 'Text',
            style: TextStyle(fontSize: fontSize),
          ),
          HtmlWidget(
            data != null
                ? '<span style="font-size: $data">$data</span>'
                : 'HtmlWidget',
            isSelectable: context.isSelectable,
          ),
        ],
      );
}

class _Values extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tsf = MediaQuery.of(context).textScaleFactor;
    final fontSize = DefaultTextStyle.of(context).style.fontSize;
    return ListTile(
      title: Text('fontSize=$fontSize', textScaleFactor: 1),
      subtitle: Text('textScaleFactor=$tsf', textScaleFactor: 1),
    );
  }
}

class _Slider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  var _textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Slider(
            divisions: 3,
            max: 2,
            min: 0.5,
            onChanged: (v) => setState(() => _textScaleFactor = v),
            value: _textScaleFactor,
          ),
          MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: _textScaleFactor),
            child: _Panel(),
          )
        ],
      );
}
