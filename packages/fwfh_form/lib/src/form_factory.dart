import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/tag_form.dart';

/// A mixin that can render simple HTML forms.
mixin FormFactory on WidgetFactory {
  BuildOp? _tagForm;
  BuildOp? _tagInput;
  BuildOp? _tagTextArea;

  @override
  void parse(BuildTree tree) {
    switch (tree.element.localName) {
      case kTagForm:
        tree.register(_tagForm ??= TagForm(this).buildOp);
      case kTagInput:
        tree.register(_tagInput ??= TagInput().buildOp);
      case kTagTextArea:
        tree.register(_tagTextArea ??= TagTextArea().buildOp);
    }
    super.parse(tree);
  }
}
