part of '../core_widget_factory.dart';

const _kAttributeDir = 'dir';
const _kCssDirection = 'direction';
const _kCssDirectionLtr = 'ltr';
const _kCssDirectionRtl = 'rtl';

BuildOp _styleDirection(WidgetFactory wf, String dir) => BuildOp(
      onWidgets: (_, ws) {
        final v = (dir == _kCssDirectionRtl)
            ? TextDirection.rtl
            : dir == _kCssDirectionLtr ? TextDirection.ltr : null;
        if (v == null) return ws;

        return _listOrNull(
            wf.buildColumn(ws)?.wrapWith(wf.buildDirectionality, v));
      },
    );
