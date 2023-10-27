import 'package:flutter/material.dart';

import '../../../flutter_widget_from_html_core.dart';
import '../core_ops.dart';

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

// ignore: avoid_classes_with_only_static_members
class StyleDisplayFlexOps {
  /// Builds custom widget for div elements with display: flex from [meta]
  static BuildOp flexOp(BuildTree tree) {
    return BuildOp(
      onVisitChild: (tree, subTree) {
        subTree.register(_flexItemOp(subTree));
      },
      onRenderBlock: (tree, placeholder) {
        final String id = tree.element.id;
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

        return Flex(
          key: Key(id),
          direction: kCssFlexDirectionRow == flexDirection
              ? Axis.horizontal
              : Axis.vertical,
          mainAxisAlignment: _toMainAxisAlignment(justifyContent),
          crossAxisAlignment: _toCrossAxisAlignment(alignItems),
          children: [
            placeholder,
          ],
        );
      },
    );
  }

  /// Build op for child elements of flex containers
  static BuildOp _flexItemOp(BuildTree tree) {
    return BuildOp(defaultStyles: (element) {
      return {kCssWidth: kCssWidthAuto, kCssHeight: kCssHeightAuto};
    });
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
