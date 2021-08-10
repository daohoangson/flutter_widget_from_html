import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_0.dart';

class AspectRatioTester extends StatelessWidget {
  final Widget child;

  final _result = _AspectRatioTestResult();

  AspectRatioTester({
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) => ListenableProvider<_AspectRatioTestResult>(
        create: (_) => _result,
        child: ListView(
          children: <Widget>[
            Builder(
                builder: (context) => Text(
                      Provider.of<_AspectRatioTestResult>(context)
                          .value
                          .toString(),
                      key: const ValueKey(kResultKey),
                    )),
            CustomSingleChildLayout(
              delegate: _AspectRatioTestDelegate(_result),
              child: child,
            ),
          ],
        ),
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
