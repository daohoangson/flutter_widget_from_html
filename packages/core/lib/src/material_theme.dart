import 'package:flutter/material.dart' as flutter_material;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

/// Selects the Material library used by widgets built from HTML.
enum MaterialThemeMode {
  /// Uses the nearest Material [flutter_material.Theme] or
  /// [material_ui.Theme] ancestor.
  ///
  /// If neither theme exists, the in-framework Flutter Material defaults are
  /// used for backwards compatibility. Cupertino-only applications therefore
  /// retain the same fallback that previous releases used.
  auto,

  /// Always uses the in-framework `package:flutter/material.dart` library.
  flutter,

  /// Always uses the `package:material_ui/material_ui.dart` library.
  materialUi,
}

/// The resolved Material library and theme values for a build context.
@immutable
class MaterialThemeModeData {
  /// The selected library. This is never [MaterialThemeMode.auto].
  final MaterialThemeMode mode;

  /// The selected theme's primary color.
  final Color primaryColor;

  /// The selected theme's brightness.
  final Brightness brightness;

  const MaterialThemeModeData._(this.mode, this.primaryColor, this.brightness);
}

/// Resolves [mode] against [context] and registers theme dependencies.
MaterialThemeModeData resolveMaterialThemeMode(
  BuildContext context,
  MaterialThemeMode mode,
) {
  if (mode == MaterialThemeMode.flutter) {
    final theme = flutter_material.Theme.of(context);
    return MaterialThemeModeData._(
      MaterialThemeMode.flutter,
      theme.colorScheme.primary,
      theme.brightness,
    );
  }
  if (mode == MaterialThemeMode.materialUi) {
    final theme = material_ui.Theme.of(context);
    return MaterialThemeModeData._(
      MaterialThemeMode.materialUi,
      theme.colorScheme.primary,
      theme.brightness,
    );
  }

  // Both calls are intentional. They register dependencies on both theme
  // families so auto mode updates when either inherited theme changes.
  final flutterTheme = flutter_material.Theme.of(context);
  final materialUiTheme = material_ui.Theme.of(context);
  if (_nearestMaterialThemeMode(context) == MaterialThemeMode.materialUi) {
    return MaterialThemeModeData._(
      MaterialThemeMode.materialUi,
      materialUiTheme.colorScheme.primary,
      materialUiTheme.brightness,
    );
  }
  return MaterialThemeModeData._(
    MaterialThemeMode.flutter,
    flutterTheme.colorScheme.primary,
    flutterTheme.brightness,
  );
}

MaterialThemeMode _nearestMaterialThemeMode(BuildContext context) {
  var resolved = MaterialThemeMode.flutter;
  context.visitAncestorElements((element) {
    final widget = element.widget;
    if (widget is flutter_material.Theme) {
      resolved = MaterialThemeMode.flutter;
      return false;
    }
    if (widget is material_ui.Theme) {
      resolved = MaterialThemeMode.materialUi;
      return false;
    }
    return true;
  });
  return resolved;
}

/// Builds a tooltip from the selected Material library.
Widget buildMaterialTooltip({
  required Widget child,
  required String message,
  required MaterialThemeMode mode,
}) =>
    Builder(
      builder: (context) => resolveMaterialThemeMode(context, mode).mode ==
              MaterialThemeMode.materialUi
          ? material_ui.Tooltip(message: message, child: child)
          : flutter_material.Tooltip(message: message, child: child),
    );

/// Builds a circular progress indicator from the selected Material library.
Widget buildMaterialProgressIndicator(
  BuildContext context, {
  required MaterialThemeMode mode,
  double? value,
}) =>
    resolveMaterialThemeMode(context, mode).mode == MaterialThemeMode.materialUi
        ? material_ui.CircularProgressIndicator.adaptive(value: value)
        : flutter_material.CircularProgressIndicator.adaptive(value: value);
