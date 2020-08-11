import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FontSizeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('FontSizeScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: _Panel(),
                  color: Colors.blue,
                ),
                Container(
                  child: _Slider(),
                  color: Colors.red,
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
        child: Padding(
          child: Column(
            children: [
              _Values(),
              Table(
                children: [
                  _row(null, 10),
                  _row('2em', 20),
                  _row('200%', 20),
                  _row('20pt', 20 * 96 / 72),
                  _row('20px', 20),
                ],
              ),
              Divider(),
              HtmlWidget(
                '<p style="font-size: 1em">Almost every developer\'s favorite molecule is '
                'C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>, '
                'also known as "caffeine."</p>',
                key: UniqueKey(),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
        ),
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 10),
      );

  TableRow _row(String data, double fontSize) => TableRow(children: [
        Text(
          data ?? 'Default',
          style: TextStyle(fontSize: fontSize),
        ),
        HtmlWidget(
          data != null
              ? '<span style="font-size: $data">$data</span>'
              : 'No font-size',
          key: UniqueKey(),
        ),
      ]);
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
  var textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Slider(
            divisions: 3,
            max: 2,
            min: 0.5,
            onChanged: (v) => setState(() => textScaleFactor = v),
            value: textScaleFactor,
          ),
          MediaQuery(
            child: _Panel(),
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: textScaleFactor),
          )
        ],
      );
}
