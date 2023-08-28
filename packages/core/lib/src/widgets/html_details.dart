import 'package:flutter/widgets.dart';

import 'html_list_marker.dart';

class HtmlDetails extends StatefulWidget {
  final Widget child;
  final bool open;

  const HtmlDetails({
    required this.child,
    this.open = false,
    super.key,
  });

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

  const HtmlDetailsContents({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final isOpen = context.htmlDetails?.isOpen ?? true;
    return isOpen ? child : const SizedBox.shrink();
  }
}

class HtmlDetailsMarker extends StatelessWidget {
  final TextStyle style;

  const HtmlDetailsMarker({super.key, required this.style});

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
    super.key,
    this.child,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final htmlDetails = context.htmlDetails;
        if (htmlDetails != null) {
          htmlDetails.setIsOpen(!htmlDetails.isOpen);
        }
      },
      child: child,
    );
  }
}

extension on BuildContext {
  _HtmlDetailsInherited? get htmlDetails =>
      dependOnInheritedWidgetOfExactType<_HtmlDetailsInherited>();
}

class _HtmlDetailsInherited extends InheritedWidget {
  final bool isOpen;
  final void Function(bool) setIsOpen;

  const _HtmlDetailsInherited({
    required super.child,
    required this.isOpen,
    required this.setIsOpen,
  });

  @override
  bool updateShouldNotify(_HtmlDetailsInherited oldWidget) =>
      isOpen != oldWidget.isOpen;
}
