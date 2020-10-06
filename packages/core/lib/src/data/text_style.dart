part of '../core_data.dart';

/// A text style.
@immutable
class TextStyleHtml {
  final Iterable<dynamic> _deps;

  /// The line height.
  final double height;

  /// The number of max lines that should be rendered.
  final int maxLines;

  /// The parent style.
  final TextStyleHtml parent;

  /// The input [TextStyle].
  final TextStyle style;

  /// The text alignment.
  final TextAlign textAlign;

  /// The text direction.
  final TextDirection textDirection;

  /// The overflow behavior.
  final TextOverflow textOverflow;

  /// Creates a text style.
  TextStyleHtml({
    @required Iterable deps,
    this.height,
    this.maxLines,
    this.parent,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textOverflow,
  }) : _deps = deps;

  /// Creates the root text style.
  factory TextStyleHtml.root(
      Iterable<dynamic> deps, TextStyle widgetTextStyle) {
    var style = _getDependency<TextStyle>(deps);
    if (widgetTextStyle != null) {
      style = widgetTextStyle.inherit
          ? style.merge(widgetTextStyle)
          : widgetTextStyle;
    }

    var mqd = _getDependency<MediaQueryData>(deps);
    final tsf = mqd.textScaleFactor;
    if (tsf != 1) {
      style = style.copyWith(fontSize: style.fontSize * tsf);
    }

    return TextStyleHtml(
      deps: deps,
      parent: null,
      style: style,
      textDirection: _getDependency<TextDirection>(deps),
    );
  }

  /// Returns a [TextStyle] merged from [style] and [height].
  ///
  /// This needs to be done because
  /// `TextStyle` with existing height cannot be copied with `height=null`.
  /// See [flutter/flutter#58765](https://github.com/flutter/flutter/issues/58765).
  TextStyle get styleWithHeight =>
      height != null && height >= 0 ? style.copyWith(height: height) : style;

  /// Creates a copy with the given fields replaced with the new values.
  TextStyleHtml copyWith({
    double height,
    int maxLines,
    TextStyleHtml parent,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    TextOverflow textOverflow,
  }) =>
      TextStyleHtml(
        deps: _deps,
        height: height ?? this.height,
        maxLines: maxLines ?? this.maxLines,
        parent: parent ?? this.parent,
        style: style ?? this.style,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        textOverflow: textOverflow ?? this.textOverflow,
      );

  /// Gets dependency value by type.
  ///
  /// See [WidgetFactory.getDependencies].
  T getDependency<T>() => _getDependency<T>(_deps);

  static T _getDependency<T>(Iterable<dynamic> deps) {
    for (final value in deps.whereType<T>()) {
      return value;
    }

    return null;
  }
}

/// A text styling builder.
class TextStyleBuilder<T1> {
  /// The parent builder.
  final TextStyleBuilder parent;

  List<Function> _builders;
  List _inputs;
  TextStyleHtml _parentOutput;
  TextStyleHtml _output;

  /// Create a builder.
  TextStyleBuilder({this.parent});

  /// Enqueues a callback.
  void enqueue<T2>(
    TextStyleHtml Function(TextStyleHtml tsh, T2 input) builder, [
    T2 input,
  ]) {
    if (builder == null) return;

    assert(_output == null, 'Cannot add builder after being built');
    _builders ??= [];
    _builders.add(builder);

    _inputs ??= [];
    _inputs.add(input);
  }

  /// Builds a [TextStyleHtml] by calling queued callbacks.
  TextStyleHtml build(BuildContext context) {
    final parentOutput = parent?.build(context);
    if (parentOutput == null || parentOutput != _parentOutput) {
      _parentOutput = parentOutput;
      _output = null;
    }

    if (_output != null) return _output;
    if (_builders == null) return _output = _parentOutput;

    _output = _parentOutput?.copyWith(parent: _parentOutput);
    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      final builder = _builders[i];
      _output = builder(_output, _inputs[i]);
      assert(_output?.parent == _parentOutput);
    }

    return _output;
  }

  /// Returns `true` if this shares same styling with [other].
  bool hasSameStyleWith(TextStyleBuilder other) {
    if (other == null) return false;

    var thisWithBuilder = this;
    while (thisWithBuilder._builders == null) {
      if (thisWithBuilder.parent == null) break;
      thisWithBuilder = thisWithBuilder.parent;
    }

    var otherWithBuilder = other;
    while (otherWithBuilder._builders == null) {
      if (otherWithBuilder.parent == null) break;
      otherWithBuilder = otherWithBuilder.parent;
    }

    return thisWithBuilder == otherWithBuilder;
  }

  /// Creates a sub-builder.
  TextStyleBuilder sub() => TextStyleBuilder(parent: this);

  @override
  String toString() =>
      'tsb#$hashCode' + (parent != null ? '(parent=#${parent.hashCode})' : '');
}
