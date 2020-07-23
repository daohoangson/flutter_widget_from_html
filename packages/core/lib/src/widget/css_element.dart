part of '../core_helpers.dart';

class CssBlock extends StatelessWidget {
  final Widget child;

  const CssBlock({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, bc) => bc.maxWidth.isFinite
            ? SizedBox(child: child, width: bc.maxWidth)
            : child,
      );
}

class CssSizing extends StatelessWidget {
  final Widget child;
  final double height;
  final double maxHeight;
  final double maxWidth;
  final double minHeight;
  final double minWidth;
  final double width;

  const CssSizing({
    @required this.child,
    this.height,
    Key key,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, bc) {
          if (_isTooBig(bc, height, width)) {
            return AspectRatio(
              aspectRatio: width / height,
              child: child,
            );
          }

          Widget built = ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height ?? maxHeight ?? double.infinity,
              maxWidth: width ?? maxWidth ?? double.infinity,
              minHeight: height ?? minHeight ?? 0,
              minWidth: width ?? minWidth ?? 0,
            ),
            child: child,
          );

          if (height != null) {
            built = UnconstrainedBox(
              child: built,
              constrainedAxis: Axis.horizontal,
              alignment: Alignment.topLeft,
            );
          }

          if (width != null) {
            built = UnconstrainedBox(
              child: built,
              constrainedAxis: Axis.vertical,
              alignment: Alignment.topLeft,
            );
          }

          return built;
        },
      );

  static bool _isTooBig(BoxConstraints bc, double h, double w) {
    if (h == null || w == null || h == 0) return false;

    final b = bc.biggest;
    if (b.height.isFinite && h > b.height) return true;
    if (b.width.isFinite && w > b.width) return true;

    return false;
  }
}
