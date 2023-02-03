import 'package:flutter/widgets.dart';

import 'html_list_marker.dart';

class HtmlDetails extends StatefulWidget {
  final Widget child;
  final bool open;

  const HtmlDetails({
    required this.child,
    this.open = false,
    Key? key,
  }) : super(key: key);

  @override
  State<HtmlDetails> createState() => _HtmlDetailsState();
}

class _HtmlDetailsState extends State<HtmlDetails> {
  var _hasSetOpen = false;
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
  }

  @override
  void didUpdateWidget(HtmlDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_hasSetOpen) {
      _isOpen = widget.open;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HtmlDetailsInherited(
      isOpen: _isOpen,
      setIsOpen: (v) => setState(() {
        _isOpen = v;
        _hasSetOpen = true;
      }),
      child: widget.child,
    );
  }
}

class HtmlDetailsContents extends StatelessWidget {
  final Widget child;

  const HtmlDetailsContents({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOpen = context.htmlDetails?.isOpen ?? true;
    return isOpen ? child : const SizedBox.shrink();
  }
}

class HtmlDetailsMarker extends StatelessWidget {
  final TextStyle style;

  const HtmlDetailsMarker({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOpen = context.htmlDetails?.isOpen;
    if (isOpen == null) {
      return const SizedBox.shrink();
    }

    return HtmlListMarker(
      markerType: isOpen
          ? HtmlListMarkerType.disclosureOpen
          : HtmlListMarkerType.disclosureClosed,
      textStyle: style,
    );
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
        final htmlDetails = context.htmlDetails;
        if (htmlDetails != null) {
          htmlDetails.setIsOpen(!htmlDetails.isOpen);
        }
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
  final bool isOpen;
  final void Function(bool) setIsOpen;

  const _HtmlDetailsInherited({
    required Widget child,
    Key? key,
    required this.isOpen,
    required this.setIsOpen,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_HtmlDetailsInherited oldWidget) =>
      isOpen != oldWidget.isOpen;
}

extension _BuildContext on BuildContext {
  _HtmlDetailsInherited? get htmlDetails =>
      dependOnInheritedWidgetOfExactType<_HtmlDetailsInherited>();
}
