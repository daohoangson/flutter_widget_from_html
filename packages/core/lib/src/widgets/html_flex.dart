/*

set -euo pipefail

_widgetHash=$( curl -s https://github.com/flutter/flutter/raw/35c388a/packages/flutter/lib/src/widgets/basic.dart | openssl md5 )
echo "_widgetHash=$_widgetHash"
_widgetStableHash=$( curl -s https://github.com/flutter/flutter/raw/refs/heads/stable/packages/flutter/lib/src/widgets/basic.dart | openssl md5 )
echo "_widgetStableHash=$_widgetStableHash"
if [ "$_widgetHash" != "$_widgetStableHash" ]; then
  echo "Widget hashes are different"
  exit 1
fi

_renderObjectHash=$( curl -s https://github.com/flutter/flutter/raw/35c388a/packages/flutter/lib/src/rendering/flex.dart | openssl md5 )
echo "_renderObjectHash=$_renderObjectHash"
_renderObjectStableHash=$( curl -s https://github.com/flutter/flutter/raw/refs/heads/stable/packages/flutter/lib/src/rendering/flex.dart | openssl md5 )
echo "_renderObjectStableHash=$_renderObjectStableHash"
if [ "$_renderObjectHash" != "$_renderObjectStableHash" ]; then
  echo "RenderObject hashes are different"
  exit 1
fi

If hashes are mismatched, then the code below should be updated.

*/

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' hide RenderFlex;
import 'package:flutter/widgets.dart'
    show BuildContext, Directionality, MultiChildRenderObjectWidget;

class HtmlFlex extends MultiChildRenderObjectWidget {
  const HtmlFlex({
    super.key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing = 0.0,
    super.children,
  }) : assert(
          !identical(crossAxisAlignment, CrossAxisAlignment.baseline) ||
              textBaseline != null,
          'textBaseline is required if you specify the crossAxisAlignment with CrossAxisAlignment.baseline',
        );

  final Axis direction;

  final MainAxisAlignment mainAxisAlignment;

  final MainAxisSize mainAxisSize;

  final CrossAxisAlignment crossAxisAlignment;

  final TextDirection? textDirection;

  final VerticalDirection verticalDirection;

  final TextBaseline? textBaseline;

  final Clip clipBehavior;

  final double spacing;

  bool get _needTextDirection {
    switch (direction) {
      case Axis.horizontal:
        return true;
      case Axis.vertical:
        return crossAxisAlignment == CrossAxisAlignment.start ||
            crossAxisAlignment == CrossAxisAlignment.end;
    }
  }

  @protected
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    return textDirection ??
        (_needTextDirection ? Directionality.maybeOf(context) : null);
  }

  @override
  RenderHtmlFlex createRenderObject(BuildContext context) {
    return RenderHtmlFlex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderHtmlFlex renderObject,
  ) {
    renderObject
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = verticalDirection
      ..textBaseline = textBaseline
      ..clipBehavior = clipBehavior
      ..spacing = spacing;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(
      EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment',
        mainAxisAlignment,
      ),
    );
    properties.add(
      EnumProperty<MainAxisSize>(
        'mainAxisSize',
        mainAxisSize,
        defaultValue: MainAxisSize.max,
      ),
    );
    properties.add(
      EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment',
        crossAxisAlignment,
      ),
    );
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<VerticalDirection>(
        'verticalDirection',
        verticalDirection,
        defaultValue: VerticalDirection.down,
      ),
    );
    properties.add(
      EnumProperty<TextBaseline>(
        'textBaseline',
        textBaseline,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<Clip>(
        'clipBehavior',
        clipBehavior,
        defaultValue: Clip.none,
      ),
    );
    properties.add(DoubleProperty('spacing', spacing, defaultValue: 0.0));
  }
}

class _AxisSize {
  final Size _size;

  _AxisSize({required double mainAxisExtent, required double crossAxisExtent})
      : _size = Size(mainAxisExtent, crossAxisExtent);

  const _AxisSize._(this._size);

  factory _AxisSize.fromSize({required Size size, required Axis direction}) {
    return _AxisSize._(_convert(size, direction));
  }

  static const _AxisSize empty = _AxisSize._(Size.zero);

  static Size _convert(Size size, Axis direction) {
    return switch (direction) {
      Axis.horizontal => size,
      Axis.vertical => size.flipped,
    };
  }

