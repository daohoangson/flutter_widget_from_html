import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kTagForm = 'form';
const kTagInput = 'input';
const kTagTextArea = 'textarea';
const kAttributeInputType = 'type';
const kAttributeInputValue = 'value';
const kAttributeInputPlaceholder = 'placeholder';

class TagForm {
  final FormFactory wf;

  TagForm(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagForm,
        alwaysRenderBlock: true,
        onRenderedChildren: (tree, children) {
          final column = wf.buildColumnPlaceholder(tree, children);
          if (column == null) {
            return null;
          }
          return column..wrapWith((context, child) => Form(child: child));
        },
      );
}

class TagInput {
  BuildOp get buildOp => BuildOp(
        debugLabel: kTagInput,
        onRenderBlock: (tree, placeholder) {
          final attrs = tree.element.attributes;
          final type = attrs[kAttributeInputType] ?? 'text';
          switch (type) {
            case 'text':
              return WidgetPlaceholder(
                debugLabel: kTagInput,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: attrs[kAttributeInputPlaceholder],
                  ),
                  initialValue: attrs[kAttributeInputValue],
                ),
              );
            case 'submit':
              final label = attrs[kAttributeInputValue] ?? 'Submit';
              return WidgetPlaceholder(
                debugLabel: kTagInput,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(label),
                ),
              );
            default:
              return placeholder;
          }
        },
      );
}

class TagTextArea {
  BuildOp get buildOp => BuildOp(
        debugLabel: kTagTextArea,
        onRenderBlock: (tree, placeholder) {
          final attrs = tree.element.attributes;
          return WidgetPlaceholder(
            debugLabel: kTagTextArea,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: attrs[kAttributeInputPlaceholder],
              ),
              initialValue: tree.element.text,
              maxLines: null,
            ),
          );
        },
      );
}
