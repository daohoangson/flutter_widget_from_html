import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

extension PopupBuildContext on BuildContext {
  bool get isSelectable => _watch.value.isSelectable;

  GlobalKey<HtmlWidgetState> get key => _watch.value.key;

  bool get showPerformanceOverlay => _watch.value.showPerformanceOverlay;

  ValueNotifier<_PopupMenuState> get _read => read();

  ValueNotifier<_PopupMenuState> get _watch => watch();
}

class PopupMenu extends StatelessWidget {
  final bool scrollToTop;
  final bool showPerfOverlay;
  final bool toggleIsSelectable;

  const PopupMenu({
    Key key,
    this.scrollToTop = false,
    this.showPerfOverlay = true,
    this.toggleIsSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PopupMenuValue>(
      onSelected: (pmv) {
        final notifier = context._read;
        final value = notifier.value;

        switch (pmv) {
          case _PopupMenuValue.scrollToTop:
            value.key.currentState?.scrollToAnchor('top');
            break;
          case _PopupMenuValue.showPerformanceOverlay:
            notifier.value = value.copyWith(
              showPerformanceOverlay: !value.showPerformanceOverlay,
            );
            break;
          case _PopupMenuValue.toggleIsSelectable:
            notifier.value = value.copyWith(isSelectable: !value.isSelectable);
            break;
        }
      },
      itemBuilder: (context) {
        final notifier = context._read;
        final value = notifier.value;

        return [
          if (scrollToTop)
            const PopupMenuItem(
              value: _PopupMenuValue.scrollToTop,
              child: ListTile(title: Text('Scroll to #top')),
            ),
          if (showPerfOverlay)
            PopupMenuItem(
              value: _PopupMenuValue.showPerformanceOverlay,
              child: _CheckBoxMenuItem(
                title: 'showPerformanceOverlay',
                value: value.showPerformanceOverlay,
              ),
            ),
          if (toggleIsSelectable)
            PopupMenuItem(
              value: _PopupMenuValue.toggleIsSelectable,
              child: _CheckBoxMenuItem(
                title: 'isSelectable',
                value: value.isSelectable,
              ),
            ),
        ];
      },
    );
  }
}

class PopupMenuStateProvider extends StatelessWidget {
  final WidgetBuilder builder;
  final bool initialIsSelectable;

  const PopupMenuStateProvider({
    @required this.builder,
    this.initialIsSelectable = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ValueNotifier(
        _PopupMenuState(
          isSelectable: initialIsSelectable,
        ),
      ),
      child: Builder(builder: builder),
    );
  }
}

class _CheckBoxMenuItem extends StatelessWidget {
  final String title;
  final bool value;

  const _CheckBoxMenuItem({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CheckboxListTile(
        value: value,
        onChanged: (_) {},
        title: Text(title),
      ),
    );
  }
}

@immutable
class _PopupMenuState {
  final bool isSelectable;
  final GlobalKey<HtmlWidgetState> key;
  final bool showPerformanceOverlay;

  _PopupMenuState({
    this.isSelectable = false,
    GlobalKey<HtmlWidgetState> key,
    this.showPerformanceOverlay = false,
  }) : key = key ?? GlobalKey<HtmlWidgetState>();

  _PopupMenuState copyWith({
    bool isSelectable,
    bool showPerformanceOverlay,
  }) =>
      _PopupMenuState(
        isSelectable: isSelectable ?? this.isSelectable,
        showPerformanceOverlay:
            showPerformanceOverlay ?? this.showPerformanceOverlay,
      );
}

enum _PopupMenuValue {
  scrollToTop,
  showPerformanceOverlay,
  toggleIsSelectable,
}