  double get mainAxisExtent => _size.width;
  double get crossAxisExtent => _size.height;

  Size toSize(Axis direction) => _convert(_size, direction);

  _AxisSize applyConstraints(BoxConstraints constraints, Axis direction) {
    final BoxConstraints effectiveConstraints = switch (direction) {
      Axis.horizontal => constraints,
      Axis.vertical => constraints.flipped,
    };
    return _AxisSize._(effectiveConstraints.constrain(_size));
  }

  _AxisSize operator +(_AxisSize other) => _AxisSize._(
        Size(
          _size.width + other._size.width,
          math.max(_size.height, other._size.height),
        ),
      );
}

typedef _AscentDescentValue = (double ascent, double descent);

class _AscentDescent {
  final _AscentDescentValue? _value;

  factory _AscentDescent({
    required double? baselineOffset,
    required double crossSize,
  }) {
    return baselineOffset == null
        ? none
        : _AscentDescent._((baselineOffset, crossSize - baselineOffset));
  }

  const _AscentDescent._(this._value);

  static const _AscentDescent none = _AscentDescent._(null);

  double? get baselineOffset => _value?.$1;

  _AscentDescent operator +(_AscentDescent other) =>
      switch ((_value, other._value)) {
        (final _AscentDescentValue? _, null) => this,
        (null, final _AscentDescentValue? _) => other,
        (
          (final double xAscent, final double xDescent),
          (final double yAscent, final double yDescent),
        ) =>
          _AscentDescent._(
            (math.max(xAscent, yAscent), math.max(xDescent, yDescent)),
          ),
      };
}

class _LayoutSizes {
  _LayoutSizes({
    required this.axisSize,
    required this.baselineOffset,
    required this.mainAxisFreeSpace,
    required this.spacePerFlex,
  }) : assert(spacePerFlex?.isFinite ?? true);

  final _AxisSize axisSize;

  final double mainAxisFreeSpace;

  final double? baselineOffset;

  final double? spacePerFlex;
}

extension on CrossAxisAlignment {
  double _getChildCrossAxisOffset(double freeSpace, bool flipped) {
    return switch (this) {
      CrossAxisAlignment.stretch || CrossAxisAlignment.baseline => 0.0,
      CrossAxisAlignment.start => flipped ? freeSpace : 0.0,
      CrossAxisAlignment.center => freeSpace / 2,
      CrossAxisAlignment.end =>
        CrossAxisAlignment.start._getChildCrossAxisOffset(
          freeSpace,
          !flipped,
        ),
    };
  }
}

extension on MainAxisAlignment {
  (double leadingSpace, double betweenSpace) _distributeSpace(
    double freeSpace,
    int itemCount,
    bool flipped,
    double spacing,
  ) {
    assert(itemCount >= 0);
    return switch (this) {
      MainAxisAlignment.start =>
        flipped ? (freeSpace, spacing) : (0.0, spacing),
      MainAxisAlignment.end => MainAxisAlignment.start._distributeSpace(
          freeSpace,
          itemCount,
          !flipped,
          spacing,
        ),
      MainAxisAlignment.spaceBetween when itemCount < 2 =>
        MainAxisAlignment.start._distributeSpace(
          freeSpace,
          itemCount,
          flipped,
          spacing,
        ),
      MainAxisAlignment.spaceAround when itemCount == 0 =>
        MainAxisAlignment.start._distributeSpace(
          freeSpace,
          itemCount,
          flipped,
          spacing,
        ),
      MainAxisAlignment.center => (freeSpace / 2.0, spacing),
      MainAxisAlignment.spaceBetween => (
          0.0,
          freeSpace / (itemCount - 1) + spacing
        ),
      MainAxisAlignment.spaceAround => (
          freeSpace / itemCount / 2,
          freeSpace / itemCount + spacing
        ),
      MainAxisAlignment.spaceEvenly => (
          freeSpace / (itemCount + 1),
          freeSpace / (itemCount + 1) + spacing,
        ),
    };
  }
}

double? _getChildBaseline(
  RenderBox child,
  BoxConstraints constraints,
  TextBaseline baseline,
) {
  // TODO: use ChildLayoutHelper.getBaseline when minimum Flutter version >= 3.24
  assert(!child.debugNeedsLayout);
  assert(child.constraints == constraints);
  return child.getDistanceToBaseline(baseline, onlyReal: true);
}

