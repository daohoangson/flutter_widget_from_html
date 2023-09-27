import 'package:flutter/material.dart';

import '../../../flutter_widget_from_html_core.dart';
import '../core_ops.dart';

// ignore: avoid_classes_with_only_static_members
class FlexOps {

  /// Builds custom widget for div elements with display: flex from [meta]
  static BuildOp flexOp(BuildMetadata meta) {
    return BuildOp(
      onChild: (childMeta) {
        childMeta.register(_flexItemOp(childMeta));
      },
      onWidgets: (meta, widgets) {
        final String id = meta.element.id;
        String flexDirection = 'row';
        String justifyContent = 'flex-start';
        String alignItems = 'flex-start';

        for (final element in meta.element.styles) {
          final String? value = element.term;

          if (value != null) {
            switch (element.property) {
              case 'flex-direction':
                flexDirection = value;
              break;
              case 'justify-content':
                justifyContent = value;
              break;
              case 'align-items':
                alignItems = value;
              break;
            }
          }
        }

        return [
          Flex(
            key: Key(id),
            direction: 'row' == flexDirection ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: _toMainAxisAlignment(justifyContent),
            crossAxisAlignment: _toCrossAxisAlignment(alignItems),
            children: widgets.toList()
          )
        ];
      },      
    );
  }

  /// Build op for child elements of flex containers
  static BuildOp _flexItemOp(BuildMetadata meta) {
    return BuildOp(
      defaultStyles: (element) {
        return {
          kCssWidth: "auto",
          kCssHeight: "auto"
        };
      }
    );
  }

  /// Converts CSS [justifyContent] to Flutter Grid MainAxisAlignment
  static MainAxisAlignment _toMainAxisAlignment(String justifyContent) {
    switch (justifyContent) {
      case 'flex-start':
        return MainAxisAlignment.start;
      case 'flex-end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'space-between':
        return MainAxisAlignment.spaceBetween;
      case 'space-around':
        return MainAxisAlignment.spaceAround;
      case 'space-evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  /// Converts CSS [alignItems] to Flutter Grid CrossAxisAlignment
  static CrossAxisAlignment _toCrossAxisAlignment(String alignItems) {
    switch (alignItems) {
      case 'flex-start':
        return CrossAxisAlignment.start;
      case 'flex-end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }
  
}
