import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main(FutureOr<void> testMain()) async {
  await loadAppFonts();
  return testMain();
}
