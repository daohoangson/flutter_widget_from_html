import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const _default = _DefaultValue();

var _warnedAboutInherit = false;

/// A [TextStyle] replacement.
class FwfhTextStyle extends _TextStyleProxy {
  /// Creates an instance from another [TextStyle].
  ///
  /// See also: [FwfhTextStyle.of].
  static TextStyle from(TextStyle ref) {
    if (ref.inherit) {
      assert(
        () {
          if (!_warnedAboutInherit) {
            debugPrint(
              "Warning: $ref has inherit=true, resetting height won't work. "
              'See https://github.com/flutter/flutter/issues/58765 for context. '
              'This is printed once per debug session.\n${StackTrace.current}',
            );
            _warnedAboutInherit = true;
          }
          return true;
        }(),
      );
      return ref;
    } else {
      return FwfhTextStyle._(ref is FwfhTextStyle ? ref.ref : ref);
    }
  }

  /// Creates an instance from the closest [DefaultTextStyle].
  static TextStyle of(BuildContext context) =>
      FwfhTextStyle.from(DefaultTextStyle.of(context).style);

  FwfhTextStyle._(TextStyle ref) : super._(ref);

  @override
  TextStyle apply({
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double decorationThicknessFactor = 1.0,
    double decorationThicknessDelta = 0.0,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    int fontWeightDelta = 0,
    FontStyle? fontStyle,
    double letterSpacingFactor = 1.0,
    double letterSpacingDelta = 0.0,
    double wordSpacingFactor = 1.0,
    double wordSpacingDelta = 0.0,
    double heightFactor = 1.0,
    double heightDelta = 0.0,
    TextBaseline? textBaseline,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    String? package,
    TextOverflow? overflow,
  }) =>
      FwfhTextStyle.from(
        ref.apply(
          color: color,
          backgroundColor: backgroundColor,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThicknessFactor: decorationThicknessFactor,
          decorationThicknessDelta: decorationThicknessDelta,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
          fontWeightDelta: fontWeightDelta,
          fontStyle: fontStyle,
          letterSpacingFactor: letterSpacingFactor,
          letterSpacingDelta: letterSpacingDelta,
          wordSpacingFactor: wordSpacingFactor,
          wordSpacingDelta: wordSpacingDelta,
          heightFactor: heightFactor,
          heightDelta: heightDelta,
          textBaseline: textBaseline,
          leadingDistribution: leadingDistribution,
          locale: locale,
          shadows: shadows,
          fontFeatures: fontFeatures,
          package: package,
          overflow: overflow,
        ),
      );

  @override
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    dynamic height = _default,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    String? newDebugLabel;
    assert(
      () {
        if (this.debugLabel != null) {
          newDebugLabel = debugLabel ?? '(${this.debugLabel}).copyWith';
        }
        return true;
      }(),
    );
    return FwfhTextStyle.from(
      TextStyle(
        inherit: inherit ?? this.inherit,
        color: this.foreground == null && foreground == null
            ? color ?? this.color
            : null,
        backgroundColor: this.background == null && background == null
            ? backgroundColor ?? this.backgroundColor
            : null,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        wordSpacing: wordSpacing ?? this.wordSpacing,
        textBaseline: textBaseline ?? this.textBaseline,
        height: height is double? ? height : this.height,
        leadingDistribution: leadingDistribution ?? this.leadingDistribution,
        locale: locale ?? this.locale,
        foreground: foreground ?? this.foreground,
        background: background ?? this.background,
        shadows: shadows ?? this.shadows,
        fontFeatures: fontFeatures ?? this.fontFeatures,
        decoration: decoration ?? this.decoration,
        decorationColor: decorationColor ?? this.decorationColor,
        decorationStyle: decorationStyle ?? this.decorationStyle,
        decorationThickness: decorationThickness ?? this.decorationThickness,
        debugLabel: newDebugLabel,
        fontFamily: fontFamily ?? this.fontFamily,
        fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
        package: package,
        overflow: overflow ?? this.overflow,
      ),
    );
  }

  @override
  TextStyle merge(TextStyle? other) => FwfhTextStyle.from(
        ref.merge(other is FwfhTextStyle ? other.ref : other),
      );
}

class _DefaultValue {
  const _DefaultValue();
}

// ignore: avoid_implementing_value_types
abstract class _TextStyleProxy implements TextStyle {
  final TextStyle ref;

  _TextStyleProxy._(this.ref);

  @override
  Paint? get background => ref.background;

  @override
  Color? get backgroundColor => ref.backgroundColor;

  @override
  Color? get color => ref.color;

  @override
  RenderComparison compareTo(TextStyle other) => ref.compareTo(other);

  @override
  void debugFillProperties(
    DiagnosticPropertiesBuilder properties, {
    String prefix = '',
  }) =>
      ref.debugFillProperties(properties, prefix: prefix);

  @override
  String? get debugLabel => ref.debugLabel;

  @override
  TextDecoration? get decoration => ref.decoration;

  @override
  Color? get decorationColor => ref.decorationColor;

  @override
  TextDecorationStyle? get decorationStyle => ref.decorationStyle;

  @override
  double? get decorationThickness => ref.decorationThickness;

  @override
  String? get fontFamily => ref.fontFamily;

  @override
  List<String>? get fontFamilyFallback => ref.fontFamilyFallback;

  @override
  List<ui.FontFeature>? get fontFeatures => ref.fontFeatures;

  @override
  double? get fontSize => ref.fontSize;

  @override
  FontStyle? get fontStyle => ref.fontStyle;

  @override
  FontWeight? get fontWeight => ref.fontWeight;

  @override
  Paint? get foreground => ref.foreground;

  @override
  ui.ParagraphStyle getParagraphStyle({
    TextAlign? textAlign,
    TextDirection? textDirection,
    double textScaleFactor = 1.0,
    String? ellipsis,
    int? maxLines,
    TextHeightBehavior? textHeightBehavior,
    Locale? locale,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    StrutStyle? strutStyle,
  }) =>
      ref.getParagraphStyle(
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
        ellipsis: ellipsis,
        maxLines: maxLines,
        textHeightBehavior: textHeightBehavior,
        locale: locale,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        strutStyle: strutStyle,
      );

  @override
  ui.TextStyle getTextStyle({double textScaleFactor = 1.0}) =>
      ref.getTextStyle(textScaleFactor: textScaleFactor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! TextStyle) {
      return false;
    }
    final otherRef = other is FwfhTextStyle ? other.ref : other;
    return ref == otherRef;
  }

  @override
  int get hashCode => ref.hashCode;

  @override
  double? get height => ref.height;

  /// Flutter's [TextStyle.merge] implementation uses private properties
  /// which will trigger weird errors in people's apps.
  /// We cannot let that happen.
  @override
  bool get inherit => false;

  @override
  TextLeadingDistribution? get leadingDistribution => ref.leadingDistribution;

  @override
  double? get letterSpacing => ref.letterSpacing;

  @override
  Locale? get locale => ref.locale;

  @override
  TextOverflow? get overflow => ref.overflow;

  @override
  List<Shadow>? get shadows => ref.shadows;

  @override
  TextBaseline? get textBaseline => ref.textBaseline;

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      ref.toDiagnosticsNode(name: name, style: style);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      ref.toString(minLevel: minLevel);

  @override
  String toStringShort() => ref.toStringShort();

  @override
  double? get wordSpacing => ref.wordSpacing;
}
