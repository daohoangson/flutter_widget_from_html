import 'package:flutter/widgets.dart';

class HtmlDetails extends StatefulWidget {
  final Widget child;
  final bool open;

  const HtmlDetails({
    required this.child,
    this.open = false,
    Key? key,
  }) : super(key: key);

  @override
  _HtmlDetailsState createState() => _HtmlDetailsState();

  static ValueNotifier<bool>? _open(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HtmlDetailsInherited>()?.open;
}

class _HtmlDetailsState extends State<HtmlDetails> {
  late ValueNotifier<bool> open;

  @override
  void initState() {
    super.initState();
    open = ValueNotifier(widget.open);
  }

  @override
  Widget build(BuildContext context) {
    return _HtmlDetailsInherited(open: open, child: widget.child);
  }
}

class HtmlDetailsContents extends StatelessWidget {
  final Widget child;

  const HtmlDetailsContents({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final open = HtmlDetails._open(context);
    if (open == null) return child;

    return AnimatedBuilder(
      animation: open,
      builder: (_, __) => open.value ? child : const SizedBox.shrink(),
    );
  }
}

class HtmlDetailsMarker extends StatelessWidget {
  final TextStyle style;

  const HtmlDetailsMarker({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final open = HtmlDetails._open(context);
    if (open == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: open,
      builder: (_, __) => Text(_getText(context, open.value), style: style),
    );
  }

  String _getText(BuildContext context, bool open) {
    // TODO: i18n
    return open ? '▼ ' : '▶ ';
  }
}

class HtmlSummary extends StatelessWidget {
  final Widget? child;
  final TextStyle style;

  const HtmlSummary({
    Key? key,
    this.child,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final open = HtmlDetails._open(context);
        open?.value = !open.value;
      },
      child: child ?? _buildDefault(context),
    );
  }

  Widget _buildDefault(BuildContext context) {
    // TODO: i18n
    const text = 'Details';

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: HtmlDetailsMarker(style: style)),
          TextSpan(text: text, style: style),
        ],
      ),
    );
  }
}

class _HtmlDetailsInherited extends InheritedWidget {
  final ValueNotifier<bool> open;

  const _HtmlDetailsInherited({
    required Widget child,
    Key? key,
    required this.open,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_HtmlDetailsInherited oldWidget) =>
      open != oldWidget.open;
}
