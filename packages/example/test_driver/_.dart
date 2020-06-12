import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AspectRatioTester extends StatelessWidget {
  final Widget child;
  final Key resultKey;

  final _result = _AspectRatioTestResult();

  AspectRatioTester({
    @required this.child,
    Key key,
    @required this.resultKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ListenableProvider<_AspectRatioTestResult>(
        child: ListView(
          children: <Widget>[
            _AspectRatioTestResultWidget(resultKey: resultKey),
            CustomSingleChildLayout(
              child: child,
              delegate: _AspectRatioTestDelegate(_result),
            ),
          ],
        ),
        create: (_) => _result,
      );
}

class _AspectRatioTestDelegate extends SingleChildLayoutDelegate {
  final _AspectRatioTestResult result;

  _AspectRatioTestDelegate(this.result);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[_AspectRatioTestDelegate] childSize=$childSize');
      result.value = childSize.aspectRatio;
    });

    return Offset.zero;
  }

  @override
  Size getSize(BoxConstraints constraints) => constraints.smallest;

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) => false;
}

class _AspectRatioTestResult with ChangeNotifier {
  double _value = 0;

  set value(double v) {
    if (_value != v) {
      _value = v;
      notifyListeners();
    }
  }

  double get value => _value;
}

class _AspectRatioTestResultWidget extends StatelessWidget {
  final Key resultKey;

  _AspectRatioTestResultWidget({this.resultKey});

  @override
  Widget build(BuildContext context) => Text(
        Provider.of<_AspectRatioTestResult>(context)
            .value
            .toStringAsFixed(3)
            .substring(0, 4),
        key: resultKey,
      );
}