double? _getChildBaselineDry(
  RenderBox child,
  BoxConstraints constraints,
  TextBaseline baseline,
) {
  // TODO: use ChildLayoutHelper.getDryBaseline when minimum Flutter version >= 3.24
  return child.getDryBaseline(constraints, baseline);
}

class RenderHtmlFlex extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData>,
        DebugOverflowIndicatorMixin {
  RenderHtmlFlex({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Clip clipBehavior = Clip.none,
    double spacing = 0.0,
  })  : _direction = direction,
        _mainAxisAlignment = mainAxisAlignment,
        _mainAxisSize = mainAxisSize,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection,
        _verticalDirection = verticalDirection,
        _textBaseline = textBaseline,
        _clipBehavior = clipBehavior,
        _spacing = spacing,
        assert(spacing >= 0.0) {
    addAll(children);
  }

  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  MainAxisAlignment _mainAxisAlignment;
  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment != value) {
      _mainAxisAlignment = value;
      markNeedsLayout();
    }
  }

  MainAxisSize get mainAxisSize => _mainAxisSize;
  MainAxisSize _mainAxisSize;
  set mainAxisSize(MainAxisSize value) {
    if (_mainAxisSize != value) {
      _mainAxisSize = value;
      markNeedsLayout();
    }
  }

  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  VerticalDirection get verticalDirection => _verticalDirection;
  VerticalDirection _verticalDirection;
  set verticalDirection(VerticalDirection value) {
    if (_verticalDirection != value) {
      _verticalDirection = value;
      markNeedsLayout();
    }
  }

  TextBaseline? get textBaseline => _textBaseline;
  TextBaseline? _textBaseline;
  set textBaseline(TextBaseline? value) {
    assert(_crossAxisAlignment != CrossAxisAlignment.baseline || value != null);
    if (_textBaseline != value) {
      _textBaseline = value;
      markNeedsLayout();
    }
  }

  bool get _debugHasNecessaryDirections {
    if (RenderObject.debugCheckingIntrinsics) {
      return true;
    }
    if (firstChild != null && lastChild != firstChild) {
      switch (direction) {
        case Axis.horizontal:
          assert(
            textDirection != null,
            'Horizontal $runtimeType with multiple children has a null textDirection, so the layout order is undefined.',
          );
        case Axis.vertical:
          break;
      }
    }
    if (mainAxisAlignment == MainAxisAlignment.start ||
        mainAxisAlignment == MainAxisAlignment.end) {
      switch (direction) {
        case Axis.horizontal:
          assert(
            textDirection != null,
            'Horizontal $runtimeType with $mainAxisAlignment has a null textDirection, so the alignment cannot be resolved.',
          );
        case Axis.vertical:
          break;
      }
    }
    if (crossAxisAlignment == CrossAxisAlignment.start ||
        crossAxisAlignment == CrossAxisAlignment.end) {
      switch (direction) {
        case Axis.horizontal:
          break;
        case Axis.vertical:
          assert(
            textDirection != null,
            'Vertical $runtimeType with $crossAxisAlignment has a null textDirection, so the alignment cannot be resolved.',
          );
      }
    }
    return true;
  }

  double _overflow = 0;

  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  double get spacing => _spacing;
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double extent,
    required double Function(RenderBox, double) childSize,
  }) {
    if (_direction == sizingDirection) {
      double totalFlex = 0.0;
      double inflexibleSpace = spacing * (childCount - 1);
      double maxFlexFractionSoFar = 0.0;
      for (RenderBox? child = firstChild;
          child != null;
          child = childAfter(child)) {
        final int flex = _getFlex(child);
        totalFlex += flex;
        if (flex > 0) {
          final double flexFraction = childSize(child, extent) / flex;
          maxFlexFractionSoFar = math.max(maxFlexFractionSoFar, flexFraction);
        } else {
          inflexibleSpace += childSize(child, extent);
        }
      }
      return maxFlexFractionSoFar * totalFlex + inflexibleSpace;
    } else {
      final bool isHorizontal = switch (direction) {
        Axis.horizontal => true,
        Axis.vertical => false,
      };

      Size layoutChild(RenderBox child, BoxConstraints constraints) {
        final double mainAxisSizeFromConstraints =
            isHorizontal ? constraints.maxWidth : constraints.maxHeight;

        assert(
          (_getFlex(child) != 0 && extent.isFinite) ==
              mainAxisSizeFromConstraints.isFinite,
        );
        final double maxMainAxisSize = mainAxisSizeFromConstraints.isFinite
            ? mainAxisSizeFromConstraints
            : (isHorizontal
                ? child.getMaxIntrinsicWidth(double.infinity)
                : child.getMaxIntrinsicHeight(double.infinity));
        return isHorizontal
            ? Size(maxMainAxisSize, childSize(child, maxMainAxisSize))
            : Size(childSize(child, maxMainAxisSize), maxMainAxisSize);
      }

      return _computeSizes(
        constraints: isHorizontal
            ? BoxConstraints(maxWidth: extent)
            : BoxConstraints(maxHeight: extent),
        layoutChild: layoutChild,
        getBaseline: _getChildBaselineDry,
      ).axisSize.crossAxisExtent;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicWidth(extent),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicWidth(extent),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicHeight(extent),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicHeight(extent),
    );
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return switch (_direction) {
      Axis.horizontal =>
        defaultComputeDistanceToHighestActualBaseline(baseline),
      Axis.vertical => defaultComputeDistanceToFirstActualBaseline(baseline),
    };
  }

  static final _fwfhFlexByRenderBox = Expando<int>();

  static int _getFlex(RenderBox child) {
    final FlexParentData childParentData = child.parentData! as FlexParentData;
    final fwfhFlex = _fwfhFlexByRenderBox[child] ?? 0;
    final fwfhFlexOrNull = fwfhFlex > 0 ? fwfhFlex : null;
    return fwfhFlexOrNull ?? childParentData.flex ?? 0;
  }

  static FlexFit _getFit(RenderBox child) {
    final FlexParentData childParentData = child.parentData! as FlexParentData;
    return childParentData.fit ?? FlexFit.tight;
  }

  bool get _isBaselineAligned {
    return switch (crossAxisAlignment) {
      CrossAxisAlignment.baseline => switch (direction) {
          Axis.horizontal => true,
          Axis.vertical => false,
        },
      CrossAxisAlignment.start ||
      CrossAxisAlignment.center ||
      CrossAxisAlignment.end ||
      CrossAxisAlignment.stretch =>
        false,
    };
  }

  double _getCrossSize(Size size) {
    return switch (_direction) {
      Axis.horizontal => size.height,
      Axis.vertical => size.width,
    };
  }

  double _getMainSize(Size size) {
    return switch (_direction) {
      Axis.horizontal => size.width,
      Axis.vertical => size.height,
    };
  }

  bool get _flipMainAxis =>
      firstChild != null &&
      switch (direction) {
        Axis.horizontal => switch (textDirection) {
            null || TextDirection.ltr => false,
            TextDirection.rtl => true,
          },
        Axis.vertical => switch (verticalDirection) {
            VerticalDirection.down => false,
            VerticalDirection.up => true,
          },
      };

  bool get _flipCrossAxis =>
      firstChild != null &&
      switch (direction) {
        Axis.vertical => switch (textDirection) {
            null || TextDirection.ltr => false,
            TextDirection.rtl => true,
          },
        Axis.horizontal => switch (verticalDirection) {
            VerticalDirection.down => false,
            VerticalDirection.up => true,
          },
      };

  BoxConstraints _constraintsForNonFlexChild(BoxConstraints constraints) {
    final bool fillCrossAxis = switch (crossAxisAlignment) {
      CrossAxisAlignment.stretch => true,
      CrossAxisAlignment.start ||
      CrossAxisAlignment.center ||
      CrossAxisAlignment.end ||
      CrossAxisAlignment.baseline =>
        false,
    };
    return switch (_direction) {
      Axis.horizontal => fillCrossAxis
          ? BoxConstraints.tightFor(height: constraints.maxHeight)
          : BoxConstraints(maxHeight: constraints.maxHeight),
      Axis.vertical => fillCrossAxis
          ? BoxConstraints.tightFor(width: constraints.maxWidth)
          : BoxConstraints(maxWidth: constraints.maxWidth),
    };
  }

  BoxConstraints _constraintsForFlexChild(
    RenderBox child,
    BoxConstraints constraints,
    double maxChildExtent,
  ) {
    assert(_getFlex(child) > 0.0);
    assert(maxChildExtent >= 0.0);
    final double minChildExtent = switch (_getFit(child)) {
      FlexFit.tight => maxChildExtent,
      FlexFit.loose => 0.0,
    };
    final bool fillCrossAxis = switch (crossAxisAlignment) {
      CrossAxisAlignment.stretch => true,
      CrossAxisAlignment.start ||
      CrossAxisAlignment.center ||
      CrossAxisAlignment.end ||
      CrossAxisAlignment.baseline =>
        false,
    };
    return switch (_direction) {
      Axis.horizontal => BoxConstraints(
          minWidth: minChildExtent,
          maxWidth: maxChildExtent,
          minHeight: fillCrossAxis ? constraints.maxHeight : 0.0,
          maxHeight: constraints.maxHeight,
        ),
      Axis.vertical => BoxConstraints(
          minWidth: fillCrossAxis ? constraints.maxWidth : 0.0,
          maxWidth: constraints.maxWidth,
          minHeight: minChildExtent,
          maxHeight: maxChildExtent,
        ),
    };
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final _LayoutSizes sizes = _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      getBaseline: _getChildBaselineDry,
    );

    if (_isBaselineAligned) {
      return sizes.baselineOffset;
    }

    final BoxConstraints nonFlexConstraints =
        _constraintsForNonFlexChild(constraints);
    BoxConstraints constraintsForChild(RenderBox child) {
      final double? spacePerFlex = sizes.spacePerFlex;
      final int flex;
      return spacePerFlex != null && (flex = _getFlex(child)) > 0
          ? _constraintsForFlexChild(child, constraints, flex * spacePerFlex)
          : nonFlexConstraints;
    }

    BaselineOffset baselineOffset = BaselineOffset.noBaseline;
    switch (direction) {
      case Axis.vertical:
        final double freeSpace = math.max(0.0, sizes.mainAxisFreeSpace);
        final bool flipMainAxis = _flipMainAxis;
        final (double leadingSpaceY, double spaceBetween) =
            mainAxisAlignment._distributeSpace(
          freeSpace,
          childCount,
          flipMainAxis,
          spacing,
        );
        double y = flipMainAxis
            ? leadingSpaceY +
                (childCount - 1) * spaceBetween +
                (sizes.axisSize.mainAxisExtent - sizes.mainAxisFreeSpace)
            : leadingSpaceY;
        final double directionUnit = flipMainAxis ? -1.0 : 1.0;
        for (RenderBox? child = firstChild;
            baselineOffset == BaselineOffset.noBaseline && child != null;
            child = childAfter(child)) {
          final BoxConstraints childConstraints = constraintsForChild(child);
          final Size childSize = child.getDryLayout(childConstraints);
          final double? childBaselineOffset =
              child.getDryBaseline(childConstraints, baseline);
          final double additionalY = flipMainAxis ? -childSize.height : 0.0;
          baselineOffset =
              BaselineOffset(childBaselineOffset) + y + additionalY;
          y += directionUnit * (spaceBetween + childSize.height);
        }
      case Axis.horizontal:
        final bool flipCrossAxis = _flipCrossAxis;
        for (RenderBox? child = firstChild;
            child != null;
            child = childAfter(child)) {
          final BoxConstraints childConstraints = constraintsForChild(child);
          final BaselineOffset distance = BaselineOffset(
            child.getDryBaseline(childConstraints, baseline),
          );
          final double freeCrossAxisSpace = sizes.axisSize.crossAxisExtent -
              child.getDryLayout(childConstraints).height;
          final BaselineOffset childBaseline = distance +
              crossAxisAlignment._getChildCrossAxisOffset(
                freeCrossAxisSpace,
                flipCrossAxis,
              );
          baselineOffset = baselineOffset.minOf(childBaseline);
        }
    }
    return baselineOffset.offset;
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    FlutterError? constraintsError;
    assert(() {
      constraintsError = _debugCheckConstraints(
        constraints: constraints,
        reportParentConstraints: false,
      );
      return true;
    }());
    if (constraintsError != null) {
      assert(debugCannotComputeDryLayout(error: constraintsError));
      return Size.zero;
    }

    return _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      getBaseline: _getChildBaselineDry,
    ).axisSize.toSize(direction);
  }

  FlutterError? _debugCheckConstraints({
    required BoxConstraints constraints,
    required bool reportParentConstraints,
  }) {
    FlutterError? result;
    assert(() {
      final double maxMainSize = _direction == Axis.horizontal
          ? constraints.maxWidth
          : constraints.maxHeight;
      final bool canFlex = maxMainSize < double.infinity;
      RenderBox? child = firstChild;
      while (child != null) {
        final int flex = _getFlex(child);
        if (flex > 0) {
          final String identity =
              _direction == Axis.horizontal ? 'row' : 'column';
          final String axis =
              _direction == Axis.horizontal ? 'horizontal' : 'vertical';
          final String dimension =
              _direction == Axis.horizontal ? 'width' : 'height';
          DiagnosticsNode error;
          DiagnosticsNode message;
          final List<DiagnosticsNode> addendum = <DiagnosticsNode>[];
          if (!canFlex &&
              (mainAxisSize == MainAxisSize.max ||
                  _getFit(child) == FlexFit.tight)) {
            error = ErrorSummary(
              'RenderFlex children have non-zero flex but incoming $dimension constraints are unbounded.',
            );
            message = ErrorDescription(
              'When a $identity is in a parent that does not provide a finite $dimension constraint, for example '
              'if it is in a $axis scrollable, it will try to shrink-wrap its children along the $axis '
              'axis. Setting a flex on a child (e.g. using Expanded) indicates that the child is to '
              'expand to fill the remaining space in the $axis direction.',
            );
            if (reportParentConstraints) {
              RenderBox? node = this;
              switch (_direction) {
                case Axis.horizontal:
                  while (!node!.constraints.hasBoundedWidth &&
                      node.parent is RenderBox) {
                    node = node.parent! as RenderBox;
                  }
                  if (!node.constraints.hasBoundedWidth) {
                    node = null;
                  }
                case Axis.vertical:
                  while (!node!.constraints.hasBoundedHeight &&
                      node.parent is RenderBox) {
                    node = node.parent! as RenderBox;
                  }
                  if (!node.constraints.hasBoundedHeight) {
                    node = null;
                  }
              }
              if (node != null) {
                addendum.add(
                  node.describeForError(
                    'The nearest ancestor providing an unbounded width constraint is',
                  ),
                );
              }
            }
            addendum.add(
              ErrorHint(
                'See also: https://flutter.dev/unbounded-constraints',
              ),
            );
          } else {
            return true;
          }
          result = FlutterError.fromParts(<DiagnosticsNode>[
            error,
            message,
            ErrorDescription(
              'These two directives are mutually exclusive. If a parent is to shrink-wrap its child, the child '
              'cannot simultaneously expand to fit its parent.',
            ),
            ErrorHint(
              'Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible '
              'children (using Flexible rather than Expanded). This will allow the flexible children '
              'to size themselves to less than the infinite remaining space they would otherwise be '
              'forced to take, and then will cause the RenderFlex to shrink-wrap the children '
              'rather than expanding to fit the maximum constraints provided by the parent.',
            ),
            ErrorDescription(
              'If this message did not help you determine the problem, consider using debugDumpRenderTree():\n'
              '  https://flutter.dev/to/debug-render-layer\n'
              '  https://api.flutter.dev/flutter/rendering/debugDumpRenderTree.html',
            ),
            describeForError(
              'The affected RenderFlex is',
              style: DiagnosticsTreeStyle.errorProperty,
            ),
            DiagnosticsProperty<dynamic>(
              'The creator information is set to',
              debugCreator,
              style: DiagnosticsTreeStyle.errorProperty,
            ),
            ...addendum,
            ErrorDescription(
              "If none of the above helps enough to fix this problem, please don't hesitate to file a bug:\n"
              '  https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
            ),
          ]);
          return true;
        }
        child = childAfter(child);
      }
      return true;
    }());
    return result;
  }

  _LayoutSizes _computeSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
    required double? Function(
      RenderBox child,
      BoxConstraints constraints,
      TextBaseline baseline,
    ) getBaseline,
  }) {
    assert(_debugHasNecessaryDirections);

    final double maxMainSize = _getMainSize(constraints.biggest);
    final bool canFlex = maxMainSize.isFinite;
    final BoxConstraints nonFlexChildConstraints =
        _constraintsForNonFlexChild(constraints);

    final TextBaseline? textBaseline = _isBaselineAligned
        ? (this.textBaseline ??
            (throw FlutterError(
              'To use CrossAxisAlignment.baseline, you must also specify which baseline to use using the "textBaseline" argument.',
            )))
        : null;

    int totalFlex = 0;
    RenderBox? firstFlexChild;
    _AscentDescent accumulatedAscentDescent = _AscentDescent.none;

    _AxisSize accumulatedSize =
        _AxisSize._(Size(spacing * (childCount - 1), 0.0));
    for (RenderBox? child = firstChild;
        child != null;
        child = childAfter(child)) {
      final int flex;
      if (canFlex && (flex = _getFlex(child)) > 0) {
        totalFlex += flex;
        firstFlexChild ??= child;
      } else {
        final _AxisSize childSize = _AxisSize.fromSize(
          size: layoutChild(child, nonFlexChildConstraints),
          direction: direction,
        );

        if (canFlex && childSize.mainAxisExtent > maxMainSize) {
          // e.g. child is wider than available width -> flex it
          final newFlex = (childSize.mainAxisExtent - maxMainSize).toInt();
          _fwfhFlexByRenderBox[child] = newFlex;
          totalFlex += newFlex;
          firstFlexChild ??= child;
        } else {
          _fwfhFlexByRenderBox[child] = -1;
          accumulatedSize += childSize;

          final double? baselineOffset = textBaseline == null
              ? null
              : getBaseline(child, nonFlexChildConstraints, textBaseline);
          accumulatedAscentDescent += _AscentDescent(
            baselineOffset: baselineOffset,
            crossSize: childSize.crossAxisExtent,
          );
        }
      }
    }

    assert((totalFlex == 0) == (firstFlexChild == null));
    assert(
      firstFlexChild == null || canFlex,
    );

    final double flexSpace =
        math.max(0.0, maxMainSize - accumulatedSize.mainAxisExtent);
    final double spacePerFlex = flexSpace / totalFlex;
    for (RenderBox? child = firstFlexChild;
        child != null && totalFlex > 0;
        child = childAfter(child)) {
      final int flex = _getFlex(child);
      if (flex == 0) {
        continue;
      }
      totalFlex -= flex;
      assert(spacePerFlex.isFinite);
      final double maxChildExtent = spacePerFlex * flex;
      assert(
        _getFit(child) == FlexFit.loose || maxChildExtent < double.infinity,
      );
      final BoxConstraints childConstraints = _constraintsForFlexChild(
        child,
        constraints,
        maxChildExtent,
      );
      final _AxisSize childSize = _AxisSize.fromSize(
        size: layoutChild(child, childConstraints),
        direction: direction,
      );
      accumulatedSize += childSize;
      final double? baselineOffset = textBaseline == null
          ? null
          : getBaseline(child, childConstraints, textBaseline);
      accumulatedAscentDescent += _AscentDescent(
        baselineOffset: baselineOffset,
        crossSize: childSize.crossAxisExtent,
      );
    }
    assert(totalFlex == 0);

    accumulatedSize += switch (accumulatedAscentDescent._value) {
      null => _AxisSize.empty,
      (final double ascent, final double descent) => _AxisSize(
          mainAxisExtent: 0,
          crossAxisExtent: ascent + descent,
        ),
    };

    final double idealMainSize = switch (mainAxisSize) {
      MainAxisSize.max when maxMainSize.isFinite => maxMainSize,
      MainAxisSize.max || MainAxisSize.min => accumulatedSize.mainAxisExtent,
    };

    final _AxisSize constrainedSize = _AxisSize(
      mainAxisExtent: idealMainSize,
      crossAxisExtent: accumulatedSize.crossAxisExtent,
    ).applyConstraints(constraints, direction);
    return _LayoutSizes(
      axisSize: constrainedSize,
      mainAxisFreeSpace:
          constrainedSize.mainAxisExtent - accumulatedSize.mainAxisExtent,
      baselineOffset: accumulatedAscentDescent.baselineOffset,
      spacePerFlex: firstFlexChild == null ? null : spacePerFlex,
    );
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    assert(() {
      final FlutterError? constraintsError = _debugCheckConstraints(
        constraints: constraints,
        reportParentConstraints: true,
      );
      if (constraintsError != null) {
        throw constraintsError;
      }
      return true;
    }());

    final _LayoutSizes sizes = _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
      getBaseline: _getChildBaseline,
    );

    final double crossAxisExtent = sizes.axisSize.crossAxisExtent;
    size = sizes.axisSize.toSize(direction);
    _overflow = math.max(0.0, -sizes.mainAxisFreeSpace);

    final double remainingSpace = math.max(0.0, sizes.mainAxisFreeSpace);
    final bool flipMainAxis = _flipMainAxis;
    final bool flipCrossAxis = _flipCrossAxis;
    final (double leadingSpace, double betweenSpace) =
        mainAxisAlignment._distributeSpace(
      remainingSpace,
      childCount,
      flipMainAxis,
      spacing,
    );
    final (
      RenderBox? Function(RenderBox child) nextChild,
      RenderBox? topLeftChild
    ) = flipMainAxis ? (childBefore, lastChild) : (childAfter, firstChild);
    final double? baselineOffset = sizes.baselineOffset;
    assert(
      baselineOffset == null ||
          (crossAxisAlignment == CrossAxisAlignment.baseline &&
              direction == Axis.horizontal),
    );

    double childMainPosition = leadingSpace;
    for (RenderBox? child = topLeftChild;
        child != null;
        child = nextChild(child)) {
      final double? childBaselineOffset;
      final bool baselineAlign = baselineOffset != null &&
          (childBaselineOffset =
                  child.getDistanceToBaseline(textBaseline!, onlyReal: true)) !=
              null;
      final double childCrossPosition = baselineAlign
          ? baselineOffset - childBaselineOffset!
          : crossAxisAlignment._getChildCrossAxisOffset(
              crossAxisExtent - _getCrossSize(child.size),
              flipCrossAxis,
            );
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      childParentData.offset = switch (direction) {
        Axis.horizontal => Offset(childMainPosition, childCrossPosition),
        Axis.vertical => Offset(childCrossPosition, childMainPosition),
      };
      childMainPosition += _getMainSize(child.size) + betweenSpace;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      defaultPaint(context, offset);
      return;
    }

    if (size.isEmpty) {
      return;
    }

    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: clipBehavior,
      oldLayer: _clipRectLayer.layer,
    );

    assert(() {
      final List<DiagnosticsNode> debugOverflowHints = <DiagnosticsNode>[
        ErrorDescription(
          'The overflowing $runtimeType has an orientation of $_direction.',
        ),
        ErrorDescription(
          'The edge of the $runtimeType that is overflowing has been marked '
          'in the rendering with a yellow and black striped pattern. This is '
          'usually caused by the contents being too big for the $runtimeType.',
        ),
        ErrorHint(
          'Consider applying a flex factor (e.g. using an Expanded widget) to '
          'force the children of the $runtimeType to fit within the available '
          'space instead of being sized to their natural size.',
        ),
        ErrorHint(
          'This is considered an error condition because it indicates that there '
          'is content that cannot be seen. If the content is legitimately bigger '
          'than the available space, consider clipping it with a ClipRect widget '
          'before putting it in the flex, or using a scrollable container rather '
          'than a Flex, like a ListView.',
        ),
      ];

      final Rect overflowChildRect = switch (_direction) {
        Axis.horizontal => Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0),
        Axis.vertical => Rect.fromLTWH(0.0, 0.0, 0.0, size.height + _overflow),
      };
      paintOverflowIndicator(
        context,
        offset,
        Offset.zero & size,
        overflowChildRect,
        overflowHints: debugOverflowHints,
      );
      return true;
    }());
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    switch (clipBehavior) {
      case Clip.none:
        return null;
      case Clip.hardEdge:
      case Clip.antiAlias:
      case Clip.antiAliasWithSaveLayer:
        return _hasOverflow ? Offset.zero & size : null;
    }
  }

  @override
  String toStringShort() {
    String header = super.toStringShort();
    if (!kReleaseMode) {
      if (_hasOverflow) {
        header += ' OVERFLOWING';
      }
    }
    return header;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(
      EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment',
        mainAxisAlignment,
      ),
    );
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize));
    properties.add(
      EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment',
        crossAxisAlignment,
      ),
    );
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<VerticalDirection>(
        'verticalDirection',
        verticalDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<TextBaseline>(
        'textBaseline',
        textBaseline,
        defaultValue: null,
      ),
    );
    properties.add(DoubleProperty('spacing', spacing, defaultValue: null));
  }
}
