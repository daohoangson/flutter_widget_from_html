part of '../core_ops.dart';

const String kCssTextShadow = 'text-shadow';

/// Refer https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow
void textShadowApply(BuildTree tree, css.Declaration style) {
  final styleExpression = style.expression as css.Expressions?;
  final expressions = styleExpression?.expressions;

  if (expressions?.isNotEmpty == true) {
    tree.inherit(_textShadow, _extractToIndividualExpressions(expressions!));
  }
}

/// This is to support multiple values separated by a comma
/// 1px 1px 2px #558ABB, 0 0 1em #24A8BB, 0 0 0.2em #FC0;
List<List<Expression>> _extractToIndividualExpressions(
  List<Expression> expressions,
) {
  final List<List<Expression>> extractedList = [];

  List<Expression> chunk = [];

  for (final Expression exp in expressions) {
    if (exp is OperatorComma) {
      extractedList.add(chunk);
      chunk = [];
    } else {
      chunk.add(exp);
    }
  }

  if (chunk.isNotEmpty) {
    extractedList.add(chunk);
  }

  return extractedList;
}

InheritedProperties _textShadow(
  InheritedProperties resolving,
  List<List<Expression>> expressions,
) {
  final List<Shadow> shadows = [];
  final defaultColor =
      resolving.parent?.get<TextStyle>()?.color ?? const Color(0xff000000);

  for (final List<Expression> exp in expressions) {
    final shadow = _parseExpressionToShadow(exp, defaultColor);
    if (shadow != null) {
      shadows.add(shadow);
    }
  }

  return resolving.copyWith(
    style: TextStyle(shadows: shadows),
  );
}

///
/// offset-x | offset-y | blur-radius | color
/// text-shadow: 1px 1px 2px black;
///
/// color | offset-x | offset-y | blur-radius
/// text-shadow: #fc0 1px 0 10px;
///
/// offset-x | offset-y | color
/// text-shadow: 5px 5px #558abb;
///
/// color | offset-x | offset-y
/// text-shadow: white 2px 5px
///
/// offset-x | offset-y
/// text-shadow: 5px 10px
///
Shadow? _parseExpressionToShadow(
  List<Expression> expressions,
  Color defaultColor,
) {
  Color? color;
  double? offsetX;
  double? offsetY;
  double? blurRadius;

  if (expressions.length < 2 || expressions.length > 4) {
    return null;
  }

  // Parse color
  // Color is ALWAYS either the first or the last index
  int colorOffsetIndex = 0;

  color = tryParseColor(expressions.last);

  if (color == null) {
    color = tryParseColor(expressions.first);
    if (color != null) {
      colorOffsetIndex = 1;
    }
  }

  if (color == null && expressions.length > 3) {
    return null;
  }
  // Parse size + blur radius
  // According to the docs, the valid ordering must always be
  // offset-x , off-set-y , blur-radius (optional)
  offsetX = tryParseCssLength(
    expressions.safeGetAt(0 + colorOffsetIndex),
  )?.number;
  offsetY = tryParseCssLength(
    expressions.safeGetAt(1 + colorOffsetIndex),
  )?.number;
  blurRadius = tryParseCssLength(
    expressions.safeGetAt(2 + colorOffsetIndex),
  )?.number;

  return Shadow(
    color: color ?? defaultColor,
    offset: Offset(offsetX ?? 0.0, offsetY ?? 0.0),
    blurRadius: blurRadius ?? 0.0,
  );
}
