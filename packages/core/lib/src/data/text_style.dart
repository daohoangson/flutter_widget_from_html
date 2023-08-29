part of '../core_data.dart';

/// A text style.
@immutable
class TextStyleHtml {
  final Iterable<dynamic> _deps;

  /// The parent style.
  final TextStyleHtml? parent;

  /// The input [TextStyle].
  final TextStyle style;

  /// The text alignment.
  final TextAlign? textAlign;

  /// The text direction.
  final TextDirection textDirection;

  /// The whitespace behavior.
  final CssWhitespace whitespace;

  const TextStyleHtml._({
    required Iterable<dynamic> deps,
    this.parent,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.whitespace,
  }) : _deps = deps;

  /// Creates the root text style.
  factory TextStyleHtml.root(Iterable<dynamic> deps, TextStyle? widgetStyle) {
    var style = _getDependency<TextStyle>(deps).merge(widgetStyle);

    final mqd = _getDependency<MediaQueryData>(deps);
    final tsf = mqd.textScaleFactor;
    final fontSize = style.fontSize;
    if (tsf != 1 && fontSize != null) {
      style = style.copyWith(fontSize: fontSize * tsf);
    }

    return TextStyleHtml._(
      deps: [
        ...deps,
        NormalLineHeight(style.height),
      ],
      style: style,
      textDirection: _getDependency<TextDirection>(deps),
      whitespace: CssWhitespace.normal,
    );
  }

  /// Creates a copy with the given fields replaced with the new values.
  TextStyleHtml copyWith({
    TextStyleHtml? parent,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    CssWhitespace? whitespace,
  }) {
    return TextStyleHtml._(
      deps: _deps,
      parent: parent ?? this.parent,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      whitespace: whitespace ?? this.whitespace,
    );
  }

  /// Gets dependency value by type.
  ///
  /// See [WidgetFactory.getDependencies].
  T getDependency<T>() => _getDependency<T>(_deps);

  static T _getDependency<T>(Iterable<dynamic> deps) {
    for (final value in deps.whereType<T>()) {
      return value;
    }

    throw StateError('The $T dependency could not be found');
  }
}

/// A text styling builder.
class TextStyleBuilder<T1> {
  /// The parent builder.
  final TextStyleBuilder? parent;

  List<Function>? _builders;
  List? _inputs;
  TextStyleHtml? _parentOutput;
  TextStyleHtml? _output;

  /// Create a builder.
  TextStyleBuilder({this.parent});

  /// Enqueues a callback.
  void enqueue<T2>(
    TextStyleHtml Function(TextStyleHtml tsh, T2 input) builder, [
    T2? input,
  ]) {
    assert(_output == null, 'Cannot add builder after being built');
    _builders ??= [];
    _builders!.add(builder);

    _inputs ??= [];
    _inputs!.add(input);
  }

  /// Builds a [TextStyleHtml] by calling queued callbacks.
  TextStyleHtml build(BuildContext context) {
    final parentOutput = parent?.build(context);
    if (parentOutput == null || !identical(parentOutput, _parentOutput)) {
      _parentOutput = parentOutput;
      _output = null;
    }

    final cachedOutput = _output;
    if (cachedOutput != null) {
      return cachedOutput;
    }

    final builders = _builders;
    final inputs = _inputs;
    if (builders == null || inputs == null) {
      if (parentOutput != null) {
        _output = parentOutput;
        return parentOutput;
      } else {
        throw StateError(
          "TextStyleBuilder does't have either parent or builders.",
        );
      }
    }

    _output = parentOutput?.copyWith(parent: parentOutput);
    final l = builders.length;
    for (var i = 0; i < l; i++) {
      final builder = builders[i];
      // ignore: avoid_dynamic_calls
      _output = builder(_output, inputs[i]) as TextStyleHtml;
      assert(identical(_output?.parent, parentOutput));
    }

    final output = _output;
    if (output != null) {
      return output;
    } else {
      throw StateError("TextStyleBuilder doesn't have any output.");
    }
  }

  /// Returns `true` if this shares same styling with [other].
  bool hasSameStyleWith(TextStyleBuilder? other) {
    if (other == null) {
      return false;
    }
    TextStyleBuilder thisWithBuilder = this;
    while (thisWithBuilder._builders == null) {
      final thisParent = thisWithBuilder.parent;
      if (thisParent == null) {
        break;
      } else {
        thisWithBuilder = thisParent;
      }
    }

    var otherWithBuilder = other;
    while (otherWithBuilder._builders == null) {
      final otherParent = otherWithBuilder.parent;
      if (otherParent == null) {
        break;
      } else {
        otherWithBuilder = otherParent;
      }
    }

    return thisWithBuilder == otherWithBuilder;
  }

  /// Creates a sub-builder.
  TextStyleBuilder sub() => TextStyleBuilder(parent: this);

  @override
  String toString() =>
      'tsb#$hashCode${parent != null ? '(parent=#${parent.hashCode})' : ''}';
}
