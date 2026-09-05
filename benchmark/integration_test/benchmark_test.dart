import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('profile benchmark matrix', (tester) async {
    final report = await tester.runAsync(
      () => runSuite(
        repetitions: const int.fromEnvironment('REPETITIONS', defaultValue: 3),
        smoke: const bool.fromEnvironment('SMOKE'),
      ),
    );
    binding.reportData = report;
    expect(report!['results'], isNotEmpty);
  }, timeout: const Timeout(Duration(minutes: 30)));
}
