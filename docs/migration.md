# Migration from v0.10 to v0.14

[PR #897](https://github.com/daohoangson/flutter_widget_from_html/pull/897) is a big change that might break things in existing app. We made it easier to understand how the package parses HTML into a Flutter widget tree. The main goals were:

1. Merge `BuildMetadata` and `BuildTree`.
2. Simplify `BuildOp` callbacks
3. Clearly show which properties are inherited from parent elements and which are not.

## BuildBit

This core class has been greatly simplified and it no longer uses generic type arguments.

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

Instead of returning `String` for text, `WidgetSpan` for inline, `Widget` for block, you must call the appropriate method on `Flattened`.

### detach, insertAfter and insertBefore

Initially, these methods were necessary to support features that required modifying the build tree. However, starting from version 0.14, you should utilize the `BuildOp.onParsed` callback and return the entirely new tree.

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

## BuildOp

We made changes to the `BuildOp` that allow you to use the old methods and properties, but they are marked as deprecated. It's a good idea to switch to the new methods as soon as possible.

<table><tr><th>Before</th><th>After</th></tr><tr><td>

```dart
final oldOp = BuildOp({
  defaultStyles: (dom.Element element) => {'color': 'red'},
  onChild: (BuildMetadata childMeta) {},
  onTree: (BuildMetadata meta, BuildTree tree) {},
  onTreeFlattening: (BuildMetadata meta, BuildTree tree) {},
  onWidgets: (BuildMetadata meta, Iterable<WidgetPlaceholder> widgets) => [Container()],
  onWidgetsIsOptional: false,
  priority: 10,
})
```

</td><td>

```dart
final newOp = BuildOp(
  alwaysRenderBlock: true,
  debugLabel: 'v0.14',
  defaultStyles: (dom.Element element) => {'color': 'red'},
  onParsed: (BuildTree tree) => tree,
  onRenderBlock: (BuildTree tree, WidgetPlaceholder placeholder) => Container(),
  onRenderInline: (BuildTree tree) {},
  onRenderedBlock: (BuildTree tree, Widget block) {},
  onVisitChild: (BuildTree tree, BuildTree subTree) {},
  priority: 10,
)
```

</td></tr></table>

- `BuildMetadata` and `BuildTree` have been merged together so the callback signatures no longer require two arguments
- he roles of the callbacks are mostly the same, but we've changed their names to make them easier to understand
- The `defaultStyles` callback still has the same signature, but now the styles are added at the end of the list instead of the beginning
- `onTree` is now `onParsed` and allow you to return a new tree
- `onWidgets` is now `onRenderBlock`, and children widgets have been parsed into a single `WidgetPlaceholder`. This callback can wrap the placeholder or returning a new one as needed

## TextStyleHtml

### InheritedProperties

The entire `TextStyleHtml` class has been marked as deprecated, its successor is the `InheritedProperties` class. However, if you have legacy code using `TextStyleHtml`, it will continue to work.

### getDependency

Similarly, the `getDependency` method has been deprecated, and you should use `get` to retrieve values by their type. It's worth noting that, for performance reasons, `v0.14` no longer depends on `MediaQueryData` to avoid excessive rebuild. Therefore, attempting to use either `getDependency<MediaQueryData>` or `get<MediaQueryData>` will not work.
