import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' hide RenderFlex;
import 'package:flutter/rendering.dart' as flutter show RenderFlex;
import 'package:flutter/widgets.dart'
    show BuildContext, Directionality, MultiChildRenderObjectWidget;
import 'package:flutter/widgets.dart' as flutter show Flex;

bool? _startIsTopLeft(
  Axis direction,
  TextDirection? textDirection,
  VerticalDirection? verticalDirection,
) {
  // If the relevant value of textDirection or verticalDirection is null, this returns null too.
  switch (direction) {
    case Axis.horizontal:
      switch (textDirection) {
        case TextDirection.ltr:
          return true;
        case TextDirection.rtl:
          return false;
        case null:
          return null;
      }
    case Axis.vertical:
      switch (verticalDirection) {
        case VerticalDirection.down:
          return true;
        case VerticalDirection.up:
          return false;
        case null:
          return null;
      }
  }
}

// ignore: avoid_private_typedef_functions
typedef _ChildSizingFunction = double Function(RenderBox child, double extent);

class HtmlFlex extends MultiChildRenderObjectWidget
    implements
        // ignore: avoid_implementing_value_types
        flutter.Flex {
  const HtmlFlex({
    super.key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.clipBehavior = Clip.none,
    super.children,
  }) : assert(
          !identical(
                crossAxisAlignment,
                CrossAxisAlignment.baseline,
              ) ||
              textBaseline != null,
          'textBaseline is required if you specify the crossAxisAlignment with CrossAxisAlignment.baseline',
        );
  // Cannot use == in the assert above instead of identical because of https://github.com/dart-lang/language/issues/1811.

  @override
  final Axis direction;

  @override
  final MainAxisAlignment mainAxisAlignment;

  @override
  final MainAxisSize mainAxisSize;

  @override
  final CrossAxisAlignment crossAxisAlignment;

  @override
  final TextDirection? textDirection;

  @override
  final VerticalDirection verticalDirection;

  @override
  final TextBaseline? textBaseline;

  @override
  final Clip clipBehavior;

  bool get _needTextDirection {
    switch (direction) {
      case Axis.horizontal:
        return true; // because it affects the layout order.
      case Axis.vertical:
        return crossAxisAlignment == CrossAxisAlignment.start ||
            crossAxisAlignment == CrossAxisAlignment.end;
    }
  }

  @override
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    return textDirection ??
        (_needTextDirection ? Directionality.maybeOf(context) : null);
  }

  @override
  flutter.RenderFlex createRenderObject(BuildContext context) {
    return _HtmlFlexRenderObject(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant flutter.RenderFlex renderObject,
  ) {
    renderObject
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = verticalDirection
      ..textBaseline = textBaseline
      ..clipBehavior = clipBehavior;
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
  }
}

