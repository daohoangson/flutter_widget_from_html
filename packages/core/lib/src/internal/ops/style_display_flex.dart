part of '../core_ops.dart';

const kCssFlexDirection = 'flex-direction';
const kCssFlexDirectionColumn = 'column';
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
      alwaysRenderBlock: true,
      onRenderedChildren: (tree, children) {
        if (children.isEmpty) {
          return null;
        }

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

        return WidgetPlaceholder(
          debugLabel: kCssDisplayFlex,
          builder: (context, _) {
            var unwrapped = children
                .map((child) => WidgetPlaceholder.unwrap(context, child))
                // adjustment 1: remove empty children to avoid incorrect layout
                .where((child) => child != widget0)
                .toList(growable: false);

            if (unwrapped.length == 1) {
              // adjustment 2: enforce sizing hint for the only child
              unwrapped = [CssSizing(child: unwrapped[0])];
            }

            return wf.buildFlex(
              tree,
              unwrapped,
              crossAxisAlignment: _toCrossAxisAlignment(alignItems),
              direction: flexDirection == kCssFlexDirectionRow
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisAlignment: _toMainAxisAlignment(justifyContent),
            );
          },
        );
      },
      priority: Priority.displayFlex,
    );
  }

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
