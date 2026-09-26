import 'package:material_ui/material_ui.dart';

/// Keeps legacy video controls working while HTML uses the modern theme.
class MaterialCompatibility extends StatelessWidget {
  final Widget child;

  const MaterialCompatibility({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Chewie still uses Flutter's built-in Material widgets.
    // ignore: deprecated_member_use
    return MaterialUiCompatibilityBridge(
      // Keep the modern theme nearest so WidgetFactory.auto detects it.
      child: Theme(data: Theme.of(context), child: child),
    );
  }
}