class _HtmlFlexRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData>,
        DebugOverflowIndicatorMixin
    implements flutter.RenderFlex {
  /// Creates a flex render object.
  ///
  /// By default, the flex layout is horizontal and children are aligned to the
  /// start of the main axis and the center of the cross axis.
  _HtmlFlexRenderObject({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Clip clipBehavior = Clip.none,
  })  : _direction = direction,
        _mainAxisAlignment = mainAxisAlignment,
        _mainAxisSize = mainAxisSize,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection,
        _verticalDirection = verticalDirection,
        _textBaseline = textBaseline,
        _clipBehavior = clipBehavior {
    addAll(children);
  }

  @override
  Axis get direction => _direction;
  Axis _direction;
  @override
  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  @override
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  MainAxisAlignment _mainAxisAlignment;
  @override
  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment != value) {
      _mainAxisAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  MainAxisSize get mainAxisSize => _mainAxisSize;
  MainAxisSize _mainAxisSize;
  @override
  set mainAxisSize(MainAxisSize value) {
    if (_mainAxisSize != value) {
      _mainAxisSize = value;
      markNeedsLayout();
    }
  }

  @override
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;
  @override
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  @override
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  VerticalDirection get verticalDirection => _verticalDirection;
  VerticalDirection _verticalDirection;
  @override
  set verticalDirection(VerticalDirection value) {
    if (_verticalDirection != value) {
      _verticalDirection = value;
      markNeedsLayout();
    }
  }

  @override
  TextBaseline? get textBaseline => _textBaseline;
  TextBaseline? _textBaseline;
  @override
  set textBaseline(TextBaseline? value) {
    assert(_crossAxisAlignment != CrossAxisAlignment.baseline || value != null);
    if (_textBaseline != value) {
      _textBaseline = value;
      markNeedsLayout();
    }
  }

  bool get _debugHasNecessaryDirections {
    if (firstChild != null && lastChild != firstChild) {
      // i.e. there's more than one child
      switch (direction) {
        case Axis.horizontal:
          assert(
            textDirection != null,
            'Horizontal $runtimeType with multiple children has a null textDirection, so the layout order is undefined.',
          );
          break;
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
          break;
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

  // Set during layout if overflow occurred on the main axis.
  double _overflow = 0;
  // Check whether any meaningful overflow is present. Values below an epsilon
  // are treated as not overflowing.
  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  @override
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;
  @override
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  bool get _canComputeIntrinsics =>
      crossAxisAlignment != CrossAxisAlignment.baseline;

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double
        extent, // the extent in the direction that isn't the sizing direction
    required _ChildSizingFunction
        childSize, // a method to find the size in the sizing direction
  }) {
    if (!_canComputeIntrinsics) {
      // Intrinsics cannot be calculated without a full layout for
      // baseline alignment. Throw an assertion and return 0.0 as documented
      // on [RenderBox.computeMinIntrinsicWidth].
      assert(
        RenderObject.debugCheckingIntrinsics,
        'Intrinsics are not available for CrossAxisAlignment.baseline.',
      );
      return 0.0;
    }
    if (_direction == sizingDirection) {
      // INTRINSIC MAIN SIZE
      // Intrinsic main size is the smallest size the flex container can take
      // while maintaining the min/max-content contributions of its flex items.
      double totalFlex = 0.0;
      double inflexibleSpace = 0.0;
      double maxFlexFractionSoFar = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        final int flex = _getFlex(child);
        totalFlex += flex;
        if (flex > 0) {
          final double flexFraction =
              childSize(child, extent) / _getFlex(child);
          maxFlexFractionSoFar = math.max(maxFlexFractionSoFar, flexFraction);
        } else {
          inflexibleSpace += childSize(child, extent);
        }
        final FlexParentData childParentData =
            child.parentData! as FlexParentData;
        child = childParentData.nextSibling;
      }
      return maxFlexFractionSoFar * totalFlex + inflexibleSpace;
    } else {
      // INTRINSIC CROSS SIZE
      // Intrinsic cross size is the max of the intrinsic cross sizes of the
      // children, after the flexible children are fit into the available space,
      // with the children sized using their max intrinsic dimensions.

      // Get inflexible space using the max intrinsic dimensions of fixed children in the main direction.
      final double availableMainSpace = extent;
      int totalFlex = 0;
      double inflexibleSpace = 0.0;
      double maxCrossSize = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        final int flex = _getFlex(child);
        totalFlex += flex;
        late final double mainSize;
        late final double crossSize;
        if (flex == 0) {
          switch (_direction) {
            case Axis.horizontal:
              mainSize = child.getMaxIntrinsicWidth(double.infinity);
              crossSize = childSize(child, mainSize);
              break;
            case Axis.vertical:
              mainSize = child.getMaxIntrinsicHeight(double.infinity);
              crossSize = childSize(child, mainSize);
          }
          inflexibleSpace += mainSize;
          maxCrossSize = math.max(maxCrossSize, crossSize);
        }
        final FlexParentData childParentData =
            child.parentData! as FlexParentData;
        child = childParentData.nextSibling;
      }

      // Determine the spacePerFlex by allocating the remaining available space.
      // When you're overconstrained spacePerFlex can be negative.
      final double spacePerFlex =
          math.max(0.0, (availableMainSpace - inflexibleSpace) / totalFlex);

      // Size remaining (flexible) items, find the maximum cross size.
      child = firstChild;
      while (child != null) {
        final int flex = _getFlex(child);
        if (flex > 0) {
          maxCrossSize =
              math.max(maxCrossSize, childSize(child, spacePerFlex * flex));
        }
        final FlexParentData childParentData =
            child.parentData! as FlexParentData;
        child = childParentData.nextSibling;
      }

      return maxCrossSize;
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
    if (_direction == Axis.horizontal) {
      return defaultComputeDistanceToHighestActualBaseline(baseline);
    }
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  int _getFlex(RenderBox child) {
    final FlexParentData childParentData = child.parentData! as FlexParentData;
    return childParentData.flex ?? 0;
  }

  FlexFit _getFit(RenderBox child) {
    final FlexParentData childParentData = child.parentData! as FlexParentData;
    return childParentData.fit ?? FlexFit.tight;
  }

  double _getCrossSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.height;
      case Axis.vertical:
        return size.width;
    }
  }

  double _getMainSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (!_canComputeIntrinsics) {
      assert(
        debugCannotComputeDryLayout(
          reason:
              'Dry layout cannot be computed for CrossAxisAlignment.baseline, which requires a full layout.',
        ),
      );
      return Size.zero;
    }
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

    final _LayoutSizes sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      constraints: constraints,
    );

    switch (_direction) {
      case Axis.horizontal:
        return constraints.constrain(Size(sizes.mainSize, sizes.crossSize));
      case Axis.vertical:
        return constraints.constrain(Size(sizes.crossSize, sizes.mainSize));
    }
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
          // ignore: avoid_multiple_declarations_per_line
          DiagnosticsNode error, message;
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
              // Constraints of parents are unavailable in dry layout.
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
                  break;
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
              '  https://flutter.dev/debugging/#rendering-layer\n'
              '  http://api.flutter.dev/flutter/rendering/debugDumpRenderTree.html',
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
  }) {
    assert(_debugHasNecessaryDirections);

    // Determine used flex factor, size inflexible items, calculate free space.
    int totalFlex = 0;
    final double maxMainSize = _direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final bool canFlex = maxMainSize < double.infinity;

    double crossSize = 0.0;
    double allocatedSize =
        0.0; // Sum of the sizes of the non-flexible children.
    RenderBox? child = firstChild;
    RenderBox? lastFlexChild;
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      final int flex = _getFlex(child);
      if (flex > 0) {
        totalFlex += flex;
        lastFlexChild = child;
      } else {
        final BoxConstraints innerConstraints;
        if (crossAxisAlignment == CrossAxisAlignment.stretch) {
          switch (_direction) {
            case Axis.horizontal:
              innerConstraints =
                  BoxConstraints.tightFor(height: constraints.maxHeight);
              break;
            case Axis.vertical:
              innerConstraints =
                  BoxConstraints.tightFor(width: constraints.maxWidth);
          }
        } else {
          switch (_direction) {
            case Axis.horizontal:
              innerConstraints =
                  BoxConstraints(maxHeight: constraints.maxHeight);
              break;
            case Axis.vertical:
              innerConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
          }
        }
        final Size childSize = layoutChild(child, innerConstraints);
        allocatedSize += _getMainSize(childSize);
        crossSize = math.max(crossSize, _getCrossSize(childSize));
      }
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    // Distribute free space to flexible children.
    final double freeSpace =
        math.max(0.0, (canFlex ? maxMainSize : 0.0) - allocatedSize);
    double allocatedFlexSpace = 0.0;
    if (totalFlex > 0) {
      final double spacePerFlex =
          canFlex ? (freeSpace / totalFlex) : double.nan;
      child = firstChild;
      while (child != null) {
        final int flex = _getFlex(child);
        if (flex > 0) {
          final double maxChildExtent = canFlex
              ? (child == lastFlexChild
                  ? (freeSpace - allocatedFlexSpace)
                  : spacePerFlex * flex)
              : double.infinity;
          late final double minChildExtent;
          switch (_getFit(child)) {
            case FlexFit.tight:
              assert(maxChildExtent < double.infinity);
              minChildExtent = maxChildExtent;
              break;
            case FlexFit.loose:
              minChildExtent = 0.0;
          }
          final BoxConstraints innerConstraints;
          if (crossAxisAlignment == CrossAxisAlignment.stretch) {
            switch (_direction) {
              case Axis.horizontal:
                innerConstraints = BoxConstraints(
                  minWidth: minChildExtent,
                  maxWidth: maxChildExtent,
                  minHeight: constraints.maxHeight,
                  maxHeight: constraints.maxHeight,
                );
                break;
              case Axis.vertical:
                innerConstraints = BoxConstraints(
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth,
                  minHeight: minChildExtent,
                  maxHeight: maxChildExtent,
                );
            }
          } else {
            switch (_direction) {
              case Axis.horizontal:
                innerConstraints = BoxConstraints(
                  minWidth: minChildExtent,
                  maxWidth: maxChildExtent,
                  maxHeight: constraints.maxHeight,
                );
                break;
              case Axis.vertical:
                innerConstraints = BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  minHeight: minChildExtent,
                  maxHeight: maxChildExtent,
                );
            }
          }
          final Size childSize = layoutChild(child, innerConstraints);
          final double childMainSize = _getMainSize(childSize);
          assert(childMainSize <= maxChildExtent);
          allocatedSize += childMainSize;
          allocatedFlexSpace += maxChildExtent;
          crossSize = math.max(crossSize, _getCrossSize(childSize));
        }
        final FlexParentData childParentData =
            child.parentData! as FlexParentData;
        child = childParentData.nextSibling;
      }
    }

    final double idealSize = canFlex && mainAxisSize == MainAxisSize.max
        ? maxMainSize
        : allocatedSize;
    return _LayoutSizes(
      mainSize: idealSize,
      crossSize: crossSize,
      allocatedSize: allocatedSize,
    );
  }

  @override
  void performLayout() {
    assert(_debugHasNecessaryDirections);
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
      layoutChild: ChildLayoutHelper.layoutChild,
      constraints: constraints,
    );

    final double allocatedSize = sizes.allocatedSize;
    double actualSize = sizes.mainSize;
    double crossSize = sizes.crossSize;
    double maxBaselineDistance = 0.0;
    if (crossAxisAlignment == CrossAxisAlignment.baseline) {
      RenderBox? child = firstChild;
      double maxSizeAboveBaseline = 0;
      double maxSizeBelowBaseline = 0;
      while (child != null) {
        assert(() {
          if (textBaseline == null) {
            throw FlutterError(
              'To use CrossAxisAlignment.baseline, you must also specify which baseline to use using the "textBaseline" argument.',
            );
          }
          return true;
        }());
        final double? distance =
            child.getDistanceToBaseline(textBaseline!, onlyReal: true);
        if (distance != null) {
          maxBaselineDistance = math.max(maxBaselineDistance, distance);
          maxSizeAboveBaseline = math.max(
            distance,
            maxSizeAboveBaseline,
          );
          maxSizeBelowBaseline = math.max(
            child.size.height - distance,
            maxSizeBelowBaseline,
          );
          crossSize =
              math.max(maxSizeAboveBaseline + maxSizeBelowBaseline, crossSize);
        }
        final FlexParentData childParentData =
            child.parentData! as FlexParentData;
        child = childParentData.nextSibling;
      }
    }

    // Align items along the main axis.
    switch (_direction) {
      case Axis.horizontal:
        size = constraints.constrain(Size(actualSize, crossSize));
        actualSize = size.width;
        crossSize = size.height;
        break;
      case Axis.vertical:
        size = constraints.constrain(Size(crossSize, actualSize));
        actualSize = size.height;
        crossSize = size.width;
    }
    final double actualSizeDelta = actualSize - allocatedSize;
    _overflow = math.max(0.0, -actualSizeDelta);
    final double remainingSpace = math.max(0.0, actualSizeDelta);
    late final double leadingSpace;
    late final double betweenSpace;
    // flipMainAxis is used to decide whether to lay out
    // left-to-right/top-to-bottom (false), or right-to-left/bottom-to-top
    // (true). The _startIsTopLeft will return null if there's only one child
    // and the relevant direction is null, in which case we arbitrarily decide
    // to flip, but that doesn't have any detectable effect.
    final bool flipMainAxis =
        !(_startIsTopLeft(direction, textDirection, verticalDirection) ?? true);
    switch (_mainAxisAlignment) {
      case MainAxisAlignment.start:
        leadingSpace = 0.0;
        betweenSpace = 0.0;
        break;
      case MainAxisAlignment.end:
        leadingSpace = remainingSpace;
        betweenSpace = 0.0;
        break;
      case MainAxisAlignment.center:
        leadingSpace = remainingSpace / 2.0;
        betweenSpace = 0.0;
        break;
      case MainAxisAlignment.spaceBetween:
        leadingSpace = 0.0;
        betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;
        break;
      case MainAxisAlignment.spaceAround:
        betweenSpace = childCount > 0 ? remainingSpace / childCount : 0.0;
        leadingSpace = betweenSpace / 2.0;
        break;
      case MainAxisAlignment.spaceEvenly:
        betweenSpace = childCount > 0 ? remainingSpace / (childCount + 1) : 0.0;
        leadingSpace = betweenSpace;
    }

    // Position elements
    double childMainPosition =
        flipMainAxis ? actualSize - leadingSpace : leadingSpace;
    RenderBox? child = firstChild;
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      final double childCrossPosition;
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.start:
        case CrossAxisAlignment.end:
          childCrossPosition = _startIsTopLeft(
                    flipAxis(direction),
                    textDirection,
                    verticalDirection,
                  ) ==
                  (_crossAxisAlignment == CrossAxisAlignment.start)
              ? 0.0
              : crossSize - _getCrossSize(child.size);
          break;
        case CrossAxisAlignment.center:
          childCrossPosition =
              crossSize / 2.0 - _getCrossSize(child.size) / 2.0;
          break;
        case CrossAxisAlignment.stretch:
          childCrossPosition = 0.0;
          break;
        case CrossAxisAlignment.baseline:
          if (_direction == Axis.horizontal) {
            assert(textBaseline != null);
            final double? distance =
                child.getDistanceToBaseline(textBaseline!, onlyReal: true);
            if (distance != null) {
              childCrossPosition = maxBaselineDistance - distance;
            } else {
              childCrossPosition = 0.0;
            }
          } else {
            childCrossPosition = 0.0;
          }
      }
      if (flipMainAxis) {
        childMainPosition -= _getMainSize(child.size);
      }
      switch (_direction) {
        case Axis.horizontal:
          childParentData.offset =
              Offset(childMainPosition, childCrossPosition);
          break;
        case Axis.vertical:
          childParentData.offset =
              Offset(childCrossPosition, childMainPosition);
      }
      if (flipMainAxis) {
        childMainPosition -= betweenSpace;
      } else {
        childMainPosition += _getMainSize(child.size) + betweenSpace;
      }
      child = childParentData.nextSibling;
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

    // There's no point in drawing the children if we're empty.
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

      // Simulate a child rect that overflows by the right amount. This child
      // rect is never used for drawing, just for determining the overflow
      // location and amount.
      final Rect overflowChildRect;
      switch (_direction) {
        case Axis.horizontal:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0);
          break;
        case Axis.vertical:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, 0.0, size.height + _overflow);
      }
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
  }
}

class _LayoutSizes {
  const _LayoutSizes({
    required this.mainSize,
    required this.crossSize,
    required this.allocatedSize,
  });

  final double mainSize;
  final double crossSize;
  final double allocatedSize;
}
