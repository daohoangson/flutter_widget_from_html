import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_math/fwfh_math.dart';

class MathScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('MathFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            r'Check this out: <math>x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}</math>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      );
}

class MyWidgetFactory extends WidgetFactory with MathFactory {}
