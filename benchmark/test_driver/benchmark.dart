import 'dart:convert';
import 'dart:io';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
      responseDataCallback: (data) async {
        final output = Directory('results')..createSync(recursive: true);
        File('${output.path}/measurements.json').writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(data),
        );
      },
    );
