part of '../core_ops.dart';

const kCssFlexDirection = 'flex-direction';
const kCssFlexDirectionRow = 'row';
const kCssJustifyContent = 'justify-content';
const kCssJustifyContentFlexStart = 'flex-start';
const kCssJustifyContentFlexEnd = 'flex-end';
const kCssJustifyContentCenter = 'center';
const kCssJustifyContentSpaceBetween = 'space-between';
const kCssJustifyContentSpaceAround = 'space-around';
const kCssJustifyContentSpaceEvenly = 'space-evenly';
const kCssAlignItems = 'align-items';
const kCssAlignItemsFlexStart = 'flex-start';
const kCssAlignItemsFlexEnd = 'flex-end';
const kCssAlignItemsCenter = 'center';
const kCssAlignItemsBaseline = 'baseline';
const kCssAlignItemsStretch = 'stretch';

class StyleDisplayFlex {
  final WidgetFactory wf;

  StyleDisplayFlex(this.wf);

  BuildOp get buildOp {
    return BuildOp(
      onVisitChild: (tree, subTree) {
        if (subTree.element.parent != tree.element) {
          return;
        }

        const itemOp = BuildOp.v2(defaultStyles: _itemDefaultStyles);
        subTree.register(itemOp);
      },
      onRenderBlock: (tree, placeholder) {
        String flexDirection = kCssFlexDirectionRow;
        String justifyContent = kCssJustifyContentFlexStart;
        String alignItems = kCssAlignItemsFlexStart;

        for (final element in tree.element.styles) {
          final String? value = element.term;

          if (value != null) {
            switch (element.property) {
              case kCssFlexDirection:
                flexDirection = value;
                break;
              case kCssJustifyContent:
                justifyContent = value;
                break;
              case kCssAlignItems:
                alignItems = value;
                break;
            }
          }
        }

        final flex = wf.buildFlex(
          tree,
          [placeholder],
          crossAxisAlignment: _toCrossAxisAlignment(alignItems),
          direction: flexDirection == kCssFlexDirectionRow
              ? Axis.horizontal
              : Axis.vertical,
          mainAxisAlignment: _toMainAxisAlignment(justifyContent),
        );

        return flex ?? placeholder;
      },
      priority: Priority.displayFlex,
    );
  }

  static StylesMap _itemDefaultStyles(dom.Element _) => const {
        kCssWidth: kCssLengthAuto,
        kCssHeight: kCssLengthAuto,
      };

  /// Converts CSS [justifyContent] to Flutter Grid MainAxisAlignment
  static MainAxisAlignment _toMainAxisAlignment(String justifyContent) {
    switch (justifyContent) {
      case kCssJustifyContentFlexStart:
        return MainAxisAlignment.start;
      case kCssJustifyContentFlexEnd:
        return MainAxisAlignment.end;
      case kCssJustifyContentCenter:
        return MainAxisAlignment.center;
      case kCssJustifyContentSpaceBetween:
        return MainAxisAlignment.spaceBetween;
      case kCssJustifyContentSpaceAround:
        return MainAxisAlignment.spaceAround;
      case kCssJustifyContentSpaceEvenly:
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  /// Converts CSS [alignItems] to Flutter Grid CrossAxisAlignment
  static CrossAxisAlignment _toCrossAxisAlignment(String alignItems) {
    switch (alignItems) {
      case kCssAlignItemsFlexStart:
        return CrossAxisAlignment.start;
      case kCssAlignItemsFlexEnd:
        return CrossAxisAlignment.end;
      case kCssAlignItemsCenter:
        return CrossAxisAlignment.center;
      case kCssAlignItemsBaseline:
        return CrossAxisAlignment.baseline;
      case kCssAlignItemsStretch:
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }
}
