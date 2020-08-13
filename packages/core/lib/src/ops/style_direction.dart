part of '../core_widget_factory.dart';

const _kAttributeDir = 'dir';
const _kCssDirection = 'direction';
const _kCssDirectionLtr = 'ltr';
const _kCssDirectionRtl = 'rtl';

BuildOp _styleDirection(WidgetFactory wf, String dir) => BuildOp(
      onWidgets: (_, ws) {
        final textDirection = (dir == _kCssDirectionRtl)
            ? TextDirection.rtl
            : dir == _kCssDirectionLtr ? TextDirection.ltr : null;
        if (textDirection == null) return ws;

        return _listOrNull(wf.buildColumnPlaceholder(ws)?.wrapWith(
            (child) => wf.buildDirectionality(child, textDirection)));
      },
    );
