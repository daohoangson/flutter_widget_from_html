# Migration from v0.10 to v0.14

PR #897 is a big change that might break things in existing app. We made it easier to understand how the package parse HTML into a Flutter widget tree. The main goals were:

1. Merge `BuildMetadata` and `BuildTree`.
2. Simplify `BuildOp` callbacks
3. Clearly show which properties are inherited from parent elements and which are not.

## BuildBit

This core class has been greatly simplified and doesn't have any generic type argument.

```diff
-abstract class BuildBit<InputType, OutputType> {
+abstract class BuildBit {
-  OutputType buildBit(InputType input);
-  bool detach();
+  void flatten(Flattened f);
-  bool insertAfter(BuildBit another);
-  bool insertBefore(BuildBit another);
}
```

### buildBit

This method has been replaced with `flatten`. It will receive an object that looks like this:

```dart
abstract class Flattened {
  void inlineWidget({ required Widget child });
  void widget(Widget value);
  void write({String? text, String? whitespace});
}
```

Instead of returning `String` for text, `WidgetSpan` for inline widget, `Widget` for block widget, you must call the appropriate method on `Flattened`.

### detach, insertAfter and insertBefore

These methods were needed to support feature that must modify the build tree in some way. Since `v0.14`, use `BuildOp.onParsed` callback and return the new tree in entirely.

<table><tr><th>Before</th><th>After</th></tr><tr><td>

```dart
final oldOp = BuildOp(
  onTreeFlattening: (meta, tree) {
    final foo = WidgetBit.inline(tree.parent!, Text('foo'));
    foo.insertBefore(tree);
    tree.detach();
  }
)
```

</td><td>

```dart
final newOp = BuildOp(
  onParsed: (tree) {
    final newTree = tree.parent.sub();
    newTree.append(WidgetBit.inline(tree, Text('foo')));
    return newTree;
  }
)
```

</td></tr></table>