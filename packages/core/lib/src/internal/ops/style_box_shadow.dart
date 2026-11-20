part of '../core_ops.dart';

const kCssBoxShadow = 'box-shadow';
const kCssBoxShadowInset = 'inset';
const kCssBoxShadowNone = 'none';

class StyleBoxShadow {
  final WidgetFactory wf;

  StyleBoxShadow(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssBoxShadow,
        onRenderBlock: (tree, placeholder) {
          final shadows = _parse(tree);
          if (shadows.isEmpty) {
            return placeholder;
          }

          return placeholder.wrapWith((context, child) {
            final resolved = tree.inheritanceResolvers.resolve(context);
            final boxShadow = <BoxShadow>[];
            // CSS paints the first shadow on top, Flutter paints the last one on top
            for (final shadow in shadows.reversed) {
              final value = shadow.getValue(resolved);
              if (value != null) {
                boxShadow.add(value);
              }
            }

            if (boxShadow.isEmpty) {
              return child;
            }

            return wf.buildDecoration(tree, child, boxShadow: boxShadow);
          });
        },
        priority: BoxModel.boxShadow,
      );

  static List<_CssBoxShadow> _parse(BuildTree tree) {
    var shadows = const <_CssBoxShadow>[];
    for (final style in tree.styles) {
      if (style.property != kCssBoxShadow) {
        continue;
      }

      final parsed = _tryParseShadows(style);
      if (parsed != null) {
        shadows = parsed;
      }
    }

    return shadows;
  }

  static List<_CssBoxShadow>? _tryParseShadows(css.Declaration style) {
    final values = style.values;
    if (values.length == 1 && style.term == kCssBoxShadowNone) {
      return const [];
    }
    if (values.isEmpty || values.last is css.OperatorComma) {
      return null;
    }

    final shadows = <_CssBoxShadow>[];
    for (final expressions in _extractToIndividualExpressions(values)) {
      final shadow = _tryParseShadow(expressions);
      if (shadow == null) {
        // an invalid shadow invalidates the whole declaration
        return null;
      }
      if (!shadow.inset) {
        // TODO: add support for inset shadows, BoxShadow can only paint outside
        shadows.add(shadow);
      }
    }

    return shadows;
  }

  /// Parses `inset? && <length>{2,4} && <color>?`.
  static _CssBoxShadow? _tryParseShadow(List<css.Expression> expressions) {
    CssColor? color;
    var inset = false;
    final lengths = <CssLength>[];

    for (final expression in expressions) {
      if (expression is css.LiteralTerm &&
          expression.valueAsString == kCssBoxShadowInset) {
        if (inset) {
          return null;
        }
        inset = true;
        continue;
      }

      final length = tryParseCssLength(expression);
      if (length != null) {
        lengths.add(length);
        continue;
      }

      final parsedColor = tryParseColor(expression);
      if (parsedColor == null || color != null) {
        return null;
      }
      color = parsedColor;
    }

    if (lengths.length < 2 || lengths.length > 4) {
      return null;
    }

    final blurRadius = lengths.length > 2 ? lengths[2] : CssLength.zero;
    if (blurRadius.number < 0) {
      return null;
    }

    return _CssBoxShadow(
      inset: inset,
      shadow: CssShadow(
        blurRadius: blurRadius,
        color: color ?? CssColor.current(),
        offsetX: lengths[0],
        offsetY: lengths[1],
      ),
      spreadRadius: lengths.length > 3 ? lengths[3] : CssLength.zero,
    );
  }
}

@immutable
class _CssBoxShadow {
  final bool inset;
  final CssShadow shadow;
  final CssLength spreadRadius;

  const _CssBoxShadow({
    required this.inset,
    required this.shadow,
    required this.spreadRadius,
  });

  BoxShadow? getValue(InheritedProperties resolved) {
    final value = shadow.getValue(resolved);
    if (value == null) {
      return null;
    }

    final spreadRadius = this.spreadRadius.getValue(resolved);
    if (spreadRadius == null) {
      return null;
    }

    return BoxShadow(
      blurRadius: value.blurRadius,
      color: value.color,
      offset: value.offset,
      spreadRadius: spreadRadius,
    );
  }
}
