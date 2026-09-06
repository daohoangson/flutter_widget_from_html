import 'package:flutter/services.dart';
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
    final details = context.htmlDetails;
    if (details == null) {
      return child ?? const SizedBox.shrink();
    }
    return _FocusableSummary(
      isOpen: details.isOpen,
      onActivate: () => details.setIsOpen(!details.isOpen),
      style: style,
      child: child,
    );
  }
}

class _FocusableSummary extends StatefulWidget {
  final Widget? child;
  final bool isOpen;
  final VoidCallback onActivate;
  final TextStyle style;

  const _FocusableSummary({
    required this.child,
    required this.isOpen,
    required this.onActivate,
    required this.style,
  });

  @override
  State<_FocusableSummary> createState() => _FocusableSummaryState();
}

class _FocusableSummaryState extends State<_FocusableSummary> {
  var _showFocus = false;
  late final _focusNode = FocusNode(onKeyEvent: _handleKeyEvent);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final activates = const SingleActivator(
          LogicalKeyboardKey.enter,
        ).accepts(event, HardwareKeyboard.instance) ||
        const SingleActivator(
          LogicalKeyboardKey.space,
        ).accepts(event, HardwareKeyboard.instance);
    if (!node.hasPrimaryFocus || !activates) {
      return KeyEventResult.ignored;
    }

    widget.onActivate();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: _focusNode,
      onShowFocusHighlight: (value) => setState(() => _showFocus = value),
      child: Semantics(
        button: true,
        expanded: widget.isOpen,
        onTap: widget.onActivate,
        child: GestureDetector(
          excludeFromSemantics: true,
          onTap: widget.onActivate,
          child: DecoratedBox(
            // Paint inside the existing bounds without shifting the summary.
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: _showFocus
                  ? Border.all(
                      color: widget.style.color ?? const Color(0xFF000000),
                      width: 2,
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  _HtmlDetailsInherited? get htmlDetails =>
      dependOnInheritedWidgetOfExactType<_HtmlDetailsInherited>();
}

class _HtmlDetailsInherited extends InheritedWidget {
  final bool isOpen;
  final void Function(bool value) setIsOpen;

  const _HtmlDetailsInherited({
    required super.child,
    required this.isOpen,
    required this.setIsOpen,
  });

  @override
  bool updateShouldNotify(_HtmlDetailsInherited oldWidget) =>
      isOpen != oldWidget.isOpen;
}
