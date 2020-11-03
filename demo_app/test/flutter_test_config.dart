import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

// Delete `main` once this reaches stable
// https://github.com/flutter/flutter/pull/67425
// Apparently this will be an error when NNBD lands
Future<void> main(FutureOr<void> Function() testMain) =>
    testExecutable(testMain);

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();
  return testMain();
}
