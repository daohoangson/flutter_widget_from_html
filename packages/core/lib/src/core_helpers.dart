import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

/// A no op placeholder widget.
const widget0 = const SizedBox.shrink();

typedef void OnTapUrl(String url);

typedef Widget WidgetBuilder(BuildContext context);

typedef WidgetFactory FactoryBuilder(HtmlWidgetConfig config);

class WidgetPlaceholder extends StatelessWidget implements IWidgetPlaceholder {
  final WidgetBuilder builder;

  WidgetPlaceholder(this.builder, {Key key})
      : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => builder(context);

  @override
  bool isSpacing() => false;
}

abstract class IWidgetPlaceholder {
  Widget build(BuildContext context);

  bool isSpacing();
}
